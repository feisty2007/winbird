unit UpdateThread;

interface

uses
  Classes,ShellAPI,Forms,Windows,Registry,WinSpool;

type
  TUpdateIPThread = class(TThread)
  private
    FAppName: string;
    FParams: string;
    FChangeIEHomePage: Boolean;
    FChangeDefaultPrinter: Boolean;
    FDefaultPrinterName: string;
    FIEHomePage: string;
    procedure SetAppName(const Value: string);
    procedure SetParams(const Value: string);
    procedure SetChangeDefaultPrinter(const Value: Boolean);
    procedure SetChangeIEHomePage(const Value: Boolean);
    procedure SetDefaultPrinterName(const Value: string);
    procedure SetIEHomePage(const Value: string);
    procedure WriteIEHomePage(strHome:string);
    procedure WriteDefaultPrinter(const PrinterName:string);
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(AppName,Params:string);
  published
    property AppName:string read FAppName write SetAppName;
    property Params:string read FParams write SetParams;
    property ChangeIEHomePage:Boolean read FChangeIEHomePage write SetChangeIEHomePage;
    property IEHomePage:string read FIEHomePage write SetIEHomePage;

    property ChangeDefaultPrinter:Boolean read FChangeDefaultPrinter write SetChangeDefaultPrinter;
    property DefaultPrinterName:string read FDefaultPrinterName write SetDefaultPrinterName;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TUpdateIPThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TUpdateIPThread }

constructor TUpdateIPThread.Create(AppName, Params: string);
begin
  inherited Create(False);
  FAppName:=AppName;
  FParams:=Params;

  FreeOnTerminate:=true;
end;

procedure TUpdateIPThread.Execute;
var
  ShellExInfo: TShellExecuteInfo;
  iResult:LongBool;
begin
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0);
  with ShellExInfo do begin
    cbSize := SizeOf(ShellExInfo);
    fMask := see_Mask_NoCloseProcess;
    Wnd := Application.Handle;
    lpVerb:='open';
    lpFile := PChar(FAppName);
    lpParameters := PChar(FParams);
    nShow := SW_HIDE;
  end;
  iResult := ShellExecuteEx(@ShellExInfo);
  if iResult then
    WaitForSingleObject(ShellExInfo.hProcess,INFINITE);

  if FChangeIEHomePage then
    WriteIEHomePage(FIEHomePage);

  if FChangeDefaultPrinter then
    WriteDefaultPrinter(FDefaultPrinterName);
//    while WaitForSingleObject(ShellExInfo.HProcess,INFINITE) = WAIT_TIMEOUT do
//    begin
//      Application.ProcessMessages;
//      if Application.Terminated then Break;
//    end;

end;

procedure TUpdateIPThread.SetAppName(const Value: string);
begin
  FAppName := Value;
end;

procedure TUpdateIPThread.SetChangeDefaultPrinter(const Value: Boolean);
begin
  FChangeDefaultPrinter := Value;
end;

procedure TUpdateIPThread.SetChangeIEHomePage(const Value: Boolean);
begin
  FChangeIEHomePage := Value;
end;

procedure TUpdateIPThread.SetDefaultPrinterName(const Value: string);
begin
  FDefaultPrinterName := Value;
end;

procedure TUpdateIPThread.SetIEHomePage(const Value: string);
begin
  FIEHomePage := Value;
end;

procedure TUpdateIPThread.SetParams(const Value: string);
begin
  FParams := Value;
end;

procedure TUpdateIPThread.WriteDefaultPrinter(const PrinterName: string);
begin
  SetDefaultPrinterName(PrinterName);
end;

procedure TUpdateIPThread.WriteIEHomePage(strHome: string);
const
  regKey='software\Microsoft\Internet Explorer\Main';
  homeKey='Start Page';
var
  reg:TRegistry;
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(regKey,false) then
      reg.WriteString(homeKey,strHome);
  finally
    reg.Free;
  end;  // try    
end;

end.
