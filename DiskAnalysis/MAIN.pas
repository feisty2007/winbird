unit MAIN;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,FileCtrl,
  Dialogs, StdCtrls, ComCtrls, VirtualTrees,ShellApi, ImgList,FolderObj,FileCount,
  ActnList, Menus, ExtCtrls, ToolWin,ScanThread;

type

  TForm1 = class(TForm)
    il_Files: TImageList;
    tlb1: TToolBar;
    pnl1: TPanel;
    vrtlstrngtr1: TVirtualStringTree;
    pnl2: TPanel;
    pgc1: TPageControl;
    ts1: TTabSheet;
    lv_MaxSizeFiles: TListView;
    ts2: TTabSheet;
    lv_MostNewFiles: TListView;
    ts3: TTabSheet;
    lv_MostOldFiles: TListView;
    spl1: TSplitter;
    btnSelDir: TToolButton;
    mm1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    actlst1: TActionList;
    act_SelDir: TAction;
    stat1: TStatusBar;
    act_AppQuit: TAction;
    Help1: TMenuItem;
    About1: TMenuItem;
    btn_Delete: TToolButton;
    btn_Explorer: TToolButton;
    act_Del: TAction;
    act_Explorer: TAction;
    act_CmdPrompt: TAction;
    btnCmdPrompt: TToolButton;
    pm_Main: TPopupMenu;
    Delete1: TMenuItem;
    Explorer1: TMenuItem;
    Command1: TMenuItem;
    il1: TImageList;
    procedure btnSelDirClick(Sender: TObject);
    procedure vrtlstrngtr1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vrtlstrngtr1InitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vrtlstrngtr1InitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vrtlstrngtr1CompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FormCreate(Sender: TObject);
    procedure vrtlstrngtr1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure lv_MaxSizeFilesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure act_AppQuitExecute(Sender: TObject);
    procedure vrtlstrngtr1FreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure act_DelExecute(Sender: TObject);
    procedure Explorer1Click(Sender: TObject);
    procedure act_CmdPromptExecute(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    sft: PFolderObj;
    MaxSizeFiles:TMaxSizeFileCount;
    MaxNewFiles:TMostNewFileCount;
    MaxOldestFiles:TMostOldFileCount;
    ScanThread:TScanThread;
    procedure PopulateTree(sft: TFolderObj);


    procedure ReCalcPercent(var sft:TFolderObj);
    function FormatByte(nSize: Int64): string;

    procedure FreeFolderObj(vsft:PFolderObj;bTop:Boolean);
    procedure FreeFileObjects;
    procedure ShowResult(sender:TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses aboutfrm;



{$R *.dfm}

{ TForm1 }

procedure TForm1.btnSelDirClick(Sender: TObject);
const
  RootPath = 'd:\book';
var
  Path:string;
begin
  //memo1.Clear;
  if ScanThread<>nil then
  begin
    ScanThread.Terminate;
    //exit;

    act_SelDir.Caption:='Browse..';
  end;
  
  if SelectDirectory('Select Dir','',Path) then
  begin
    vrtlstrngtr1.Clear;
    lv_MaxSizeFiles.Clear;
    lv_MostNewFiles.Clear;
    lv_MostOldFiles.Clear;
    MaxSizeFiles:=TMaxSizeFileCount.Create;
    MaxNewFiles:=TMostNewFileCount.Create;
    MaxOldestFiles:=TMostOldFileCount.Create;
    //FillChar(sft, SizeOf(TFolderObj), $0);

    sft:=GetMemory(SizeOf(TFolderObj));
    sft.isFolder := True;
    StrLCopy(sft.FullPath, PAnsiChar(Path),MAX_PATH);
    StrLCopy(sft.DispalyName,PAnsiChar(Path),MAX_PATH);
    sft.Parent:=nil;
    sft.FirstChild:=nil;
    sft.CurrentChild:=nil;
    sft.Next:=nil;
    sft.Size:=0;
    sft.SubFolderCount:=0;
    sft.SubFileCount:=0;
    sft.isVirtualFolder:=false;
    //BuildTree(Path, sft, true);
    ScanThread:=TScanThread.Create(Path,sft,stat1);
    ScanThread.OnTerminate:=ShowResult;
    ScanThread.FreeOnTerminate:=true;
    ScanThread.Resume;
    act_SelDir.Caption:='Stop';
  end;

  //ShowMessage(IntToStr(lv_MaxFiles.Items.Count));
end;



procedure TForm1.PopulateTree(sft: TFolderObj);
var
  first: PFolderObj;
  next: PFolderObj;
begin
  //PrintFolderObj(sft);

  first := sft.FirstChild;

  if first <> nil then
  begin
    PopulateTree(first^);
    next := first.Next;

    while next <> nil do
    begin
      PopulateTree(next^);

      next := next.Next;
    end;
  end;
end;




procedure TForm1.ReCalcPercent(var sft: TFolderObj);
var
  pFirst:PFolderObj;
  pNext:PFolderObj;
begin
  if sft.Parent=nil then
    sft.Percent:=100
  else
  begin
    if sft.Parent.Size<>0 then
      sft.Percent:=(sft.Size*100)/sft.Parent^.Size
    else
      sft.Percent:=100;

    if sft.isFolder=false then
    begin
      MaxSizeFiles.InsertFolderObj(sft);
      MaxNewFiles.InsertFolderObj(sft);
      MaxOldestFiles.InsertFolderObj(sft);
    end;
  end;

  pFirst:=sft.FirstChild;

  if pFirst<>nil then
  begin
    ReCalcPercent(pFirst^);

    pNext:=pFirst.Next;
    while pNext<>nil do
    begin
      ReCalcPercent(pNext^);
      pNext:=pNext.Next;
    end;
  end;
end;

procedure TForm1.vrtlstrngtr1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data:PFolderObj;
begin
  Data:=Sender.GetNodeData(Node);

  case Column of
    0:
      CellText:=Data.DispalyName;
    1:
      CellText:=Format('%.2f',[Data.Percent])+'%';
    2:
      CellText:=FormatByte(Data.Size);
    3:
      if Data.isFolder then
        CellText:=IntToStr(Data.SubFolderCount)
      else
        CellText:='';
    4:
      if Data.isFolder then
        CellText:=IntToStr(Data.SubFileCount)
      else
        CellText:='';
    5:
      if not Data.isFolder then
        CellText:='A';
      else
        CellText:='';
  end;

end;

procedure TForm1.vrtlstrngtr1InitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data:PFolderObj;
  Level:Integer;
begin
  if ParentNode=nil then
  begin
     Include(InitialStates,ivsHasChildren);
     Data:=Sender.GetNodeData(Node);

     Data^:=sft^;
     Level := Sender.GetNodeLevel(Node);
     if Level = 0 then
        Include(InitialStates, ivsExpanded);

     //ShowMessage(IntToStr(Data^.SubFileCount));
  end
  else
  begin
    Data:=Sender.GetNodeData(Node);

    if Data.isFolder then
    begin
      if (Data.SubFolderCount>0) or (Data.SubFileCount>0) then
        Include(InitialStates,ivsHasChildren);
    end;

  end;
end;

procedure TForm1.vrtlstrngtr1InitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  Data:PFolderObj;
  pFirst:PFolderObj;
  pNext:PFolderObj;
  childNode:PVirtualNode;
  childData:PFolderObj;
begin
  Data:=Sender.GetNodeData(Node);

  pFirst:=Data.FirstChild;

  if pFirst=nil then
  begin
    ChildCount:=0;
    exit;
  end;
    
  if (Data.SubFolderCount=0) and (pFirst.isVirtualFolder=true) then
    pFirst:=pFirst.FirstChild;

  if pFirst<>nil then
  begin
    childNode:=Sender.AddChild(Node);
    childData:=Sender.GetNodeData(childNode);
    childData^:=pFirst^;

    Sender.ValidateNode(Node,False);
    pNext:=pFirst.Next;

    while pNext<>nil do
    begin
      childNode:=Sender.AddChild(Node);
      childData:=Sender.GetNodeData(childNode);
      childData^:=pNext^;
      Sender.ValidateNode(Node,False);
      pNext:=pNext.Next;
    end;
  end;

  Sender.Sort(Node,2,sdDescending,False);
  ChildCount:=Sender.ChildCount[Node];
end;

procedure TForm1.vrtlstrngtr1CompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2:PFolderObj;
begin
  Data1:=Sender.GetNodeData(Node1);
  Data2:=Sender.GetNodeData(Node2);

  if Data1.Size>Data2.Size then
    Result:=1
  else
    Result:=-1;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  hSysImageList:THandle;
  shfileinfo:TShFileInfo;
begin
  hSysImageList:=SHGetFileInfo('C:\',
                0,
                shfileinfo,
                SizeOf(shfileinfo),
                SHGFI_SMALLICON or SHGFI_SYSICONINDEX);

  il1.Handle:=hSysImageList;
end;

procedure TForm1.vrtlstrngtr1GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data:PFolderObj;
  shfileInfo:TShFileInfo;
begin
  Data:=Sender.GetNodeData(Node);

  if Column=0 then
  begin
    if Data.isVirtualFolder=false then
    begin
      SHGetFileInfo(Data.FullPath,
                   0,
                   shfileinfo,
                   SizeOf(shfileinfo),
                   SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
      ImageIndex:=shfileinfo.iIcon;
    end
  end;
end;

function TForm1.FormatByte(nSize: Int64): string;
begin
    if nSize > 1073741824 then
      Result := FormatFloat('###,##0.00G', nSize / 1073741824)
    else if nSize > 1048576 then
      Result := FormatFloat('###,##0.00M', nSize / 1048576)
    else if nSize > 1024 then
      Result := FormatFloat('###,##00K', nSize / 1024)
    else
      Result := FormatFloat('###,#0B', nSize);
    if Length(Result) > 2 then
      if Result[1] = '0' then
        Delete(Result, 1, 1);
end;


procedure TForm1.lv_MaxSizeFilesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  size1:Integer;
  size2:Integer;
begin
  size1:=Int64(Item1.Data^);
  size2:=Int64(Item2.Data^);

  if size1>=size2 then
    Compare:=1
  else
    Compare:=-1;
end;

procedure TForm1.FreeFolderObj(vsft: PFolderObj;bTop:Boolean);
var
  pFirst,pNext:PFolderObj;
begin
  pFirst:=vsft.FirstChild;

  if pFirst<>nil then
  begin
    pNext:=pFirst.Next;

    if pNext<>nil then
    begin
      while pNext<>nil do
      begin
        FreeFolderObj(pNext,false);
        pNext:=pNext.Next;
      end;
    end;

    FreeFolderObj(pFirst,False);
  end;

  FreeMemory(vsft);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeFileObjects;

  //FreeAndNil(MaxSizeFiles);
end;

procedure TForm1.ShowResult(sender:TObject);
begin
    ReCalcPercent(sft^);
    //PopulateTree(sft);
    vrtlstrngtr1.Clear;
    vrtlstrngtr1.NodeDataSize:=SizeOf(TFolderObj);
    vrtlstrngtr1.RootNodeCount:=1;
    stat1.SimpleText:='Scan Complete:'+IntToStr(sft.SubFolderCount);

    MaxSizeFiles.DisplayData(lv_MaxSizeFiles);
    MaxNewFiles.DisplayData(lv_MostNewFiles);
    MaxOldestFiles.DisplayData(lv_MostOldFiles);

    act_SelDir.Caption:='Browse..';
end;

procedure TForm1.act_AppQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FreeFileObjects;
begin
  FreeAndNil(MaxSizeFiles);
  FreeAndNil(MaxNewFiles);
  FreeAndNil(MaxOldestfiles);

//  if sft<>nil then
//    FreeFolderObj(sft,true);
end;

procedure TForm1.vrtlstrngtr1FreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  psft:PFolderObj;
begin
//  psft:=Sender.GetNodeData(Node);
//
//  FreeFolderObj(psft,true);
end;

procedure TForm1.act_DelExecute(Sender: TObject);
var
  Node:PFolderObj;
  op:TSHFileOpStruct;
begin
  if vrtlstrngtr1.RootNodeCount <>0 then
  begin
    Node:=vrtlstrngtr1.GetNodeData(vrtlstrngtr1.GetFirstSelected);

    op.Wnd:=Handle;
    op.wFunc:=FO_DELETE;
    op.fFlags:=FOF_ALLOWUNDO;
    op.pFrom:=Node.FullPath;
    SHFileOperation(op);
  end;
end;
procedure TForm1.Explorer1Click(Sender: TObject);
var
  Node:PFolderObj;
begin
  if vrtlstrngtr1.RootNodeCount <>0 then
  begin
    Node:=vrtlstrngtr1.GetNodeData(vrtlstrngtr1.GetFirstSelected);
    ShellExecute(Handle,nil,PChar('Explorer.exe'),PAnsiChar(ExtractFilePath(Node.FullPath)),nil,SW_SHOWNORMAL);
  end
  else
    ShellExecute(Handle,nil,PChar('Explorer.exe'),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm1.act_CmdPromptExecute(Sender: TObject);
var
  Node:PFolderObj;
begin

  if vrtlstrngtr1.RootNodeCount = 0 then
  begin
    ShellExecute(0,'open','cmd.exe',nil,nil,SW_SHOW);
    Exit;
  end;
  
  Node:=vrtlstrngtr1.GetNodeData(vrtlstrngtr1.GetFirstSelected);
  ShellExecute(0,'open','cmd.exe',PChar('/k cd '+PChar(ExtractFilePath(Node.FullPath))),PChar(ExtractFilePath(Node.FullPath)),SW_SHOW);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  OKBottomDlg.ShowModal;
end;

end.

