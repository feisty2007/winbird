program VT;

uses
  Forms,
  MAIN in 'MAIN.pas' {Form1},
  FolderObj in 'FolderObj.pas',
  ScanThread in 'ScanThread.pas',
  FileCount in 'FileCount.pas',
  aboutfrm in 'aboutfrm.pas' {OKBottomDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKBottomDlg, OKBottomDlg);
  Application.Run;
end.

