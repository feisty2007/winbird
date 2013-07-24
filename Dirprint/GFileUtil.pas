unit GFileUtil;

interface
uses
  ShellAPI,Windows,SysUtils;

type
  TGFileUtil=class
    function GetTypeName(sFileName:string):string;
    class function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
    class function GetAttrString(Attr: Integer): string;
  end;

implementation

class function TGFileUtil.GetAttrString(Attr: Integer): string;
const
  Attrs: array[1..5] of Integer =
    (FILE_ATTRIBUTE_COMPRESSED, FILE_ATTRIBUTE_ARCHIVE,
     FILE_ATTRIBUTE_SYSTEM, FILE_ATTRIBUTE_HIDDEN,
     FILE_ATTRIBUTE_READONLY);
  AttrChars: array[1..5] of Char = ('C', 'A', 'S', 'H', 'R');
  FAttrSpace=' ';
var
  Index: Integer;
  LowBound: Integer;
begin
  Result := '';
  if Attr <> 0 then
  begin
    LowBound := Low(Attrs);
    if Win32PlatForm <> VER_PLATFORM_WIN32_NT then
      Inc(LowBound);

    for Index := LowBound to High(Attrs) do
      if (Attr and Attrs[Index] <> 0) then
        Result := Result + AttrChars[Index]
      else
        Result := Result + FAttrSpace;
  end;
end;
class function TGFileUtil.FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  SysTime: TSystemTime;
  LocalFileTime: TFileTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SysTime);
  Result := SystemTimeToDateTime(SysTime);
end;

{ TGFileUtil }

function TGFileUtil.GetTypeName(sFileName: string): string;
var
  shfileInfo:TSHFileInfo;
begin
   SHGetFileInfo(PChar(sFileName),
               0,
               shfileinfo,
               SizeOf(shfileinfo),
               SHGFI_TYPENAME );
   Result:=shfileinfo.szTypeName;
end;

end.
 