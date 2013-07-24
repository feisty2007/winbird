unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IpHlpApi, StdCtrls, Nb30, Registry, ActnList, ImgList, ProfileCls,IPAddressControl;

type
  TfrmMagicIPSet = class(TForm)
    lst_Adapters: TListBox;
    btn_GetInf2: TButton;
    actlst1: TActionList;
    act_AddProfile: TAction;
    btn_EditProfile: TButton;
    btn_RemoveProfile: TButton;
    il_Image: TImageList;
    act_RemoveProfile: TAction;
    btn_SwtichTo: TButton;
    act_Swtich: TAction;
    act_EditProfile: TAction;
    procedure act_AddProfileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lst_AdaptersMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lst_AdaptersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure act_RemoveProfileExecute(Sender: TObject);
    procedure act_RemoveProfileUpdate(Sender: TObject);
    procedure act_SwtichUpdate(Sender: TObject);
    procedure act_EditProfileUpdate(Sender: TObject);
    procedure act_EditProfileExecute(Sender: TObject);
    procedure act_SwtichExecute(Sender: TObject);
  private
    { Private declarations }
    profiles: TGNetworkProfile;
  public
    { Public declarations }
  end;

var
  frmMagicIPSet: TfrmMagicIPSet;

implementation

uses IpTypes, IpExport, IpRtrMib, NetAdapters, AddNewProfile, NetshDebug;

{$R *.dfm}

procedure TfrmMagicIPSet.act_AddProfileExecute(Sender: TObject);
var
  na: TNetAdapter;
begin

  if formAddProfile.showmodal = mrOk then
  begin
    na := TNetAdapter.Create;

    with formAddProfile do
    begin
      na.profileName := edt_ProfileName.Text;
      na.imageindex := cbb_ProfileImage.ItemIndex;

      na.AdapterName := cbb_Adapters.Text;
      na.isDHCP := rb_DHCP.Checked;

      if not rb_DHCP.Checked then
      begin
        na.IPAddress := ipdrscntrl_IP.IPAddress;
        na.NetMask := ipdrscntrl_Mask.IPAddress;
        na.Gateway := ipdrscntrl_GateWay.IPAddress;
      end;

      na.isAutoDNS := rb_AutoDNS.Checked;

      if not na.isAutoDNS then
      begin
        na.dns_first := ipdrscntrl_PriDNS.IPAddress;
        na.dns_second := ipdrscntrl_SecDNS.IPAddress;
      end;

      profiles.ProfileList.Add(na);
      lst_Adapters.Items.Add(IntToStr(lst_Adapters.Count));
    end;
  end;
end;

procedure TfrmMagicIPSet.FormCreate(Sender: TObject);
var
  i: integer;
  iCount: Integer;
begin
  profiles := TGNetworkProfile.Create;

  iCount := profiles.ProfileList.Count;
  if iCount > 0 then
  begin
    for i := 0 to iCount - 1 do
    begin
      lst_Adapters.Items.Add(IntToStr(i))
    end;
  end;
end;

procedure TfrmMagicIPSet.lst_AdaptersMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  na: TNetAdapter;
begin
  Height := 68;
end;

procedure TfrmMagicIPSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  profiles.WriteToConfig;
  profiles.ProfileList.Free;

  profiles.Free;
end;

procedure TfrmMagicIPSet.lst_AdaptersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
const
  Margin = 2;
var
  na: TNetAdapter;
  bmp: TBitmap;
  _ip:string;
