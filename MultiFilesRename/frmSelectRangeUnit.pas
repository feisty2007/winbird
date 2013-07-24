unit frmSelectRangeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmSelectRange = class(TForm)
    btn_OK: TBitBtn;
    btn_Cancel: TBitBtn;
    edt_SelTxt: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectRange: TfrmSelectRange;

implementation

{$R *.dfm}

procedure TfrmSelectRange.FormShow(Sender: TObject);
begin
  FocusControl(edt_SelTxt);
  edt_SelTxt.SelectAll;
end;

end.
