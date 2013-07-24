unit ShellCmdLine;

interface

uses
  Registry, Windows, Dialogs;
type
  CmdWindows = class
  public
    procedure Execute;
    function CreateSubKey(parentkey: string; subkey: string): boolean;
  end;

implementation

{ CmdWindows }

function CmdWindows.CreateSubKey(parentkey, subkey: string): boolean;
var
  bcmdkey: boolean;
  reg: TRegistry;
begin
  bcmdKey := false;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    if reg.OpenKey(parentkey, true) then
    begin
      if reg.CreateKey(subkey) then
      begin
        bCmdKey := true;
      end;

      if reg.KeyExists(subkey) then
        bCmdKey := true;
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

  result := bCmdKey;
end;

procedure CmdWindows.Execute;
const
  s_CmdWin = '√¸¡Ó––(Command Windows)-gm';
  s_FolderShell = 'Folder\shell';
var
  reg: TRegistry;
  bCmdKey: boolean;
begin
  if not CreateSubKey(s_FolderShell, s_CmdWin) then exit;
  if not CreateSubKey(s_FolderShell + '\' + s_CmdWin, 'command') then exit;

  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  try
    if reg.OpenKey(s_FolderShell + '\' + s_Cmdwin + '\command', true) then
    begin
      reg.WriteString('', 'cmd /K cd /d %L');
        //ShowMessage(reg.ReadString(''));
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;

end;

end.
