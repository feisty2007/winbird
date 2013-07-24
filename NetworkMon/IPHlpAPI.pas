unit IPHLPAPI;

interface

uses Windows, SysUtils;

const
    MaxAdapterNameLength                = 256;
    MaxAdapterDescriptionLength         = 128;
    MaxAdapterAddressLength             = 8;

type
    // IP Address
    PIPAddressString = ^TIPAddressString;
    TIPAddressString = array [0..15] of Char;           // xxx.xxx.xxx.xxx

    // IP Address list
    PIPAddressList = ^TIPAddressList;
    TIPAddressList = record
        Next: PIPAddressList;
        IpAddress: TIPAddressString;
        IpMask: TIPAddressString;
        Context: Integer;
    end;

    // Internet Adaptor info
    PIPAdapterInfo = ^TIPAdapterInfo;
    TIPAdapterInfo = record
        Next: PIPAdapterInfo;
        ComboIndex: Integer;
        AdapterName: array [0..MaxAdapterNameLength + 3] of Char;
        Description: array [0..MaxAdapterDescriptionLength + 3] of Char;
        AddressLength: Integer;
        Address: array [0..MaxAdapterAddressLength - 1] of Byte;
        Index: Integer;
        AdapterType: Integer;
        DHCPEnabled: Integer;
        CurrentIPAddress: PIPAddressList;
        IPAddressList: TIPAddressList;
        GatewayList: TIPAddressList;
        DHCPServer: TIPAddressList;
        HaveWINS: Bool;
        PrimaryWINSServer: TIPAddressList;
        SecondaryWINSServer: TIPAddressList;
        LeaseObtained: Integer;
        LeaseExpires: Integer;
    end;

    // IP Statistics
    TIPStatistics = record
        IPStats: array [0..22] of Integer;
    end;

    // TCP statistics
    TTCPStatistics = record
        TCPStats: array [0..14] of Integer;
    end;

    // TCP Table
    TTCPTableEntry = record
        dwState: DWord;
        dwLocalAddr: DWord;
        dwLocalPort: DWord;
        dwRemoteAddr: DWord;
        dwRemotePort: DWord;
    end;

    // UDP Table
    TUDPTableEntry = record
        dwLocalAddr: DWord;
        dwLocalPort: DWord;
    end;

    TUDPTableEntryEx = record
        dwLocalAddr: DWord;
        dwLocalPort: DWord;
        dwProcessID: DWord;
    end;

    // TTCPTableEntryEx
    TTCPTableEntryEx = record
        dwState: DWord;
        dwLocalAddr: DWord;
        dwLocalPort: DWord;
        dwRemoteAddr: DWord;
        dwRemotePort: DWord;
        dwProcessID: DWord;
    end;

    PTCPTable = ^TTCPTable;
    TTCPTable = record
        NumEntries: Integer;
        Table: array [0..0] of TTCPTableEntry;
    end;

    PUDPTable = ^TUDPTable;
    TUDPTable = record
        NumEntries: Integer;
        Table: array [0..0] of TUDPTableEntry;
    end;

    // TCP Table - extended
    PTCPTableEx = ^TTCPTableEx;
    TTCPTableEx = record
        NumEntries: Integer;
        Table: array [0..0] of TTCPTableEntryEx;
    end;

    // UDP Table - extended
    PUDPTableEx = ^TUDPTableEx;
    TUDPTableEx = record
        NumEntries: Integer;
        Table: array [0..0] of TUDPTableEntryEx;
    end;

const
    DLLName = 'IPHLPAPI.DLL';

var
    AllocateAndGetTcpExTableFromStack: procedure (var Table: PTCPTableEx; bOrder: Bool; Heap: THandle; Zero, Flags: Integer); stdcall;
    AllocateAndGetUdpExTableFromStack: procedure (var Table: PUDPTableEx; bOrder: Bool; Heap: THandle; Zero, Flags: Integer); stdcall;

function GetTcpTableEx: PTCPTableEx;
function GetUdpTableEx: PUDPTableEx;

function GetAdaptersInfo (AdapterInfo: PIPAdapterInfo; var BufLen: Integer): Integer; stdcall; external DLLName;
function GetIpStatistics (var Stats: TIPStatistics): Integer; stdcall; external DLLName;
function GetTcpStatistics (var Stats: TTCPStatistics): Integer; stdcall; external DLLName;
function GetTcpTable (Table: PTCPTable; var BufLen: Integer; Order: Bool): Integer; stdcall; external DLLName;
function GetUdpTable (Table: PUDPTable; var BufLen: Integer; Order: Bool): Integer; stdcall; external DLLName;

implementation

procedure InitExtendedAPI;
var
    hLib: HModule;
begin
    AllocateAndGetTcpExTableFromStack := Nil;
    AllocateAndGetUdpExTableFromStack := Nil;

    hLib := LoadLibrary (DLLName);
    if hLib <> 0 then begin
        AllocateAndGetTcpExTableFromStack := GetProcAddress (hLib, 'AllocateAndGetTcpExTableFromStack');
        AllocateAndGetUdpExTableFromStack := GetProcAddress (hLib, 'AllocateAndGetUdpExTableFromStack');
    end;
end;

function GetTcpTableEx: PTCPTableEx;
var
    bytes: Integer;
    PTable: PTCPTableEx;
begin
    Result := Nil;
    if @AllocateAndGetTcpExTableFromStack <> Nil then begin
        AllocateAndGetTcpExTableFromStack (PTable, True, GetProcessHeap, 2, 2);
        try
            bytes := HeapSize (GetProcessHeap, 0, PTable);
            GetMem (Result, bytes);
            Move (PTable^, Result^, bytes);
        finally
            HeapFree (GetProcessHeap, 0, PTable);
        end;
    end;
end;

function GetUdpTableEx: PUDPTableEx;
var
    bytes: Integer;
    PTable: PUDPTableEx;
begin
    Result := Nil;
    if @AllocateAndGetUdpExTableFromStack <> Nil then begin
        AllocateAndGetUdpExTableFromStack (PTable, True, GetProcessHeap, 2, 2);
        try
            bytes := HeapSize (GetProcessHeap, 0, PTable);
            GetMem (Result, bytes);
            Move (PTable^, Result^, bytes);
        finally
            HeapFree (GetProcessHeap, 0, PTable);
        end;
    end;
end;

initialization
    InitExtendedAPI;
end.
