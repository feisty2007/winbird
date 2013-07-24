unit apetag;

interface

uses
  Classes, SysUtils;

const
  { Tag ID }
  ID3V1_ID = 'TAG'; { ID3v1 }
  APE_ID = 'APETAGEX'; { APE }

  { Size constants }
  ID3V1_TAG_SIZE = 128; { ID3v1 tag }
  APE_TAG_FOOTER_SIZE = 32; { APE tag footer }
  APE_TAG_HEADER_SIZE = 32; { APE tag header }

  { Version of APE tag }
  APE_VERSION_1_0 = 1000;
  APE_VERSION_2_0 = 1000;

type
  RTagHeader = record
    { Real structure of APE footer }
    ID: array[0..7] of Char; { Always "APETAGEX" }
    Version: Integer; { Tag version }
    Size: Integer; { Tag size including footer }
    Fields: Integer; { Number of fields }
    Flags: Integer; { Tag flags }
    Reserved: array[0..7] of Char; { Reserved for later use }
    { Extended data }
    DataShift: Byte; { Used if ID3v1 tag found }
    FileSize: Integer; { File size (bytes) }
  end;

  RField = record
    Name: string;
    Value: UTF8string;
  end;
  AField = array of RField;

  TAPETag = class
  private
    pField: Afield;
    pExists: Boolean;
    pVersion: Integer;
    pSize: Integer;
    function ReadFooter(sFile: string; var footer: RTagHeader): boolean;
    procedure ReadFields(sFile: string; footer: RTagHeader);
  public
    property Exists: Boolean read pExists; { True if tag found }
    property Version: Integer read pVersion; { Tag version }
    property Fields: AField read pField;
    property Size: Integer read pSize;
    constructor Create();

    function ReadFromFile(sFile: string): Boolean;
    function WriteToFile(sFile: string): Boolean;
    procedure ResetData;
  end;

implementation

{ TAPETag }

constructor TAPETag.Create;
begin
  inherited;

  ResetData;
end;

procedure TAPETag.ReadFields(sFile: string; footer: RTagHeader);
var
  fileMP3: TFileStream;
  FieldName: string;
  FieldValue: array[1..250] of Char;
  NextChar: Char;
  Iterator, ValueSize, ValuePosition, FieldFlags: Integer;
begin
  fileMP3 := TFileStream.Create(sFile, fmOpenRead);
  try
    fileMP3.Seek(footer.FileSize - footer.DataShift - footer.Size, soFromBeginning);
    SetLength(pField, footer.Fields);

    for Iterator := 0 to footer.Fields - 1 do
    begin
      FillChar(FieldValue, SizeOf(FieldValue), 0);
      fileMP3.Read(ValueSize, SizeOf(ValueSize));
      fileMP3.Read(FieldFlags, SizeOf(FieldFlags));
      FieldName := '';
      repeat
        fileMP3.Read(NextChar, SizeOf(NextChar));
        FieldName := FieldName + NextChar;
      until Ord(NextChar) = 0;
      ValuePosition := fileMP3.Position;
      fileMP3.Read(FieldValue, ValueSize mod SizeOf(FieldValue));
      pField[Iterator].Name := Trim(FieldName);
      pField[Iterator].Value := Trim(FieldValue);
      fileMP3.Seek(ValuePosition + ValueSize, soFromBeginning);
    end;
  finally
    fileMP3.Free;
  end;
end;

function TAPETag.ReadFooter(sFile: string;
  var footer: RTagHeader): boolean;
var
  fileMP3: TFileStream;
  TagID: array[0..2] of char;
  transffered: Integer;
begin
  Result := True;
  fileMP3 := TFileStream.Create(sFile, fmOpenRead);
  try
    footer.FileSize := fileMP3.Size;
    fileMP3.Seek(0 - ID3V1_TAG_SIZE, soFromEnd);
    fileMP3.Read(TagID, 3);

    if TagID = ID3V1_ID then
      footer.DataShift := ID3V1_TAG_SIZE
    else
      footer.DataShift := 0;

    transffered := 0;
    fileMP3.Seek(0 - ID3V1_TAG_SIZE - APE_TAG_FOOTER_SIZE, soFromEnd);
    transffered := fileMP3.Read(footer, APE_TAG_FOOTER_SIZE);

    if transffered < APE_TAG_FOOTER_SIZE then
      Result := false;
  finally
    fileMP3.Free;
  end; // try
end;



function TAPETag.ReadFromFile(sFile: string): Boolean;
var
  footer: RTagHeader;
