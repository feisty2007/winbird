unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  TlHelp32,PsAPI,ShellAPI,CommCtrl, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    btnGetProcess: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    lv_Process: TListView;
    Splitter1: TSplitter;
    pnl1: TPanel;
    Panel3: TPanel;
    pgc_Modules: TPageControl;
    ts_Modules: TTabSheet;
    lv_Modules: TListView;
    mm1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    lbl_Proc: TLabel;
    lbl1: TLabel;
    procedure btnGetProcessClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lv_ProcessSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure lv_ProcessCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnGetProcessClick(Sender: TObject);
var
  pe:TProcessEntry32;
  pList:THandle;
  sFileName:string;
  FileInfo:TSHFileInfo;

  function GetExeFileName(processID:Cardinal):string;
  var
    
    path:array[0..MAX_PATH-1] of char;
    hProcess:THandle;
  begin
      //SetLength(filename,MAX_PATH+1);
      hProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
      false,
      processID);

      GetModuleFileNameEx(hProcess,0,path,MAX_PATH-1);

      result:=path;
  end;
begin
  pList:=CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS,0);

  pe.dwSize:=SizeOf(TProcessEntry32);

  if Process32First(pList,pe) then
  begin
      while Process32Next(pList,pe) do
      begin
//          if pe.pcPriClassBase=1 then
//          begin
            sFileName:=GetExeFileName(pe.th32ProcessID);

            if Pos(pe.szExeFile,sFileName)>0 then
            begin
                with lv_Process.Items.Add do
                begin
                  SHGetFileInfo(PChar(sFileName),
                                0,
                                FileInfo,SizeOf(FileInfo),
                                SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
                  ImageIndex:=FileInfo.iIcon;
                  Caption:=ExtractFileName(pe.szExeFile);
                  SubItems.Add(IntToStr(pe.th32ProcessID));
                  SubItems.Add(sFileName);
                  SubItems.Add(IntToStr(pe.pcPriClassBase));
              //end;
                end;
            end;
      end;
  end;

  CloseHandle(pList);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  hImageList:Thandle;
  FileInfo:TSHFileInfo;
begin
  hImageList := SHGetFileInfo('', 0, FileInfo, SizeOf(FileInfo),
    SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  SendMessage(lv_Process.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, hImageList);

  btnGetProcessClick(sender);
end;

procedure TForm1.lv_ProcessSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
   hSnapshot:THandle;
   me:TModuleEntry32;
   processID:Cardinal;
   found:LongBool;
begin
  if Selected then
     //ShowMessage(Item.SubItems[0]);
  begin
    lv_Modules.Items.Clear;

    processID:=StrToInt(Item.SubItems[0]);

    hSnapshot:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,processID);
    me.dwSize:=SizeOf(TModuleEntry32);
    found:=Module32First(hSnapshot,me);

    while found do
    begin
        with lv_Modules.Items.Add do
        begin
          caption:=me.szModule;
          SubItems.Add(me.szExePath);
        end;

        found:=Module32Next(hSnapshot,me);
    end;

    CloseHandle(hSnapshot);
  end;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=False;
end;

procedure TForm1.lv_ProcessCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare:=CompareText(Item1.Caption,Item2.Caption);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.


