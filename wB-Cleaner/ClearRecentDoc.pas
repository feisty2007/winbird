unit ClearRecentDoc;

interface
uses
  Registry, Windows, SysUtils, Classes;

type
  TClearRecentDoc = class
  public
    procedure Clear;
  end;

  TWindowsApplets = class
  public
    procedure ClearPaint;
    procedure ClearWordPad;
    function ClearApplet(const iType: Integer): Boolean;

    procedure ClearByName(const sName: string);
  end;

  TWinzip = class
  public
    procedure Clear;
  end;

implementation

uses gUtil, Winrar;

{ TClearRecentDoc }

procedure TClearRecentDoc.Clear;
var
  tcu: TCurrentDocClearner;
begin
  tcu := TCurrentDocClearner.Create;
  tcu.Clear;
  tcu.Free;
end;

{ TWindowsAppltet }

function TWindowsApplets.ClearApplet(const iType: Integer): Boolean;
var
  reg: TRegistry;
  AppString: string;
  regKey: string;
begin
  case iType of
    1:
      AppString := 'Paint';
    2:
      AppString := 'Wordpad';
  else
    AppString := 'Unknow';
    exit;
  end;

  regKey := 'software\Microsoft\Windows\CurrentVersion\Applets\' + AppString + '\Recent File List';
  RegeditHelper.RemoveAllValues(regKey);
  Result := true;
end;

procedure TWindowsApplets.ClearByName(const sName: string);
begin
  if sName = 'Paint' then
    ClearPaint;

  if sName = 'Wordpad' then
    ClearWordPad;
end;

procedure TWindowsApplets.ClearPaint;
begin
  ClearApplet(1);
end;

procedure TWindowsApplets.ClearWordPad;
begin
  ClearApplet(2);
end;

{ TWinzip }

procedure TWinzip.Clear;
const
  regkey = 'Software\Nico Mak Computing\WinZip\filemenu';
begin
  RegeditHelper.RemoveAllValues(regkey);
end;

end.
