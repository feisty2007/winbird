unit AddNewProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IPAddressControl, StdCtrls, Buttons, ComCtrls, ActnList,IpHlpApi,IpTypes,
  Registry,Printers;

type
  TFormAddProfile = class(TForm)
    pgc_Profile: TPageControl;
    ts_Gernel: TTabSheet;
    ts_Network: TTabSheet;
    btn_OK: TBitBtn;
    btn_Cancel: TBitBtn;
    grp_Adapter: TGroupBox;
    cbb_Adapters: TComboBox;
    grp_IPAddress: TGroupBox;
    rb_DHCP: TRadioButton;
    rb_SetIP: TRadioButton;
    lbl_IP: TLabel;
    ipdrscntrl_IP: TIPAddressControl;
    ipdrscntrl_Mask: TIPAddressControl;
    ipdrscntrl_GateWay: TIPAddressControl;
    lbl_Mask: TLabel;
    lbl_DefaultGateWay: TLabel;
    grp_DNS: TGroupBox;
    rb_AutoDNS: TRadioButton;
    rb_useDNS: TRadioButton;
    ipdrscntrl_PriDNS: TIPAddressControl;
    ipdrscntrl_SecDNS: TIPAddressControl;
    lbl_PrimaryDNSServer: TLabel;
    lbl_SecondDNSServer: TLabel;
    btn_useCurrentSettings: TButton;
    grp_General: TGroupBox;
    lbl_ProfileName: TLabel;
    edt_ProfileName: TEdit;
    actlst_dhcp: TActionList;
    act_ProfileOK: TAction;
    cbb_ProfileImage: TComboBox;
    lbl_Image: TLabel;
    act_UseCurrentSetting: TAction;
    ts_IE: TTabSheet;
    ts_Printers: TTabSheet;
    ts_Shell: TTabSheet;
    grp_Printers: TGroupBox;
    chk_ChagePrinter: TCheckBox;
    cbb_Printers: TComboBox;
    lbl_DefaultPrinter: TLabel;
    act_ChangePrinter: TAction;
    grp_InternetExploreHomePage: TGroupBox;
    chk_ChangeIEHomePage: TCheckBox;
    lbl_TypeHomePageUrl: TLabel;
    edt_IEHomePage: TEdit;
    grp_ShellCommand: TGroupBox;
    chk_ExecuteShellCommand: TCheckBox;
    btn_BrowseShellCmd: TButton;
    edt_ShellCommand: TEdit;
    act_IE_ChangeHomePage: TAction;
    act_Shell_Cmd: TAction;
    procedure FormCreate(Sender: TObject);
    procedure act_autodhcpUpdate(Sender: TObject);
    procedure act_autodhcpExecute(Sender: TObject);
    procedure act_autodnsExecute(Sender: TObject);
    procedure act_autodnsUpdate(Sender: TObject);
    procedure cbb_ProfileImageMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    procedure cbb_ProfileImageDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure act_ProfileOKUpdate(Sender: TObject);
    procedure act_ProfileOKExecute(Sender: TObject);
    procedure act_UseCurrentSettingExecute(Sender: TObject);
    procedure rb_DHCPClick(Sender: TObject);
    procedure rb_SetIPClick(Sender: TObject);
    procedure rb_AutoDNSClick(Sender: TObject);
    procedure rb_useDNSClick(Sender: TObject);
    procedure act_ChangePrinterUpdate(Sender: TObject);
    procedure act_IE_ChangeHomePageUpdate(Sender: TObject);
    procedure act_Shell_CmdUpdate(Sender: TObject);
  private
    { Private declarations }
    procedure ClearIP;
    procedure initImageList;

  public
    { Public declarations }
    procedure EnableIPControl;
  end;

var
  FormAddProfile: TFormAddProfile;

implementation

uses NetAdapters, frmMain;

{$R *.dfm}

procedure TFormAddProfile.FormCreate(Sender: TObject);
var
  _adapterinfo: TNetAdapterInfo;
  _ads: TStringList;
begin
  _adapterinfo := TNetAdapterInfo.Create;
  try
    _ads := _adapterinfo.GetAdaptersName;
    cbb_Adapters.Items.Assign(_ads);
    cbb_Adapters.ItemIndex := 0;
  finally
    _adapterinfo.Free;
    _ads.Free;
  end; // try

  ClearIP;
  initImageList;
  EnableIPControl;

  cbb_Printers.Items.Assign(Printer.Printers);
  cbb_Printers.ItemIndex:=Printer.PrinterIndex;
end;

procedure TFormAddProfile.act_autodhcpUpdate(Sender: TObject);
begin
  if rb_DHCP.Checked then
  begin
    EnableWindow(ipdrscntrl_IP.Handle, false);
    EnableWindow(ipdrscntrl_Mask.Handle, false);
    EnableWindow(ipdrscntrl_GateWay.Handle, false);
  end
  else
  begin
    EnableWindow(ipdrscntrl_IP.Handle, true);
    EnableWindow(ipdrscntrl_Mask.Handle, true);
    EnableWindow(ipdrscntrl_GateWay.Handle, true);
  end;
