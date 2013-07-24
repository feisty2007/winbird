unit main;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Contnrs, XPMan, ImgList, CommCtrl, Menus,
  ExtCtrls, FileCtrl, ActnList;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    TabSheet3: TTabSheet;
    Button2: TButton;
    Button3: TButton;
    TabSheet4: TTabSheet;
    Button4: TButton;
    Button5: TButton;
    TabSheet5: TTabSheet;
    Button6: TButton;
    TabSheet6: TTabSheet;
    Button7: TButton;
    Button8: TButton;
    MultiPrint: TTabSheet;
    lstFiles: TListBox;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    Button10: TButton;
    Button11: TButton;
    lvBootItem: TListView;
    btnLoadRegRun: TButton;
    btnRegApplyChange: TButton;
    lvSoftware: TListView;
    btnReadSoftInstallInfo: TButton;
    btnDeletePrintFile: TButton;
    btnUninstallSoft: TButton;
    btnHideWinPatch: TButton;
    tsSerivice: TTabSheet;
    lvServices: TListView;
    btnReadSerivices: TButton;
    xpmnfst1: TXPManifest;
    ilSoftwares: TImageList;
    pm_UninstallProgram: TPopupMenu;
    Uninstall1: TMenuItem;
    pnl1: TPanel;
    tv_RegComplete: TTreeView;
    spl1: TSplitter;
    lv_RegComplete: TListView;
    btn_UnlockInternetOption: TButton;
    btn_EnableTaskManager: TButton;
    btn_OrderStartMenuByName: TButton;
    ts_Login: TTabSheet;
    chk_AutoLogin: TCheckBox;
    grp1: TGroupBox;
    lbl_UserName: TLabel;
    edt_UserName: TEdit;
    lbl_Password: TLabel;
    edt_Password: TEdit;
    btn_AutoLogin_OK: TButton;
    grp_LogalNotice: TGroupBox;
    lbl_ln_Caption: TLabel;
    lbl_ln_Text: TLabel;
    edt_ln_Caption: TEdit;
    btn_ln_Set: TButton;
    btn_ln_Clear: TButton;
    mmo_ln_Text: TMemo;
    btnShowHidden: TButton;
    ts_HiddenFolder: TTabSheet;
    edt_FolderName: TEdit;
    btn_SeleFolder: TButton;
    lbl1: TLabel;
    cbb_HiddenFolder: TComboBox;
    btn_HiddenFolder: TButton;
    btn_UnhiddenFolder: TButton;
    ts_OemInfo: TTabSheet;
    grp_OemInfo: TGroupBox;
    lbl_Manu: TLabel;
    edt_Oem_Menau: TEdit;
    lbl_Oem_Model: TLabel;
    edt_Oem_Model: TEdit;
    btn_Read_OEM: TButton;
    btn_SetOem: TButton;
    mmo_OEM_Support: TMemo;
    ts_ImeTool: TTabSheet;
    lst_Imes: TListBox;
    btn_ReadIme: TButton;
    btn_Ime_Up: TButton;
    btn_Ime_Down: TButton;
    actlst_Ime: TActionList;
    act_Ime_Up: TAction;
    act_Ime_Down: TAction;
    btn_Ime_Apply: TButton;
    act_Ime_Apply: TAction;
    act_PM_Read: TAction;
    act_PM_uninstall: TAction;
    act_PM_HidePatch: TAction;
    act_NTService_Read: TAction;
    act_HiddenFolder_Hidden: TAction;
    act_HiddenFolder_Unhidden: TAction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure btnLoadRegRunClick(Sender: TObject);
    procedure btnRegApplyChangeClick(Sender: TObject);
    procedure btnDeletePrintFileClick(Sender: TObject);
    procedure btnReadSoftInstallInfoClick(Sender: TObject);
    procedure btnUninstallSoftClick(Sender: TObject);
    procedure lvSoftwareDeletion(Sender: TObject; Item: TListItem);
    procedure btnHideWinPatchClick(Sender: TObject);
    procedure btnReadSerivicesClick(Sender: TObject);
    procedure btn_UnlockInternetOptionClick(Sender: TObject);
    procedure btn_EnableTaskManagerClick(Sender: TObject);
    procedure btn_OrderStartMenuByNameClick(Sender: TObject);
    procedure btn_AutoLogin_OKClick(Sender: TObject);
    procedure chk_AutoLoginClick(Sender: TObject);
    procedure btn_ln_SetClick(Sender: TObject);
    procedure btn_ln_ClearClick(Sender: TObject);
    procedure btnShowHiddenClick(Sender: TObject);
    procedure btn_SeleFolderClick(Sender: TObject);
    procedure btn_HiddenFolderClick(Sender: TObject);
    procedure btn_UnhiddenFolderClick(Sender: TObject);
    procedure btn_Read_OEMClick(Sender: TObject);
    procedure btn_SetOemClick(Sender: TObject);
    procedure btn_ReadImeClick(Sender: TObject);
    procedure act_Ime_UpUpdate(Sender: TObject);
    procedure act_Ime_DownUpdate(Sender: TObject);
    procedure act_Ime_DownExecute(Sender: TObject);
    procedure act_Ime_UpExecute(Sender: TObject);
    procedure act_Ime_ApplyUpdate(Sender: TObject);
    procedure act_Ime_ApplyExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure act_PM_uninstallUpdate(Sender: TObject);
    procedure act_PM_HidePatchUpdate(Sender: TObject);
    procedure act_HiddenFolder_HiddenUpdate(Sender: TObject);
    procedure act_HiddenFolder_UnhiddenUpdate(Sender: TObject);
  private
    { Private declarations }
    tvFoot_NodeChecked: Boolean;
    //tvFoot_NodeClick:TTreeNode;
  public
    { Public declarations }

  private
    bImageChange:Boolean;
    imes:TObjectList;
  end;

