program NetworkMon;

uses
  Forms,
  niMain in 'niMain.pas' {Form1},
  ProcessMapper in 'ProcessMapper.pas',
  IPHLPAPI in 'IPHlpAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
