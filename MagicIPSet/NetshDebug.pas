unit NetshDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls,ShellAPI, ExtCtrls,UpdateThread;

type
  TfrmNetsh = class(TForm)
    mmo_Netsh: TMemo;
    lbl_ApplyChange: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FAppParams: string;
    FAppName: string;
    FChangeIEHomePage: Boolean;
    FChangeDefaultPrinter: Boolean;
    FIEHomePage: string;
    FDefaultPrinterName: string;
    procedure SetAppName(const Value: string);
    procedure SetAppParams(const Value: string);
    procedure SetChangeDefaultPrinter(const Value: Boolean);
    procedure SetChangeIEHomePage(const Value: Boolean);
    procedure SetDefaultPrinterName(const Value: string);
    procedure SetIEHomePage(const Value: string);
  private
    { Private declarations }

  public
    { Public declarations }
    property AppName:string read FAppName write SetAppName;
    property AppParams:string read FAppParams write SetAppParams;
    property ChangeIEHomePage:Boolean read FChangeIEHomePage write SetChangeIEHomePage;
    property IEHomePage:string read FIEHomePage write SetIEHomePage;

    property ChangeDefaultPrinter:Boolean read FChangeDefaultPrinter write SetChangeDefaultPrinter;
    property DefaultPrinterName:string read FDefaultPrinterName write SetDefaultPrinterName;
    function ExeAppAndWait(AppName, Parameters: string): Boolean;

    procedure CloseForm(sender:TObject);
  end;

var
  frmNetsh: TfrmNetsh;

implementation

{$R *.dfm}

{ TfrmNetsh }

function TfrmNetsh.ExeAppAndWait(AppName, Parameters: string): Boolean;
var
  ShellExInfo: TShellExecuteInfo;
begin
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0);
  with ShellExInfo do begin
    cbSize := SizeOf(ShellExInfo);
    fMask := see_Mask_NoCloseProcess;
    Wnd := Application.Handle;
    lpFile := PChar(AppName);
    lpParameters := PChar(Parameters);
    nShow := sw_ShowNormal;
  end;
  Result := ShellExecuteEx(@ShellExInfo);
  if Result then
    while WaitForSingleObject(ShellExInfo.HProcess,INFINITE) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Break;
    end;
end;


procedure TfrmNetsh.SetAppName(const Value: string);
begin
  FAppName := Value;
end;

procedure TfrmNetsh.SetAppParams(const Value: string);
begin
  FAppParams := Value;
end;

procedure TfrmNetsh.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfrmNetsh.FormShow(Sender: TObject);
var
  ut:TUpdateIPThread;
begin
  ut:=TUpdateIPThread.Create(FAppName,FAppParams);
  ut.ChangeIEHomePage:=FChangeIEHomePage;

  if FChangeIEHomePage then
    ut.IEHomePage:=FIEHomePage;

  ut.ChangeDefaultPrinter:=FChangeDefaultPrinter;
  if FChangeDefaultPrinter then
    ut.DefaultPrinterName:=FDefaultPrinterName;
  ut.OnTerminate:=CloseForm;
end;

procedure TfrmNetsh.CloseForm(sender: TObject);
begin
  Close;
end;

procedure TfrmNetsh.SetChangeDefaultPrinter(const Value: Boolean);
begin
  FChangeDefaultPrinter := Value;
end;

procedure TfrmNetsh.SetChangeIEHomePage(const Value: Boolean);
begin
  FChangeIEHomePage := Value;
end;

procedure TfrmNetsh.SetDefaultPrinterName(const Value: string);
begin
  FDefaultPrinterName := Value;
end;

procedure TfrmNetsh.SetIEHomePage(const Value: string);
begin
  FIEHomePage := Value;
end;

end.

