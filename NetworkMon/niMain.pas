unit niMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ComCtrls, ToolWin, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    tlb_Main: TToolBar;
    lv_Status: TListView;
    btn_GetState: TToolButton;
    il_Main: TImageList;
    actlst1: TActionList;
    act_GetProcess: TAction;
    stat_Main: TStatusBar;
    mm_Main: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    btn1: TToolButton;
    btn_TCP: TToolButton;
    btn_UDP: TToolButton;
    btn2: TToolButton;
    btn_AutoRefresh: TToolButton;
    tmr_Fresh: TTimer;
    Option1: TMenuItem;
    Option2: TMenuItem;
    act_ShowTCP: TAction;
    act_ShowUDP: TAction;
    act_ShowOptions: TAction;
    act_AutoRefresh: TAction;
    procedure Exit1Click(Sender: TObject);
    procedure act_GetProcessExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure act_ShowTCPUpdate(Sender: TObject);
    procedure act_ShowUDPUpdate(Sender: TObject);
    procedure tmr_FreshTimer(Sender: TObject);
    procedure act_ShowTCPExecute(Sender: TObject);
    procedure act_ShowUDPExecute(Sender: TObject);
    procedure act_AutoRefreshExecute(Sender: TObject);
    procedure act_AutoRefreshUpdate(Sender: TObject);
  private
    { Private declarations }
    bShowTCP:Boolean;
    bShowUDP:Boolean;
    bAutoRefresh:Boolean;
    procedure GetTCPLinks;
    procedure GetUDPLinks;

    procedure ClearTCPItems;
    procedure ClearUDPItems;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation



uses IPHLPAPI, ProcessMapper;

{$R *.dfm}



function PortNumToString (PortNum: Word): String;
begin
    Result := IntToStr ((LoByte (PortNum) * 256) + HiByte (PortNum));
end;

// Convert a packed IP address to xxx.xxx.xxx.xxx format

function IPAddressToString (IPAddress: DWord): String;
var
    Idx: Integer;
begin
    Result := '';
    for Idx := 0 to 3 do begin
        Result := Result + Format ('%d', [IPAddress and $FF]);
        if Idx <> 3 then Result := Result + '.';
        IPAddress := IPAddress shr 8;
    end;
end;

function GetTcpStateDescription(dwStatus:DWORD):string;
const
  TCPStateNames: array [1..12] of String = (
        'Closed', 'Listening', 'Syn Sent', 'Syn Rcvd', 'Established', 'Fin Wait1',
        'Fin Wait2', 'Close Wait', 'Closing', 'Last_Ack', 'Time Wait', 'Delete TCB' );
begin
  if (dwStatus<1) and (dwStatus>12) then
    Result:='Unknown'
  else
    Result:=TCPStateNames[dwStatus];
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.act_GetProcessExecute(Sender: TObject);
begin
  lv_Status.Clear;

  if bShowTCP then
    GetTCPLinks;

  if bShowUDP then
    GetUDPLinks;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 bShowTCP:=true;
 bShowUDP:=true;
 bAutoRefresh:=true;
end;

procedure TForm1.GetTCPLinks;
var
  tcps:PTCPTableEx;
  i:integer;
begin
  ProcessCreateSnapshot;
  tcps:=GetTcpTableEx;
  for i := 0 to tcps^.NumEntries-1 do
  begin
      with lv_Status.Items.Add do
      begin
        Caption:=IPAddressToString(tcps^.Table[i].dwLocalAddr)+':'+PortNumToString(tcps^.Table[i].dwLocalPort);
        SubItems.Add(IPAddressToString(tcps^.Table[i].dwRemoteAddr)+':'+PortNumToString(tcps^.Table[i].dwRemotePort));
        SubItems.Add(GetTcpStateDescription(tcps^.Table[i].dwState));
        SubItems.Add('TCP');
        SubItems.Add(ProcessPIDToProcessName(tcps^.Table[i].dwProcessID));
	      SubItems.Add(GetExeFileName(tcps^.Table[i].dwProcessID));
      end;
  end;
  ProcessDeleteSnapshot;
end;

procedure TForm1.GetUDPLinks;
var
  udps:PUDPTableEx;
  i:integer;
begin
  udps:=GetUdpTableEx;
  ProcessCreateSnapshot;
  for i :=0  to udps^.NumEntries-1 do
  begin
    with lv_Status.Items.Add do
    begin
        Caption:=IPAddressToString(udps^.Table[i].dwLocalAddr)+':'+PortNumToString(udps^.Table[i].dwLocalPort);
        SubItems.Add('');
        SubItems.Add('');
        SubItems.Add('UDP');
        SubItems.Add(ProcessPIDToProcessName(udps^.Table[i].dwProcessID));
	      SubItems.Add(GetExeFileName(udps^.Table[i].dwProcessID));
    end;
  end;

  ProcessDeleteSnapshot;
end;

procedure TForm1.act_ShowTCPUpdate(Sender: TObject);
begin
  btn_TCP.Down:=bShowTCP;
end;

procedure TForm1.act_ShowUDPUpdate(Sender: TObject);
begin
  btn_UDP.Down:=bShowUDP;
end;

procedure TForm1.tmr_FreshTimer(Sender: TObject);
begin
  if bShowUDP or bShowTCP then
  begin
    lv_Status.Clear;

    if bShowTCP then
      GetTCPLinks;

    if bShowUDP then
      GetUDPLinks;
  end;
end;

procedure TForm1.act_ShowTCPExecute(Sender: TObject);
begin
  bShowTCP:=not bShowTCP;

  if bShowTCP=false  then
    ClearTCPItems;

  if (bShowTCP) and (not bAutoRefresh) then
	GetTCPLinks;
end;

procedure TForm1.act_ShowUDPExecute(Sender: TObject);
begin
  bShowUDP:=not bShowUDP;

  if bShowUDP=False then
    ClearUDPItems;

  if (bShowUDP) and (not bAutoRefresh) then
	GetUDPLinks;
end;

procedure TForm1.act_AutoRefreshExecute(Sender: TObject);
begin
  bAutoRefresh:=not bAutoRefresh;
  tmr_Fresh.Enabled:=bAutoRefresh;
end;

procedure TForm1.act_AutoRefreshUpdate(Sender: TObject);
begin
 tmr_Fresh.Enabled:=bAutoRefresh; 
 btn_AutoRefresh.Down:=bAutoRefresh;
end;

procedure TForm1.ClearTCPItems;
const
  typeIndex=3;
var
  i:Integer;
begin
  for i := lv_Status.Items.Count-1 downto 0 do
  begin
      if lv_Status.Items[i].SubItems[typeIndex]='TCP' then
        lv_Status.Items[i].Delete;
  end;
end;

procedure TForm1.ClearUDPItems;
const
  typeIndex=3;
var
  i:Integer;
begin
  for i := lv_Status.Items.Count-1 downto 0 do
  begin
      if lv_Status.Items[i].SubItems[typeIndex]='UDP' then
        lv_Status.Items[i].Delete;
  end;
end;

end.
