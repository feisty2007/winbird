program mp3info;

uses
  Forms,
  main in 'main.pas' {Form1},
  mp3_id3v1 in 'mp3_id3v1.pas',
  fileUtil in 'fileUtil.pas',
  FormBatchConvert in 'FormBatchConvert.pas' {BatchConvert},
  ConvertThread in 'ConvertThread.pas',
  apetag in 'apetag.pas',
  wmafile in 'wmafile.pas',
  ID3v2 in 'ID3v2.pas',
  ConvertYongzheng in 'ConvertYongzheng.pas' {ConvertYongzheng};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TBatchConvert, BatchConvert);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

