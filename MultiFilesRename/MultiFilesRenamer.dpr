program MultiFilesRenamer;

uses
  Forms,
  frmMainMFR in 'frmMainMFR.pas' {Form1},
  frmSelectRangeUnit in 'frmSelectRangeUnit.pas' {frmSelectRange},
  frmAbout in 'frmAbout.pas' {OKBottomDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmSelectRange, frmSelectRange);
  Application.CreateForm(TOKBottomDlg, OKBottomDlg);
  Application.Run;
end.