begin
  na := profiles.ProfileList[index] as TNetAdapter;

  if na.isDHCP then
    _ip:='DHCP'
  else
    _ip:=na.IPAddress;
    
  if odSelected in State then
  begin
    lst_Adapters.Canvas.Brush.Color := clBlue;
    lst_Adapters.Canvas.FillRect(rect);

    lst_Adapters.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    lst_Adapters.Canvas.Brush.Color := clWhite;
    lst_Adapters.Canvas.FillRect(rect);
    lst_Adapters.Canvas.Brush.Color := clWhite;
  end;

  bmp := TBitmap.Create;
  //bmp.TransparentColor:=clWhite;
  //bmp.Transparent:=true;
  il_Image.GetBitmap(na.imageindex, bmp);
  lst_Adapters.Canvas.Draw(Rect.Left + Margin, Rect.Top + Margin, bmp);

  //lst_Adapters.Canvas.Pen.Color:=clYellow;
  if odSelected in State then
  begin
    lst_Adapters.Canvas.Brush.Color := clBlue;
    lst_Adapters.Canvas.TextOut(Rect.Left + bmp.Width + 10, Rect.Top + 2, na.profileName+'('+_ip+')');
    lst_Adapters.Canvas.TextOut(Rect.Left + bmp.Width + 10, Rect.Top + 2 + 20, na.AdapterName);
    lst_Adapters.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    lst_Adapters.Canvas.Brush.Color := clWhite;
    lst_Adapters.Canvas.TextOut(Rect.Left + bmp.Width + 10, Rect.Top + 2, na.profileName+'('+_ip+')');
    lst_Adapters.Canvas.TextOut(Rect.Left + bmp.Width + 10, Rect.Top + 2 + 20, na.AdapterName);
    lst_Adapters.Canvas.Brush.Color := clWhite;
  end;
  bmp.Free;
end;

procedure TfrmMagicIPSet.act_RemoveProfileExecute(Sender: TObject);
begin
  profiles.ProfileList.Delete(lst_Adapters.ItemIndex);
  lst_Adapters.Items.Delete(lst_Adapters.ItemIndex);
end;

procedure TfrmMagicIPSet.act_RemoveProfileUpdate(Sender: TObject);
begin
  btn_RemoveProfile.Enabled := (lst_Adapters.Items.Count > 0) and (lst_Adapters.ItemIndex <> -1);
end;

procedure TfrmMagicIPSet.act_SwtichUpdate(Sender: TObject);
begin
  btn_SwtichTo.Enabled := (lst_Adapters.Items.Count > 0) and (lst_Adapters.ItemIndex <> -1);
end;

procedure TfrmMagicIPSet.act_EditProfileUpdate(Sender: TObject);
begin
  btn_EditProfile.Enabled := (lst_Adapters.Items.Count > 0) and (lst_Adapters.ItemIndex <> -1);
end;

procedure TfrmMagicIPSet.act_EditProfileExecute(Sender: TObject);
var
  _na:TNetAdapter;
  function VerifyIPAddress(IPAddress:string):Boolean;
  var
    ips:TStringList;
    i,iCount:integer;
    j:integer;
  begin
    Result:=True;
    j:=0;
    ips:=TStringList.Create;
    iCount:=ExtractStrings(['.'],[],PChar(IPAddress),ips);

    if iCount<>4 then
    begin
      Result:=false;
      exit;
    end;

    for i :=0  to iCount-1 do
    begin
       if not TryStrToInt(ips[i],j) then
       begin
         Result:=false;
         exit;
       end
       else if (j<0) or (j>255) then
       begin
         result:=False;
         exit;
       end;
    end;
  end;
  procedure SetIPAddress(IPCtrl:TIPAddressControl;IPAddress:string);
  const
    IPM_CLEARADDRESS=WM_USER+100;
  begin
    if (Length(Trim(IPAddress))=0) then
    begin
      SendMessage(IPCtrl.Handle,IPM_CLEARADDRESS,0,0);
      exit;
    end;

    if not VerifyIPAddress(IPAddress) then
    begin
      SendMessage(IPCtrl.Handle,IPM_CLEARADDRESS,0,0);
      exit;
    end;
    IPCtrl.IPAddress:=IPAddress;
  end;

  function GetIPAddress(IPCtrl:TIPAddressControl):string;
  begin
    Result:=IPCtrl.IPAddress;
  end;
