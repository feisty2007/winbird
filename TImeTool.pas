unit TImeTool;

interface
uses
	Registry,Windows,SysUtils,Classes,Contnrs;

type
	TIme=class
  private
    Findex: integer;
    FLayoutText: string;
    Fkeycode: string;
    procedure Setindex(const Value: integer);
    procedure Setkeycode(const Value: string);
    procedure SetLayoutText(const Value: string);
  public
    property index:integer read Findex write Setindex;
    property keycode:string read Fkeycode write Setkeycode;
    property LayoutText:string read FLayoutText write SetLayoutText;
	end;

	TimeTools=class
  public
    function ReadImes:TObjectList;
    procedure WriteImeCfg(const imes:TObjectList);
	end;


implementation

{ TimeTools }

function TimeTools.ReadImes: TObjectList;
const
  preLoadKey='Keyboard Layout\Preload';
  imeKey='SYSTEM\CurrentControlSet\Control\Keyboard Layouts';

var
  ime:TStringList;
  imeName:TStringList;
  imeKeys:TStringList;
  reg:TRegistry;
  i:integer;
  _ime:TIme;

  function GetLayoutFromKey(const Key:string):string;
  var
    reg:TRegistry;
  begin
      result:='Unknow IME';
      reg:=TRegistry.Create;
      reg.RootKey:=HKEY_LOCAL_MACHINE;
      if reg.OpenKey(imeKey+'\'+Key,false) then
      begin
          result:=reg.ReadString('Layout Text');
      end;
  end;
begin { GetLayoutFromKey }
  result:=TObjectList.Create;
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CURRENT_USER;
  ime:=TStringList.Create;
  if reg.OpenKey(preLoadKey,false) then
  begin
    reg.GetValueNames(ime);
  end;

  reg.CloseKey;

  imeKeys:=TStringList.Create;

  if reg.OpenKey(preLoadKey,false) then
  begin
    for i :=0  to ime.Count-1 do
    begin
      imeKeys.Add(reg.ReadString(ime[i]));
    end;
  end;

  imeName:=TStringList.Create;


  for i := 0 to imeKeys.Count-1 do
  begin
    imeName.Add(GetLayoutFromKey(imeKeys[i]));
  end;

  for i :=0  to ime.Count-1 do
  begin
    _ime:=TIme.Create;
    _ime.index := i+1;
    _ime.keycode := imeKeys[i];
    _ime.LayoutText := imeName[i];
    Result.Add(_ime);
  end;
end;

procedure TimeTools.WriteImeCfg(const imes: TObjectList);
const
  preLoadKey='Keyboard Layout\Preload';
var
  i:Integer;
  reg:TRegistry;
  _ime:TIme;
begin
  reg:=TRegistry.Create;

  if reg.OpenKey(preLoadKey,false) then
  begin
    for i := 0 to imes.Count-1 do
    begin
       _ime:=imes[i] as TIme;

       reg.WriteString(IntToStr(i+1),_ime.keycode);
    end;
  end;

  reg.CloseKey;

  reg.free;
end;

{ TIme }

procedure TIme.Setindex(const Value: integer);
begin
  Findex := Value;
end;

procedure TIme.Setkeycode(const Value: string);
begin
  Fkeycode := Value;
end;

procedure TIme.SetLayoutText(const Value: string);
begin
  FLayoutText := Value;
end;

end.