unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellTreeView, StdCtrls, Menus, ToolWin, ImgList,
  ActnList, ExtCtrls,ShellAPI,CommCtrl;

type
  TForm1 = class(TForm)
    statMsg: TStatusBar;
    tlb_Main: TToolBar;
    tv_Dir: TGShellTreeView;
    mm_Main: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    actlst1: TActionList;
    il_Main: TImageList;
    spl1: TSplitter;
    pnl_Right: TPanel;
    lv_Files: TListView;
    spl2: TSplitter;
    act_GenReport: TAction;
    btn_GenReport: TToolButton;
    Edit1: TMenuItem;
    Options1: TMenuItem;
    act_Option: TAction;
    btn_Option: TToolButton;
    pnl1: TPanel;
    procedure tv_DirChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure lv_FilesDblClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure act_OptionExecute(Sender: TObject);
    procedure act_GenReportExecute(Sender: TObject);
  private
    { Private declarations }
      dirs:TStringList;
    procedure GetFileInDir(Dir:string);
    procedure ShowResult(sender:TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses edtOption, fsWalk, GFileUtil;

{$R *.dfm}

function SizeFromSRec(const SRec: SysUtils.TSearchRec): Int64;
begin
  with SRec do
  begin
    // Hopefuly TSearchRec.FindData is available with all Windows versions
    {if Size >= 0 then Result := Size
      else}
{$WARNINGS OFF}
    Result := Int64(FindData.nFileSizeHigh) shl 32 + FindData.nFileSizeLow;
{$WARNINGS ON}
  end;
end;



function TrimSolot(sDir:string):string;
var
     stemp:string;
begin
     Result:=sDir;
     stemp:=sDir[Length(sDir)];
     if stemp='\' then
        Result:=Copy(sDir,0,Length(sDir)-1);
end;

procedure TForm1.GetFileInDir(Dir: string);
var
   sr:TSearchRec;
   rs:integer;
   shfileinfo:TSHFileInfo;
   attrs:DWORD;
   sDir:string;

begin
  sDir:=TrimSolot(Dir);
  lv_Files.Clear;
  rs:=FindFirst(sdir+'\*.*',faAnyFile,sr);

  if rs=0 then
  begin
    repeat
      if (sr.Name<>'.') and (sr.Name<>'..') then
      begin
        with lv_Files.Items.Add do
        begin
          Caption:=sr.Name;
          SHGetFileInfo(PChar(sDir+'\'+sr.Name),
               attrs,
               shfileinfo,
               SizeOf(shfileinfo),
               SHGFI_TYPENAME or SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
          ImageIndex:=shfileinfo.iIcon;
          if (sr.Attr and faDirectory=faDirectory) then
            SubItems.Add('')
          else
            SubItems.Add(IntToStr(SizeFromSRec(sr)));
          SubItems.Add(shfileinfo.szTypeName);
          SubItems.Add(DateTimeToStr(FileDateToDateTime(sr.Time)));

          SubItems.Add(TGFileUtil.GetAttrString(sr.Attr));

        end;
      end;
    until(FindNext(sr)<>0);

    FindClose(sr);
  end;
end;

procedure TForm1.tv_DirChange(Sender: TObject; Node: TTreeNode);
begin
  statMsg.SimpleText:=tv_Dir.Directory;
  GetFileInDir(tv_Dir.Directory);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  hImage:THandle;
  shfileinfo:TSHFileInfo;
begin
  hImage:=SHGetFileInfo('C:\',
                0,
                shfileinfo,
                SizeOf(shfileinfo),
                SHGFI_SMALLICON or SHGFI_SYSICONINDEX);

  ListView_SetImageList(lv_Files.Handle,hImage,LVSIL_SMALL);
end;

procedure TForm1.lv_FilesDblClick(Sender: TObject);
var
  fullDir:string;
  item:TListItem;
begin
  item:=lv_Files.Selected;

  fullDir:=TrimSolot(tv_Dir.Directory)+'\'+item.Caption;
  if DirectoryExists(fullDir) then
  begin
    tv_Dir.Directory:=fullDir;
    GetFileInDir(fullDir);
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.act_OptionExecute(Sender: TObject);
begin
  frmOptions.ShowModal;
end;

procedure TForm1.act_GenReportExecute(Sender: TObject);
var
  ft:TFileSystemWalk;
begin
  dirs:=TStringList.Create;
  ft:=TfileSystemWalk.Create(tv_Dir.Directory,dirs,statMsg);

  ft.Resume;
  ft.OnTerminate:=ShowResult;
end;

procedure TForm1.ShowResult(sender:TObject);
begin
  Dirs.Savetofile('c:\dirs.txt');
  ShellExecute(Handle,'open','c:\dirs.txt',nil,nil,SW_SHOWMAXIMIZED);
  statMsg.SimpleText:='Generate Complete';
end;

end.
