unit ProcessMapper;

interface

uses Windows;

procedure ProcessCreateSnapshot;
procedure ProcessDeleteSnapshot;
function ProcessPIDToProcessName (PID: DWord): String;
function GetExeFileName(processID:Cardinal):string;

implementation

uses SysUtils, TLHelp32 , PsAPI;

var
    ProcessSnapshot: THandle;

procedure ProcessCreateSnapshot;
begin
    // If we've already got a snapshot, ditch it
    if ProcessSnapShot <> 0 then ProcessDeleteSnapshot;
    ProcessSnapshot := CreateToolhelp32Snapshot (TH32CS_SnapProcess, 0);
end;

procedure ProcessDeleteSnapshot;
begin
    if ProcessSnapShot <> 0 then CloseHandle (ProcessSnapShot);
    ProcessSnapShot := 0;
end;

function ProcessPIDToProcessName (PID: DWord): String;
var
    OK: Boolean;
    ProcEntry: TProcessEntry32;
begin
    if ProcessSnapShot = 0 then Result := IntToStr (PID) else begin
        Result := '-unknown-';
        Ok := Process32First (ProcessSnapShot, ProcEntry);
        while Ok do begin
            if ProcEntry.th32ProcessID = PID then begin
                Result := ProcEntry.szExeFile;
                Exit;
            end;

            Ok := Process32Next (ProcessSnapShot, ProcEntry);
        end;
    end;
end;
function GetExeFileName(processID:Cardinal):string;
var
  hSnapshot:Thandle;
  me:TModuleEntry32;
  path:array[0..MAX_PATH-1] of char;
  hProcess:THandle;
begin
    //SetLength(filename,MAX_PATH+1);
    hProcess:=OpenProcess(PROCESS_QUERY_INFORMATION + PROCESS_VM_READ,
    false,
    processID);

    GetModuleFileNameEx(hProcess,0,path,MAX_PATH-1);

    if path[0]<>'?' then
      result:=path
    else
      result:='';
end;
initialization
    ProcessSnapShot := 0;
finalization
    ProcessDeleteSnapshot;
end.