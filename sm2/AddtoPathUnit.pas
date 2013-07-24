unit AddtoPathUnit;

interface

uses
  IExeInf,SysUtils,Forms,Windows,Dialogs,Registry,Messages;
  
type
  AddToPath=class(TInterfacedObject,IExeInterface)
  public
     function GetDescription:string;
     function GetParam:string;
     procedure Execute(folder:string);
  end;

implementation
var
  AP:AddToPath;

{ AddToPath }

procedure AddToPath.Execute(folder: string);
const
  SessionKey='\System\CurrentControlSet\Control\Session Manager\Environment';
var
  strPath:string;
  reg:TRegistry;
begin
  strPath:=GetEnvironmentVariable('Path');
  strPath:=strPath+';'+folder;

  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;

    if reg.OpenKey(SessionKey,false) then
    begin
      reg.WriteExpandString('Path',strPath);
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

  SendMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,0);
  MessageBox(0,'已经更改设置，可能需要重新启动才能生效!','特别提示',MB_OK OR MB_ICONINFORMATION);
end;

function AddToPath.GetDescription: string;
begin
  result:='添加到全局路径';
end;

function AddToPath.GetParam: string;
begin
  result:='AppendToPath';
end;

initialization
    AP:=AddtoPath.Create;
    RegisterExeInf(AP as IExeInterface);
end.
 