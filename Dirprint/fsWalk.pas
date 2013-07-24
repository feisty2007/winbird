unit fsWalk;

interface

uses
  Classes,ComCtrls,SysUtils;

type
  TFileSystemWalk = class(TThread)
  private
    { Private declarations }
    FRootPath:string;
    FFileList:TStringList;
    FMsgBar:TStatusBar;
    FCurrentDir:string;
    procedure ShowProgress;
  protected
    procedure Execute; override;
    procedure WalkDir(dir:string;iLevel:Integer);
  public
    constructor Create(RootDir:string;FileList:TStringList;MsgBar:TStatusBar);overload;
  end;

implementation

uses GFileUtil;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TFileSystemWalk.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TFileSystemWalk }

constructor TFileSystemWalk.Create(RootDir: string; FileList: TStringList;
  MsgBar: TStatusBar);
begin
  inherited Create(false);
  FRootPath:=RootDir;
  FFileList:=FileList;
  FMsgBar:=MsgBar;
end;

procedure TFileSystemWalk.Execute;
begin
  { Place thread code here }

  WalkDir(FRootPath,0);
end;

procedure TFileSystemWalk.ShowProgress;
begin
  FMsgBar.SimpleText:=FCurrentDir;
end;

procedure TFileSystemWalk.WalkDir(dir: string;iLevel:integer);
var
  sr:TSearchRec;
  fr:Integer;
  ftFilter:string;
  fu:TGFileUtil;
  ftypeName:string;
  outStr:string;
  function GetSpaces(i:Integer):string;
  var
    j:integer;
  begin
    Result:='';
    for j :=0  to i do
    begin
      Result:=Result+'  ';
    end;
  end;

  function GetFileTimeStr(sr:TSearchRec):String;
  begin
    Result:=DateTimeToStr(FileDateToDateTime(sr.Time));
  end;
begin
  fu:=TGFileUtil.Create;
  FCurrentDir:=Dir;
  Synchronize(ShowProgress);
  ftfilter:='*.*';
  fr:=FindFirst(Dir+'\'+ftFilter,faArchive or faSysFile or faHidden,sr);

  if fr=0 then
  begin
    FFileList.Add(Dir);
    repeat
      if (sr.Name<>'.') and (sr.Name<>'..') then
      begin
        ftypeName:=fu.GetTypeName(Dir+'\'+sr.Name);
        outStr:=Format('%-50s  %-30s  %25s  %30s %5s',[sr.Name,ftypeName,IntToStr(sr.Size),GetFileTimeStr(sr),fu.GetAttrString(sr.Attr)]);
        //FFileList.Add(GetSpaces(iLevel)+sr.Name+' '+ftypeName+' '+IntToStr(sr.Size));
        FFileList.Add(outStr);
      end;
    until(FindNext(sr)<>0);

    FindClose(sr);
  end;

  fu.Free;
  fr:=FindFirst(Dir+'\'+ftFilter,faDirectory,sr);
  if fr=0 then
  begin
    repeat
      if (sr.Name<>'.') and (sr.Name<>'..') then
        WalkDir(Dir+'\'+sr.Name,iLevel+1);
    until(FindNext(sr)<>0);

    FindClose(sr);
  end;
end;

end.
