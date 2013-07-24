unit NtService;

interface
uses
  WinSvc, Windows, Contnrs, Registry ,WinSvcEx;

type
  TNtService = class
  public
    function ReadFromRegistry(ServiceName: string; KeyName: string; IsInt: Integer = 0): string;
    constructor Create(ess: TEnumServiceStatus); overload;
    function GetServiceState(ServiceState: DWORD): string;
  private
    FServiceName: string;
    FDescription: string;
    FStartType: string;
    FServiceState: string;
    procedure SetDescription(const Value: string);
    procedure SetServiceName(const Value: string);
    procedure SetServiceState(const Value: string);
    procedure SetStartType(const Value: string);
    procedure ReadServiceInformation;
    function GetServiceStartStyle(ServiceStart:DWORD):string;
  published
    property ServiceName: string read FServiceName write SetServiceName;
    property Description: string read FDescription write SetDescription;
    property StartType: string read FStartType write SetStartType;
    property ServiceState: string read FServiceState write SetServiceState;
  end;

  TNtServiceManager = class
  public
    constructor Create; overload;
    function GetServices: TObjectList;

    destructor destory; overload;
  private
    hScm: SC_HANDLE;
  end;

implementation

{ TNtService }

constructor TNtService.Create(ess: TEnumServiceStatus);
begin
  inherited Create;

  FServiceName := ess.lpServiceName;
//  FDescription := ReadFromRegistry(FServiceName, 'Description');
//  FStartType := ReadFromRegistry(FServiceName, 'Start', 1);
  ReadServiceInformation;
  FServiceState := GetServiceState(ess.ServiceStatus.dwCurrentState);
end;

function TNtService.GetServiceStartStyle(ServiceStart: DWORD): string;
begin
  Result:='Invali Value';

  case ServiceStart of
    SERVICE_AUTO_START:
      Result:='Auto Start' ;
    SERVICE_DISABLED:
      Result:='Disable';
    SERVICE_BOOT_START:
      Result:='Boot Start';
    SERVICE_SYSTEM_START:
      Result:='System Start';
    SERVICE_DEMAND_START:
      Result:='Daemon Start';
  end;    
end;

function TNtService.GetServiceState(ServiceState: DWORD): string;
begin
  Result := 'Invalid value';

  case ServiceState of
    SERVICE_STOPPED:
      Result := ('Stoped');
    SERVICE_START_PENDING:
      Result := ('Starting');
    SERVICE_STOP_PENDING:
      Result := ('Stoping');
    SERVICE_RUNNING:
      Result := ('Started');
    SERVICE_CONTINUE_PENDING:
      Result := ('SERVICE_CONTINUE_PENDING');
    SERVICE_PAUSE_PENDING:
      Result := ('Pausing..');
    SERVICE_PAUSED:
      Result := ('Paused');
  end;
end;

function TNtService.ReadFromRegistry(ServiceName, KeyName: string;
  IsInt: Integer): string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SYSTEM\CurrentControlSet\Services\' + ServiceName, False);
    if IsInt <> 0 then
    begin
      case reg.ReadInteger(KeyName) of
        2: Result := 'auto';
        3: Result := 'manual';
        4: Result := 'disable';
      end;
    end
    else
      Result := reg.ReadString(KeyName);
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

procedure TNtService.ReadServiceInformation;
var
  schHCManager:SC_HANDLE;
  schServie:SC_HANDLE;
  dwBytesNeeded,bufSize,dwErr:DWORD;
  svcConfig:PQueryServiceConfig;
  svcDesp:PServiceDescription;
begin

  schHCManager:=OpenSCManager(
                nil,
                nil,
                SC_MANAGER_ALL_ACCESS);

  if 0=schHCManager then
    Exit;

  schServie:=OpenService(
              schHCManager,
              PAnsiChar(FServiceName),
              SERVICE_QUERY_CONFIG);

  if 0=schServie then
  begin
    CloseHandle(schHCManager);
    Exit;
  end;


  if not QueryServiceConfig(schServie,nil,0,dwBytesNeeded) then
  begin
    dwErr:=GetLastError;

    if ERROR_INSUFFICIENT_BUFFER=dwErr then
    begin
      bufSize:=dwBytesNeeded;
      svcConfig:=PQueryServiceConfig(LocalAlloc(LMEM_FIXED,bufSize));
    end;
  end;

  if not QueryServiceConfig(schServie,svcConfig,bufSize,dwBytesNeeded) then
  begin
    CloseHandle(schHCManager);
    Exit;
  end;

  if not QueryServiceConfig2(schServie,SERVICE_CONFIG_DESCRIPTION,nil,0,dwBytesNeeded) then
  begin
    if ERROR_INSUFFICIENT_BUFFER=dwErr then
    begin
      bufSize:=dwBytesNeeded;
      //svcConfig:=PQueryServiceConfig(LocalAlloc(LMEM_FIXED,bufSize));
      svcDesp:=PServiceDescription(LocalAlloc(LMEM_FIXED,bufSize));
    end;
  end;

  if not QueryServiceConfig2(schServie,SERVICE_CONFIG_DESCRIPTION,svcDesp,bufSize,dwBytesNeeded) then
  begin
    Exit;
  end;

  //FServiceState:=GetServiceState(svcConfig.dwStartType);
  FDescription:=svcDesp.lpDescription;
  FStartType:=GetServiceStartStyle(svcConfig.dwStartType);

  LocalFree(Cardinal(svcConfig));
  LocalFree(Cardinal(svcDesp));
  //CloseHandle(schServie);
  //CloseHandle(schHCManager);
end;

procedure TNtService.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TNtService.SetServiceName(const Value: string);
begin
  FServiceName := Value;
end;

procedure TNtService.SetServiceState(const Value: string);
begin
  FServiceState := Value;
end;

procedure TNtService.SetStartType(const Value: string);
begin
  FStartType := Value;
end;

{ TNtServiceManager }

constructor TNtServiceManager.Create;
begin
  hScm := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
end;

destructor TNtServiceManager.destory;
begin
  CloseHandle(hScm);

  inherited;
end;

function TNtServiceManager.GetServices: TObjectList;
var
  Ret: BOOL;
  PBuf: Pointer;
  PEss: PEnumServiceStatus;
  BytesNeeded, ServicesReturned, ResumeHandle: DWORD;
  i: integer;
  NtSvc: TNtService;
begin
    //Assert((DesiredAccess and SC_MANAGER_ENUMERATE_SERVICE) <> 0);
    // Enum the services
  result := TObjectList.Create;
  ResumeHandle := 0; // Must set this value to zero !!!
  try
    PBuf := nil;
    BytesNeeded := 40960;
    repeat
      ReallocMem(PBuf, BytesNeeded);
      Ret := EnumServicesStatus(hScm,
        SERVICE_WIN32,
        SERVICE_STATE_ALL,
        PEnumServiceStatus(PBuf){$IFNDEF FPC}^{$ENDIF},
        BytesNeeded,
        BytesNeeded,
        ServicesReturned,
        ResumeHandle);
    until Ret or (GetLastError <> ERROR_MORE_DATA);
      //Win32Check(Ret);
    PEss := PBuf;
    for I := 0 to ServicesReturned - 1 do
    begin
      NtSvc := TNtService.Create(PEss^);
      Result.Add(NtSvc);
      Inc(PEss);
    end;
  finally
    FreeMem(PBuf);
  end;
end;

end.
