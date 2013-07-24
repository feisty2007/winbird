unit ShellFolderHelperUtil;

interface

uses
  Windows, ShellAPI, ShlObj;

type

  ShellFolderHelper = class
  public
    class function GetHistoryPath(FWndHandle: THandle): string;
    class function GetFavoritesPath(FWndHandle: THandle): string;
    class function GetCookiesPath(FWndHandle: THandle): string;
  end;

implementation

{ ShellFolderHelper }

class function ShellFolderHelper.GetCookiesPath(
  FWndHandle: THandle): string;
var
  path: array[0..MAX_PATH] of char;
  idl: PItemIdList;
begin
  SHGetSpecialFolderLocation(FWndHandle, CSIDL_COOKIES, idl);
  SHGetPathFromIDList(idl, path);
  result := path;
end;

class function ShellFolderHelper.GetFavoritesPath(
  FWndHandle: THandle): string;
var
  path: array[0..MAX_PATH] of char;
  idl: PItemIdList;
begin
  SHGetSpecialFolderLocation(FWndHandle, CSIDL_FAVORITES, idl);
  SHGetPathFromIDList(idl, path);
  result := path;
end;

class function ShellFolderHelper.GetHistoryPath(FWndHandle: THandle): string;
var
  path: array[0..MAX_PATH] of char;
  idl: PItemIdList;
begin
  SHGetSpecialFolderLocation(FWndHandle, CSIDL_HISTORY, idl);
  SHGetPathFromIDList(idl, path);
  result := path;
end;

end.
