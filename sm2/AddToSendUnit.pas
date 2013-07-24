unit AddToSendUnit;

interface

uses
    IExeInf,ShellAPI,ShlObj,Windows,ActiveX,SysUtils,ComObj,Forms,Controls;

type
    AddToSend=class(TInterfacedObject,IExeInterface)
    public
      function GetDescription:string;
      function GetParam:string;
      procedure Execute(folder:string);
    private
      procedure CreateLink(strPath:string;strDescription:string);
      function GetSendToPath:string;
    end;

implementation

uses PromptName;
var
  ATS:AddToSend;


{ AddToSend }

procedure AddToSend.CreateLink(strPath, strDescription: string);
var
  aObj:IUnknown;
  ShellLink:IShellLink;
  PersistFile:IPersistFile;
  szBuffer:array[0..MAX_PATH] of char;
  szWChar:array[0..MAX_PATH] of WideChar;
begin
  aObj:=CreateComObject(CLSID_ShellLink);
  ShellLink:=aObj as IShellLink;
  PersistFile:=ShellLink as IPersistFile;

  StrPCopy(szBuffer,strPath);
  OleCheck(ShellLink.SetPath(szBuffer));

  StrPCopy(szBuffer,GetSendToPath+'\'+strDescription+'.lnk');
  MultiByteToWideChar(CP_ACP,0,szBuffer,-1,szWChar,1024);
  OleCheck(PersistFile.Save(szWChar,true));
end;



procedure AddToSend.Execute(folder: string);
var
  input:TInputFrm;
begin
  input:=TInputFrm.Create(nil);
  input.Edit1.Text:=folder;
  input.ShowModal;
  if (input.ModalResult=mrOK) and (input.Edit1.Text<>'') then
    CreateLink(folder,input.Edit1.text);
  input.Free;
end;

function AddToSend.GetDescription: string;
begin
  result:='添加到"发送到"菜单';
end;

function AddToSend.GetParam: string;
begin
  result:='SendTo';
end;

function AddToSend.GetSendToPath: string;
var
  LPID:PItemIDList;
  path:array[0..MAX_PATH] of char;
begin
  SHGetSpecialFolderLocation(Application.Handle,
          CSIDL_SENDTO,
          LPID);

  ShGetPathFromIDList(lpid,path);
  result:=string(path);
end;

initialization
    ATS:=AddToSend.Create;
    RegisterExeInf(ATS as IExeInterface);
end.
 