end;

procedure TFormAddProfile.act_autodhcpExecute(Sender: TObject);
begin
  rb_DHCP.Enabled := true;
end;

procedure TFormAddProfile.act_autodnsExecute(Sender: TObject);
begin
  rb_AutoDNS.Enabled := true;
end;

procedure TFormAddProfile.act_autodnsUpdate(Sender: TObject);
begin
  EnableWindow(ipdrscntrl_PriDNS.Handle, not rb_AutoDNS.Checked);
  EnableWindow(ipdrscntrl_SecDNS.Handle, not rb_AutoDNS.Checked);
end;

procedure TFormAddProfile.ClearIP;
  procedure fnClearIP(_ip:TIPAddressControl);
  const
    IPM_CLEARADDRESS=WM_USER+100;
  begin
    SendMessage(_ip.Handle,IPM_CLEARADDRESS,0,0);
  end;
begin
  fnClearIP(ipdrscntrl_IP);
  fnClearIP(ipdrscntrl_GateWay);

  fnClearIP(ipdrscntrl_PriDNS);
  fnClearIP(ipdrscntrl_SecDNS);
end;

procedure TFormAddProfile.cbb_ProfileImageMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 68;
end;

procedure TFormAddProfile.cbb_ProfileImageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  images: TImageList;
  i: integer;
  bmp_Draw: TBitmap;
  bErr: Boolean;
begin
  images := frmMagicIPSet.il_Image;

  bmp_Draw := TBitmap.Create;
  bErr := Images.GetBitmap(Index, bmp_Draw);
  if odSelected in State then
  begin
    cbb_ProfileImage.Canvas.Brush.Color := clBlue;
    cbb_ProfileImage.Canvas.FillRect(Rect);
    cbb_ProfileImage.Canvas.Brush.Color := clDefault;
  end
  else
  begin
    cbb_ProfileImage.Canvas.Brush.Color := clWhite;
    cbb_ProfileImage.Canvas.FillRect(Rect);
    cbb_ProfileImage.Canvas.Brush.Color := clDefault;
  end;

  cbb_ProfileImage.Canvas.Draw(Rect.Left + 2, Rect.Top + 2, bmp_Draw);
  bmp_Draw.Free;
end;

procedure TFormAddProfile.initImageList;
var
  i: integer;
begin
  for i := 0 to frmMagicIPSet.il_Image.Count - 1 do
  begin
    cbb_ProfileImage.Items.Add(IntToStr(i));
  end;
  cbb_ProfileImage.ItemIndex := 0;
end;

procedure TFormAddProfile.act_ProfileOKUpdate(Sender: TObject);
begin
  btn_OK.Enabled := Length(Trim(edt_ProfileName.Text)) > 0;
end;

