program wbCleaner;

uses
  Forms,
  main in 'main.pas' {Form2},
  Winrar in 'Winrar.pas',
  TreeNodeUtil in 'TreeNodeUtil.pas',
  gUtil in '..\gUtil.pas',
  GMsgbox in '..\GMsgbox.pas',
  ShellFolderHelperUtil in 'ShellFolderHelperUtil.pas',
  OfficeClearn in 'OfficeClearn.pas',
  UrlHistory in 'UrlHistory.pas',
  ClearRecentDoc in 'ClearRecentDoc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
