unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls, Registry, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    procedure ShowSucMsg;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

const
     Outlook_Key = 'software\microsoft\office\12.0\outlook\security';
     SucMessage = 'Save Config Success! Restart Outllok';
{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
   reg:TRegistry;
begin
   reg := TRegistry.Create;
   try
      if reg.OpenKey(Outlook_Key,true) then
      begin
           reg.WriteString('level1remove','.exe;.com');
           reg.CloseKey;
      end;
   finally
      reg.Free;
   end;
   
   ShowSucMsg;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   reg:TRegistry;
begin

   reg := TRegistry.Create;
   try
      if reg.OpenKey(Outlook_Key,true) then
      begin
           reg.DeleteValue('level1remove');
           reg.CloseKey;
      end;
   finally
      reg.Free;
   end;

   ShowSucMsg;
end;

procedure TForm1.ShowSucMsg;
begin
  MessageBox(Handle,SucMessage,PChar('Message'),MB_OK + MB_ICONINFORMATION);
end;

initialization
  {$I main.lrs}

end.

