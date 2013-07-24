unit IExeInf;

interface

uses
   classes;
type
    IExeInterface=interface
    ['{505C8811-F199-4FD2-8C16-2AD21F4DD948}']
      function GetDescription:string;
      function GetParam:string;
      procedure Execute(folder:string);
    end;

    procedure RegisterExeInf(IE:IExeInterface);
    function GetExeInf(strName:string):IExeInterface;
var
    ExeList:TInterfaceList;
implementation

procedure RegisterExeInf(IE:IExeInterface);
begin
    ExeList.Add(IE);
end;

function GetExeInf(strName:string):IExeInterface;
var
  i:integer;
  ie:IExeInterface;
  temp:string;
begin
  for i :=0  to ExeList.Count-1 do
  begin
     ie:=IExeInterface(ExeList.Items[i]);
     temp:='-'+ie.GetParam;
     if temp=strName then
     begin
         result:=ie;
         exit;
     end;
  end;

  result:=nil;
end;

initialization
    ExeList:=TInterfaceList.Create;
finalization
    ExeList.Destroy;
end.



 