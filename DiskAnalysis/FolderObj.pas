unit FolderObj;

interface
uses
  Windows,SysUtils;

type
  PFolderObj = ^TFolderObj;
  TFolderObj = record
    Parent: PFolderObj;
    FirstChild: PFolderObj;
    CurrentChild: PFolderObj;
    Next: PFolderObj;
    FullPath: array[0..MAX_PATH] of Char;
    DispalyName: array[0..MAX_PATH] of Char;
    Size: Int64;
    Percent: Double;
    case isFolder: Boolean of
      true:
      (
        SubFolderCount: Integer;
        SubFileCount: Integer;
        isVirtualFolder: Boolean;
        );
      false:
      (
        FileAttribute: Integer;
        FileTime:Integer;
        );
  end;
function FormatByte(nSize: Int64): string;

implementation

function FormatByte(nSize: Int64): string;
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

end.
 