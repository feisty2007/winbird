unit NetworkInfo;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IPHLPAPI;

type
    // Internet Adapter type
    TNetworkAdapterType = ( natOther, natEthernet, natTokenRing, natFDDI, natPPP, natLoopBack, natSLIP );

    TNetworkAdapter = class (TObject)
    private
        fName: String;
        fDescription: String;
        fMACAddress: String;
        fDriverName: String;
        fIndex: Integer;
        fDHCPServerAddress: String;
        fPrimaryWINSServer, fSecondaryWINSServer: String;
        fDHCPEnabled, fHaveWINS: Boolean;
        fDefaultGateway: String;
        fAdapterType: TNetworkAdapterType;
        fLeaseObtained, fLeaseExpires: TDateTime;
        fIPAddresses, fIPMasks: TStringList;
    public
        constructor Create (Info: PIPAdapterInfo);
        destructor Destroy; override;
        property Index: Integer read fIndex;
        property Name: String read fName;
        property DriverName: String read fDriverName;
        property Description: String read fDescription;
        property MACAddress: String read fMACAddress;
        property DHCPEnabled: Boolean read fDHCPEnabled;
        property DHCPServerAddress: String read fDHCPServerAddress;
        property DHCPStartLease: TDateTime read fLeaseObtained;
        property DHCPEndLease: TDateTime read fLeaseExpires;
        property DefaultGateway: String read fDefaultGateway;
        property HaveWINS: Boolean read fHaveWINS;
        property PrimaryWINSServer: String read fPrimaryWINSServer;
        property SecondaryWINSServer: String read fSecondaryWINSServer;
        property AdapterType: TNetworkAdapterType read fAdapterType;
        property IPAddresses: TStringList read fIPAddresses;
        property IPMasks: TStringList read fIPMasks;
    end;

    TIPStats = class (TPersistent)
    private
        fDummy: Integer;
        fIPStats: TIPStatistics;
        function GetIPStats (Index: Integer): Integer;
    published
        property IPForwarding: Integer index 0 read GetIPStats write fDummy;
        property IPDefaultTTL: Integer index 1 read GetIPStats write fDummy;
        property IPDatagramsReceived: Integer index 2 read GetIPStats write fDummy;
        property IPReceivedHeaderErrors: Integer index 3 read GetIPStats write fDummy;
        property IPReceivedAddressErrors: Integer index 4 read GetIPStats write fDummy;
        property IPForwardedDatagrams: Integer index 5 read GetIPStats write fDummy;
        property IPUnknownProtocols: Integer index 6 read GetIPStats write fDummy;
        property IPReceivedDiscardCount: Integer index 7 read GetIPStats write fDummy;
        property IPReceivedDeliveredCount: Integer index 8 read GetIPStats write fDummy;
        property IPSentDatagramsCount: Integer index 9 read GetIPStats write fDummy;
        property IPRoutingDiscards: Integer index 10 read GetIPStats write fDummy;
        property IPSetDatagramsDiscarded: Integer index 11 read GetIPStats write fDummy;
        property IPNoRouteDatagrams: Integer index 12 read GetIPStats write fDummy;
        property IPReassembleTimeoutCount: Integer index 13 read GetIPStats write fDummy;
        property IPReassemblyRequiredCount: Integer index 14 read GetIPStats write fDummy;
        property IPOKReassemblies: Integer index 15 read GetIPStats write fDummy;
        property IPBadReassemblies: Integer index 16 read GetIPStats write fDummy;
        property IPOKFragmentations: Integer index 17 read GetIPStats write fDummy;
        property IPBadFragmentations: Integer index 18 read GetIPStats write fDummy;
        property IPFragmentationsCount: Integer index 19 read GetIPStats write fDummy;
        property IPNumInterfaces: Integer index 20 read GetIPStats write fDummy;
        property IPNumAddresses: Integer index 21 read GetIPStats write fDummy;
        property IPNumRoutes: Integer index 22 read GetIPStats write fDummy;
    end;

    TTCPStats = class (TPersistent)
    private
        fDummy: Integer;
        fTCPStats: TTCPStatistics;
        function GetTCPStats (Index: Integer): Integer;
    published
        property TCPTimeoutAlgo: Integer index 0 read GetTCPStats write fDummy;
        property TCPMinTimeout: Integer index 1 read GetTCPStats write fDummy;
        property TCPMaxTimeout: Integer index 2 read GetTCPStats write fDummy;
        property TCPMaxConnections: Integer index 3 read GetTCPStats write fDummy;
        property TCPActiveOpens: Integer index 4 read GetTCPStats write fDummy;
        property TCPPassiveOpens: Integer index 5 read GetTCPStats write fDummy;
        property TCPFailedConnects: Integer index 6 read GetTCPStats write fDummy;
        property TCPResetConnects: Integer index 7 read GetTCPStats write fDummy;
        property TCPCurrentConnects: Integer index 8 read GetTCPStats write fDummy;
        property TCPReceivedSegments: Integer index 9 read GetTCPStats write fDummy;
        property TCPSentSegments: Integer index 10 read GetTCPStats write fDummy;
        property TCPResentSegments: Integer index 11 read GetTCPStats write fDummy;
        property TCPErrorsReceived: Integer index 12 read GetTCPStats write fDummy;
        property TCPSentSegsReset: Integer index 13 read GetTCPStats write fDummy;
        property TCPCumulativeConnects: Integer index 14 read GetTCPStats write fDummy;
    end;

    TNetworkInfo = class (TComponent)
    private
        { Private declarations }
        fAdapters: TList;
        fIPStatistics, fIPStatsDummy: TIPStats;
        fTCPStatistics, fTCPStatsDummy: TTCPStats;
        fTCPConnectionsDummy, fUDPConnectionsDummy: TStringList;
        fTCPConnections: TStringList;
        fUDPConnections: TStringList;
        fMapProcessIDs: Boolean;
        procedure InitAdapters;
        procedure ClearAdapters;
    protected
        { Protected declarations }
    public
        { Public declarations }
        constructor Create (AOwner: TComponent); override;
        destructor Destroy; override;
        procedure RefreshStatistics;
        procedure RefreshTCPConnections;
        procedure RefreshUDPConnections;
        property Adapters: TList read fAdapters;
    published
        // Statistics
        property IPStatistics: TIPStats read fIPStatistics write fIPStatsDummy;
        property TCPStatistics: TTCPStats read fTCPStatistics write fTCPStatsDummy;
        // Connections
        property TCPConnections: TStringList read fTCPConnections write fTCPConnectionsDummy;
        property UDPConnections: TStringList read fUDPConnections write fUDPConnectionsDummy;
        // Bells and whistles!
        property MapProcessIDs: Boolean read fMapProcessIDs write fMapProcessIDs;
    end;

