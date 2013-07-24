unit LoginUtil;

interface
uses
  Windows, SysUtils, Registry;
type
  TAutoLigin = class
    procedure SetAutoLogin(const username: string; const password: string);
    procedure SetNoAutoLogin;
    procedure ReadAutoLoginInfo(var username: string; var password: string);
  end;

  TLegalNotice = class
    procedure Setcaption(const caption: string);
    procedure setText(const text: string);
    procedure ClearAll;
  end;

implementation

{ TAutoLigin }

procedure TAutoLigin.ReadAutoLoginInfo(var username, password: string);
const
  regkey = 'software\Microsoft\Windows NT\CurrentVersion\Winlogon';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(regkey, False) then
    begin
      username := reg.ReadString('DefaultUserName');
      password := reg.ReadString('DefaultPassword');
    end;
  finally
    reg.Free;
  end;

end;

procedure TAutoLigin.SetAutoLogin(const username, password: string);
const
  regkey = 'software\Microsoft\Windows NT\CurrentVersion\Winlogon';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(regkey, False) then
    begin
      reg.WriteInteger('AutoAdminLogon', 1);
      reg.WriteString('DefaultUserName', username);
      reg.WriteString('DefaultPassword', password);
    end;
  finally
    reg.Free;
  end;
end;

procedure TAutoLigin.SetNoAutoLogin;
const
  regkey = 'software\Microsoft\Windows NT\CurrentVersion\Winlogon';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(regkey, False) then
    begin
      reg.WriteInteger('AutoAdminLogon', 0);

      if reg.ValueExists('DefaultPassword') then
        reg.DeleteValue('DefaultPassword');
    end;
  finally
    reg.Free;
  end;
end;

{ TLegalNotice }

procedure TLegalNotice.ClearAll;
begin
  setText('');
  Setcaption('');
end;

procedure TLegalNotice.Setcaption(const caption: string);
const
  regkey = 'software\Microsoft\Windows NT\CurrentVersion\Winlogon';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(regkey, False) then
    begin
      reg.WriteString('LegalNoticeCaption', caption);
    end;
  finally
    reg.Free;
  end;
end;

procedure TLegalNotice.setText(const text: string);
const
  regkey = 'software\Microsoft\Windows NT\CurrentVersion\Winlogon';
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(regkey, False) then
    begin
      reg.WriteString('LegalNoticeText', text);
    end;
  finally
    reg.Free;
  end;

end;

end.