var
  Form1: TForm1;

implementation

uses ShellCmdLine, RegUnlock, ShareDllClearner, GMsgbox, OfficeOperation,
  regrun, SoftInfo, NtService,
  RegComplete, SystemSecurity, SystemEnc,
  LoginUtil, gUtil, THiddenFolder, oeminfo, TImeTool;

{$R *.dfm}

procedure TForm1.Button10Click(Sender: TObject);
var
  i: integer;
  opx: OfficePrinter;

  function GetPrinter(ext: string): OfficePrinter;
  begin
    if (ext = '.doc') or (ext = '.docx') then
      result := TWordPrinter.create
    else
    begin
      if (ext = '.xls') or (ext = '.xlsx') then
        result := TExcelPrinter.Create
      else
        result := TPdfPrinter.Create;
    end;
  end;
begin
  for i := 0 to lstFiles.Items.Count - 1 do
  begin
    opx := GetPrinter(ExtractFileExt(lstFiles.Items[i]));
    opx.PrintFile(lstFiles.Items[i]);
    opx._Release;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  cw: CmdWindows;
begin
  cw := CmdWindows.Create;
  cw.Execute;

  ShowMessage('添加右键命令成功!');
  cw.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ru: RegeditUnlock;
begin
  ru := RegeditUnlock.Create;

  ru.unlockRegCanEdit(false);

  ru.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ru: RegeditUnlock;
begin
  ru := RegeditUnlock.Create;
  ru.unlockIEHomePage(false);

  ru.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  sm: SharedDllManager;
  zeroUseDll: TStringList;
  i: Integer;
  AutoStart: TRegComplete;
  MissingHelp: TRegComplete;
begin
  sm := SharedDllManager.Create;

  //listbox1.Clear;
  zeroUseDll := sm.GetNoExistsSharedDll;
  //listBox1.Items.AddStrings(zeroUseDll);

  for i := 0 to zeroUseDll.Count - 1 do
  begin
    with lv_RegComplete.Items.Add do
    begin
      Caption := 'Missed Shared DLL';
      SubItems.Add(zeroUseDll.Strings[i]);
    end;
  end;


  TGMsgBox.ShowInfo(handle, 'Modify Windows Pro', '分析完毕！');
  zeroUseDll.Free;
  sm.Free;

