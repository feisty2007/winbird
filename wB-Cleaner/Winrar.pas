unit Winrar;

interface
uses
  Registry, Windows, Dialogs, Classes, ShellAPI, ShlObj, SysUtils;
type
  IClear = interface
    ['{135EDE90-A3C3-4798-A87F-24F772EE9386}']
    procedure Clear;
  end;
  TWinrar = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;

  TIEAddressBarCleaner = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;



  TRealPlayerTenHistoryCleaner = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;

  TCurrentDocClearner = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;

  TRunProgramClearner = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;

  TMediaPlayerClearner = class(TInterfacedObject, IClear)
  public
    procedure Clear;
  end;



  TIEClear = class(TInterfacedObject, IClear)
  private
    FFWndHandle: THandle;
    procedure SetFWndHandle(const Value: THandle);
  published
    property FWndHandle: THandle read FFWndHandle write SetFWndHandle;
  public
    procedure Clear;
    procedure ClearCookies;
    procedure ClearIntelliForms;
    constructor Create(WndHandle: THandle); overload;
  end;

implementation

uses GMsgbox, gUtil, ShellFolderHelperUtil;

{ TWinrar }

procedure TWinrar.Clear;
const
  regKey = 'software\WinRAR\ArcHistory';
begin
  RegeditHelper.RemoveAllValues(regKey);
end;

{ TIEAddressCleaner }

procedure TIEAddressBarCleaner.Clear;
const
  regKey = 'software\Microsoft\Internet Explorer\TypedURLs';
begin
  RegeditHelper.RemoveAllValues(regKey);
end;

{ TRealPlayerTenHistoryCleaner }

procedure TRealPlayerTenHistoryCleaner.Clear;
var
  reg: TRegistry;
  i: integer;
  tempKey: string;
const
  regkey = 'software\RealNetworks\RealPlayer\6.0\Preferences';
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regkey, false) then
    begin
      for i := 1 to 8 do
      begin
        tempKey := 'MostRecentClips' + IntToStr(i);
        if reg.KeyExists(tempKey) then
        begin
          reg.deleteKey(tempKey);
        end;
      end;
    end;
  finally
    reg.Free;
  end;
end;

{ TCurrentDocClearner }

procedure TCurrentDocClearner.Clear;
const
  regkey = 'software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs';
begin
  RegeditHelper.RemoveAllValues(regkey);
end;

{ TRunProgramClearner }

procedure TRunProgramClearner.Clear;
const
  regKey = 'software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU';
begin
  RegeditHelper.RemoveAllValues(regkey);
end;

{ TMediaPlayerClearner }

procedure TMediaPlayerClearner.Clear;
const
  regkey = 'software\Microsoft\MediaPlayer\Player\RecentFileList';
begin
  RegeditHelper.RemoveAllValues(regkey);
end;

{ TIEIntelliFormsClearner }

procedure TIEClear.ClearIntelliForms;
var
  reg: TRegistry;
const
  regkey = 'software\Microsoft\Internet Explorer';
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regkey, false) then
      reg.DeleteKey('IntelliForms');
  finally
    reg.Free;
  end;
end;

{ TIEFavoritesClear }

procedure TIEClear.Clear;
var
  favPath: string;
begin
  favPath := ShellFolderHelper.GetFavoritesPath(FWndHandle);
  DirHelper.DeleteDir(favPath, true);
end;

procedure TIEClear.ClearCookies;
var
  cookiesPath: string;
begin
  cookiesPath := ShellFolderHelper.GetCookiesPath(FWndHandle);
  DirHelper.DeleteDir(cookiesPath, true);
end;


constructor TIEClear.Create(WndHandle: THandle);
begin
  FWndHandle := WndHandle;
end;

procedure TIEClear.SetFWndHandle(const Value: THandle);
begin
  FFWndHandle := Value;
end;

end.
