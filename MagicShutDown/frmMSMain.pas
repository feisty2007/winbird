unit frmMSMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ShellAPI, Menus, IniFiles, Buttons;

type
  TForm1 = class(TForm)
    grp1: TGroupBox;
    tmr1: TTimer;
    pm_MS: TPopupMenu;
    grp_Options: TGroupBox;
    chk_Prompt: TCheckBox;
    chk_AutoCloseProgram: TCheckBox;
    chk_Reboot: TCheckBox;
    edt_Prompt: TEdit;
    ud_Prompt: TUpDown;
    dtp_SD: TDateTimePicker;
    Exit1: TMenuItem;
    btn_OK: TBitBtn;
    cbb_Counter: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnTrayMsg(var Msg: TMessage); message WM_USER + 1001;
    procedure ShutDownComputer;
    procedure tmr1Timer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chk_RebootClick(Sender: TObject);
    procedure chk_AutoCloseProgramClick(Sender: TObject);
    procedure chk_PromptClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    tray: TNotifyIconData;
    bPrompt: Boolean;
    PromptMinute: Integer;
    bAutoCloseProgram: Boolean;
    bAutoReboot: Boolean;
    LastSHTime:TDateTime;
    bVirtual:Boolean;

    {Config }
    procedure ReadCfg;
    procedure WriteCfg;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const
  CFG_GERNEL = 'Gernel';
  CFG_BPROMPT = 'Prompt';
  CFG_PROMPTMIN = 'PromptMin';
  CFG_AUTOCLOSEPRG = 'AutoClosePrg';
  CFG_REBOOT = 'AutoReboot';
  CFG_LASTSETTIME = 'LastSetTime';

function GetComputerName: string;
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@buffer, Size);
  Result := strpas(buffer);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  tray.cbSize := SizeOf(TNotifyIconData);

  tray.Wnd := Handle;
  tray.uCallbackMessage := WM_USER + 1001;
  tray.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
  tray.hIcon := Icon.Handle;

  tray.szTip := 'Magic ShutDown';

  Shell_NotifyIcon(NIM_ADD, @tray);

  ReadCfg;


  bVirtual:=false;
  dtp_SD.Time:=LastSHTime;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @tray);

  WriteCfg;
end;

procedure TForm1.OnTrayMsg(var Msg: TMessage);
var
  pt: TPoint;
  x, y: Integer;
begin
  GetCursorPos(pt);

  if Msg.LParam = WM_RBUTTONDOWN then
    pm_MS.Popup(pt.X, pt.Y);

    if msg.LParam=WM_LBUTTONDBLCLK then
      if not Visible then
        Visible:=True;
  msg.Result := 1;
end;

procedure TForm1.ReadCfg;
var
  iniFile: TIniFile;
  strIniFileName: string;
begin
  strIniFileName := ExtractFilePath(Application.ExeName) + 'Shutdown.ini';
  if FileExists(strIniFileName) then
  begin
    IniFile := TIniFile.Create(strIniFileName);
    try
      bPrompt := iniFile.ReadBool(CFG_GERNEL, CFG_BPROMPT, false);
      PromptMinute := iniFile.ReadInteger(CFG_GERNEL, CFG_PROMPTMIN, 30);
      bAutoCloseProgram := iniFile.ReadBool(CFG_GERNEL, CFG_AUTOCLOSEPRG, true);
      bAutoReboot := iniFile.ReadBool(CFG_GERNEL, CFG_REBOOT, False);
      LastSHTime:=iniFile.ReadTime(CFG_GERNEL,CFG_LASTSETTIME,Now+1000);
    finally
      iniFile.Free;
    end;
  end
  else
  begin
    bPrompt := False;
    PromptMinute := 30;
    bAutoCloseProgram := true;
    bAutoReboot := false;
    LastSHTime:=Now+1000;
  end;
end;

procedure TForm1.ShutDownComputer;
var
  hToken: THandle;
  tkp: TOKEN_PRIVILEGES;
  iRet: Cardinal;
begin

  if bVirtual then
  begin
    ShowMessage('Close Computer');
    tmr1.Enabled:=False;

    Exit;
  end;  
  if OpenProcessToken(GetCurrentProcess,
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
    hToken)
    then
  begin
    if LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].luid) then
    begin
      tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tkp.PrivilegeCount := 1;
      AdjustTokenPrivileges(hToken, False, tkp, 0, nil, iRet);
    end;

    InitiateSystemShutdown(PAnsiChar(GetComputerName), 'Computer will be Shutdown in', PromptMinute, bAutoCloseProgram, bAutoReboot);
  end;

  tmr1.Enabled:=false;
end;

procedure TForm1.WriteCfg;
var
  iniFile: TIniFile;
  strIniFileName: string;
begin
  strIniFileName := ExtractFilePath(Application.ExeName) + 'Shutdown.ini';
  IniFile := TIniFile.Create(strIniFileName);
  try
    iniFile.WriteBool(CFG_GERNEL, CFG_BPROMPT, bPrompt);
    iniFile.WriteInteger(CFG_GERNEL, CFG_PROMPTMIN, PromptMinute);
    iniFile.WriteBool(CFG_GERNEL, CFG_AUTOCLOSEPRG, bAutoCloseProgram);
    iniFile.WriteBool(CFG_GERNEL, CFG_REBOOT, bAutoReboot);
    iniFile.WriteTime(CFG_GERNEL,CFG_LASTSETTIME,dtp_SD.Time);
  finally
    iniFile.Free;
  end;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
var
  interval:integer;
begin
  if Now>dtp_SD.Time then
    ShutDownComputer;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caHide;
end;

procedure TForm1.chk_RebootClick(Sender: TObject);
begin
  bAutoReboot:=chk_Reboot.Checked;
end;

procedure TForm1.chk_AutoCloseProgramClick(Sender: TObject);
begin
  bAutoCloseProgram:=chk_AutoCloseProgram.Checked;
end;

procedure TForm1.chk_PromptClick(Sender: TObject);
begin
  bPrompt:=chk_Prompt.Checked;

  if bPrompt then
  begin
    if cbb_Counter.ItemIndex=0 then
      PromptMinute:=StrToInt(edt_Prompt.Text)
    else
      PromptMinute:=StrToInt(edt_Prompt.Text)*60;
  end;
end;

procedure TForm1.btn_OKClick(Sender: TObject);
begin
  Hide;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=false;
end;

end.

