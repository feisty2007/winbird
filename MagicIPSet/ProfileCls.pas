unit ProfileCls;

interface
uses
  IniFiles, Windows, NetAdapters, SysUtils, Classes, Contnrs, Forms;

type
  TGNetworkProfile = class
  private
    function GetProfileName: string;
    procedure readProfileFromFile(strFile: string);
  public
    ProfileList: TObjectList;
    constructor Create;
    procedure WriteToConfig;
  end;

implementation

const
  na_AdapterName = 'AdapterName';
  na_isDHCP = 'dhcp';
  na_IPAddress = 'IPAddress';
  na_SubnetMask = 'SubnetMask';
  na_GateWay = 'GateWay';
  na_isAutoDNS = 'autoDNS';
  na_PriDNS = 'PriDNS';
  na_SecDNS = 'SecDNS';
  na_ImageIndex = 'ImageIndex';
  na_count = 'Count';
  na_CfgName = 'ProfileName';
  na_ChangePrinter='ChangePrinter';
  na_DefaultPrinter='DefaultPrinterName';
  na_ChangeIEHomePage='ChangeHomePage';
  na_IEHomePage='IEHomePage';
  na_ExeShellCmd='ExeShellCmd';
  na_ShellCmd='ShellCmd';

{ TGNetworkProfile }

constructor TGNetworkProfile.Create;
var
  _profilePath: string;
begin
  ProfileList := TObjectList.Create;

  _profilePath := GetProfileName;
  if FileExists(_profilePath) then
  begin
    readProfileFromFile(_profilePath);
  end;
end;


function TGNetworkProfile.GetProfileName: string;
const
  FileName = 'NetworkProfile.ini';
var
  path: string;
begin
  path := ExtractFilePath(Application.ExeName);

  result := path + '\' + FileName;
end;

procedure TGNetworkProfile.readProfileFromFile(strFile: string);
var
  _profile: TIniFile;
  count: integer;
  i: integer;

  function GetNetAdapterByName(_strSection: string): TNetAdapter;
  var
    configs: TStringList;
  begin
    result := TNetAdapter.Create;

    configs := TStringList.Create;

    Result.profileName := _profile.ReadString(_strSection, na_CfgName, '');
    Result.AdapterName := _profile.ReadString(_strSection, na_AdapterName, '');
    Result.isDHCP := _profile.ReadBool(_strSection, na_isDHCP, false);

    if not Result.isDHCP then
    begin
      Result.IPAddress := _profile.ReadString(_strSection, na_IPAddress, '0.0.0.0');
      Result.NetMask := _profile.ReadString(_strSection, na_SubnetMask, '255.255.255.0');
      Result.Gateway := _profile.ReadString(_strSection, na_GateWay, '0.0.0.0');
    end;

    Result.isAutoDNS := _profile.ReadBool(_strSection, na_isAutoDNS, false);

    if not Result.isAutoDNS then
    begin
      Result.dns_first := _profile.ReadString(_strSection, na_PriDNS, '0.0.0.0');
      Result.dns_second := _profile.ReadString(_strSection, na_SecDNS, '0.0.0.0');
    end;

    Result.imageindex := _profile.ReadInteger(_strSection, 'ImageIndex', 0);

    Result.ChangeIEHomePage:=_profile.ReadBool(_strSection,na_ChangeIEHomePage,false);
    if Result.ChangeIEHomePage then
      Result.IEHomePage:=_profile.ReadString(_strSection,na_IEHomePage,'about:blank');

    Result.ChangeDefaultPrinter:=_profile.ReadBool(_strSection,na_ChangePrinter,false);
    if Result.ChangeDefaultPrinter then
      Result.DefaultPrinter:=_profile.ReadString(_strSection,na_DefaultPrinter,'');

    Result.ISExecuteShell:=_profile.ReadBool(_strSection,na_ExeShellCmd,False);
    if Result.ISExecuteShell then
      Result.ShellCommand:=_profile.ReadString(_strSection,na_ShellCmd,'');

  end;
begin
  _profile := TIniFile.Create(strFile);
  count := _profile.ReadInteger('General', na_count, 0);

  for i := 0 to count - 1 do
  begin
    ProfileList.Add(GetNetAdapterByName('Profile' + IntToStr(i)));
  end;
end;

procedure TGNetworkProfile.WriteToConfig;
var
  iCount: integer;
  _profile: TIniFile;
  i: Integer;

  procedure WriteCfgToProfileSection(i: Integer; NetWorkAdapter: TNetAdapter);
  var
    sectionName: string;
  begin
    sectionName := 'Profile' + IntToStr(i);
    _profile.WriteString(sectionName, na_CfgName, NetWorkAdapter.profileName);
    _profile.WriteString(sectionName, na_AdapterName, NetWorkAdapter.AdapterName);
    _profile.WriteBool(sectionName, na_isDHCP, NetWorkAdapter.isDHCP);

    if not NetWorkAdapter.isDHCP then
    begin
      _profile.WriteString(sectionName, na_IPAddress, NetWorkAdapter.IPAddress);
      _profile.WriteString(sectionName, na_SubnetMask, NetWorkAdapter.NetMask);
      _profile.WriteString(sectionName, na_GateWay, NetWorkAdapter.Gateway);
    end;

    _profile.WriteBool(sectionName, na_isAutoDNS, NetWorkAdapter.isAutoDNS);

    if not NetWorkAdapter.isAutoDNS then
    begin
      _profile.WriteString(sectionName, na_PriDNS, NetWorkAdapter.dns_first);
      _profile.WriteString(sectionName, na_SecDNS, NetWorkAdapter.dns_second);
    end;

    _profile.WriteInteger(sectionName, na_ImageIndex, NetWorkAdapter.imageindex);

    _profile.WriteBool(sectionName,na_ChangeIEHomePage,NetWorkAdapter.ChangeIEHomePage);
    if NetWorkAdapter.ChangeIEHomePage then
      _profile.WriteString(sectionName,na_IEHomePage,NetWorkAdapter.IEHomePage);

    _profile.WriteBool(sectionName,na_ChangePrinter,NetWorkAdapter.ChangeDefaultPrinter);
    if NetWorkAdapter.ChangeDefaultPrinter then
      _profile.WriteString(sectionName,na_DefaultPrinter,NetWorkAdapter.DefaultPrinter);

    _profile.WriteBool(sectionName,na_ExeShellCmd,NetWorkAdapter.ISExecuteShell);
    if NetWorkAdapter.ISExecuteShell then
      _profile.WriteString(sectionName,na_ShellCmd,'"'+NetworkAdapter.ShellCommand+'"');

  end;
begin
  if FileExists(GetProfileName) then
    DeleteFile(GetProfileName);
  _profile := TIniFile.Create(GetProfileName);
  iCount := ProfileList.Count;

  _profile.WriteString('General', na_count, IntToStr(iCount));

  for i := 0 to iCount - 1 do
  begin
    WriteCfgToProfileSection(i, ProfileList[i] as TNetAdapter);
  end;
  _profile.Free;
end;

end.