begin
  ResetData;
  Result := ReadFooter(sFile, Footer);
  { Process data if loaded and footer valid }
  if (Result) and (Footer.ID = APE_ID) then
  begin
    pExists := True;
    pVersion := Footer.Version;
    pSize := Footer.Size;
    ReadFields(sFile, Footer);
  end;
end;

procedure TAPETag.ResetData;
begin
  SetLength(pField, 0);
  pExists := False;
  pVersion := 0;
  pSize := 0;
end;

function TAPETag.WriteToFile(sFile: string): Boolean;
const
  APEPreample: array[0..7] of char = ('A', 'P', 'E', 'T', 'A', 'G', 'E', 'X');
var
  SourceFile: TFileStream;
  Header, Footer, RefFooter: RTagHeader;
  ID3: PChar;
  i, len, TagSize, Flags: integer;
  TagData: TStringStream;
begin
  ID3 := nil;
    // method : first, save any eventual ID3v1 tag lying around
    //          then we truncate the file after the audio data
    //          then write the APE tag (and possibly the ID3)
  Result := ReadFooter(sFile, RefFooter);
    { Process data if loaded and footer valid }
  if (Result) and (RefFooter.ID = APE_ID) then
  begin
    SourceFile := TFileStream.Create(sFile, fmOpenReadWrite or fmShareDenyWrite);
      { If there is an ID3v1 tag roaming around behind the APE tag, we have to buffer it }
    if RefFooter.DataShift = ID3V1_TAG_SIZE then
    begin
      GetMem(ID3, ID3V1_TAG_SIZE);
      SourceFile.Seek(Reffooter.FileSize - Reffooter.DataShift, soFromBeginning);
      SourceFile.Read(ID3^, ID3V1_TAG_SIZE);
    end;
      { If this is an APEv2, header size must be added }
      //if (RefFooter.Flags shr 31) > 0 then
    Inc(RefFooter.Size, APE_TAG_HEADER_SIZE);
    SourceFile.Seek(RefFooter.FileSize - RefFooter.Size - RefFooter.DataShift, soFromBeginning);
      //truncate
    SourceFile.Size := SourceFile.Position;
    SourceFile.Free;
  end;
  TagData := TStringStream.Create('');
  TagSize := APE_TAG_FOOTER_SIZE;
  for i := 0 to high(pField) do
  begin
    TagSize := TagSize + 9 + Length(pField[i].Name) + Length(pField[i].Value);
  end;
  Header.ID[0] := 'A';
  Header.ID[1] := 'P';
  Header.ID[2] := 'E';
  Header.ID[3] := 'T';
  Header.ID[4] := 'A';
  Header.ID[5] := 'G';
  Header.ID[6] := 'E';
  Header.ID[7] := 'X';
  Header.Version := 2000;
  Header.Size := TagSize;
  Header.Fields := Length(pField);
  Header.Flags := 0 or (1 shl 29) or (1 shl 31); // tag contains a header and this is the header
    //ShowMessage(IntToSTr(Header.Flags));
  TagData.Write(Header, APE_TAG_HEADER_SIZE);
  for i := 0 to high(pField) do
  begin
    len := Length(pField[i].Value);
    Flags := 0;
    TagData.Write(len, SizeOf(len));
    TagData.Write(Flags, SizeOf(Flags));
    TagData.WriteString(pField[i].Name + #0);
    TagData.WriteString(pField[i].Value);
  end;
  Footer.ID[0] := 'A';
  Footer.ID[1] := 'P';
  Footer.ID[2] := 'E';
  Footer.ID[3] := 'T';
  Footer.ID[4] := 'A';
  Footer.ID[5] := 'G';
  Footer.ID[6] := 'E';
  Footer.ID[7] := 'X';
  Footer.Version := 2000;
  Footer.Size := TagSize;
  Footer.Fields := Length(pField);
  Footer.Flags := 0 or (1 shl 31); // tag contains a header and this is the footer
  TagData.Write(Footer, APE_TAG_FOOTER_SIZE);
  if (RefFooter.DataShift = ID3V1_TAG_SIZE) and Assigned(ID3) then
  begin
    TagData.Write(ID3^, ID3V1_TAG_SIZE);
    FreeMem(ID3);
  end;
  SourceFile := TFileStream.Create(sFile, fmOpenReadWrite or fmShareDenyWrite);
  SourceFile.Seek(0, soFromEnd);
  TagData.Seek(0, soFromBeginning);
  SourceFile.CopyFrom(TagData, TagData.Size);
  SourceFile.Free;
  TagData.Free;
end;

end.
