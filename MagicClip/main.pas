unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Clipbrd, ComCtrls, ExtCtrls, Menus, PsAPI;

type
  TForm1 = class(TForm)
    mm_Main: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    pnl_Clips: TPanel;
    spl1: TSplitter;
    pnl_Detail: TPanel;
    lv_Clips: TListView;
    pgc1: TPageControl;
    ts_Text: TTabSheet;
    mmo1: TMemo;
    ts_Graph: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lv_ClipsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    hwndNextClip:HWND;
    procedure WMDrawClip(var Msg:TMessage);message WM_DRAWCLIPBOARD;
    function GetValidStr(str:string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.WMDrawClip(var Msg: TMessage);
var
  str:string;
  hActiveWnd:HWND;
  Path:array[0..MAX_PATH] of char;
  iReturn:Integer;
  ProcessId:Cardinal;
  strProcName: string;
  appName: string;

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

  SendMessage(hwndNextClip,Msg.Msg,msg.WParam,msg.LParam);

  hActiveWnd := GetForegroundWindow;
  iReturn := GetWindowThreadProcessId(hActiveWnd,ProcessID);
  strProcName := GetExeFileName(ProcessId);
  appName := Application.ExeName;
  if strProcName = Application.Name then Exit;

  if Clipboard.HasFormat(CF_TEXT) then
  begin
    with lv_Clips.Items.Add do
    begin
      Caption:=GetValidStr(Clipboard.AsText);

      SubItems.Add(ExtractFileName(GetExeFileName(ProcessId)));
      SubItems.Add(DateTimeToStr(Now));
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  hwndNextClip:=SetClipboardViewer(Handle);
  lv_Clips.ViewStyle:=vsReport;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ChangeClipboardChain(Handle,hwndNextClip);
  SendMessage(hwndNextClip,WM_CHANGECBCHAIN,Handle,hwndNextClip);
end;

function TForm1.GetValidStr(str: string):string;
var
  strs:TStringList;
  iCount:Integer;
begin
  strs:=TStringList.Create;

  iCount:=ExtractStrings([Char($13)],[],PAnsiChar(str),strs);

  if iCount>1 then
  begin
    Result:=strs[0];
  end
  else
  begin
    iCount:=Length(str);

    if iCount>100 then
      iCount:=100;

    Result:=Copy(str,0,iCount);
  end;

  strs.Free;
end;

procedure TForm1.lv_ClipsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
      Clipboard.AsText:=Item.Caption;
  end;
end;

end.