procedure Register;

implementation

uses ProcessMapper;

// Colin Wilson's time_t >> TDateTime converter

function time_tToDateTime (t: Integer) : TDateTime;
type
    PComp = ^Comp;
var
    baseDate: TDateTime;
    systemBaseDate: TSystemTime;
    filetimeBaseDate: TFileTime;
    timet_comp, c: comp;
begin
    baseDate := EncodeDate (1970, 1, 1);
    DateTimeToSystemTime (baseDate, systemBaseDate);
    SystemTimeToFileTime (systemBaseDate, filetimeBaseDate);
    timet_comp := PComp (@filetimeBaseDate)^;
    c := t;
    c := c * 10000000 + timet_comp; // + d3time_comp;
    filetimeBaseDate := PFileTime (@c)^;
    FileTimeToSystemTime (filetimeBaseDate, systemBaseDate);
    Result := SystemTimeToDateTime (systemBaseDate);
end;

// Colin Wilson's TDateTime >> time_t converter

function DateTimeTotime_t (const dt: TDateTime): DWord;
type
    PComp = ^Comp;
var
    baseDate: TDateTime;
    systemBaseDate: TSystemTime;
    filetimeBaseDate: TFileTime;
    timet_comp, c: comp;
begin
    baseDate := EncodeDate (1970, 1, 1);
    DateTimeToSystemTime (baseDate, systemBaseDate);
    SystemTimeToFileTime (systemBaseDate, filetimeBaseDate);
    timet_comp := PComp (@filetimeBaseDate)^;
    DateTimeToSystemTime (dt, systemBaseDate);
    SystemTimeToFileTime (systemBaseDate, filetimeBaseDate);
    c := PComp (@filetimeBaseDate)^;
    c := (c - timet_comp) / 10000000;
    Result := Round (c);
end;

// Transmogrify port number from network byte order to host byte order

function PortNumToString (PortNum: Word): String;
begin
    Result := IntToStr ((LoByte (PortNum) * 256) + HiByte (PortNum));
