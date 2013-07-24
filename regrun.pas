unit regrun;

interface
uses
  Contnrs, Registry, Windows, Classes;

type
  runitem = class
  private
    Fregpath: string;
    Frunname: string;
    Ffileapth: string;
    procedure Setfileapth(const Value: string);
    procedure Setregpath(const Value: string);
    procedure Setrunname(const Value: string);
  public
    property runname: string read Frunname write Setrunname;
    property fileapth: string read Ffileapth write Setfileapth;
    property regpath: string read Fregpath write Setregpath;
  end;

  TRegRead = class
  public
    function GetRegRunItem(isMachine: Boolean): TObjectList;
    class procedure RemoveItem(itme: runitem);
  end;


{ TRegRead }


implementation

function TRegRead.GetRegRunItem(isMachine: Boolean): TObjectList;
const
  regkey = 'software\Microsoft\Windows\CurrentVersion\Run';
var
  reg: TRegistry;
  regkeys: TStringList;
  i: Integer;
  rtemp: runitem;
begin
  reg := TRegistry.Create;
  Result := TObjectList.Create;
  regkeys := TStringList.Create;

  if isMachine then
    reg.RootKey := HKEY_LOCAL_MACHINE
  else
    reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(regkey, False) then
  begin
    reg.GetValueNames(regKeys);

    for i := 0 to regkeys.Count - 1 do
    begin
      if Length(regkeys[i]) <> 0 then
      begin
        rtemp := runitem.Create;
        rtemp.Frunname := regkeys[i];
        rtemp.Ffileapth := reg.ReadString(regkeys[i]);
        if isMachine then
          rtemp.regpath := 'HKEY_LOCAL_MACHINE'
        else
          rtemp.regpath := 'HKEY_CURRENT_USER';

        result.Add(rtemp);
      end;
    end;

    reg.Free;
  end;

  regkeys.Free;
end;

procedure runitem.Setfileapth(const Value: string);
begin
  Ffileapth := Value;
end;

procedure runitem.Setregpath(const Value: string);
begin
  Fregpath := Value;
end;

procedure runitem.Setrunname(const Value: string);
begin
  Frunname := Value;
end;

class procedure TRegRead.RemoveItem(itme: runitem);
const
  regkey = 'software\Microsoft\Windows\CurrentVersion\Run';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;

  if itme.regpath = 'HKEY_LOCAL_MACHINE' then
    reg.RootKey := HKEY_LOCAL_MACHINE;

  if itme.regpath = 'HKEY_CURRENT_USER' then
    reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(regkey, false) then
  begin
    reg.DeleteValue(itme.runname);
  end;

  reg.CloseKey;
end;

end.