//  mi:=TMissingMUI.Create('');
//  mi.FillList(lv_RegComplete);
//
  AutoStart := TStartProgram.Create('');
  AutoStart.FillList(lv_RegComplete);

  MissingHelp := TMissingHelp.Create('');
  MissingHelp.FillList(lv_RegComplete);

  MissingHelp.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  hf: TFolderHidden;
begin
  Caption := 'Modify Windows Pro';

  //Folder Hidde init Item
  hf := TFolderHidden.Create;
  cbb_HiddenFolder.Items.Assign(hf.GetHiddenNames);
  cbb_HiddenFolder.ItemIndex := 0;
  hf.Free;

  bImageChange:=False;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  ru: RegeditUnlock;
begin
  ru := RegeditUnlock.Create;
  ru.lockautorun;

  TGMsgBox.ShowInfo(handle, 'Modify windows Pro', '禁止自动运行功能成功');
  ru.Free;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  ru: RegeditUnlock;
begin
  ru := RegeditUnlock.Create;
  ru.DelAutoShare;
  ru.Free;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  ru: RegeditUnlock;
begin
  ru := RegeditUnlock.Create;
  ru.DefIcmpRedirect;

  ru.Free;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i: integer;
begin
  if openDialog1.Execute then
  begin
    for I := 0 to openDialog1.Files.Count - 1 do
      lstFiles.Items.add(OpenDialog1.Files[i]);
  end;
end;

procedure TForm1.btnLoadRegRunClick(Sender: TObject);
var
  regReader: TRegRead;
  items_user, items_machine: TObjectList;
  procedure AddRunItem(items: TObjectList);
  var
    temp_item: integer;
    rt: runitem;
  begin
    for temp_item := 0 to items.Count - 1 do
    begin
      rt := items[temp_item] as runitem;

      with lvBootItem.Items.Add do
      begin
        caption := rt.runname;
        Checked := true;
        SubItems.Add(rt.fileapth);
        SubItems.Add(rt.regpath);
      end;
    end;
  end;

  procedure FreeMemx(var items: TObjectList);
  var
    i: integer;
    rt: runitem;
  begin
    for i := items.Count - 1 downto 0 do
    begin
      rt := items[i] as runitem;
      rt.Free;
    end;

  end;
begin
  regReader := TRegRead.Create;

  items_user := regReader.GetRegRunItem(false);
  items_machine := regReader.GetRegRunItem(true);

  AddRunItem(items_user);
  AddRunItem(items_machine);

  items_user.Free;
  items_machine.Free;

    //FreeMemx(items_user);
    //FreeMemx(items_machine);
  regReader.Free;
end;

procedure TForm1.btnRegApplyChangeClick(Sender: TObject);
var
  i: integer;
  tempItem: TListItem;
  rt: runitem;

  function getRunItemFromListItem(listItem: TListItem): runitem;
  begin
    result := runitem.Create;

    Result.runname := listItem.Caption;
    Result.fileapth := listItem.SubItems[0];
    Result.regpath := listItem.SubItems[1];
  end;
begin
  for i := 0 to lvBootItem.Items.Count - 1 do
  begin
    tempItem := lvBootItem.Items[i];

    if not tempItem.Checked then
    begin
      rt := getRunItemFromListItem(tempItem);
      TRegRead.RemoveItem(rt);
      rt.Free;
    end;
  end;

  for i := lvBootItem.Items.Count - 1 downto 0 do
  begin
    tempItem := lvBootItem.Items[i];
    if tempItem.Checked = false then
      tempItem.Delete;
  end;
end;

procedure TForm1.btnDeletePrintFileClick(Sender: TObject);
begin
  lstFiles.DeleteSelected;
end;

procedure TForm1.btnReadSoftInstallInfoClick(Sender: TObject);
var
  sx: TSoftInfo;
  six: PSoftInfoData;
  softs: TObjectList;
  i: Integer;
  iAddIconResult: Integer;
