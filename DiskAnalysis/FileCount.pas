unit FileCount;

interface


uses
    FolderObj,ComCtrls,SysUtils;
type

    TFileCount=class
    private
    protected
      files:array[0..200] of TFolderObj;
      FCurrentPos:Integer;
      FCount:integer;
      procedure MoveUp(index:Integer);
      procedure MoveDown(index:Integer);
      function RemoveMin:TFolderObj;
      procedure CopyFolderObj(fo1:TFolderObj;var fo2:TFolderObj);
      function CompareLe(fo1,fo2:TFolderObj):Boolean;virtual;abstract;
      function CompareGe(fo1,fo2:TFolderObj):Boolean;virtual;abstract;
      function Greater(fo1,fo2:TFolderObj):Boolean;virtual;abstract;
    public
      constructor Create;
      procedure DisplayData(lv_Files:TListView);
      procedure InsertFolderObj(fo:TFolderObj);
    end;

    TMaxSizeFileCount=class(TFileCount)
      function CompareLe(fo1,fo2:TFolderObj):Boolean;override;
      function CompareGe(fo1,fo2:TFolderObj):Boolean;override;
      function Greater(fo1,fo2:TFolderObj):Boolean;override;
    end;

    TMostNewFileCount=class(TFileCount)
      function CompareLe(fo1,fo2:TFolderObj):Boolean;override;
      function CompareGe(fo1,fo2:TFolderObj):Boolean;override;
      function Greater(fo1,fo2:TFolderObj):Boolean;override;
    end;

    TMostOldFileCount=class(TFileCount)
      function CompareLe(fo1,fo2:TFolderObj):Boolean;override;
      function CompareGe(fo1,fo2:TFolderObj):Boolean;override;
      function Greater(fo1,fo2:TFolderObj):Boolean;override;
    end;

implementation

{ TFileCount }
const
  GFileCount=200;


procedure TFileCount.CopyFolderObj(fo1: TFolderObj; var fo2: TFolderObj);
begin
  fo2.FullPath:=fo1.FullPath;
  fo2.DispalyName:=fo1.DispalyName;
  fo2.isFolder:=false;
  fo2.FileTime:=fo1.FileTime;
  fo2.Size:=fo1.Size;
  fo2.FileAttribute:=fo1.FileAttribute;
end;

constructor TFileCount.Create;
begin
  FCurrentPos:=0;
  FCount:=200;
end;

procedure TFileCount.DisplayData(lv_Files: TListView);
var
  i:Integer;
  ft:TFolderObj;
begin
  for i:=FCurrentPos downto 1 do
  begin
    ft:=RemoveMin;
    with lv_Files.Items.Insert(0) do
    begin
        Caption:=ft.DispalyName;
        Data:=@ft.Size;
        SubItems.Add(FormatByte(ft.Size));
        SubItems.Add(ExtractFilePath(ft.FullPath));
        SubItems.Add(DateTimeToStr(FileDateToDateTime(ft.FileTime)));
        SubItems.Add('A');
    end;
  end;
end;

procedure TFileCount.InsertFolderObj(fo: TFolderObj);
begin
   if FCurrentPos <= FCount - 1 then
    begin
        CopyFolderObj(fo,files[FCurrentPos]);
        MoveUp(FCurrentPos);
        Inc(FCurrentPos);
    end
    else
    begin
      if Greater(fo,files[0]) then
      begin
        CopyFolderObj(fo,files[0]);
        MoveDown(0);
      end;
    end;
end;

procedure TFileCount.MoveDown(index: Integer);
var
  fo:TFolderObj;
  iCurrent:Integer;
  childPos:Integer;
begin
  fo:=files[index];
  iCurrent:=index;

  childPos:=2*index+1;

  while childPos<FCurrentPos do
  begin
      if (childPos+1<FCurrentPos) and ( Comparele(files[childpos+1],files[childpos]) ) then
        childPos:=childPos+1;

      if (Comparele(fo,files[childpos])) then
        Break
      else
      begin
        CopyFolderObj(files[childPos],files[iCurrent]);
        iCurrent:=childPos;
        childPos:=2*childPos+1;
      end;
  end;

  CopyFolderObj(fo,files[iCurrent]);
end;

procedure TFileCount.MoveUp(index: Integer);
var
  iCurrent,iParent:integer;
  fo:TFolderObj;
begin
  iCurrent:=index;
  iParent:=(index-1) div 2;

  fo:=files[index];

  while iCurrent<>0 do
  begin
     if CompareLe(files[iParent],fo) then
      break
     else
     begin
       CopyFolderObj(files[iParent],files[iCurrent]);
       iCurrent:=iParent;
       iParent:=(iCurrent-1) div 2;
     end;
  end;
  CopyFolderObj(fo,files[iCurrent]);
end;

function TFileCount.RemoveMin:TFolderObj;
begin
  CopyFolderObj(files[0],Result);

  CopyFolderObj(Files[FCurrentPos-1],FileS[0]);
  Dec(FCurrentPos);
  MoveDown(0);
end;

{ TMaxSizeFileCount }

function TMaxSizeFileCount.CompareGe(fo1, fo2: TFolderObj): Boolean;
begin
  Result:= fo1.Size >= fo2.Size;
end;

function TMaxSizeFileCount.CompareLe(fo1, fo2: TFolderObj): Boolean;
begin
  Result:= fo1.Size <= fo2.Size;
end;

function TMaxSizeFileCount.Greater(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.Size > fo2.Size;
end;

{ TMostNewFileCount }

function TMostNewFileCount.CompareGe(fo1, fo2: TFolderObj): Boolean;
begin
  result:=fo1.FileTime>=fo2.FileTime;
end;

function TMostNewFileCount.CompareLe(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.FileTime<=fo2.FileTime;
end;

function TMostNewFileCount.Greater(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.FileTime>fo2.FileTime;
end;

{ TMostOldFileCount }

function TMostOldFileCount.CompareGe(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.FileTime<=fo2.FileTime;
end;

function TMostOldFileCount.CompareLe(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.FileTime>=fo2.FileTime;
end;

function TMostOldFileCount.Greater(fo1, fo2: TFolderObj): Boolean;
begin
  Result:=fo1.FileTime<fo2.FileTime;
end;

end.
 