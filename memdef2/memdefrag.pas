
(*
    Memdefrag  : Main unit for the memory defragmenter 
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
unit memdefrag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, StdCtrls, Registry, Defrag, Gauges,
  shellapi;
const MyWM_NotifyIcon = $1982;

type
  TForm1 = class(TForm)
    MemBar: TProgressBar;
    MemLevel: TTrackBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Option1: TMenuItem;
    Memori1: TMenuItem;
    Info1: TMenuItem;
    Defrag1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Timer1: TTimer;
    LInfo: TLabel;
    Button1: TButton;
    Label1: TLabel;
    LCPUStat: TLabel;
    Label3: TLabel;
    LMemInfo: TLabel;
    Button2: TButton;
    Pie: TGauge;
    procedure Info1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MemLevelChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Option1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure minimise(var msg: TMessage); message WM_SYSCOMMAND;
    procedure TaskBarHandler(var msg: TMessage); message MyWM_NotifyIcon;
  end;


var
  Form1: TForm1;
  Totalmem : longint; //total memory dalam satuan megabyte
  Tr : TRegistry;
  tnid : TNotifyIconData;
  lastdefrag : longint;
  isFirst    : boolean;
  
implementation

uses info, option, about, CPUMessag;

{$R *.DFM}

procedure TForm1.Info1Click(Sender: TObject);
begin
     Form2.showmodal;
     showwindow(Application.Handle, SW_HIDE);     
end;

procedure TForm1.minimise(var msg: TMessage);
begin
     case msg.WParam of
          SC_CLOSE : close;
          SC_MINIMIZE :
                      begin
                           showwindow(Application.Handle, SW_HIDE);
                           showwindow(Form1.Handle, SW_HIDE);
                      end;
          else
              DefWindowProc(Form1.Handle, msg.msg, msg.WParam, msg.LParam);
     end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
       Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var ms : TMemoryStatus;
    trg : tregistry;
    i   : integer;
    function TryReadInteger(reg:TRegistry;keyName:string):Integer;
    begin
      if reg.KeyExists(keyName) then
         result:=reg.ReadInteger(keyName)
      else
         result:=1;
    end;
begin
       LastDefrag:=GetTickCount;
       tnid.cbSize := sizeof(TNotifyIconData);
       tnid.Wnd := Form1.handle;
       tnid.uID := $2111;
       tnid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
       tnid.uCallbackMessage := MYWM_NOTIFYICON;
       tnid.hIcon := Application.Icon.Handle;
       Shell_NotifyIcon(NIM_ADD, @tnid);
       ms.dwLength:=sizeof(ms);
       GlobalMemoryStatus(ms);
       TotalMem:=(ms.dwTotalPhys shr 20) + 1;
       MemLevel.Max:=Totalmem;
       MemBar.Max:=TotalMem*2;
       Tr:=Tregistry.create;
       tr.RootKey:=HKEY_DYN_DATA;
       tr.OpenKey('PerfStats\StatData',false);
       pie.Visible:=false;
       trg:=tregistry.create;
       with trg do
            begin
                 RootKey:=HKEY_CURRENT_USER;
                 OpenKey(KeyName, true);
                 i:=TryReadInteger(Tr,'MemToFree');
                 if (i<MemLevel.Min) or (i>MemLevel.Max) then
                    begin
                         i:=MemLevel.Max shr 2;
                         WriteInteger('MemToFree', i);
                    end;
                 MemLevel.Position:=i;
                 closekey;
                 free;
            end;
     LInfo.Caption:=Format(
     'Defragmen RAM sebanyak %d Mb', [MemLevel.Position]);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var ms : TMemoryStatus;
    l : longint;
    s:string;
begin
       ms.dwLength:=sizeof(ms);
       GlobalMemoryStatus(ms);
       MemBar.Position:=ms.dwAvailPhys shr 19;
       s:=Format('%dM/%dM',[ms.dwAvailPhys shr 20, ms.dwTotalPhys shr 20]);
       LMemInfo.Caption:=s;

       //tr.ReadBinaryData('KERNEL\CPUUsage',l, sizeof(l));
       //LCPUStat.Caption:=Format('%d %%', [l]);
       GetCPUUsage(LCPUStat);
       s:='Memori bebas/Total '+s;
       lstrcpy(tnid.szTip, pchar(s));
       Shell_NotifyIcon(NIM_Modify, @tnid);
       if option.AutoDefrag then
       begin
           if (option.CPULimit=0) or (l<option.CPULimit) then
           begin
                if (GetTickCount-lastdefrag)<5000 then exit;
                if (membar.position shr 1)<option.MemLimit then
                begin
                            button2click(self);
                            LastDefrag:=GetTickCount;
                end;
           end;
       end;
       
end;

procedure TForm1.MemLevelChange(Sender: TObject);
begin
     LInfo.Caption:=Format(
     'Defragmen RAM sebanyak %d Mb', [MemLevel.Position]);
end;

procedure idle;
begin
     Application.processMessages;
     Form1.Pie.progress:=Form1.Pie.progress+1;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     timer1.Enabled:=false;
     Button2.Enabled:=false;
     pie.Visible:=true;
     pie.MaxValue:=memlevel.position*2;
     Defragmem(memlevel.position,idle);
     pie.Visible:=false;
     Button2.Enabled:=true;
     timer1.Enabled:=true;     
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Shell_NotifyIcon(NIM_DELETE, @tnid);
end;

procedure TForm1.Option1Click(Sender: TObject);
begin
     Form3.ShowModal;
     showwindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
     Form4.showmodal;
     showwindow(Application.Handle, SW_HIDE);     
end;


procedure Tform1.TaskBarHandler(var msg: TMessage);
begin
     case msg.LParamLo of
          WM_LBUTTONDOWN :
                         begin
                              if not IsWindowVisible(form1.handle)
                              then showWindow(form1.handle, sw_show);
                         end;
     end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     showwindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
   trg : tregistry;
begin
       trg:=tregistry.create;
       with trg do
            begin
                 RootKey:=HKEY_CURRENT_USER;
                 OpenKey(KeyName, true);
                 WriteInteger('MemToFree',MemLevel.Position);
                 closekey;
                 free;
            end;
       tr.closeKey;
       tr.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
     if IsFirst and option.MinOnLoad then
     begin
          hide;
          IsFirst:=false;
     end;
end;

begin
     isFirst:=true;
end.