begin

  softs := TUninstallInfo.GetInstalledSoft;
  lvSoftware.Clear;
  for i := 0 to softs.Count - 1 do
  begin
    sx := softs.Items[i] as TSoftInfo;
    if Length(sx.DisplayName) > 0 then
    begin
      with lvSoftware.Items.Add do
      begin
        New(six);
        Caption := sx.DisplayName;
        six^.UninstallProgram := sx.UninstallProgram;
        six^.DisplayName := sx.DisplayName;
        Data := six;
        SubItems.Add(sx.Publisher);
        SubItems.Add(sx.UninstallProgram);

        if sx.fhasicon then
        begin
          iAddIconResult := ImageList_AddIcon(ilSoftwares.Handle, sx.icon);
          if iAddIconResult <> -1 then
            ImageIndex := iAddIconResult
          else
            ImageIndex := 0;
        end
        else
          ImageIndex := 0;
      end;
    end;
  end;
  softs.Free;
end;

procedure TForm1.btnUninstallSoftClick(Sender: TObject);
var
  item: TListItem;
  si: PSoftInfoData;
begin
  if lvSoftware.Selected = nil then
  begin
    ShowMessage('Please Select some Software');
    exit;
  end;

  item := lvSoftware.Selected;
  si := item.data;
  WinExec(PChar(si^.UninstallProgram), SW_SHOWNORMAL);

  item.Delete;
end;

procedure TForm1.lvSoftwareDeletion(Sender: TObject; Item: TListItem);
var
  six: PSoftInfoData;
begin
  if Item.Data = nil then Exit;
  six := item.Data;
  Dispose(six);
end;

procedure TForm1.btnHideWinPatchClick(Sender: TObject);
var
  item: TListItem;
  i: Integer;
begin
  for i := lvSoftware.Items.Count - 1 downto 0 do
  begin
    item := lvSoftware.Items[i];

    if pos('KB', item.Caption) <> 0 then
      item.Delete;
  end;
end;

procedure TForm1.btnReadSerivicesClick(Sender: TObject);
var
  Services: TObjectList;
  NSM: TNtServiceManager;
  NS: TNtService;
  i: integer;
begin

  NSM := TNtServiceManager.Create;
  try
    Services := NSM.GetServices;

    for i := 0 to Services.Count - 1 do
    begin
      with lvServices.Items.Add do
      begin
        ns := Services[i] as TNtService;

        Caption := ns.ServiceName;
        SubItems.Add(ns.Description);
        SubItems.Add(ns.StartType);
        if ns.ServiceState='Started' then
          SubItems.Add(ns.ServiceState)
        else
          SubItems.Add('');
      end;
    end;

    Services.Free;
  finally
    NSM.Free;
  end;
end;



procedure TForm1.btn_UnlockInternetOptionClick(Sender: TObject);
var
  regu: RegeditUnlock;
begin
  regu := RegeditUnlock.Create;
  try
    regu.UnlockInternetOptions;
  finally
    regu.Free;
  end;

end;

procedure TForm1.btn_EnableTaskManagerClick(Sender: TObject);
var
  task: TTaskManagerSecurity;
begin
  task := TTaskManagerSecurity.Create;
  task.Enable();
  task.Free;
end;

procedure TForm1.btn_OrderStartMenuByNameClick(Sender: TObject);
var
  startMenu: TStartMenuOrderByName;
begin
  startMenu := TStartMenuOrderByName.Create;

  startMenu.Sort;
  startMenu.Free;
end;

procedure TForm1.btn_AutoLogin_OKClick(Sender: TObject);
var
  gMsgBox: TGMsgBox;
  lu: TAutoLigin;
begin
  gMsgBox := TGMsgBox.Create;
  if (edt_UserName.Text = '') then
  begin
    GMsgbox.ShowWarn(Handle, 'Warning', 'You should input username or password');
    Exit;
  end;

  lu := TAutoLigin.Create;
  lu.SetAutoLogin(edt_UserName.Text, edt_Password.Text);

  gMsgBox.ShowInfo(handle, 'Information', 'Reboot to see the Auto login');
end;

