unit FormBatchConvert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TBatchConvert = class(TForm)
    grp1: TGroupBox;
    lst_MP3Files: TListBox;
    btnSelect: TButton;
    lbl_Ready: TLabel;
    pb_Convert: TProgressBar;
    dlgOpen1: TOpenDialog;
    btn_Start: TButton;
    procedure btnSelectClick(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BatchConvert: TBatchConvert;

implementation

uses ConvertThread;

{$R *.dfm}

procedure TBatchConvert.btnSelectClick(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    lst_MP3Files.Clear;
    lst_MP3Files.Items.AddStrings(dlgOpen1.Files);
  end;
end;

procedure TBatchConvert.btn_StartClick(Sender: TObject);
var
  tc: ConvertFileThread;
begin
  tc := ConvertFileThread.Create(lst_MP3Files.Items, lbl_Ready, pb_Convert);
end;

end.
