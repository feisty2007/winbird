unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Contnrs, Registry, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnSelDir(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    FolderList:TObjectList;
    procedure InitFolderList;
    procedure FreeFolderList;
    procedure ReadSysCfg;
  public
    { public declarations }
  end; 
  
  { TSystemName }

  TSystemName = class
  private
    Fcsidl: DWORD;
    FName: string;
    procedure Setcsidl(const AValue: DWORD);
    procedure SetName(const AValue: string);
  public
    property Name:string read FName write SetName;
    property csidl:DWORD read Fcsidl write Setcsidl;
    constructor Create(vcsidl: integer; vName: string);
  end;

var
  Form1: TForm1; 

implementation

{ TForm1 }

const
     REGKEY1 = 'software\Microsoft\Windows\CurrentVersion\Policies';
     REGKEY2 = 'ComDlg32';
     REGKEY3 = 'PlacesBar';
     REGKEY4 = 'Place';

procedure TForm1.Button1Click(Sender: TObject);
var
   Reg:TRegistry;
   sn:TSystemName;
   sn_csidl:integer;
   cbb_index:integer;
   
begin

   reg := TRegistry.Create;
   
   if reg.OpenKey( REGKEY1 + '\' + REGKEY2 + '\' + REGKEY3, true) then
   begin
        if (checkbox1.Checked) and (length(edit1.text)>0) then
        begin
           if DirectoryExists(edit1.text) then
              reg.WriteString(REGKEY4+'0',edit1.text);
        end
        else
        begin
           cbb_index := ComboBox1.ItemIndex;
           sn := FolderList[cbb_index] as TSystemName;
           sn_csidl := sn.csidl;
           
           Reg.WriteInteger(REGKEY4 + '0', sn_csidl);
        end;

        if (checkbox2.Checked) and (length(edit2.text)>0) then
        begin
           if DirectoryExists(edit2.text) then
              reg.WriteString(REGKEY4+'1',edit2.text);
        end
        else
        begin
           cbb_index := ComboBox2.ItemIndex;
           sn := FolderList[cbb_index] as TSystemName;
           sn_csidl := sn.csidl;

           Reg.WriteInteger(REGKEY4 + '1', sn_csidl);
        end;

        if (checkbox3.Checked) and (length(edit3.text)>0) then
        begin
           if DirectoryExists(edit3.text) then
              reg.WriteString(REGKEY4+'2',edit3.text);
        end
        else
        begin
           cbb_index := ComboBox3.ItemIndex;
           sn := FolderList[cbb_index] as TSystemName;
           sn_csidl := sn.csidl;

           Reg.WriteInteger(REGKEY4 + '2', sn_csidl);
        end;

        if (checkbox4.Checked) and (length(edit4.text)>0) then
        begin
           if DirectoryExists(edit4.text) then
              reg.WriteString(REGKEY4+'3',edit4.text);
        end
        else
        begin
           cbb_index := ComboBox4.ItemIndex;
           sn := FolderList[cbb_index] as TSystemName;
           sn_csidl := sn.csidl;

           Reg.WriteInteger(REGKEY4 + '3', sn_csidl);
        end;
        
        if (checkbox5.Checked) and (length(edit5.text)>0) then
        begin
           if DirectoryExists(edit5.text) then
              reg.WriteString(REGKEY4+'4',edit5.text);
        end
        else
        begin
           cbb_index := ComboBox5.ItemIndex;
           sn := FolderList[cbb_index] as TSystemName;
           sn_csidl := sn.csidl;

           Reg.WriteInteger(REGKEY4 + '4', sn_csidl);
        end;
   end;
   
   reg.CloseKey;
   
   reg.Free;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
   reg:TRegistry;
begin

   try
     reg := TRegistry.Create;
     
     if reg.OpenKey(REGKEY1 + '\' + REGKEY2, true) then
     begin
          reg.DeleteKey(REGKEY3);
     end;
   finally
     reg.free;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  SystemName:TSystemName;
begin
  InitFolderList;
  
  for i := 0 to FolderList.count - 1 do
  begin
       SystemName := FolderList[i] as TSystemName;
       ComboBox1.Items.Add( SystemName.Name );
       ComboBox2.Items.Add( SystemName.Name );
       ComboBox3.Items.Add( SystemName.Name );
       ComboBox4.Items.Add( SystemName.Name );
       ComboBox5.Items.Add( SystemName.Name );
  end;
  
  i:=0;
  ComboBox1.ItemIndex := i;
  inc(i);
  ComboBox2.ItemIndex := i;
  inc(i);
  ComboBox3.ItemIndex := i;
  inc(i);
  ComboBox4.ItemIndex := i;
  inc(i);
  ComboBox5.ItemIndex := i;
  inc(i);
  
  ReadSysCfg;

end;

procedure TForm1.BtnSelDir(Sender: TObject);
var
   btn:TButton;
   selPath:string;
begin
   if SelectDirectory('Select Directory','',selPath,false) then
   begin
        btn := Sender as TButton;
        
        if btn.Name = 'Button2'  then
           Edit1.Text := selPath;

        if btn.Name = 'Button3'  then
           Edit2.Text := selPath;

        if btn.Name = 'Button4'  then
           Edit3.Text := selPath;
           
        if btn.Name = 'Button5'  then
           Edit4.Text := selPath;
           
        if btn.Name = 'Button6'  then
           Edit5.Text := selPath;
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeFolderList;
end;

procedure TForm1.InitFolderList;
begin
  FolderList := TObjectList.Create;
  
  //System Default OpenDialog Folder
  FolderList.Add( TSystemName.Create($8,'Recent'));
  FolderList.Add( TSystemName.Create($0,'Desktop'));
  FolderList.Add( TSystemName.Create($5,'My Document'));
  FolderList.Add( TSystemName.Create($11,'Computer'));
  FolderList.Add( TSystemName.Create($13,'Network Neighborhood'));
  
  
  FolderList.Add( TSystemName.Create($1,'Internet Explorer'));
  FolderList.Add( TSystemName.Create($27,'My Pictures'));
  FolderList.Add( TSystemName.Create($6,'Favorites'));
  FolderList.Add( TSystemName.Create($22,'History'));
  FolderList.Add( TSystemName.Create($7,'Startup'));
  FolderList.Add( TSystemName.Create($9,'Send To'));
  FolderList.Add( TSystemName.Create($b,'Start Menu'));
  FolderList.Add( TSystemName.Create($4,'Printer'));
  FolderList.Add( TSystemName.Create($a,'Recycle Bin'));
  FolderList.Add( TSystemName.Create($26,'Program files'));

end;

procedure TForm1.FreeFolderList;
begin
  if FolderList<>nil then
     FolderList.Free;
end;

procedure TForm1.ReadSysCfg;
var
   reg:TRegistry;
   i:integer;
   iValue:integer;
   strValue:string;

   
   function GetIndexByCsidl(vcsidl:integer):integer;
   var
      i:integer;
      sn:TSystemName;
   begin
        result := 0;
        for i :=0 to FolderList.count - 1 do
        begin
             sn := FolderList[i] as TSystemName;
             
             if sn.csidl = vcsidl then
             begin
                  result := i;
                  exit;
             end;
        end;
   end;
begin

   reg := TRegistry.Create;
   
   if reg.OpenKeyReadOnly(REGKEY1) then
   begin
        if not reg.KeyExists(REGKEY2) then
        begin
           reg.CloseKey;
           reg.Free;
           exit;
        end;
   end;
   
   reg.CloseKey;
   if reg.OpenKeyReadOnly(REGKEY1+'\'+REGKEY2) then
   begin
        if not reg.KeyExists(REGKEY3) then
        begin
          reg.CloseKey;
          reg.Free;
          exit;
        end;
   end;
   
   reg.CloseKey;
   
   if reg.OpenKeyReadOnly( REGKEY1 + '\' + REGKEY2 + '\' + REGKEY3) then
   begin

      //ShowMessage(reg.CurrentPath);
      if reg.GetDataType('Place0') = rdString then
      begin
           strValue := Reg.ReadString('Place0');
           checkbox1.checked := True;
           edit1.Text := strValue;
      end
      else
      begin
           iValue := reg.ReadInteger('Place0');
           ComboBox1.ItemIndex := GetIndexByCsidl(iValue);
      end;

      if reg.GetDataType('Place1') = rdInteger then
      begin
           iValue := reg.ReadInteger('Place1');
           ComboBox2.ItemIndex := GetIndexByCsidl(iValue);
      end
      else
      begin
           strValue := Reg.ReadString('Place1');
           checkbox2.checked := True;
           edit2.Text := strValue;
      end;
      
      if reg.GetDataType('Place2') = rdInteger then
      begin
           iValue := reg.ReadInteger('Place2');
           ComboBox3.ItemIndex := GetIndexByCsidl(iValue);
      end
      else
      begin
           strValue := Reg.ReadString('Place2');
           checkbox3.checked := True;
           edit3.Text := strValue;
      end;
      
      if reg.GetDataType('Place3') = rdInteger then
      begin
           iValue := reg.ReadInteger('Place3');
           ComboBox4.ItemIndex := GetIndexByCsidl(iValue);
      end
      else
      begin
           strValue := Reg.ReadString('Place3');
           checkbox4.checked := True;
           edit4.Text := strValue;
      end;
      
      if reg.GetDataType('Place4') = rdInteger then
      begin
           iValue := reg.ReadInteger('Place4');
           ComboBox5.ItemIndex := GetIndexByCsidl(iValue);
      end
      else
      begin
           strValue := Reg.ReadString('Place4');
           checkbox5.checked := True;
           edit5.Text := strValue;
      end;
      
      reg.closeKey;
   end;
   reg.free;
end;

{ TSystemName }

procedure TSystemName.Setcsidl(const AValue: DWORD);
begin
  if Fcsidl=AValue then exit;
  Fcsidl:=AValue;
end;

procedure TSystemName.SetName(const AValue: string);
begin
  if FName=AValue then exit;
  FName:=AValue;
end;

constructor TSystemName.Create(vcsidl: integer; vName: string);
begin
  FCsidl := vcsidl;
  FName := vName;
end;

initialization
  {$I main.lrs}

end.

