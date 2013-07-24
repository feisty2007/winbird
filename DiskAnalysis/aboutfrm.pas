unit aboutfrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ShellAPI;

type
  TOKBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    lbl_Mail: TLabel;
    procedure lbl_MailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKBottomDlg: TOKBottomDlg;

implementation

{$R *.dfm}

procedure TOKBottomDlg.lbl_MailClick(Sender: TObject);
begin
  ShellExecute(handle,'open',PChar('mailto:'+lbl_Mail.Caption),nil,nil,SW_SHOWNORMAL);
end;

end.
