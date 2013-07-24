unit ScanThread;

interface

uses
  Classes,FolderObj,SysUtils,Windows,ComCtrls;

type
  TScanThread = class(TThread)
  private
    { Private declarations }
    FMessagePanel:TStatusBar;
    FMessage:string;
    FRootFolderObject:PFolderObj;
    FRootPath:string;
    procedure BuildTree(Path: string; sft: PFolderObj; isTop: Boolean);
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(RootPath:string;RootFolderObj:PFolderObj;MsgPanel:TStatusBar);overload;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TScanThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TScanThread }

procedure TScanThread.BuildTree(Path: string; sft: PFolderObj;
  isTop: Boolean);
var
  sr: TSearchRec;
  rs: Integer;
  pft: PFolderObj;
  bFirst: Boolean;
  bNeedGenerateVirtualFolder: Boolean;
  pftVirtual: PFolderObj;
  bFirstVirtualChild: Boolean;

  procedure AddAllFolderCount(pft: PFolderObj; Root: PFolderObj);
  var
    pPft: PFolderObj;
  begin
    pPft := pft.Parent;

    while pPft <> nil do
    begin
      Inc(pPft.SubFolderCount);
      pPft := pPft.Parent;
    end;
  end;

  procedure AddAllFileCount(pft: PFolderObj; Root: PFolderObj);
  var
    pPft: PFolderObj;
  begin
    pPft := pft.Parent;

    while pPft <> nil do
    begin
      inc(pPft.SubFileCount);
      pPft := pPft.Parent;
    end;
  end;

  procedure AddAllFileSizeCount(pft: PFolderObj; Root: PFolderObj);
  var
    pPft: PFolderObj;
  begin
    pPft := pft.Parent;

    while pPft <> nil do
    begin
      pPft.Size := pPft.Size + pft.Size;
      pPft := pPft.Parent;
    end;
  end;
begin
  bFirst := True;
  bNeedGenerateVirtualFolder := True;
  bFirstVirtualChild := True;
  rs := FindFirst(Path + '\*.*', faAnyFile, sr);

  repeat
    if (sr.Name <> '..') and (sr.Name <> '.') then
    begin
      FMessage:='Now Scan '+Path+'\'+sr.Name;
      Synchronize(ShowMessage);
       pft := GetMemory(SizeOf(TFolderObj));
      //New(pft);
      //ZeroMemory(pft,SizeOf(TFolderObj));
      //StrCopy(pft.FullPath, PAnsiChar(Path + '\' + sr.Name), MAX_PATH);
      StrPCopy(pft.FullPath, PAnsiChar(Path + '\' + sr.Name));
      //StrLCopy(pft.DispalyName, PAnsiChar(sr.Name), MAX_PATH);
      StrPCopy(pft.DispalyName, PAnsiChar(sr.Name));

      pft.FirstChild := nil;
      pft.Next := nil;

      if sr.Attr and faDirectory = faDirectory then
      begin
        pft.Parent := sft;
        if bFirst then
        begin
          sft.FirstChild := pft;
          sft.CurrentChild := pft;
          bFirst := false;
        end
        else
        begin
          sft.CurrentChild.Next := pft;
          sft.CurrentChild := pft;
          sft.CurrentChild.Next:=nil;
        end;
        pft.isFolder := true;
        pft.isVirtualFolder:=false;
        pft.SubFolderCount:=0;
        pft.SubFileCount:=0;
        pft.Size:=0;
        AddAllFolderCount(pft, sft);
        BuildTree(Path + '\' + sr.Name, pft, false);
      end
      else
      begin
      if bNeedGenerateVirtualFolder then
        begin
          pftVirtual := GetMemory(SizeOf(TFolderObj));
          //FillChar(pftVirtual,SizeOf(TfolderObj),#0);
          pftVirtual.Parent := sft;
          StrLCopy(pftVirtual.FullPath,PAnsiChar( 'Virtual Files Folder:' + Path ),MAX_PATH);
          pftVirtual.DispalyName := 'Files';
          pftVirtual.isFolder := true;
          pftVirtual.Size := 0;
          pftVirtual.isVirtualFolder := true;
          pftVirtual.SubFolderCount := 0;
          pftVirtual.FirstChild := nil;
          pftVirtual.Next := nil;

          if bFirst then
          begin
            bFirst := false;
            sft.FirstChild := pftVirtual;
            sft.CurrentChild := pftVirtual;
          end
          else
          begin
            sft.CurrentChild.Next := pftVirtual;
            sft.CurrentChild := pftVirtual;
          end;
          bNeedGenerateVirtualFolder := false;
        end;

        pft.Parent := pftVirtual;
        pft.isFolder := False;
        if bFirstVirtualChild then
        begin
          bFirstVirtualChild := False;
          pftVirtual.FirstChild := pft;
          pftVirtual.CurrentChild := pft;
        end
        else
        begin
          pftVirtual.CurrentChild.Next := pft;
          pftVirtual.CurrentChild := pft;
        end;

        AddAllFileCount(pft, sft);
        pft.Size := sr.Size;
        pft.FileTime:=sr.Time;
        AddAllFileSizeCount(pft, sft);
      end;
    end;
  until (FindNext(sr) <> 0);

  SysUtils.FindClose(sr);

end;



constructor TScanThread.Create(RootPath:String;RootFolderObj: PFolderObj;
  MsgPanel: TStatusBar);
begin
  inherited Create(True);
  FRootFolderObject:=RootFolderObj;
  FMessagePanel:=MsgPanel;
  FMessage:='';
  FRootPath:=RootPath;
end;

procedure TScanThread.Execute;
begin
  { Place thread code here }
  BuildTree(FRootPath,FRootFolderObject,true);
end;

procedure TScanThread.ShowMessage;
begin
    FMessagePanel.SimpleText:=FMessage;
end;

end.
