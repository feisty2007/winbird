unit NetAdapters;

interface

uses
  IpHlpApi, Windows, Classes, IpTypes, Registry, SysUtils;

type
  TNetAdapterInfo = class
    function GetAdaptersName: TStringList;
  end;

  TNetAdapter = class
  private
    FAdapterName: string;
    FisAutoDNS: Boolean;
    FisDHCP: Boolean;
    Fdns_second: string;
    FNetMask: string;
    FIPAddress: string;
    Fdns_first: string;
    FGateway: string;
    Fimageindex: integer;
    FprofileName: string;
    FDefaultPrinter: string;
    FChangeDefaultPrinter: Boolean;
    FChangeIEHomePage: Boolean;
    FIEHomePage: string;
    FISExecuteShell: Boolean;
    FShellCommand: string;
    procedure SetAdapterName(const Value: string);
    procedure Setdns_first(const Value: string);
    procedure Setdns_second(const Value: string);
    procedure SetIPAddress(const Value: string);
    procedure SetisAutoDNS(const Value: Boolean);
    procedure SetisDHCP(const Value: Boolean);
    procedure SetNetMask(const Value: string);
    procedure SetGateway(const Value: string);
    procedure Setimageindex(const Value: integer);
    procedure SetprofileName(const Value: string);
    procedure SetDefaultPrinter(const Value: string);
    procedure SetChangeDefaultPrinter(const Value: Boolean);
    procedure SetChangeIEHomePage(const Value: Boolean);
    procedure SetIEHomePage(const Value: string);
    procedure SetISExecuteShell(const Value: Boolean);
    procedure SetShellCommand(const Value: string);
  published
    property AdapterName: string read FAdapterName write SetAdapterName;
    property isDHCP: Boolean read FisDHCP write SetisDHCP;
    property IPAddress: string read FIPAddress write SetIPAddress;
    property NetMask: string read FNetMask write SetNetMask;
    property Gateway: string read FGateway write SetGateway;
    property isAutoDNS: Boolean read FisAutoDNS write SetisAutoDNS;
    property dns_first: string read Fdns_first write Setdns_first;
    property dns_second: string read Fdns_second write Setdns_second;
    property imageindex: integer read Fimageindex write Setimageindex;
    property profileName: string read FprofileName write SetprofileName;
    property DefaultPrinter:string read FDefaultPrinter write SetDefaultPrinter;
    property ChangeDefaultPrinter:Boolean read FChangeDefaultPrinter write SetChangeDefaultPrinter;
    property ChangeIEHomePage:Boolean read FChangeIEHomePage write SetChangeIEHomePage;
    property IEHomePage:string read FIEHomePage write SetIEHomePage;

    property ISExecuteShell:Boolean read FISExecuteShell write SetISExecuteShell;
    property ShellCommand:string read FShellCommand write SetShellCommand;
  public
    procedure SwitchIP;
    function GetSwithCommands:TStringList;
  end;

implementation

{ TNetAdapter }

function TNetAdapterInfo.GetAdaptersName: TStringList;
var
  BufLen: ULONG;
  Err: DWORD;
  P: Pointer;
  AdapterInfo: PIP_ADAPTER_INFO;
  AdapterList: TStringList;
  function GetAdapterNameByID(Id: string): string;
  const
    regKey = 'SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}';
  var
    reg: TRegistry;
  begin
    result := '';

    reg := TRegistry.Create;

    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly(regKey + '\' + id + '\connection') then
    begin
      result := Reg.ReadString('Name');
    end;
  end;
begin
  result := TStringList.Create;
  BufLen := SizeOf(AdapterInfo^);
  GetAdaptersInfo(nil, BufLen);
  AdapterInfo := AllocMem(BufLen);
  Err := GetAdaptersInfo(AdapterInfo, BufLen);
  P := AdapterInfo;

  AdapterList := TStringList.Create;

  if Err = NO_ERROR then
  begin
    while p <> nil do
    begin
      with IP_ADAPTER_INFO(P^) do
      begin
        Result.Add(GetAdapterNameByID(AdapterName));
        p := Next;
      end;
    end;
  end;
  Dispose(AdapterInfo);
end;

procedure TNetAdapter.Setdns_first(const Value: string);
begin
  Fdns_first := Value;
end;

procedure TNetAdapter.Setdns_second(const Value: string);
begin
  Fdns_second := Value;
end;

procedure TNetAdapter.SetIPAddress(const Value: string);
begin
  FIPAddress := Value;
end;

procedure TNetAdapter.SetisAutoDNS(const Value: Boolean);
begin
  FisAutoDNS := Value;
end;

procedure TNetAdapter.SetisDHCP(const Value: Boolean);
begin
  FisDHCP := Value;
end;

procedure TNetAdapter.SetNetMask(const Value: string);
begin
  FNetMask := Value;
end;

procedure TNetAdapter.SetGateway(const Value: string);
begin
  FGateway := Value;
end;

procedure TNetAdapter.Setimageindex(const Value: integer);
begin
  Fimageindex := Value;
end;

procedure TNetAdapter.SetprofileName(const Value: string);
begin
  FprofileName := Value;
end;

procedure TNetAdapter.SwitchIP;
begin
  
end;

function TNetAdapter.GetSwithCommands: TStringList;
var
  _AdapterName:string;
begin
  Result:=TStringList.Create;

  Result.Add('pushd interface ip');
  if not FisDHCP then
  begin
    Result.Add('set address name='+'"'+FAdapterName+'" source=static addr='+FIPAddress+' mask='+NetMask);
    Result.Add('set address name='+'"'+FAdapterName+'" gateway='+FGateway+' gwmetric=0');
  end
  else
  begin
    Result.Add('set address name='+'"'+FAdapterName+'" source=dhcp');
  end;

  if not FisAutoDNS then
  begin
    Result.Add('set dns name="'+FAdapterName+'" source=static addr='+Fdns_first+' register=PRIMARY');
    Result.Add('add dns name="'+FAdapterName+'" addr='+fdns_second+' index=2');
  end
  else
  begin
    Result.Add('set dns name='+'"'+FAdapterName+'" source=dhcp');
  end;

  Result.Add('set wins name="'+FAdapterName+'" source=static addr=none');
  Result.Add('popd');
end;

procedure TNetAdapter.SetDefaultPrinter(const Value: string);
begin
  FDefaultPrinter := Value;
end;

procedure TNetAdapter.SetChangeDefaultPrinter(const Value: Boolean);
begin
  FChangeDefaultPrinter := Value;
end;

procedure TNetAdapter.SetChangeIEHomePage(const Value: Boolean);
begin
  FChangeIEHomePage := Value;
end;

procedure TNetAdapter.SetIEHomePage(const Value: String);
begin
  FIEHomePage := Value;
end;

procedure TNetAdapter.SetISExecuteShell(const Value: Boolean);
begin
  FISExecuteShell := Value;
end;

procedure TNetAdapter.SetShellCommand(const Value: string);
begin
  FShellCommand := Value;
end;

{ TNetAdapter }

procedure TNetAdapter.SetAdapterName(const Value: string);
begin
  FAdapterName := Value;
end;

end.

 