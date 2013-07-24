(*
    OPTION.PAS : Unit for handling the option menu
    Copyright (C) 2000  Yohanes Nugroho

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    Yohanes Nugroho (yohanes_n@hotmail.com)
    Kp Areman RT 09/08 No 71
    Ds Tugu Cimanggis
    Bogor 16951
    Indonesia

*)
unit option;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Registry;

type
  TForm3 = class(TForm)
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure UpDateData(show:boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
     KeyName = 'Software\Caecilia Tech\Mem Defrag';
     RunKey = 'Software\Microsoft\Windows\CurrentVersion\Run';
var
  Form3: TForm3;
  AutoDefrag : boolean;
  MemLimit : integer;
  // 0 = abaikan kerja CPU
  CPULimit : integer;
  MinOnLoad:boolean;

implementation

uses memdefrag;

{$R *.DFM}

procedure TForm3.Button2Click(Sender: TObject);
begin
     close;
end;

procedure TForm3.Button1Click(Sender: TObject);
var tr: tregistry;
begin
     tr:=tregistry.create();
     with tr do
          begin
               RootKey:=HKEY_CURRENT_USER;
               OpenKey(KeyName, true);
               WriteBool('AutoDefrag', checkbox2.Checked);
               WriteBool('MinOnLoad', checkbox3.Checked);
               WriteInteger('MemLimit',trackbar1.Position);
               WriteInteger('CPULoadLimit',StrToInt(Edit1.Text));
               CloseKey;
               RootKey:=HKEY_CURRENT_USER;
               OpenKey(RunKey, true);
          end;
     if checkbox1.Checked then
        begin
             tr.WriteString('MemDefrag',paramstr(0));
        end
     else
        begin
             tr.DeleteValue('MemDefrag');
        end;
     tr.CloseKey;
     tr.Free;
     close;
     UpdateData(false);
end;

procedure TForm3.CheckBox2Click(Sender: TObject);
begin
     label1.Enabled:=CheckBox2.Checked;
     trackbar1.Enabled:=CheckBox2.Checked;
end;


procedure TForm3.TrackBar1Change(Sender: TObject);
begin
     label1.Caption:=Format(
     'Autodefrag saat memori bebas tersisa sebanyak %d Mb',
     [Trackbar1.position]);

end;

procedure TForm3.Edit1Exit(Sender: TObject);
begin
     try
     if StrToInt(edit1.Text)>50 then
     Edit1.Text:='50';
     if StrToInt(edit1.Text)>50 then
     Edit1.Text:='50';
     except
           on EConvertError do
           begin
                Edit1.Text:='0';
           end;
     end;
end;

procedure TForm3.UpdateData(show:boolean);
var ms : TMemoryStatus;
    tr : tregistry;
    i : integer;
    maxmem:integer;
    function TryReadBool(reg:TRegistry;keyName:string):Boolean;
    begin
      if reg.KeyExists(keyName) then
         result:=reg.ReadBool(keyName)
      else
         result:=False;
    end;

    function TryReadInteger(reg:TRegistry;keyName:string):Integer;
    begin
      if reg.KeyExists(keyName) then
         result:=reg.ReadInteger(keyName)
      else
         result:=1;
    end;
begin
       ms.dwLength:=sizeof(ms);
       GlobalMemoryStatus(ms);
       maxmem:=(ms.dwTotalPhys shr 20) + 1;
       if show then trackbar1.max:=maxmem;
       if show then trackbar1.min:=1;
       tr:=tregistry.create();
       tr.RootKey:=HKEY_CURRENT_USER;
       tr.OpenKey(KeyName, true);
       AutoDefrag:=TryReadBool(tr,'AutoDefrag');
         
       if show then checkbox2.Checked:=AutoDefrag;
       MinOnLoad:=TryReadBool(tr,'MinOnLoad');
       if show then   checkbox3.Checked:=MinOnLoad;
       i:=TryReadInteger(tr,'MemLimit');
       if (i<2) or (i>maxmem) then
          begin
               i:=maxmem div 2;
               tr.WriteInteger('MemLimit',i);
          end;
       if show then TrackBar1.Position:=i;
       MemLimit:=i;
       i:=TryReadInteger(tr,'CPULoadLimit');
       if (i<0) or (i>50) then
          begin
               i:=0;
               tr.WriteInteger('CPULoadLimit', i);
          end;
     if show then Edit1.Text:=IntToStr(i);
     CPULimit:=i;
     tr.CloseKey;
     tr.RootKey:=HKEY_CURRENT_USER;
     tr.OpenKey(RunKey, true);
     if show then checkbox1.checked:=tr.ValueExists('MemDefrag');
     tr.CloseKey;
     tr.free;
     if show then TrackBar1Change(Self);
end;


procedure TForm3.FormShow(Sender: TObject);
begin
     ShowWindow(application.handle, SW_HIDE);
     UpdateData(true);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
     UpdateData(false);
end;

end.