end;

// Convert a packed IP address to xxx.xxx.xxx.xxx format

function IPAddressToString (IPAddress: DWord): String;
var
    Idx: Integer;
begin
    Result := '';
    for Idx := 0 to 3 do begin
        Result := Result + Format ('%d', [IPAddress and $FF]);
        if Idx <> 3 then Result := Result + '.';
        IPAddress := IPAddress shr 8;
    end;
end;

// Create a human-readable MAC address

function MACAddressFromBytes (Count: Integer; Bytes: PChar): String;
begin
    Result := '';
    while Count > 0 do begin
        Result := Result + IntToHex (Ord (Bytes^), 2);
        if Count > 1 then Result := Result + '-';
        Inc (Bytes);  Dec (Count);
    end;
end;

// TNetworkAdapter

constructor TNetworkAdapter.Create (Info: PIPAdapterInfo);
var
    HyphenPos: Integer;
    IPAddr: PIPAddressList;
begin
    Inherited Create;
    fIPMasks := TStringList.Create;
    fIPAddresses := TStringList.Create;
    fName := Info.AdapterName;

    HyphenPos := Pos ('-', Info.Description);
    if HyphenPos = 0 then begin
        fDescription := Info.Description;
        fDriverName := '';
    end else begin
        fDescription := Trim (Copy (Info.Description, 1, HyphenPos - 1));
        fDriverName := Trim (Copy (Info.Description, HyphenPos + 1, MaxInt));
    end;

    fMACAddress := MACAddressFromBytes (Info.AddressLength, @Info.Address);
    fIndex := Info.Index;
    fAdapterType := TNetworkAdapterType (Info.AdapterType);
    fDHCPEnabled := Info.DHCPEnabled <> 0;
    fHaveWINS := Info.HaveWINS <> False;
    fDefaultGateway := Info.GatewayList.IpAddress;

    IPAddr := @Info.IPAddressList;
    while IPAddr <> Nil do begin
        fIPAddresses.Add (IPAddr.IpAddress);
        fIPMasks.Add (IPAddr.IpMask);
        IPAddr := IPAddr.Next;
    end;

    if fDHCPEnabled then begin
        fDHCPServerAddress := Info.DHCPServer.IpAddress;
        fLeaseObtained := time_tToDateTime (Info.LeaseObtained);
        fLeaseExpires := time_tToDateTime (Info.LeaseExpires);
    end;

    if fHaveWINS then begin
        fPrimaryWINSServer := Info.PrimaryWINSServer.IpAddress;
        fSecondaryWINSServer := Info.SecondaryWINSServer.IPAddress;
    end;
end;

destructor TNetworkAdapter.Destroy;
begin
    fIPMasks.Free;
    fIPAddresses.Free;
    Inherited Destroy;
end;

// TIPStats

function TIPStats.GetIPStats (Index: Integer): Integer;
begin
    Result := fIPStats.IPStats [Index];
end;

// TTCPStats

function TTCPStats.GetTCPStats (Index: Integer): Integer;
begin
    Result := fTCPStats.TCPStats [Index];
end;

// TNetworkInfo

constructor TNetworkInfo.Create (AOwner: TComponent);
begin
    Inherited Create (AOwner);
    fAdapters := TList.Create;
    fTCPConnections := TStringList.Create;
    fUDPConnections := TStringList.Create;
    InitAdapters;
    RefreshStatistics;
    RefreshTCPConnections;
    RefreshUDPConnections;
end;

destructor TNetworkInfo.Destroy;
begin
    ClearAdapters;
    fAdapters.Free;
    fIPStatistics.Free;
    fTCPStatistics.Free;
    fTCPConnections.Free;
    fUDPConnections.Free;
    Inherited Destroy;
end;

procedure TNetworkInfo.ClearAdapters;
begin
    while fAdapters.Count > 0 do begin
        TNetworkAdapter (fAdapters [0]).Free;
        fAdapters.Delete (0);
    end;
end;

procedure TNetworkInfo.InitAdapters;
var
    BuffLen: Integer;
    Buff, Curr: PIPAdapterInfo;
begin
    // Clear current adapter list
    ClearAdapters;

    // Figure out size of the wanted buffer
    BuffLen := 0;
    GetAdaptersInfo (Nil, BuffLen);

    // Allocate the buffer and load it
    Buff := AllocMem (BuffLen);
    try
        GetAdaptersInfo (Buff, BuffLen);
        Curr := Buff;

        // Iterate through the linked list of adapters
        while Curr <> Nil do begin
            fAdapters.Add (TNetworkAdapter.Create (Curr));
            Curr := Curr.Next;
        end;
    finally
        FreeMem (Buff);
    end;