procedure TForm1.chk_AutoLoginClick(Sender: TObject);
var
  lu: TAutoLigin;
  un: string;
  pwd: string;
begin
  edt_UserName.Enabled := chk_AutoLogin.Checked;
  edt_Password.Enabled := chk_AutoLogin.Checked;
  btn_AutoLogin_OK.Enabled := chk_AutoLogin.Checked;
  lu := TAutoLigin.Create;
  if chk_AutoLogin.Checked = False then
  begin
    lu.SetNoAutoLogin;
  end
  else
  begin
    lu.ReadAutoLoginInfo(un, pwd);
    edt_UserName.Text := un;
    edt_Password.Text := pwd;
  end;

  lu.Free;
end;

procedure TForm1.btn_ln_SetClick(Sender: TObject);
var
  ln: TLegalNotice;
begin
  ln := TLegalNotice.Create;

  ln.Setcaption(edt_ln_Caption.Text);
  ln.setText(mmo_ln_Text.Text);

  ln.Free;
end;

procedure TForm1.btn_ln_ClearClick(Sender: TObject);
var
  ln: TLegalNotice;
begin
  ln := TLegalNotice.Create;
  try
    ln.ClearAll;
  finally
    ln.Free;
  end; // try
end;

procedure TForm1.btnShowHiddenClick(Sender: TObject);
var
  sh: TShowHiddenFile;
begin
  sh := TShowHiddenFile.Create;
  try
    sh.show;
  finally
    sh.Free;
  end;
end;

procedure TForm1.btn_SeleFolderClick(Sender: TObject);
var
  dirName: string;
begin
  if SelectDirectory('Select Directory', 'c:\\', dirName) then
    edt_FolderName.Text := dirName;
end;

procedure TForm1.btn_HiddenFolderClick(Sender: TObject);
var
  hf: TFolderHidden;
begin
  if (edt_FolderName.Text = '') or (not DirectoryExists(edt_FolderName.Text)) then
  begin
    ShowMessage('Please select dir');
    exit;
  end;

  hf := TFolderHidden.Create;

  hf.Hidden(edt_FolderName.Text, cbb_HiddenFolder.ItemIndex);

  hf.Free;
end;

procedure TForm1.btn_UnhiddenFolderClick(Sender: TObject);
var
  hf: TFolderHidden;
begin
  if (edt_FolderName.Text = '') or (not DirectoryExists(edt_FolderName.Text)) then
  begin
    ShowMessage('Please select dir');
    exit;
  end;
  hf := TFolderHidden.Create;
  try
    hf.Unhidden(edt_FolderName.Text);
  finally
    hf.Free;
  end;
end;

procedure TForm1.btn_Read_OEMClick(Sender: TObject);
var
  ofi: TOemInfo;
begin
  ofi := TOemInfo.Create;
  try
    ofi.ReadInfo;

    edt_Oem_Menau.Text := ofi.Manu;
    edt_Oem_Model.Text := ofi.Model;

    mmo_OEM_Support.Lines.Assign(ofi.SupportInfo);
  finally
    ofi.Free;
  end;

end;

procedure TForm1.btn_SetOemClick(Sender: TObject);
var
  ofi: TOemInfo;
begin
  ofi := TOemInfo.Create;
  try
    ofi.Manu := edt_Oem_Menau.Text;
    ofi.Model := edt_Oem_Model.Text;
    ofi.SupportInfo.Assign(mmo_Oem_Support.Lines);

    ofi.WriteInfo;
  finally
    ofi.Free;
  end;
end;

procedure TForm1.btn_ReadImeClick(Sender: TObject);
var
  itx:TImeTools;
  //imes:TObjectList;
  i,j:integer;
  ime:TIme;
begin
  itx:=TImeTools.Create;
  lst_Imes.Clear;
  imes:=itx.ReadImes;

  for i := 0 to imes.Count-1 do
  begin
      ime := imes[i] as TIme;
      j:=lst_Imes.Items.Add(ime.LayoutText);
  end;
end;

