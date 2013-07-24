unit ConvertYongzheng;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    lv_Files: TListView;
    btn_SelectFiles: TButton;
    dlgOpenMp3: TOpenDialog;
    btn_Change: TButton;
    btn_Apply: TButton;
    procedure btn_SelectFilesClick(Sender: TObject);
    procedure btn_ChangeClick(Sender: TObject);
    procedure btn_ApplyClick(Sender: TObject);
  private
    { Private declarations }
    function ExtractTitle(fn:string):string;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses ID3v2;

{$R *.dfm}

procedure TForm3.btn_SelectFilesClick(Sender: TObject);
var
  id3:TID3v2;
  i:integer;

begin
  if dlgOpenMp3.Execute then
  begin
    id3 := TID3v2.Create;
    for i := 0 to dlgOpenMp3.Files.Count-1 do
    begin
      id3.ReadFromFile(dlgOpenMp3.Files[i]);

      with lv_Files.Items.Add do
      begin
        Caption:=dlgOpenMp3.Files[i];
        SubItems.Add(id3.Title);
        SubItems.Add(id3.Artist);
        SubItems.Add(id3.Album);
        SubItems.Add(id3.Comment);
        SubItems.Add(id3.Year);
      end;  
    end;
  end;  
end;

procedure TForm3.btn_ChangeClick(Sender: TObject);
var
  i:Integer;
  fn:string;
begin
  for i := 0 to lv_Files.Items.Count-1 do
  begin
      with lv_Files.Items[i] do
      begin
        fn:=ExtractTitle(Caption);
        SubItems[0]:=fn;
      end;
  end;
end;

procedure TForm3.btn_ApplyClick(Sender: TObject);
var
  i:integer;
  id3:TID3v2;
begin
  id3 := TID3v2.Create;
  for i:=0 to lv_Files.Items.Count-1 do
  begin
    with lv_Files.Items[i] do
    begin
      id3.ReadFromFile(Caption);
      id3.Title:=ExtractTitle(Caption);
      id3.SaveToFile(Caption);
    end;
  end;
end;

function TForm3.ExtractTitle(fn: string): string;
var
    rfn:string;
begin
    rfn:=ExtractFileName(fn);

    Result:=Copy(rfn,0,Length(rfn)-length(ExtractFileExt(rfn)));
end;

end.
