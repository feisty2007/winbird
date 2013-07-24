unit MDNowFlder;

interface

uses
  IExeInf,SysUtils,Forms;
  
type
  MakeTodayFolder=class(TInterfacedObject,IExeInterface)
  public
     function GetDescription:string;
     function GetParam:string;
     procedure Execute(folder:string);
  private
     function GetToday:string;
  end;

implementation
var
  MTF:MakeTodayFolder;

{ MakeTodayFolder }

procedure MakeTodayFolder.Execute(folder: string);
var
  curF:string;
begin
  curF:=GetCurrentDir;
  SetCurrentDir(folder);
  mkdir(GetToday);
  SetCurrentDir(curF);
end;

function MakeTodayFolder.GetDescription: string;
begin
   result:='建立以今天为名称的文件夹';
end;

function MakeTodayFolder.GetParam: string;
begin
  result:='MDNowFolder';
end;

function MakeTodayFolder.GetToday: string;
var
  day,month,year:word;
  function LessThanTen(i:integer):string;
  begin
      if i<10 then
          result:='0'+IntToStr(i)
      else
          result:=IntToStr(i);
  end;
begin
  DecodeDate(now,year,month,day);
  result:=IntToStr(Year)+LessThanTen(month)+LessThanTen(day);
end;

initialization
    MTF:=MakeTodayFolder.Create;
    RegisterExeInf(MTF as IExeInterface);
end.