procedure TFormAddProfile.act_ProfileOKExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormAddProfile.act_UseCurrentSettingExecute(Sender: TObject);
var
  BufLen:DWORD;
  AdapterInfo: PIP_ADAPTER_INFO;
  Err:ULONG;
  P:Pointer;
  _dnsList:TStringList;
  function GetAdapterNameByID(Id: string): string;
  const
    regKey = 'SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}';
  var
    reg: TRegistry;
  begin
    result := '';

    reg := TRegistry.Create;

    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly(regKey + '\' + id + '\connection') then
    begin
      result := Reg.ReadString('Name');
    end;
  end;

  procedure GetIPFromIPList(IPAddress:IP_ADDR_STRING);
  var
    _P:Pointer;
  begin
    P:=@IPAddress;

    with IP_ADDR_STRING(P^) do
    begin
      ipdrscntrl_IP.IPAddress:=IPAddress.S;
      ipdrscntrl_Mask.IPAddress:=IpMask.S;
    end;
  end;

  function GetDNSList(ifIndex:ULONG):TStringList;
  var
    _buflen:DWORD;
    _perAdapterInfo:PIP_PER_ADAPTER_INFO;
    p:Pointer;
    Err:DWORD;
  begin
    result:=TStringList.Create;

    GetPerAdapterInfo(ifIndex,nil,_buflen);
    _perAdapterInfo:=AllocMem(_buflen);

    Err:=GetPerAdapterInfo(ifIndex,_perAdapterInfo,_buflen);

    if Err=NO_ERROR then
    begin
      p:=@_perAdapterInfo.DnsServerList;

      while p<> nil do
      begin
        with IP_ADDR_STRING(P^) do
        begin
          Result.Add(IPAddress.S);
          p:=Next;
        end;
      end;
    end;

    Dispose(_perAdapterInfo);
  end;
begin
  BufLen := SizeOf(AdapterInfo^);
  GetAdaptersInfo(nil, BufLen);
  AdapterInfo := AllocMem(BufLen);
  Err := GetAdaptersInfo(AdapterInfo, BufLen);
  P := AdapterInfo;

  if Err = NO_ERROR then
  begin
    while p <> nil do
    begin
      with IP_ADAPTER_INFO(P^) do
      begin
        if GetAdapterNameByID(AdapterName)=cbb_Adapters.Text then
        begin
          if DhcpEnabled>0 then
          begin
            rb_DHCP.Checked:=true;
            //rb_SetIP.Checked:=False;
            rb_AutoDNS.Checked:=true;
            //rb_useDNS.Checked:=False;
          end
          else
          begin
            rb_DHCP.Checked:=False;
            rb_SetIP.Checked:=true;
            rb_AutoDNS.Checked:=False;
            rb_useDNS.Checked:=true;

            ipdrscntrl_GateWay.IPAddress:=GatewayList.IpAddress.S;

            GetIPFromIPList(IpAddressList);
            _dnsList:=GetDNSList(index);

            if _dnsList.Count=2 then
            begin
              ipdrscntrl_PriDNS.IPAddress:=_dnsList[0];
              ipdrscntrl_SecDNS.IPAddress:=_dnsList[1];
            end
            else if _dnsList.Count=1 then ipdrscntrl_PriDNS.IPAddress:=_dnsList[0];
          end;
          Exit;
          Dispose(AdapterInfo);
        end;
        p:=Next;
      end;
    end;
  end;

  Dispose(AdapterInfo);
end;

procedure TFormAddProfile.rb_DHCPClick(Sender: TObject);
var
  enabled:Boolean;
begin
  enabled:=rb_DHCP.Checked;
  EnableWindow(ipdrscntrl_IP.Handle,not enabled);
  EnableWindow(ipdrscntrl_Mask.Handle,not enabled);
  EnableWindow(ipdrscntrl_GateWay.Handle,not enabled);
end;

procedure TFormAddProfile.rb_SetIPClick(Sender: TObject);
var
  Enabled:Boolean;
begin
  enabled:=rb_SetIP.Checked;
  EnableWindow(ipdrscntrl_IP.Handle,enabled);
  EnableWindow(ipdrscntrl_Mask.Handle,enabled);
  EnableWindow(ipdrscntrl_GateWay.Handle,enabled);
end;

procedure TFormAddProfile.rb_AutoDNSClick(Sender: TObject);
var
  Enabled:Boolean;
begin
  Enabled:=rb_AutoDNS.Checked;

  EnableWindow(ipdrscntrl_PriDNS.Handle,not Enabled);
  EnableWindow(ipdrscntrl_SecDNS.Handle,not Enabled);
end;

procedure TFormAddProfile.rb_useDNSClick(Sender: TObject);
var
  Enabled:Boolean;
begin
  Enabled:=rb_useDNS.Checked;

  EnableWindow(ipdrscntrl_PriDNS.Handle,Enabled);
  EnableWindow(ipdrscntrl_SecDNS.Handle,Enabled);
end;

procedure TFormAddProfile.EnableIPControl;
var
  Enabled:Boolean;
begin
  Enabled:=rb_AutoDNS.Checked;

  EnableWindow(ipdrscntrl_PriDNS.Handle,not Enabled);
  EnableWindow(ipdrscntrl_SecDNS.Handle,not Enabled);

  enabled:=rb_DHCP.Checked;
  EnableWindow(ipdrscntrl_IP.Handle,not enabled);
  EnableWindow(ipdrscntrl_Mask.Handle,not enabled);
  EnableWindow(ipdrscntrl_GateWay.Handle,not enabled);
end;

procedure TFormAddProfile.act_ChangePrinterUpdate(Sender: TObject);
var
  bEnabled:Boolean;
begin
  bEnabled:=chk_ChagePrinter.Checked;

  lbl_DefaultPrinter.Enabled:=bEnabled;
  cbb_Printers.Enabled:=bEnabled;

  chk_ChagePrinter.Enabled:=true;
end;

procedure TFormAddProfile.act_IE_ChangeHomePageUpdate(Sender: TObject);
var
  bEnabled:Boolean;
begin
  bEnabled:=chk_ChangeIEHomePage.Checked;

  lbl_TypeHomePageUrl.Enabled:=bEnabled;
  edt_IEHomePage.Enabled:=bEnabled;

  chk_ChangeIEHomePage.Enabled:=true;
end;

procedure TFormAddProfile.act_Shell_CmdUpdate(Sender: TObject);
var
  bEnabled:Boolean;
begin
  bEnabled:=chk_ExecuteShellCommand.Checked;

  edt_ShellCommand.Enabled:=bEnabled;
  btn_BrowseShellCmd.Enabled:=bEnabled;

  chk_ExecuteShellCommand.Enabled:=true;
end;

end.

