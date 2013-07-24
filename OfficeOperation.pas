unit OfficeOperation;

interface
uses
  ComObj, Windows, Classes, SysUtils, Dialogs;
type

  OfficePrinter = interface
    ['{499C13F4-40EB-4D34-A62A-D7A37652F4FB}']
    procedure PrintFile(filename: string);
  end;
  TWordPrinter = class(TInterfacedObject, OfficePrinter)
    procedure PrintFiles(files: TStrings);
    procedure PrintFile(filename: string);
  end;

  TExcelPrinter = class(TInterfacedObject, OfficePrinter)
    procedure PrintFiles(files: TStrings);
    procedure PrintFile(filename: string);
  end;

  TPdfPrinter = class(TInterfacedObject, OfficePrinter)
    procedure PrintFiles(files: TStrings);
    procedure PrintFile(filename: string);
  end;

implementation

{ WordPrinter }

procedure TWordPrinter.PrintFile(filename: string);
var
  wordApp, wordDoc: OleVariant;
begin
  try
    wordApp := GetActiveOleObject('Word.Application');
  except
    on e: EOleError do
    begin
      try
        wordApp := CreateOleObject('Word.Application');
      except
        on e: EOleError do
        begin
          ShowMessage('Word is not Installed!');
        end;
      end;
    end;
  end;

  wordApp.visible := true;
  worddoc := wordApp.Documents.Open(filename);
  worddoc.PrintOut;
  wordDoc.close;
end;

procedure TWordPrinter.PrintFiles(files: TStrings);
var
  i: integer;
begin
  for i := 0 to files.Count - 1 do
  begin
    PrintFile(files[i]);
  end;
end;

procedure TExcelPrinter.PrintFile(filename: string);
var
  excelApp, excelWorkbook, excelSheet: OleVariant;
begin
  try
    excelApp := GetActiveOleObject('Excel.Application');
  except
    on e: EOleError do
    begin
      try
        excelApp := CreateOleObject('Excel.Application');
      except
        on ex: EOleError do
        begin
          ShowMessage('Check you software! make sure excel is installed');
          exit;
        end;
      end;
    end;
  end;

  excelApp.Visible := true;
  excelWorkBook := excelApp.Workbooks.open(filename);
  excelSheet := excelworkbook.sheets[1];
  excelSheet.PrintOut;
end;

procedure TExcelPrinter.PrintFiles(files: TStrings);
var
  i: integer;
begin
  for i := 0 to files.Count - 1 do
  begin
    PrintFile(files[i]);
  end;
end;
{ TPdfPrinter }

procedure TPdfPrinter.PrintFiles(files: TStrings);
var
  i: integer;
begin
  for i := 0 to files.Count - 1 do
  begin
    PrintFile(files[i]);
  end;
end;


procedure TPdfPrinter.PrintFile(filename: string);
var
  AcroApp, AVDoc, PDDoc: olevariant;
  PageNum: integer;
begin
  try
    AcroApp := CreateOleObject('AcroExch.App');
    AcroApp.show;
    AVDoc := CreateOleObject('AcroExch.AVDoc');
    PDDoc := CreateOleObject('AcroExch.PDDoc');

    AVDoc.Open(filename, 'PDF title');
    AVDoc := AcroApp.GetActiveDoc;
    PDDoc := AVDoc.GetPDDoc;

    AcroApp.Show; //AcroApp.Hide;
    PageNum := PDDoc.GetNumPages;

    AVDoc.PrintPagesSilent(0, PageNum, 0, 0, 0);

      //showmessage('ok');
  except
    on e: Exception do
      ShowMessage(e.Message);
      //PDDoc.Close;
      //AcroApp.Exit;
  end;
end;

end.
