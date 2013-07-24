unit fileUtil;

interface
uses
  SysUtils, Classes;

type
  TFileUtil = class
  public
    class function GetRealName(str: string): string;
    class function GetLastName(str: string): string;
  end;
implementation

{ TFileUtil }

class function TFileUtil.GetLastName(str: string): string;
var
  strings: TStringList;
begin
  strings := TStringList.Create;

  ExtractStrings(['_'], [], PChar(str), strings);

  result := strings[strings.count - 1];
end;

class function TFileUtil.GetRealName(str: string): string;
var
  strings: TStringList;
begin
  strings := TStringList.Create;

  ExtractStrings(['_'], [], PChar(str), strings);

  if strings.Count = 3 then
    Result := strings[1] + '_' + strings[2]
  else
    Result := strings[0] + strings[1];

end;

end.
