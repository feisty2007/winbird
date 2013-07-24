unit main;

interface



uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    shp_CapsLock: TShape;
    shp_NumLock: TShape;
    lbl_CapsLock: TLabel;
    lbl_NumLock: TLabel;
    tmr_CHK: TTimer;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr_CHKTimer(Sender: TObject);
  private
    { Private declarations }
    procedure CheckState(sp:TShape;checked:Boolean);
    procedure GetState;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  K_CAPSLOCK = $14;
  K_NUMLOCK = $90;
  K_SCRLOCK = $91;
implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  GetState;
end;

procedure TForm1.CheckState(sp: TShape; checked: Boolean);
begin
  if not checked then
  begin
    sp.Brush.Color := clWhite;
  end
  else
  begin
    sp.Brush.Color := clGreen;
  end;
end;

procedure TForm1.GetState;
var
  isNum:Boolean;
  ks:TKeyboardState;
begin
  isNum := GetKeyboardState(KS);
  CheckState(shp_CapsLock,ks[K_CAPSLOCK]=1);
  CheckState(shp_NumLock,ks[K_NUMLOCK]=1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GetState;
end;

procedure TForm1.tmr_CHKTimer(Sender: TObject);
begin
  GetState;
end;

end.