procedure TForm1.act_Ime_UpUpdate(Sender: TObject);
begin
  btn_Ime_Up.Enabled:=(lst_Imes.Count>0) and (lst_Imes.ItemIndex>0) and (lst_Imes.ItemIndex<>-1);
end;

procedure TForm1.act_Ime_DownUpdate(Sender: TObject);
begin
  btn_Ime_Down.Enabled:=(lst_Imes.Count>0) and (lst_Imes.ItemIndex<>lst_Imes.Count-1) and (lst_Imes.ItemIndex<>-1);
end;

procedure TForm1.act_Ime_DownExecute(Sender: TObject);
var
  i:integer;
  text:string;
begin
  bImageChange:=true;
  i:=lst_Imes.ItemIndex;

  text:=lst_Imes.Items[i];
  lst_Imes.Items.BeginUpdate;
  lst_Imes.Items.Delete(i);
  //lst_Imes.Items.Insert(i,text);
  lst_Imes.Items.EndUpdate;

  lst_Imes.Items.BeginUpdate;
  lst_Imes.Items.Insert(i+1,text);
  lst_Imes.Items.EndUpdate;

  lst_Imes.ItemIndex:=i+1;
end;

procedure TForm1.act_Ime_UpExecute(Sender: TObject);
var
  i:integer;
  text:string;
begin
  bImageChange:=true;
  i:=lst_Imes.ItemIndex;

  text:=lst_Imes.Items[i];
  lst_Imes.Items.BeginUpdate;
  lst_Imes.Items.Delete(i);
  //lst_Imes.Items.Insert(i,text);
  lst_Imes.Items.EndUpdate;

  lst_Imes.Items.BeginUpdate;
  lst_Imes.Items.Insert(i-1,text);
  lst_Imes.Items.EndUpdate;

  lst_Imes.ItemIndex:=i-1;
end;

procedure TForm1.act_Ime_ApplyUpdate(Sender: TObject);
begin
  btn_Ime_Apply.Enabled:=bImageChange;
end;

procedure TForm1.act_Ime_ApplyExecute(Sender: TObject);
var
  _imes:TObjectList;
  i:integer;
  _it:TimeTools;

  function GetImeByName(imeName:string):TIme;
  var
    i:integer;
    _tempIme:TIme;
  begin
    for i := 0 to imes.Count-1 do
    begin
      _tempIme:=imes[i] as TIme;

      if _tempIme.LayoutText=imeName then
      begin
        result:=_tempIme;
        exit;
      end;
    end;
  end;
begin
  _imes:=TObjectList.Create;
  for i := 0 to lst_Imes.Count-1 do
  begin
    _imes.Add(GetImeByName(lst_Imes.Items[i]));
  end;

  _it:=TImeTools.Create;

  _it.WriteImeCfg(_imes);

  imes.Free;
  _it.Free;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  imes.Free;
end;

procedure TForm1.act_PM_uninstallUpdate(Sender: TObject);
begin
  btnUninstallSoft.Enabled:=lvSoftware.Items.Count>0;
end;

procedure TForm1.act_PM_HidePatchUpdate(Sender: TObject);
begin
  btnHideWinPatch.Enabled:=lvSoftware.Items.Count>0;
end;

procedure TForm1.act_HiddenFolder_HiddenUpdate(Sender: TObject);
var
  s:string;
begin
  s:=Trim(edt_FolderName.Text);

  if Length(s)=0 then
  begin
    btn_HiddenFolder.Enabled:=False;
    exit;
  end;

  if not DirectoryExists(s) then
  begin
    btn_HiddenFolder.Enabled:=False;
    exit;
  end;

  btn_HiddenFolder.Enabled:=true;
end;

procedure TForm1.act_HiddenFolder_UnhiddenUpdate(Sender: TObject);
var
  s:string;
begin
  s:=Trim(edt_FolderName.Text);

  if Length(s)=0 then
  begin
    btn_UnhiddenFolder.Enabled:=False;
    exit;
  end;

  if not DirectoryExists(s) then
  begin
    btn_UnHiddenFolder.Enabled:=False;
    exit;
  end;

  btn_UnhiddenFolder.Enabled:=true;

end;

end.

