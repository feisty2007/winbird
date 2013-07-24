unit vistauac;

interface

uses
  Windows, Registry;
type
  TVistaUAC = class
  public
    procedure Close;
    procedure Open;
  private
    procedure Operation(bClose: boolean = true);
  end;
implementation

procedure TVistaUAC.Close;
begin
  Operation();
end;

procedure TVistaUAC.Open;
begin
  Operation(false);
end;

procedure TVistaUAC.Operation(bClose: boolean);
const
  regKey = 'Software\Microsoft\Windows\CurrentVersion\Policies\System';
var
  reg: TRegistry;
  ci: Integer;
begin
  reg := TRegistry.Create;

  if bClose then ci := 0 else ci := 1;
  reg.RootKey := HKEY_LOCAL_MACHINE;

  try
    if reg.OpenKey(regKey, true) then
      reg.WriteInteger('EnableLUA', ci);
  finally
    reg.free;
  end;
end;
end.
