unit IDosCmd;

interface
uses
    IExeInf,ShellApi,Windows,SysUtils;
type

    DosCmd=class(TInterfacedObject,IExeInterface)
    public
      function GetDescription:string;
      function GetParam:string;
      procedure Execute(folder:string);
    end;

implementation

{ DosCmd }
var
  DS:DosCmd;

procedure DosCmd.Execute(folder: string);
begin
  ShellExecute(0,'open','cmd.exe',PChar('/k cd '+folder),PChar(GetCurrentDir),SW_SHOW);
end;

function DosCmd.GetDescription: string;
begin
  result:='我的Dos快速通道';
end;

function DosCmd.GetParam: string;
begin
  result:='Dos快速通道';
end;

initialization
    DS:=DosCmd.Create;
    RegisterExeInf(DS as IExeInterface);
end.
 