begin
  _na:=profiles.ProfileList[lst_Adapters.ItemIndex] as TNetAdapter;

  with formAddProfile do
  begin
    edt_ProfileName.Text:=_na.profileName;
    cbb_ProfileImage.ItemIndex:=_na.imageindex;

    cbb_Adapters.ItemIndex:=cbb_Adapters.Items.IndexOf(_na.AdapterName);
    if _na.isDHCP then
    begin
      rb_DHCP.Checked:=true;
    end
    else
    begin
      rb_DHCP.Checked:=False;
      rb_SetIP.Checked:=true;
      SetIPAddress(ipdrscntrl_IP,_na.IPAddress);
      SetIPAddress(ipdrscntrl_Mask,_na.NetMask);
      SetIPAddress(ipdrscntrl_GateWay,_na.Gateway);
    end;

    if _na.isAutoDNS then
    begin
      rb_AutoDNS.Checked:=true;
    end
    else
    begin
      rb_AutoDNS.Checked:=False;
      rb_useDNS.Checked:=true;
      SetIPAddress(ipdrscntrl_PriDNS,_na.dns_first);
      SetIPAddress(ipdrscntrl_SecDNS,_na.dns_second);
    end;

    if _na.ChangeIEHomePage then
    begin
      chk_ChangeIEHomePage.Checked:=true;
      edt_IEHomePage.Text:=_na.IEHomePage;
    end
    else
      chk_ChangeIEHomePage.Checked:=False;

    if _na.ChangeDefaultPrinter then
    begin
      chk_ChagePrinter.Checked:=true;
      cbb_Printers.ItemIndex:=cbb_Printers.Items.IndexOf(_na.DefaultPrinter);
    end
    else
      chk_ChagePrinter.Checked:=False;

    if _na.ISExecuteShell then
    begin
      chk_ExecuteShellCommand.Checked:=true;
      edt_ShellCommand.Text:=_na.ShellCommand;
    end
    else
      chk_ExecuteShellCommand.Checked:=false;

    EnableIPControl;
    if ShowModal=mrOK then
    begin
      _na.profileName := edt_ProfileName.Text;
      _na.imageindex := cbb_ProfileImage.ItemIndex;

      _na.AdapterName := cbb_Adapters.Text;
      _na.isDHCP := rb_DHCP.Checked;

      if not rb_DHCP.Checked then
      begin
        _na.IPAddress := ipdrscntrl_IP.IPAddress;
        _na.NetMask := ipdrscntrl_Mask.IPAddress;
        _na.Gateway := ipdrscntrl_GateWay.IPAddress;
      end;

      _na.isAutoDNS := rb_AutoDNS.Checked;

      if not _na.isAutoDNS then
      begin
        _na.dns_first := ipdrscntrl_PriDNS.IPAddress;
        _na.dns_second := ipdrscntrl_SecDNS.IPAddress;
      end;

      _na.ChangeIEHomePage:=chk_ChangeIEHomePage.Checked;
      if _na.ChangeIEHomePage then
        _na.IEHomePage:=edt_IEHomePage.Text;

      _na.ChangeDefaultPrinter:=chk_ChagePrinter.Checked;
      if _na.ChangeDefaultPrinter then
        _na.DefaultPrinter:=cbb_Printers.Text;

      _na.ISExecuteShell:=chk_ExecuteShellCommand.Checked;
      if _na.ISExecuteShell then
        _na.ShellCommand:=edt_ShellCommand.Text;
    end;
  end;


end;

procedure TfrmMagicIPSet.act_SwtichExecute(Sender: TObject);
var
  _na:TNetAdapter;
  _cmds:TStringList;
  _fileName:string;
  Err:DWORD;
  Applyfrm:TfrmNetsh;
begin
  _na:=profiles.ProfileList[lst_Adapters.ItemIndex] as TNetAdapter;

  _cmds:=_na.GetSwithCommands;
   _fileName:=ExtractFilePath(Application.ExeName)+'IPSet.txt';
  if fileExists(_fileName) then
    Deletefile(_FileName);

  _cmds.SaveToFile(_fileName);

  Applyfrm:=TfrmNetsh.Create(self);
  Applyfrm.AppName:='cmd.exe';
  Applyfrm.AppParams:=' /c netsh -f "'+_filename+'"';
  Applyfrm.ChangeIEHomePage:=_na.ChangeIEHomePage;
  if _na.ChangeIEHomePage then
    Applyfrm.IEHomePage:=_na.IEHomePage;

  Applyfrm.ChangeDefaultPrinter:=_na.ChangeDefaultPrinter;
  if _na.ChangeDefaultPrinter then
    Applyfrm.DefaultPrinterName:=_na.DefaultPrinter;
  Applyfrm.ShowModal;
  _cmds.Free;
end;

end.

