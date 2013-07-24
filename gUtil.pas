unit gUtil;

interface
uses
  SysUtils, Windows, Classes, Registry;

type
  DirHelper = class
    class procedure DeleteDir(dirname: string; bTop: Boolean);
  end;

  TShowHiddenFile = class
    procedure Show;
  end;

  RegeditHelper = class
    class procedure RemoveAllKeys(const regKey: string; isMachine: Boolean = False);
    class procedure RemoveAllValues(const regKey: string; isMachine: Boolean = False);
  end;

implementation

{ DirHelper }

class procedure DirHelper.DeleteDir(dirname: string; bTop: Boolean);
var
  sr: SysUtils.TSearchRec;
  iRet: integer;
  sFileName: string;
  dwAttribute: Cardinal;
begin
  if SysUtils.FindFirst(dirname + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if ((sr.Attr and faDirectory) = faDirectory) then
      begin
        if (sr.Name <> '.') and (sr.Name <> '..') then
          DeleteDir(dirname + '\' + sr.Name, false);
      end
      else
      begin
        sFileName := dirname + '\' + sr.Name;
        dwAttribute := GetFileAttributes(PChar(sFileName));

        if (dwAttribute and FILE_ATTRIBUTE_READONLY) = 0 then
        begin
          SetFileAttributeS(PChar(sFileName), dwAttribute or FILE_ATTRIBUTE_READONLY);
        end;
        SysUtils.DeleteFile(dirname + '\' + sr.Name);
      end;
    until SysUtils.FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

  if not btop then
    rmdir(dirname);
end;

{ RegeditHelper }

class procedure RegeditHelper.RemoveAllKeys(const regKey: string;
  isMachine: Boolean);
var
  reg: TRegistry;
  keys: TStringList;
  i: integer;
begin

  reg := TRegistry.Create;
  keys := TStringList.Create;
  if isMachine then
    reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey(regKey, false) then
    begin
      reg.GetKeyNames(keys);

      for i := 0 to keys.Count - 1 do
      begin
        reg.DeleteKey(keys[i]);
      end;

      reg.CloseKey;
    end;
  finally
    reg.Free;
    keys.Free;
  end;

end;

class procedure RegeditHelper.RemoveAllValues(const regKey: string;
  isMachine: Boolean);
var
  reg: TRegistry;
  values: TStringList;
  i: integer;
begin
  reg := TRegistry.Create;
  values := TStringList.Create;
  if isMachine then
    reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey(regKey, false) then
    begin
      reg.GetValueNames(values);

      for i := 0 to values.Count - 1 do
      begin
        reg.DeleteValue(values[i]);
      end;

      reg.CloseKey;
    end;
  finally
    reg.Free;
    values.Free;
  end;


end;

{ TShowHiddenFile }

procedure TShowHiddenFile.Show;
const
  regkey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey(regkey, false) then
    begin
      if reg.ValueExists('CheckedValue') then
        reg.DeleteValue('CheckedValue');

      reg.WriteInteger('CheckedValue', 1);
      reg.WriteInteger('DefaultValue', 2);
    end;
  finally
    reg.Free;
  end; // try
end;

end.
