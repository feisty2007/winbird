unit SystemEnc;

interface

uses
  Registry, Windows;

type
  TStartMenuOrderByName = class
    procedure Sort;
  end;

implementation

{ TStartMenuOrderByName }

procedure TStartMenuOrderByName.Sort;
const
  regkey = 'Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder';
var
  reg: TRegistry;
  keyname: string;
begin
  keyname := 'Start Menu2';
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regkey, false) then
    begin
      if reg.KeyExists(keyname) then
      begin
        reg.DeleteKey(keyname);
      end;
    end;
  finally
    reg.Free;
  end; // try
end;

end.
