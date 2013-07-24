program smII;

uses
  Forms,
  main in 'main.pas' {Form1},
  IExeInf in 'IExeInf.pas',
  AddToSendUnit in 'AddToSendUnit.pas',
  MDNowFlder in 'MDNowFlder.pas',
  AddtoPathUnit in 'AddtoPathUnit.pas',
  PromptName in 'PromptName.pas' {InputFrm},
  IDosCmd in 'IDosCmd.pas',
  HideFolder in 'HideFolder.pas';

{$R *.res}

var
  ie:IExeInterface;
begin
  Application.Initialize;
  if ParamCount=0 then
  begin
    Application.CreateForm(TForm1, Form1);
  Application.Run;
  end;

  if ParamCount=2 then
  begin
     ie:=GetExeInf(ParamStr(1));
     if ie<>nil then
       ie.Execute(ParamStr(2));
  end;
end.
