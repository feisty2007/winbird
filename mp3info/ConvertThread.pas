unit ConvertThread;

interface

uses
  Classes, CommCtrl, StdCtrls, ComCtrls, SysUtils;

type
  ConvertFileThread = class(TThread)
  private
    { Private declarations }
    fLabelMsg: TLabel;
    fProgressBar: TProgressBar;
    fMsg: string;
    ffiles: TStrings;
    procedure Convertfile(str: string);
    procedure ConvertApegFile(str: string);
  protected
    procedure Execute; override;
    procedure UpdateMsg;
    procedure UpdateProgressMax;
  public
    constructor Create(files: TStrings; lblMsg: TLabel; ProgressBar: TProgressBar); overload;
  end;

implementation

uses mp3_id3v1, fileUtil, apetag;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ConvertFileThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ ConvertFileThread }

procedure ConvertFileThread.ConvertApegFile(str: string);
var
  ape: TAPETag;

  function GetValueByName(pField: AField; name: string): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 0 to High(pField) do
    begin
      if pField[i].Name = name then
        Result := UTF8Decode(pField[i].Value);
    end;
  end;

  function SetValueByName(pField: AField; name: string; value: string): Boolean;
  var
    i: integer;
  begin
    Result := false;

    for i := 0 to High(pField) do
    begin
      if pField[i].Name = name then
      begin
        pField[i].Value := UTF8Encode(value);
        Result := True;
      end;
    end;
  end;
begin
  ape := TAPETag.Create;
  ape.ReadFromFile(str);
  fMsg := ExtractFileName(str);
  Synchronize(UpdateMsg);
  SetValueByName(ape.Fields,
    'Title',
    '童林传_' + TFileUtil.GetLastName(GetValueByName(ape.Fields, 'Title')));

  ape.WriteToFile(str);
end;

procedure ConvertFileThread.Convertfile(str: string);
var
  mp3info: TMP3Info;
begin
  mp3info := TMP3Info.Create(str);

  fMsg := ExtractFileName(str);
  Synchronize(UpdateMsg);
  mp3info.GetMp3Info;
  mp3info.Comment := '童林传_' + TFileUtil.GetLastName(mp3info.title);
  mp3info.WriteMp3Info;
  mp3info.Free;
end;

constructor ConvertFileThread.Create(files: TStrings; lblMsg: TLabel;
  ProgressBar: TProgressBar);
begin
  inherited Create(false);
  FlabelMsg := lblMsg;
  FProgressBar := ProgressBar;
  fFiles := files;

  Synchronize(UpdateProgressMax);
end;

procedure ConvertFileThread.Execute;
var
  i: integer;
begin
  { Place thread code here }

  for i := 0 to ffiles.Count - 1 do
  begin
    ConvertApegFile(ffiles[i]);
  end;
end;

procedure ConvertFileThread.UpdateMsg;
begin
  fLabelMsg.Caption := '正在处理' + fMsg;
  fProgressBar.StepIt;
end;

procedure ConvertFileThread.UpdateProgressMax;
begin
  fProgressBar.Max := ffiles.Count;
  fProgressBar.Step := 1;
end;

end.
