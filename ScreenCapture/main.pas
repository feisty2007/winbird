unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

const
  WM_SCRCAPTURE = WM_APP+1001;

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    rg_CaptureOption: TRadioGroup;
    Button1: TButton;
    procedure TurnoffMonitor(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnHotKey(var msg:TMessage);message WM_HOTKEY;
  private
    { Private declarations }
    procedure CapWholeDesktop;
    procedure CapActiveWindow;
    procedure CapActiveWidowWithoutTile;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.TurnoffMonitor(Sender: TObject);
begin
  //CapWholeDesktop;
  SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER,2);
  SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER,1)
end;

procedure TForm1.CapActiveWidowWithoutTile;
var
  wActive: HWND;
  m_Hdc: HDC;
  m_iWidth,m_iHeight: integer;
  m_rect:TRect;
  bmp: TBitmap;
  pt:TPoint;
begin
  wActive := GetForegroundWindow;

  Windows.GetClientRect(wActive,m_rect);

  bmp := TBitmap.Create;
  m_iWidth := m_rect.Right - m_rect.Left;
  m_iHeight := m_rect.Bottom - m_rect.Top;
  bmp.Width := m_iWidth;
  bmp.Height := m_iHeight;

  m_hdc := GetDC(0);
  Windows.ClientToScreen(wActive,m_rect.TopLeft);

  Bitblt(bmp.Canvas.Handle,
    0,
    0,
    m_iWidth,
    m_iHeight,
    m_hdc,
    m_rect.TopLeft.X,
    m_rect.TopLeft.Y,
    SRCCOPY
    );
  bmp.SaveToFile('c:\temp\s3.bmp');

end;

procedure TForm1.CapActiveWindow;
var
  wActive: HWND;
  m_Hdc: HDC;
  m_iWidth,m_iHeight: integer;
  m_rect:TRect;
  bmp: TBitmap;
begin
  wActive := GetForegroundWindow;

  GetWindowRect(wActive,m_rect);

  bmp := TBitmap.Create;
  m_iWidth := m_rect.Right - m_rect.Left;
  m_iHeight := m_rect.Bottom - m_rect.Top;
  bmp.Width := m_iWidth;
  bmp.Height := m_iHeight;

  m_hdc := GetDC(0);

  Bitblt(bmp.Canvas.Handle,
    0,
    0,
    m_iWidth,
    m_iHeight,
    m_hdc,
    m_rect.Left,
    m_rect.Top,
    SRCCOPY
    );
  bmp.SaveToFile('c:\temp\s2.bmp');
end;



procedure TForm1.CapWholeDesktop;
var
  bmp: TBitmap;
  desktop_dc: HDC;
begin
  bmp := TBitmap.Create;
  bmp.Width := Screen.Width;
  bmp.Height := Screen.Height;
  desktop_dc := GetDC(0);
  Bitblt(bmp.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, desktop_dc, 0, 0, SRCCOPY);
  bmp.SaveToFile('c:\temp\s1.bmp');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterHotkey(Handle,WM_SCRCAPTURE,MOD_CONTROL+MOD_ALT,VK_F2);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnRegisterHotkey(Handle,WM_SCRCAPTURE);
end;

procedure TForm1.OnHotKey(var msg: TMessage);
var
  i:integer;
begin
  if msg.WParam = WM_SCRCAPTURE then
  begin
      case rg_CaptureOption.ItemIndex of
        0:
          CapWholeDesktop;
        1:
          CapActiveWindow;
        2:
          CapActiveWidowWithoutTile;
      end;
  end;
end;

end.
