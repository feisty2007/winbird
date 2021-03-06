unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Registry, Buttons,ShellApi;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RegisterRight;
  end;

var
  Form1: TForm1;



implementation

uses IExeInf;

{$R *.dfm}

{ TForm1 }

procedure TForm1.RegisterRight;
const
  REGKEY='Folder\Shell';
var
  i:integer;
  ie:IExeInterface;
  reg:TRegistry;
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;

  for i := 0 to exeList.Count-1 do
  begin
      ie:=IExeInterface(exeList.items[i]);

      if reg.OpenKey(REGKEY+'\'+ie.GetParam,true) then
      begin
         reg.WriteString('',ie.GetDescription);
         reg.CloseKey;
         reg.OpenKey(REGKEY+'\'+ie.GetParam+'\command',true);
         reg.WriteString('',Application.ExeName+' -'+ie.GetParam+' %1');
         reg.CloseKey;
      end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterRight;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'open','mailto:camark@sohu.com','','',SW_SHOW);
end;

end.
