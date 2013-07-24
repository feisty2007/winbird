unit RegUnlock;

interface

uses
  Registry, Windows;
type
  RegeditUnlock = class
  public
    procedure lock(regKey: string; key: string; block: boolean);
  public
    procedure unlockIEHomePage(block: boolean);
    procedure unlockRegCanEdit(block: boolean);
    procedure lockautorun;
    procedure DelAutoShare;
    procedure DefIcmpRedirect;
    procedure UnlockInternetOptions;
  end;

implementation

{ RegeditUnlock }

procedure RegeditUnlock.lock(regkey, key: string; block: boolean);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey(regkey, true) then
    begin
      if not block then
      begin
        if reg.ValueExists(key) then
          reg.WriteInteger(key, 0);
      end
      else
        reg.WriteInteger(key, 1);

      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

end;

procedure RegeditUnlock.unlockRegCanEdit(block: boolean);
const
  regKey = 'Software\Microsoft\Windows\CurrentVersion\Policies\System';
  key = 'DisableRegistryTools';
begin
  lock(regKey, key, block);
end;

procedure RegeditUnlock.unlockIEHomePage(block: boolean);
const
  regKey = 'Software\Policies\Microsoft\Internet Explorer\Control Panel';
  key = 'HomePage';
begin
  lock(regKey, key, block);
end;

procedure RegeditUnlock.lockautorun;
const
  regkey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer';
  key = 'NoDriveTypeAutoRun';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regkey, true) then
    begin
      reg.WriteInteger(key, $FF);
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure RegeditUnlock.DelAutoShare;
const
  regKey_autoshare = 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters';
  key_autoshare = 'AutoShareServer';
  regKey_AutoShareWks = 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters';
  key_AutoShareWks = 'AutoShareWks';
  regkey_ipc = 'SYSTEM\CurrentControlSet\Control\Lsa';
  key_ipc = 'restrictanonymous';
begin
  lock(regKey_autoshare, key_autoshare, false);
  lock(regKey_autosharewks, key_autosharewks, false);
  lock(regkey_ipc, key_ipc, true);
end;

procedure RegeditUnlock.DefIcmpRedirect;
const
  regkey = 'System\CurrentControlSet\Services\Tcpip\Parameters';
  key = 'EnableICMPRedirect';
begin
  lock(regkey, key, false);
end;


procedure RegeditUnlock.UnlockInternetOptions;
const
  regkey = 'Software\Policies\Microsoft\Internet Explorer\restrictions';
  regValue = 'NoBrowserOptions';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try

    if reg.OpenKey(regkey, true) then
    begin
      reg.WriteInteger(regValue, 0);
    end;
  finally
    reg.Free;
  end;

end;

end.
