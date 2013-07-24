unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  TForm1 = class(TForm)
    grp1: TGroupBox;
    edt_Mp3File: TEdit;
    btn1: TButton;
    btn_Read: TButton;
    grp_Result: TGroupBox;
    lblTitle: TLabel;
    dlgOpen1: TOpenDialog;
    lbl_Title: TLabel;
    lbl_Artist: TLabel;
    lblArtist: TLabel;
    lbl_Comment: TLabel;
    lblComment: TLabel;
    lbl_Album: TLabel;
    lblAlbum: TLabel;
    lbl_Year: TLabel;
    lblYear: TLabel;
    lbl_Genre: TLabel;
    lblGenre: TLabel;
    lbl_msg: TLabel;
    btn_Write: TButton;
    btn_BatchConvert: TButton;
    btn_ReadAPETag: TButton;
    lst_ApeTag: TListBox;
    btn_ReadWMA: TButton;
    chk_ApeTag: TCheckBox;
    id3v2: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn_ReadClick(Sender: TObject);
    procedure btn_WriteClick(Sender: TObject);
    procedure btn_BatchConvertClick(Sender: TObject);
    procedure btn_ReadAPETagClick(Sender: TObject);
    procedure btn_ReadWMAClick(Sender: TObject);
    procedure id3v2Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    //function GetRealName(str:string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses mp3_id3v1, fileUtil, FormBatchConvert, apetag, wmafile, ID3v2,
  ConvertYongzheng;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
    edt_Mp3File.Text := dlgOpen1.FileName;
end;

procedure TForm1.btn_ReadClick(Sender: TObject);
var
  mp3Info: TMP3Info;
begin
  mp3Info := TMP3Info.Create(edt_Mp3File.Text);
  try
    mp3Info.GetMp3Info;

    if mp3Info.hasTag then
    begin
      lblTitle.Caption := mp3Info.title;
      lblArtist.Caption := mp3Info.Artist;
      lblComment.Caption := mp3Info.Comment;
      lblAlbum.Caption := mp3Info.Album;
      lblYear.Caption := mp3Info.Year;
      lblGenre.Caption := mp3Info.Genre;
    end;
  finally
    mp3Info.Free;
  end;

  //lbl_msg.Caption := TFileUtil.GetLastName(lblTitle.Caption);
end;



procedure TForm1.btn_WriteClick(Sender: TObject);
var
  mp3info: TMP3Info;
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
  if chk_ApeTag.Checked = false then
  begin
    mp3info := TMP3Info.Create(edt_Mp3File.Text);

    mp3info.GetMp3Info;
    mp3info.title := '童林传_' + TFileUtil.GetLastName(mp3info.title);
    mp3info.WriteMp3Info;

    mp3info.Free;
  end
  else
  begin
    ape := TAPETag.Create;
    ape.ReadFromFile(edt_Mp3File.Text);

    SetValueByName(ape.Fields,
      'Title',
      '童林传_' + TFileUtil.GetLastName(GetValueByName(ape.Fields, 'Title')));

    ape.WriteToFile(edt_Mp3File.Text);
  end;
end;

procedure TForm1.btn_BatchConvertClick(Sender: TObject);
var
  fmBC: TBatchConvert;
begin
  fmBC := TBatchConvert.Create(self);

  fmBC.ShowModal;
end;

procedure TForm1.btn_ReadAPETagClick(Sender: TObject);
var
  apeTag: TAPETag;
  iLen: Integer;
  i: Integer;
begin
  apeTag := TAPETag.Create;

  apeTag.ReadFromFile(edt_Mp3File.Text);

  iLen := Length(apeTag.Fields);

  for i := Low(apetag.Fields) to High(apetag.Fields) do
  begin
    lst_ApeTag.Items.Add(apeTag.Fields[i].Name + ':' + UTF8Decode(apeTag.Fields[i].Value));
  end;

  apeTag.Free;
end;

procedure TForm1.btn_ReadWMAClick(Sender: TObject);
var
  wma: TWMAfile;
begin
  if LowerCase(ExtractFileExt(edt_Mp3File.Text)) <> '.wma' then
  begin
    ShowMessage('Please Select WMA File');
    Exit;
  end;

  wma := TWMAFile.Create;
  try
    wma.ReadFromFile(edt_Mp3File.Text);

    lblTitle.Caption := wma.Title;
    lblArtist.Caption := wma.Artist;
    lblAlbum.Caption := wma.Album;
    lblYear.Caption := wma.Year;
    lblComment.Caption := wma.Comment;
    lblGenre.Caption := wma.Genre;
  finally
    wma.Free;
  end; // try
end;

procedure TForm1.id3v2Click(Sender: TObject);
var
  _id3v2:TID3v2;
begin
  _id3v2:=TID3v2.Create;

  if _id3v2.ReadFromFile(edt_Mp3File.Text) then
  begin
    lblTitle.Caption := _id3v2.Title;
    lblArtist.Caption := _id3v2.Artist;
    lblAlbum.Caption := _id3v2.Album;
    lblYear.Caption := _id3v2.Year;
    lblComment.Caption := _id3v2.Comment;
    lblGenre.Caption := _id3v2.Genre;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
    form3.Show;
end;

end.

