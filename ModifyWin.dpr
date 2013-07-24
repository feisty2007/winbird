program ModifyWin;

uses
  Forms,
  main in 'main.pas' {Form1},
  ShellCmdLine in 'ShellCmdLine.pas',
  RegUnlock in 'RegUnlock.pas',
  ShareDllClearner in 'ShareDllClearner.pas',
  GMsgbox in 'GMsgbox.pas',
  regrun in 'regrun.pas',
  SoftInfo in 'SoftInfo.pas',
  NtService in 'NtService.pas',
  gUtil in 'gUtil.pas',
  RegComplete in 'RegComplete.pas',
  SystemSecurity in 'SystemSecurity.pas',
  SystemEnc in 'SystemEnc.pas',
  LoginUtil in 'LoginUtil.pas',
  THiddenFolder in 'THiddenFolder.pas',
  vistauac in 'vistauac.pas',
  oeminfo in 'oeminfo.pas',
  TImeTool in 'TImeTool.pas',
  WinSvcEx in 'WinSvcEx.pas';

{$R *.res}
{$R UAC.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

