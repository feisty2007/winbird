unit OemInfo;

interface
uses
  Windows, IniFiles, SysUtils, Classes;
type

  TOemInfo = class
  private
    FSupportInfo: TStringList;
    FManu: string;
    FModel: string;
    procedure SetSupportInfo(const vSI: TStringList);

    procedure setManu(const value: string);
    procedure setModel(const value: string);

  public
    property Manu: string read FManu write setManu;
    property Model: string read FModel write setModel;

    property SupportInfo: TStringList read FSupportInfo write SetSupportInfo;
  public
    constructor Create;
    procedure ReadInfo;
    procedure WriteInfo;
  end;

implementation

function GetSystemDir: TFileName;
var
  SysDir: array [0..MAX_PATH-1] of char;
begin
  SetString(Result, SysDir, GetSystemDirectory(SysDir, MAX_PATH));
  if Result = '' then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;


procedure TOemInfo.setManu(const value: string);
begin
  FManu := value;
end;

procedure TOemInfo.setModel(const value: string);
begin
  FModel := value;
end;

constructor TOemInfo.Create;
begin
  Manu := '';
  Model := '';
  FSupportInfo := TStringList.Create;
end;

procedure TOemInfo.SetSupportInfo(const vSI: TStringList);
begin
  FSupportInfo.Assign(vSI);
end;

procedure TOemInfo.ReadInfo;
var
  iniFile: TIniFile;
  sysDir: string;
  oemFile: string;
  values: TStringList;
  i:integer;
  function GetValue(const s:string):string;
  var
    ss:TStringList;
    icount:integer;
  begin
    ss:=TStringList.Create;

    icount:=ExtractStrings(['='],[],PAnsiChar(s),ss);
    if icount>1 then
      Result:=ss[icount-1]
    else
      Result := '';
  end;
begin
  sysDir := GetSystemDir;

  oemFile := sysDir + '\oeminfo.ini';

  if not FileExists(oemFile) then exit;

  iniFile := TIniFile.Create(oemFile);
  values := TStringList.Create;
  FManu := iniFile.ReadString('General', 'Manufacturer', '');
  FModel := iniFile.ReadString('General', 'Model', '');

  iniFile.ReadSectionValues('Support Information', values);

  for i := 0 to  values.Count-1 do
  begin
    FSupportInfo.Add(GetValue(values[i]));
  end;
end;

procedure TOemInfo.WriteInfo;
var
  iniFile: TIniFile;
  i: integer;
  sysDir: string;
  oemFile: string;
begin
  sysDir := GetSystemDir;
  oemFile := sysDir + '\oeminfo.ini';
  iniFile := TIniFile.Create(oemFile);
  iniFile.WriteString('General', 'Manufacturer', FManu);
  iniFile.WriteString('General', 'Model', FModel);

  for i := 1 to FSupportInfo.count - 1 do
  begin
    iniFile.WriteString('Support Information', 'Line' + IntToStr(i), FSupportInfo[i]);
  end;
end;
end.
d.