end;

procedure TNetworkInfo.RefreshTCPConnections;
var
    TableEx: PTCPTableEx;

    procedure LoadTCPTable;
    var
        Table: PTCPTable;
        Idx, BuffLen: Integer;
    begin
        BuffLen := 0;
        GetTCPTable (Nil, BuffLen, False);
        Table := AllocMem (BuffLen);
        try
            GetTCPTable (Table, BuffLen, True);
            for Idx := 0 to Table.NumEntries - 1 do begin
                fTCPConnections.Add (IntToStr (Table.Table [Idx].dwState) + '|' +
                                     IPAddressToString (Table.Table [Idx].dwLocalAddr) + '|' +
                                     PortNumToString (Table.Table [Idx].dwLocalPort) + '|' +
                                     IPAddressToString (Table.Table [Idx].dwRemoteAddr) + '|' +
                                     PortNumToString (Table.Table [Idx].dwRemotePort) + '|-');
            end;
        finally
            FreeMem (Table);
        end;
    end;

    procedure LoadTCPTableEx;
    var
        Idx: Integer;
    begin
        if fMapProcessIDs then ProcessCreateSnapshot;
        for Idx := 0 to TableEx.NumEntries - 1 do
            fTCPConnections.Add (IntToStr (TableEx.Table [Idx].dwState) + '|' +
                                 IPAddressToString (TableEx.Table [Idx].dwLocalAddr) + '|' +
                                 PortNumToString (TableEx.Table [Idx].dwLocalPort) + '|' +
                                 IPAddressToString (TableEx.Table [Idx].dwRemoteAddr) + '|' +
                                 PortNumToString (TableEx.Table [Idx].dwRemotePort) + '|' +
                                 ProcessPIDToProcessName (TableEx.Table [Idx].dwProcessID));

        if fMapProcessIDs then ProcessDeleteSnapshot;
    end;

begin
    fTCPConnections.Clear;
    TableEx := GetTcpTableEx;
    if TableEx = Nil then LoadTCPTable else try
        LoadTCPTableEx;
    finally
        FreeMem (TableEx);
    end;
end;

procedure TNetworkInfo.RefreshUDPConnections;
var
    TableEx: PUDPTableEx;

    procedure LoadUDPTable;
    var
        Table: PUDPTable;
        Idx, BuffLen: Integer;
    begin
        BuffLen := 0;
        GetUDPTable (Nil, BuffLen, False);
        Table := AllocMem (BuffLen);
        try
            GetUDPTable (Table, BuffLen, True);
            for Idx := 0 to Table.NumEntries - 1 do
                fUDPConnections.Add (IPAddressToString (Table.Table [Idx].dwLocalAddr) + '|' +
                                     PortNumToString (Table.Table [Idx].dwLocalPort) + '|-');

        finally
            FreeMem (Table);
        end;
    end;

    procedure LoadUDPTableEx;
    var
        Idx: Integer;
    begin
        if fMapProcessIDs then ProcessCreateSnapshot;
        for Idx := 0 to TableEx.NumEntries - 1 do
            fUDPConnections.Add (IPAddressToString (TableEx.Table [Idx].dwLocalAddr) + '|' +
                                 PortNumToString (TableEx.Table [Idx].dwLocalPort) + '|' +
                                 ProcessPIDToProcessName (TableEx.Table [Idx].dwProcessID));

        if fMapProcessIDs then ProcessDeleteSnapshot;
    end;

begin
    fUDPConnections.Clear;
    TableEx := GetUdpTableEx;
    if TableEx = Nil then LoadUDPTable else try
        LoadUDPTableEx;
    finally
        FreeMem (TableEx);
    end;
end;

procedure TNetworkInfo.RefreshStatistics;
begin
    if fIPStatistics = Nil then fIPStatistics := TIPStats.Create;
    GetIpStatistics (fIPStatistics.fIPStats);
    if fTCPStatistics = Nil then fTCPStatistics := TTCPStats.Create;
    GetTCPStatistics (fTCPStatistics.fTCPStats);
end;

procedure Register;
begin
    RegisterComponents ('TDM', [TNetworkInfo]);
end;

end.