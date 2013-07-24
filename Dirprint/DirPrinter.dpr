program DirPrinter;

uses
  Forms,
  main in 'main.pas' {Form1},
  edtOption in 'edtOption.pas' {frmOptions},
  fsWalk in 'fsWalk.pas',
  WalkOption in 'WalkOption.pas',
  GFileUtil in 'GFileUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.Run;
end.
