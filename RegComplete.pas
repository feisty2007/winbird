unit RegComplete;

interface
uses
  SysUtils, Classes, Registry, Windows, Forms, ComCtrls;

type

  TRegComplete = class
  private
    FregKey: string;
    procedure SetregKey(const Value: string);
  published
    property regKey: string read FregKey write SetregKey;
  public
    constructor Create(m_RegKey: string);
    function GetNoExistItems: TStringList;
    function GetExplain: string; virtual; abstract;
    procedure FillList(listView: TListView);
  protected
    function GetKeys: TStringList; virtual; abstract;
    function GetSomeKey(isMachine: Boolean): TStringList;
    function GetFirstString(const strSplit: string): string;
  end;

  TMissingMUI = class(TRegComplete)
  public
    constructor Create(m_RegKey: string); overload;
    function GetExplain: string; override;
  protected
    function GetKeys: TStringList; override;
  end;

  TExpiredStartMenu = class(TRegComplete)
  public
    constructor Create(m_RegKey: string); overload;
    function GetExplain: string; override;
  protected
    function GetKeys: TStringList; override;
  end;

  TStartProgram = class(TRegComplete)
  public
    constructor Create(m_RegKey: string); overload;
    function GetExplain: string; override;
  protected
    function GetKeys: TStringList; override;
  end;

  TMissingHelp = class(TRegComplete)
  public
    constructor Create(m_RegKey: string); overload;
    function GetExplain: string; override;
  protected
    function GetKeys: TStringList; override;
  end;

implementation

{ RegComplete }

constructor TRegComplete.Create(m_RegKey: string);
begin
  FregKey := m_RegKey;
end;

procedure TRegComplete.FillList(listView: TListView);
var
  fileList: TStringList;
  i: integer;
  sCaption: string;
begin
  fileList := GetNoExistItems;
  sCaption := GetExplain;
  for i := 0 to fileList.count - 1 do
  begin
    with ListView.items.Add do
    begin
      Caption := SCaption;
      SubItems.Add(fileList.Strings[i]);
    end;
  end;
end;


function TRegComplete.GetFirstString(const strSplit: string): string;
var
  ss: TStrings;
  i: Integer;
  iCount: integer;
begin
  ss := TStringList.Create;

  ss.Delimiter := ' ';
  ss.CommaText := strSplit;

  iCount := ss.Count;

  if iCount = 1 then
    result := ss.Strings[0]
  else
  begin
    result := ss.Strings[0];
    for i := 1 to ss.Count - 2 do
    begin
      result := result + ' ' + ss.Strings[i];
    end;
  end;
end;

function TRegComplete.GetNoExistItems: TStringList;
var
  items: TStringList;
  i: integer;
begin
  Result := TStringList.Create;

  items := GetKeys;

  for i := 0 to items.Count - 1 do
  begin
    if not FileExists(items.Strings[i]) then
      Result.Add(items.Strings[i]);
  end;
  items.Free;
end;

function TRegComplete.GetSomeKey(isMachine: Boolean): TStringList;
var
  reg: TRegistry;
  Values: TStringList;
  i: integer;
begin
  result := TStringList.Create;
  Values := TStringList.Create;
    //Values:=TStringList.Create;

  reg := TRegistry.Create;
  if isMachine then
    reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if reg.OpenKey(regKey, false) then
    begin
      reg.GetValueNames(Values);

      for i := 0 to Values.Count - 1 do
      begin
        Result.Add(GetFirstString(reg.ReadString(Values.Strings[i])));
      end;
    end;

    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TRegComplete.SetregKey(const Value: string);
begin
  FregKey := Value;
end;

{ TMissingMUI }

constructor TMissingMUI.Create(m_RegKey: string);
begin
  inherited Create(m_RegKey);
  regKey := 'software\Microsoft\Windows\ShellNoRoam\MUICache';
end;

function TMissingMUI.GetExplain: string;
begin
  result := 'Missed MUI file';
end;

function TMissingMUI.GetKeys: TStringList;
var
  reg: TRegistry;
begin
  result := TStringList.Create;
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regKey, False) then
      reg.GetValueNames(result);
  finally
    reg.Free;
  end;
end;

{ TExpiredStartMenu }

constructor TExpiredStartMenu.Create(m_RegKey: string);
begin
  inherited Create(m_RegKey);

  regKey := '';
end;

function TExpiredStartMenu.GetExplain: string;
begin

end;

function TExpiredStartMenu.GetKeys: TStringList;
begin

end;

{ TStartProgram }

constructor TStartProgram.Create(m_RegKey: string);
begin
  inherited Create(m_RegKey);

  regKey := 'software\Microsoft\Windows\CurrentVersion\Run';
end;

function TStartProgram.GetExplain: string;
begin
  result := 'Missing AutoStart Program';
end;

function TStartProgram.GetKeys: TStringList;
begin
  result := TStringList.Create;
  Result.AddStrings(GetSomeKey(false));
  Result.AddStrings(GetSomeKey(true));
end;

{ TMissingHelp }

constructor TMissingHelp.Create(m_RegKey: string);
begin
  inherited Create(m_RegKey);
  regKey := 'software\Microsoft\Windows\Help';
end;

function TMissingHelp.GetExplain: string;
begin
  result := 'Misssing Help File';
end;

function TMissingHelp.GetKeys: TStringList;
  function GetMissingHelp(const reg1: string): TStringList;
  var
    reg: TRegistry;
    values: TStringList;
    i: integer;
    sItem: string;
    iLen: Integer;
  begin
    result := TStringList.Create;
    values := TStringList.Create;
    reg := TRegistry.Create;

    reg.RootKey := HKEY_LOCAL_MACHINE;

    if reg.OpenKey(reg1, false) then
    begin
      reg.GetValueNames(values);

      for i := 0 to values.Count - 1 do
      begin
        sItem := values.Strings[i];

        if Pos('Folder', sItem) = 0 then
        begin
          iLen := Length(sItem);
          if sItem[ilen] <> '\' then
            result.Add(reg.ReadString(values.Strings[i]) + '\' + sItem)
          else
            Result.Add(sItem + values.Strings[i]);
        end;
      end;
    end;
  end;
begin
  result := TStringList.Create;

  Result.AddStrings(GetMissingHelp(regKey));
  regKey := 'software\Microsoft\Windows\Html Help';
  Result.AddStrings(GetMissingHelp(regKey));
end;

end.
