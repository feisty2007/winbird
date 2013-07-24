unit Main; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IniFiles, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edt_thunder_dir: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    procedure DeleteResource(thunder_dir: string);
    procedure NoAD(thunder_dir: string);
    procedure NoP4PDll(thunder_dir: string);
    procedure NoStoreData(thunder_dir : string);
    procedure tryDeleteFile(fileName: string);
    procedure tryMakeDir(ParentDir,Dir: string);
    procedure LogMsg(str:string);
  public
    { public declarations }
  end; 
  
  function GetSystemDir:string;

var
  Form1: TForm1; 

implementation

{ TForm1 }

const
     g_thunder_dir = 'C:\Program Files (x86)\Thunder Network\Thunder';
     
function GetSystemDir:string;
var
  buf:array[0..145]   of   char;
  sDir:pchar;
begin
  sDir:=@buf[0];
  GetSystemDirectory(sDir,144);
  Result:=StrPas(sDir);
end;
     
procedure TForm1.Button1Click(Sender: TObject);
var
   thunder_dir : string;
begin
  if OpenDialog1.Execute then
  begin
       //if LowerCase(OpenDialog1.FileName) = 'thunder.exe' then
       //begin
            edt_thunder_dir.Text := ExtractFilePath(OpenDialog1.FileName);
       //end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   sDir : string;
begin

   if edt_thunder_dir.Text = '' then
   begin
        ShowMessage('You must Select Thunder Install Directory first!');
        exit;
   end;
   if edt_thunder_dir.Text <> '' then
   begin
        if not fileExists(edt_thunder_dir.Text+'\Thunder.exe') then
        begin
             ShowMessage('Thunder.exe is not exist in Select Dir!,Choose Another Directory');
             exit;
        end;
   end;
   
   sDir := edt_thunder_dir.Text;
      
   Memo1.Lines.Clear;
   
   LogMsg('Delete Resource Bar');
   DeleteResource(sDir);
   
   LogMsg('Delete Ad Files');
   NoAD(sDir);
   
   LogMsg('Delete P4P Files');
   NoP4PDll(sDir);
   
   LogMsg('Stop Auto Upload');
   NoStoreData(sDir);
   
   ShowMessage('Clear OK. Start Thunder to see the Effect!');
end;

procedure TForm1.DeleteResource(thunder_dir: string);
var
   userCfg_Ini: TIniFile;
   fileName: string;
begin
   fileName := thunder_dir + '\Profiles\UserConfig.ini';
   
   try
      userCfg_Ini := TIniFile.Create(fileName);
      userCfg_Ini.WriteBool('Splitter_1','Pane1_Hide',True);
   finally
      userCfg_Ini.Destroy;
   end;
end;

procedure TForm1.NoAD(thunder_dir: string);
var
   guiCfg_Ini:TIniFile;
   fileName: string;
   AdDir:string;
   sr:TSearchRec;
begin
   fileName := thunder_dir + '\Program\gui.cfg';
   
   try
     guiCfg_Ini := TIniFile.Create(fileName);
     
     guiCfg_Ini.WriteString('URL','ADServer',' ');
     guiCfg_Ini.WriteString('URL','PVServer',' ');
     guiCfg_Ini.WriteString('URL','ADCountingServer',' ');
     guiCfg_Ini.WriteString('URL','HomePage',' ');
   finally
     guiCfg_Ini.Destroy;
   end;
   
   AdDir := thunder_dir + '\Program\Ad';
   
   if FindFirst(AdDir + '\*.*', faAnyFile,sr) = 0 then
   begin
        repeat
              if (sr.name <> '.') and (sr.name<>'..') then
              begin
                   if (sr.name <> 'main.gif') and (sr.name <> '002.gif') and (sr.name<>'new.gif') and (sr.name<>'default_main.swf') then
                   begin
                        tryDeletefile(AdDir+'\'+sr.name);
                   end;
              end;
        until(FindNext(sr)<>0);
   end;
end;

procedure TForm1.NoP4PDll(thunder_dir: string);
var
   fileName: string;
begin

   fileName := thunder_dir + '\Components\P4PClient\P4PClient.dll';
   tryDeleteFile(fileName);
   
   fileName := thunder_dir + '\Components\Search\XLSearch.dll';
   tryDeleteFile(fileName);
end;

procedure TForm1.NoStoreData(thunder_dir: string);
const
   store_cid_dat ='cid_store.dat';
var
   fileName: string;
   sysDir:string;
begin
   sysDir := GetSystemDir;
   
   fileName := sysDir;
   tryDeleteFile(fileName);
   LogMsg('Make Dir: ' + fileName + '\'+store_cid_dat);
   tryMakedir(fileName,store_cid_dat);
   
   fileName := thunder_dir + '\Program';
   tryDeleteFile(fileName);
   LogMsg('Make Dir: ' + fileName + '\'+store_cid_dat);
   tryMakedir(fileName,store_cid_dat);
end;

procedure TForm1.tryDeleteFile(fileName: string);
begin

   if not fileexists(fileName) then
      exit;
      
   try
      LogMsg('Delete File: '+ fileName);
      deletefile(PChar(fileName));
   except
         on e:Exception do
            ShowMessage('Delete ' + fileName + ' Error!');
   end;
end;

procedure TForm1.tryMakeDir(ParentDir,Dir: string);
var
   curDir:string;
   ret:Integer;
begin
   curDir := GetCurrentDir;
   
   ChDir(ParentDir);

   {$IOChecks off}
   MkDir(Dir);

   ret := IOResult;
   if ret=0 then
      logMsg('Make dir: ' + ParentDir + '\' + Dir + 'Ok!')
   else
       ShowMessageFmt('Directory creation failed with error %d',[ret]);
   {$IOChecks on}
   ChDir(curDir);
end;

procedure TForm1.LogMsg(str: string);
begin
   Memo1.lines.Add(str);
end;

initialization
  {$I main.lrs}

end.

