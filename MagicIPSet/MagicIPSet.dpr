program MagicIPSet;

uses
  Forms,
  frmMain in 'frmMain.pas' {frmMagicIPSet},
  IpExport in 'IPHlpAPI\IpExport.pas',
  IpHlpApi in 'IPHlpAPI\IpHlpApi.pas',
  IpIfConst in 'IPHlpAPI\IpIfConst.pas',
  IpRtrMib in 'IPHlpAPI\IpRtrMib.pas',
  IpTypes in 'IPHlpAPI\IpTypes.pas',
  NetAdapters in 'NetAdapters.pas',
  AddNewProfile in 'AddNewProfile.pas' {FormAddProfile},
  ProfileCls in 'ProfileCls.pas',
  NetshDebug in 'NetshDebug.pas' {frmNetsh},
  UpdateThread in 'UpdateThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMagicIPSet, frmMagicIPSet);
  Application.CreateForm(TFormAddProfile, FormAddProfile);
  Application.Run;
end.

