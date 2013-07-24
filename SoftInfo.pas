unit SoftInfo;

interface
uses
  Classes, Contnrs, Registry, Windows, ShellAPI, Forms;
type
  TSoftInfo = class
  private
    FfHasIcon: Boolean;
    FIcon: HICON;
    FPublisher: string;
    procedure SetfHasIcon(const Value: Boolean);
    procedure SetIcon(const Value: HICON);
    procedure SetPublisher(const Value: string);
  public
    constructor Create; overload;
    function GetIconIndex: integer;
  private
    FDisplayName: string;
    FUninstallKey: string;
    FUninstallProgram: string;

    procedure SetDisplayName(const Value: string);
    procedure SetUninstallKey(const Value: string);
    procedure SetUninstallProgram(const Value: string);
  published
    property Publisher: string read FPublisher write SetPublisher;
    property Icon: HICON read FIcon write SetIcon;
    property fHasIcon: Boolean read FfHasIcon write SetfHasIcon;
    property DisplayName: string read FDisplayName write SetDisplayName;
    property UninstallKey: string read FUninstallKey write SetUninstallKey;
    property UninstallProgram: string read FUninstallProgram write SetUninstallProgram;
  end;

  PSoftInfoData = ^SoftInfoData;

  SoftInfoData = record
    UninstallProgram: string;
    DisplayName: string;
  end;

  TUninstallInfo = class
  public
    class function GetInstalledSoft: TObjectList;
  end;

implementation

{ softInfo }

constructor TSoftInfo.Create;
begin
  inherited;
  FDisplayName := '';
  fHasIcon := false;
  FPublisher := '';
end;

function TSoftInfo.GetIconIndex: integer;
begin
  if fHasIcon then
  begin

  end;
end;

procedure TSoftInfo.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

{ TUninstallInfo }

class function TUninstallInfo.GetInstalledSoft: TObjectList;
const
  regkey = 'software\Microsoft\Windows\CurrentVersion\Uninstall';
var
  reg: TRegistry;

  keys: TStrings;
  i: integer;
  tempDisp: string;
  si: TSoftInfo;
  szIconFileName: string;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  result := TObjectList.Create;
  keys := TStringList.Create;
  try
    if reg.OpenKey(regkey, false) then
    begin
      reg.GetKeyNames(keys);
    end;

    reg.CloseKey;

    for i := 0 to keys.Count - 1 do
    begin
      if reg.OpenKey(regkey + '\' + keys[i], False) then
      begin
        si := TSoftInfo.Create;
        si.UninstallKey := keys[i];
        if reg.ValueExists('DisplayName') then
        begin
          tempDisp := reg.ReadString('DisplayName');
          si.DisplayName := tempDisp;
        end;

        if reg.ValueExists('UninstallString') then
        begin
          tempDisp := reg.ReadString('UninstallString');
          si.UninstallProgram := tempDisp;
        end;

        if reg.ValueExists('DisplayIcon') then
        begin
          szIconFileName := reg.ReadString('DisplayIcon');
          si.FICON := ExtractIcon(HInstance, PAnsiChar(szIconFileName), 0);
          si.fHasIcon := True;
        end;

        if reg.ValueExists('Publisher') then
        begin
          si.FPublisher := reg.ReadString('Publisher');
        end;
        Result.Add(si);
        reg.CloseKey;
      end;
    end;
  finally
    reg.Free;
    keys.Free;
  end;
end;

procedure TSoftInfo.SetfHasIcon(const Value: Boolean);
begin
  FfHasIcon := Value;
end;

procedure TSoftInfo.SetIcon(const Value: HICON);
begin
  FIcon := Value;
end;

procedure TSoftInfo.SetPublisher(const Value: string);
begin
  FPublisher := Value;
end;

procedure TSoftInfo.SetUninstallKey(const Value: string);
begin
  FUninstallKey := Value;
end;

procedure TSoftInfo.SetUninstallProgram(const Value: string);
begin
  FUninstallProgram := Value;
end;

end.
