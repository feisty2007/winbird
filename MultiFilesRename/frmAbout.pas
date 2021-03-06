unit frmAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ShellAPI;

type
  TOKBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    lbl_Version: TLabel;
    lbl_MailLink: TLabel;
    procedure lbl_MailLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKBottomDlg: TOKBottomDlg;

implementation

{$R *.dfm}

procedure TOKBottomDlg.lbl_MailLinkClick(Sender: TObject);
var
  mail:String;
begin
  mail := lbl_MailLink.Caption;

  ShellExecute(0,'open',PChar('mailto:'+mail),nil,nil,SW_SHOWNORMAL);
end;

end.
