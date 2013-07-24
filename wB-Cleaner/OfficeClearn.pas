unit OfficeClearn;

interface

uses
  Registry, Classes, SysUtils;

type
  TOffice2007Cleaner = class
  private
    procedure CleanHistory(const iApp: Integer);
  public
    procedure ClearWord;
    procedure ClearExcel;
    procedure ClearPowerPoint;
  end;

  TWpsOffice2005Cleaner = class
    procedure CleanHistory(const iApp: Integer);
  end;

implementation

{ TOffice2007Cleaner }

procedure TOffice2007Cleaner.CleanHistory(const iApp: Integer);
var
  reg: TRegistry;
  AppString: string;
  Values: TStringList;
  i: integer;
begin
  Values := TStringList.Create;
  case iApp of
    1:
      AppString := 'Word';
    2:
      AppString := 'Excel';
    3:
      AppString := 'PowerPoint';
  else
    AppString := 'Unknow';
    exit;
  end;

  reg := TRegistry.Create;
  try
    if reg.OpenKey('software\Microsoft\Office\12.0\' + AppString + '\File MRU', False) then
    begin
      reg.GetValueNames(Values);

      for i := 0 to Values.Count - 1 do
      begin
        reg.DeleteValue(Values.Strings[i]);
      end;
    end;

    reg.CloseKey;
  finally
    reg.Free;
    Values.Free;
  end;
end;

procedure TOffice2007Cleaner.ClearExcel;
begin
  CleanHistory(2);
end;

procedure TOffice2007Cleaner.ClearPowerPoint;
begin
  CleanHistory(3);
end;

procedure TOffice2007Cleaner.ClearWord;
begin
  CleanHistory(1);
end;

{ TWpsOffice2005Cleaner }

procedure TWpsOffice2005Cleaner.CleanHistory(const iApp: Integer);
const
  regkey = 'Software\Kingsoft\Office\6.0\wps\RecentFiles\files';
var
  reg: TRegistry;
  keys: TStringList;
  i: integer;
begin
  reg := TRegistry.Create;
  keys := TStringList.Create;
  try
    if reg.OpenKey(regkey, false) then
    begin
      reg.GetKeyNames(keys);

      for i := 0 to keys.Count - 1 do
      begin
        reg.DeleteKey(keys[i]);
      end;
    end;
  finally
    reg.Free;
  end;
end;

end.
