unit edtOption;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TfrmOptions = class(TForm)
    pgc1: TPageControl;
    ts_FileAttribute: TTabSheet;
    grp_InCludefileInfo: TGroupBox;
    chk_FileName: TCheckBox;
    chk_FileTypeName: TCheckBox;
    chk_FileSize: TCheckBox;
    chk_FileTime: TCheckBox;
    grp_FileTime: TGroupBox;
    chk_ftCreate: TCheckBox;
    chk_ftModify: TCheckBox;
    chk_ftLastAccess: TCheckBox;
    chk_FileAttribute: TCheckBox;
    btn_OK: TBitBtn;
    btn_Cancel: TBitBtn;
    ts_Main: TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

end.
