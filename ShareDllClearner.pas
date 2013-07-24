unit ShareDllClearner;

interface
uses
  Registry, Classes, Windows, SysUtils;
type
  SharedDllManager = class
  public
    function GetZeroUsedDll: TStringList;
    procedure ClearUnusedDll(dllList: TStrings);
    function GetNoExistsSharedDll: TStringList;
  end;

const
  ShareDllKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls';

implementation

{ SharedDllManager }

procedure SharedDllManager.ClearUnusedDll(dllList: TStrings);
var
  i: integer;
begin
  for i := 0 to dllList.Count - 1 do
  begin
    try
      deletefile(PAnsiChar(dllList.Strings[i]));
    except
    end;
  end;
end;

function SharedDllManager.GetZeroUsedDll: TStringList;
var
  reg: TRegistry;
  dllList: TStringList;
  i: integer;
begin
  dllList := TStringList.Create;
  result := TStringList.Create;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;

    if reg.OpenKey(ShareDllKey, false) then
    begin
      reg.GetValueNames(dllList);

      for i := 0 to dllList.Count - 1 do
      begin
        if reg.ReadInteger(dllList.Strings[i]) = 0 then
          result.Add(dllList.Strings[i]);
      end;
    end;

    reg.CloseKey;
  finally
    reg.Free;
  end;

  dllList.Free;
end;

function SharedDllManager.GetNoExistsSharedDll: TStringList;
var
  reg: TRegistry;
  dllList: TStringList;
  i: integer;
begin
  dllList := TStringList.Create;
  result := TStringList.Create;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;

    if reg.OpenKey(ShareDllKey, false) then
    begin
      reg.GetValueNames(dllList);

      for i := 0 to dllList.Count - 1 do
      begin
        if not FileExists(dllList.Strings[i]) then
          result.Add(dllList.Strings[i]);
      end;
    end;

    reg.CloseKey;
  finally
    reg.Free;
  end;

  dllList.Free;
end;

end.
