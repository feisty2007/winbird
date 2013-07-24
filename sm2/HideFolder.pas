unit HideFolder;

interface

uses IExeInf,Registry,Windows,SysUtils,Messages,ShlObj;

type
  THideShowHiddenFolder=class(TinterfacedObject,IExeInterface)
  public
     function GetDescription:string;
     function GetParam:string;
     procedure Execute(folder:string);
  end;

implementation

var
  ih:THideShowHiddenFolder;


{ THideShowHiddenFolder }

procedure THideShowHiddenFolder.Execute(folder:string);
const
  REGKEY='SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced';
  HIDDEN_KEYVALUE='Hidden';
  SHIDDEN_KEYVALUE='ShowSuperHidden';
var
  //reg1:TRegistry;
  bIsHidden:Boolean;

  function IsNowShowHide:Boolean;
  var
    reg2:TRegistry;
    regValue:Integer;
  begin
    Result := True;
    reg2 := TRegistry.Create;
    try
      //reg2.RootKey := HKEY_LOCAL_MACHINE;

      if reg2.OpenKeyReadOnly(REGKEY) then
      begin
        if reg2.ValueExists(HIDDEN_KEYVALUE) then
        begin
          regValue:=reg2.ReadInteger(HIDDEN_KEYVALUE);

          if regValue=1 then Result:=False;
        end;
      end;
    finally
      reg2.Free;
    end;  // try
  end;

  procedure MakeHidden(isHide:Boolean);
  var
    regx:TRegistry;
  begin
    regX:=TRegistry.Create;
    try
      //regx.RootKey := HKEY_LOCAL_MACHINE;

      if regx.OpenKey(REGKEY,True) then
      begin
        if not isHide then
        begin
          regx.WriteInteger(HIDDEN_KEYVALUE,1);
          //regx.WriteInteger(SHIDDEN_KEYVALUE,1);
        end
        else
        begin
          regx.WriteInteger(HIDDEN_KEYVALUE,2);
          //regx.WriteInteger(SHIDDEN_KEYVALUE,0);
        end;
      end;
    finally
      regx.Free;
    end;
  end;
begin
  bIsHidden:=IsNowShowHide;
  //MessageBox(0,PChar('Hide-'+booltostr(bIsHidden)),'',MB_OK);
  if bIsHidden then MakeHidden(false) else MakeHidden(True);
  //SendMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,Pointer(PChar(REGKEY)));
  //PostMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,0)
  //SHChangeNotify(SHCNE_ASSOCCHANGED,   SHCNF_FLUSHNOWAIT,   nil,   NiL);
  //PostMessage(FindWindow('Progman', nil), WM_KEYDOWN, VK_F5, 3);
  PostMessage(GetActiveWindow, WM_KEYDOWN, VK_F5, 3);
  PostMessage(GetActiveWindow, WM_KEYUP, VK_F5, 3);
  //SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

function THideShowHiddenFolder.GetDescription: string;
begin
  Result :='ÇÐ»»ÏÔÊ¾Òþ²ØÎÄ¼þ¼Ð';
end;

function THideShowHiddenFolder.GetParam: string;
begin
  Result :='ÇÐ»»ÏÔÊ¾Òþ²ØÎÄ¼þ¼Ð';
end;

initialization
  ih:=THideShowHiddenFolder.Create;
  RegisterExeInf(ih as IExeInterface);
end.
