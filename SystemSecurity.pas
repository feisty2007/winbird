unit SystemSecurity;

interface
uses
  Registry, Windows;

type
  TTaskManagerSecurity = class
    procedure Enable(isEnable: Boolean = True);
  end;

implementation

{ TTaskManagerSecurity }

procedure TTaskManagerSecurity.Enable(isEnable: Boolean);
const
  regKey = 'Software\Microsoft\Windows\CurrentVersion\Policies\System';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regKey, false) then
    begin
      if isEnable then
        reg.WriteInteger('DisableTaskmgr', 0)
      else
        reg.WriteInteger('DisableTaskmgr', 1);

      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

end;

end.
