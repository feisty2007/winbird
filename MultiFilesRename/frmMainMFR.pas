unit frmMainMFR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ToolWin, Menus, ActnList, ImgList, StdCtrls ,FileCtrl,
  PerlRegEx;

type

  PItemNo=^ItemNo;
  ItemNo=record
    No:integer;
  end;
  
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    ToolButton1: TToolButton;
    btnStartRename: TToolButton;
    ToolButton3: TToolButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    lv_Files: TListView;
    ImageList1: TImageList;
    ActionList1: TActionList;
    OpenDialog1: TOpenDialog;
    ac_SelectFiles: TAction;
    GroupBox1: TGroupBox;
    cbb_FileName: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox2: TGroupBox;
    cbb_FileExt: TComboBox;
    Button5: TButton;
    Button6: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edt_Search: TEdit;
    Label2: TLabel;
    edt_Replace: TEdit;
    GroupBox4: TGroupBox;
    cbb_NameSet: TComboBox;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    edt_CounterStart: TEdit;
    UpDown1: TUpDown;
    edt_CounterStep: TEdit;
    UpDown2: TUpDown;
    Label4: TLabel;
    Label5: TLabel;
    cbb_CounterDigits: TComboBox;
    act_StartRename: TAction;
    btn_fnRange: TButton;
    btn_ExtRange: TButton;
    chk_OtherDir: TCheckBox;
    prlrgx1: TPerlRegEx;
    btn_Replace: TButton;
    btn_Up: TToolButton;
    btn_Down: TToolButton;
    btn_Delete: TToolButton;
    act_ItemUp: TAction;
    act_ItemDown: TAction;
    act_ItemDel: TAction;
    Help1: TMenuItem;
    About1: TMenuItem;
    procedure ac_SelectFilesExecute(Sender: TObject);
    procedure cbb_FileNameChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure act_StartRenameExecute(Sender: TObject);
    procedure btn_fnRangeClick(Sender: TObject);
    procedure btn_ReplaceClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure act_StartRenameUpdate(Sender: TObject);
    procedure act_ItemUpUpdate(Sender: TObject);
    procedure act_ItemDownUpdate(Sender: TObject);
    procedure act_ItemDelExecute(Sender: TObject);
    procedure act_ItemDelUpdate(Sender: TObject);
    procedure act_ItemUpExecute(Sender: TObject);
    procedure act_ItemDownExecute(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateFileNo;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses frmSelectRangeUnit, frmAbout;

{$R *.dfm}

function UpperFirstChar(str:string):string;
var
  strs:TStringList;
  i:integer;
  tempStr:string;
  destStrs:TStringList;
begin
  strs:=TStringList.Create;
  destStrs:=TStringList.Create;

  ExtractStrings([' '],[],PAnsiChar(str),strs);

  for i :=0  to strs.Count-1 do
  begin
    tempstr:=strs[i];
    tempStr[1]:=UpperCase(tempStr)[1];
    destStrs.Add(tempStr);
  end;

  Result:=destStrs[0];

  for i := 1 to destStrs.Count-1 do
  begin
      Result:=Result+' '+destStrs[i];
  end;
end;

procedure SplitFileTime(ftStr:string;var DateStr:string;var TimeStr:string);
var
  strs:TStringList;
begin
  strs:=TStringList.Create;

  ExtractStrings([' '],[],PAnsiChar(ftStr),strs);

  DateStr:=strs[0];
  TimeStr:=strs[1];
end;

procedure SplitFileName(fileName:string;var fName:string;var fExt:string);
var
  iLen:integer;
  fileExt:string;
begin
  fileExt:=ExtractFileExt(fileName);
  fExt:='';

  if Length(fileExt)<>0 then
  begin
     fext:=Copy(fileExt,2,Length(fileExt)-1);
     iLen:=Length(fileName);
     fName:=Copy(fileName,0,ilen-length(fExt)-1);
  end
  else
    fName:=fileName;
end;

function GetSubString(str:string;iStart,iEnd:Integer):string;
var
  vStart,vEnd:Integer;
  iLen:integer;
begin
  Result:='';
  iLen:=Length(str);
  if (iStart=iEnd) or (iStart>iLen) then
  begin
      Result:='';
      exit;
  end;

  vStart:=iStart;
  vEnd:=iEnd;

  if iEnd<iStart then
  begin
      vStart:=iEnd;
      vEnd:=iStart;
  end;

  if vEnd>iLen then
  begin
    Result:=Copy(str,vStart,iLen-vStart);
    exit;
  end
  else
  begin
    Result:=Copy(str,vStart,vEnd-vStart);
    exit;
  end;
end;

procedure TForm1.ac_SelectFilesExecute(Sender: TObject);
var
  i:integer;
  fileName:string;
  itemData:PItemNo;
  function GetFileModifyDate(fileName:string):TDateTime;
  var
    fh:Integer;
    ix:integer;
  begin
    fh:=FileOpen(fileName,fmOpenRead);

    ix:=FileGetDate(fh);

    Result:=FileDateToDateTime(ix);
    FileClose(fh);
  end;  
begin
  if openDialog1.Execute then
  begin
    lv_Files.Clear;
    for i:=0 to openDialog1.Files.Count-1 do
    begin
      with lv_Files.Items.Add do
      begin
          fileName:=ExtractFileName(openDialog1.Files[i]);
          Caption:=fileName;
          SubItems.Add(fileName);
          SubItems.Add(ExtractFilePath(OpenDialog1.Files[i]));
          New(ItemData);
          itemData.No:=i;
          SubItems.Add(DateTimeToStr(GetFileModifyDate(OpenDialog1.Files[i])));
      end;
    end;
  end;
end;

procedure TForm1.cbb_FileNameChange(Sender: TObject);
var
  fileNameTxt:string;
  fileExtTxt:string;
  i:integer;
  iCurrentStep:integer;
  iIncreaseStep:integer;
  strFileName:string;
  strFileExt:string;
  strDestFileName:string;
  strDestFileExt:string;
  strFileDate:string;
  strFileTime:string;
  iMatchStart,iMatchEnd:Integer;
  strValidFileName:string;
  step:string;
  strStepFmt:string;
  strFinalFileName:string;
const
  fileNameReg='\[N(\d)..(\d)\]';
  fileExtReg='\[E(\d)..(\d)\]';
begin
  fileNameTxt:=cbb_FileName.Text;
  fileExtTxt:=cbb_FileExt.Text;

  iCurrentStep:=StrToInt(edt_CounterStart.Text);
  iIncreaseStep:=StrToInt(edt_CounterStep.Text);

  for i := 0 to lv_Files.Items.Count-1 do
  begin
    strStepFmt:='%.'+IntToStr(cbb_CounterDigits.itemIndex+1)+'d';
    step:=Format(strStepFmt,[iCurrentStep]);
    SplitFileName(lv_Files.Items[i].Caption,strFileName,strFileExt);
    SplitFileTime(lv_Files.Items[i].SubItems[2],strFileDate,strFileTime);

    strDestFileName:=fileNameTxt;
    prlrgx1.Subject:=strDestFileName;
    prlrgx1.RegEx:=fileNameReg;

    prlrgx1.Compile;
    while prlrgx1.MatchAgain do
    begin
      iMatchStart:=StrToInt(prlrgx1.SubExpressions[1]);
      iMatchEnd:=StrToInt(prlrgx1.SubExpressions[2]);

      strValidFileName:=GetSubString(strFileName,iMatchStart,iMatchEnd);

      strDestFileName:=StringReplace(strdestFileName,prlrgx1.SubExpressions[0],strValidFileName,[rfReplaceAll]);
    end;

    strDestFileName:=StringReplace(strDestFileName,'[N]',strFileName,[rfReplaceAll]);
    strDestFileName:=StringReplace(strDestFileName,'[C]',step,[rfReplaceAll]);
    strDestFileName:=StringReplace(strdestFileName,'[YMD]',strFileDate,[rfReplaceAll]);
    strDestFileName:=StringReplace(strDestFileName,'[hms]',strFileTime,[rfReplaceAll]);

    strDestFileExt:=fileExtTxt;
    prlrgx1.Subject:=strDestFileExt;
    prlrgx1.RegEx:=fileExtReg;

    prlrgx1.Compile;

    while prlrgx1.MatchAgain do
    begin
      iMatchStart:=StrToInt(prlrgx1.SubExpressions[1]);
      iMatchEnd:=StrToInt(prlrgx1.SubExpressions[2]);

      strValidFileName:=GetSubString(strFileExt,iMatchStart,iMatchEnd);
      strDestFileExt:=StringReplace(strDestFileExt,prlrgx1.SubExpressions[0],strValidFileName,[rfReplaceAll]);
    end;

    strDestFileExt:=StringReplace(strDestFileExt,'[C]',IntToStr(iCurrentStep),[rfReplaceAll]);
    strDestFileExt:=StringReplace(strDestFileExt,'[E]',strFileExt,[rfReplaceAll]);

    Inc(iCurrentStep,iIncreaseStep);

    if Length(strDestFileExt)>0 then
      strFinalFileName:=strDestFileName+'.'+strdestFileExt
    else
      strFinalFileName:=strDestFileName;
    case cbb_NameSet.ItemIndex of
      0:
      ;
      1:
        strFinalFileName:=UpperCase(strFinalFileName);
      2:
        strFinalFileName:=LowerCase(strFinalFileName);
      3:
        if Length(strDestFileExt)>0 then
          strFinalFileName:=UpperFirstChar(strDestFileName)+'.'+UpperFirstChar(strdestFileExt)
        else
          strFinalFileName:=UpperFirstChar(strDestFileName);
    end;
    lv_Files.Items[i].SubItems[0]:=strFinalFileName;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  cbb_FileName.Text:=cbb_FileName.Text+'[N]';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  cbb_FileName.Text:=cbb_FileName.Text+'[C]';
  cbb_FileNameChange(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  cbb_FileName.Text:=cbb_FileName.Text+'[YMD]';
  cbb_FileNameChange(Sender);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  cbb_FileName.Text:=cbb_FileName.Text+'[hms]';
  cbb_FileNameChange(Sender);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  cbb_FileExt.Text:=cbb_FileExt.Text+'[E]';
  cbb_FileNameChange(Sender);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  cbb_FileExt.Text:=cbb_FileExt.Text+'[C]';
  cbb_FileNameChange(Sender);
end;

procedure TForm1.act_StartRenameExecute(Sender: TObject);
var
  i:Integer;
  strDestPath:string;
  bCopy:Boolean;

  function EnsureSlashEnd(const s:string):string;
  begin
    if s[Length(s)]='\' then
      result:=s
    else
      Result:=s+'\';
  end;
begin
  bCopy:=False;
  if chk_OtherDir.Checked then
  begin
    SelectDirectory('Select Output Dir','',strDestPath);
    strDestPath:=EnsureSlashEnd(strDestPath);
    bCopy:=true;
  end
  else
    strDestPath:=lv_Files.Items[0].SubItems[1];
  try
    for i :=0  to lv_Files.Items.Count-1 do
    begin
      with lv_Files.Items[i] do
      begin
          if not bCopy then
          begin
            try
               if (not RenameFile(SubItems[1]+Caption,strDestPath+SubItems[0])) then
                ShowMessage('Rename Error!');
            except on ex:Exception do
               ShowMessage(ex.Message);
            end;

          end
          else
            CopyFile(PAnsiChar(SubItems[1]+Caption),PAnsiChar(strDestPath+SubItems[0]),false);
      end;
    end;
  finally
    MessageBox(Handle,'Rename Success','Message',MB_OK OR MB_ICONINFORMATION);
  end;   
end;

procedure TForm1.btn_fnRangeClick(Sender: TObject);
var
  sFileName:string;
  sFileExt:string;
  iStart,iEnd:Integer;
begin
  if lv_Files.Items.Count=0 then
    exit;

  SplitFileName(lv_Files.Items[0].Caption,sFileName,sFileExt);
  if TButton(Sender).Caption=btn_fnRange.Caption then
  begin
    frmSelectRange.edt_SelTxt.Text:=sFileName;
    //frmSelectRange.FocusControl(frmSelectRange.edt_SelTxt);
    //frmSelectRange.edt_SelTxt.SelectAll;

    if (frmSelectRange.ShowModal=mrOK) and (frmSelectRange.edt_SelTxt.SelLength>0) and (Length(trim(frmSelectRange.edt_SelTxt.Text))>0) then
    begin
      iStart:=frmSelectRange.edt_SelTxt.SelStart;
      iEnd:=frmSelectRange.edt_SelTxt.SelStart+frmSelectRange.edt_SelTxt.SelLength;

      cbb_FileName.Text:=cbb_FileName.Text+format('[N%d..%d]',[iStart,iEnd]);
      cbb_FileNameChange(Sender);
    end;
  end;

  if TButton(Sender).Caption=btn_ExtRange.Caption then
  begin
    frmSelectRange.edt_SelTxt.Text:=sFileExt;
    //frmSelectRange.FocusControl(frmSelectRange.edt_SelTxt);
    //frmSelectRange.edt_SelTxt.SelectAll;

    if (frmSelectRange.ShowModal=mrOK) and (frmSelectRange.edt_SelTxt.SelLength>0) and (Length(trim(frmSelectRange.edt_SelTxt.Text))>0) then
    begin
      iStart:=frmSelectRange.edt_SelTxt.SelStart;
      iEnd:=frmSelectRange.edt_SelTxt.SelStart+frmSelectRange.edt_SelTxt.SelLength;

      cbb_FileExt.Text:=cbb_FileExt.Text+format('[E%d..%d]',[iStart,iEnd]);
      cbb_FileNameChange(Sender);
    end;
  end;    
end;

procedure TForm1.btn_ReplaceClick(Sender: TObject);
var
  i:integer;
  function isEditEmpty(edt:TEdit):boolean;
  begin
    result:=Length(Trim(edt.Text))=0;
  end;
begin
  if (isEditEmpty(edt_Search)) or (isEditEmpty(edt_Replace)) then
    Exit;
  with lv_Files do
  begin
      for i := 0 to items.Count-1 do
      begin
          Items[i].SubItems[0]:=StringReplace(Items[i].SubItems[0],edt_Search.Text,edt_Replace.Text,[rfReplaceAll]);
      end;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.act_StartRenameUpdate(Sender: TObject);
begin
  act_StartRename.Enabled:=lv_Files.Items.Count>0;
end;

procedure TForm1.act_ItemUpUpdate(Sender: TObject);
begin
  if lv_Files.Items.Count=0 then
  begin
    act_ItemUp.Enabled:=false;
  end
  else
  begin
    act_ItemUp.Enabled:=lv_Files.ItemIndex<>0;
  end;
end;

procedure TForm1.act_ItemDownUpdate(Sender: TObject);
begin
   if lv_Files.Items.Count=0 then
  begin
    act_ItemDown.Enabled:=false;
  end
  else
  begin
    act_ItemDown.Enabled:=lv_Files.ItemIndex<>lv_Files.Items.Count-1;
  end;
end;

procedure TForm1.act_ItemDelExecute(Sender: TObject);
begin
  if lv_Files.ItemIndex<>-1 then
  begin
        lv_Files.Items.Delete(lv_Files.ItemIndex);
        UpdateFileNo;
  end;
end;

procedure TForm1.act_ItemDelUpdate(Sender: TObject);
begin
  act_ItemDel.Enabled:=lv_Files.Items.Count>0;
end;

procedure TForm1.act_ItemUpExecute(Sender: TObject);
var
  i:integer;
  item1:TListItem;
  strFn,strNewFn,strDir,strFt:string;
begin
  i:=lv_Files.ItemIndex;

  item1:=lv_Files.Items[i];
  //iData1:=PItemNo(item1.Data);

  strFn:=item1.Caption;
  strNewFn:=item1.SubItems[0];
  strDir:=item1.SubItems[1];
  strft:=item1.SubItems[2];

  item1.Delete;

  with lv_Files.Items.Insert(i-1) do
  begin
    Caption:=strFn;
    SubItems.Add(strNewFn);
    SubItems.Add(strDir);
    SubItems.Add(strFt);
  end;

  lv_Files.ItemIndex:=i-1;
  UpdateFileNo;
end;

procedure TForm1.act_ItemDownExecute(Sender: TObject);
var
  i:integer;
  item1:TListItem;
  strFn,strNewFn,strDir,strFt:string;
begin
  i:=lv_Files.ItemIndex;

  item1:=lv_Files.Items[i];
  //iData1:=PItemNo(item1.Data);

  strFn:=item1.Caption;
  strNewFn:=item1.SubItems[0];
  strDir:=item1.SubItems[1];
  strft:=item1.SubItems[2];

  item1.Delete;

  with lv_Files.Items.Insert(i+1) do
  begin
    Caption:=strFn;
    SubItems.Add(strNewFn);
    SubItems.Add(strDir);
    SubItems.Add(strFt);
  end;
  lv_Files.ItemIndex:=i+1;

  UpdateFileNo;
end;

procedure TForm1.UpdateFileNo;
begin
  if (Pos('[C]',cbb_FileName.Text)<>0) or (Pos('[C]',cbb_FileExt.Text)<>0) then
    cbb_FileNameChange(cbb_FileName);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  OKBottomDlg.ShowModal;
end;

end.
