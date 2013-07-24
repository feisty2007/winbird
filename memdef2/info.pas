(*
    INFO.PAS : Unit to show the memory information
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

unit info;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    LTotalRAM: TLabel;
    LFreeRAM: TLabel;
    LTotalPage: TLabel;
    LPageFree: TLabel;
    LTotalVirtual: TLabel;
    LFreeVirtual: TLabel;
    LMemoryLoad: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}


procedure TForm2.Button1Click(Sender: TObject);
begin
     Close;
end;

procedure TForm2.FormShow(Sender: TObject);
const b = ' M byte';
var ms : TMemoryStatus;
begin
     ShowWindow(application.handle, SW_HIDE);
     ms.dwLength:=sizeof(ms);
     GlobalMemoryStatus(ms);
     LTotalRam.Caption:=Format('%d'+b, [ms.dwTotalPhys shr 20]);
     LFreeRam.Caption:=Format('%d'+b,[ms.dwAvailPhys shr 20]);
     LTotalPage.Caption:=Format('%d'+b,[ms.dwTotalPageFile shr 20]);
     LPageFree.Caption:=Format('%d'+b, [ms.dwAvailPageFile shr 20]);
     LTotalVirtual.Caption:= Format('%d'+b, [ms.dwTotalVirtual shr 20]);
     LFreeVirtual.Caption:= Format('%d'+b,[ms.dwAvailVirtual shr 20]);
     LMemoryLoad.Caption:= Format('%d %%',[ms.dwMemoryLoad]);
     timer1.Enabled:=true;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
const b = ' byte';
var ms : TMemoryStatus;
begin
     ms.dwLength:=sizeof(ms);
     GlobalMemoryStatus(ms);
     LFreeRam.Caption:=Format('%d'+b,[ms.dwAvailPhys shr 20]);
     LMemoryLoad.Caption:= Format('%d %%',[ms.dwMemoryLoad]);
end;

procedure TForm2.FormHide(Sender: TObject);
begin
     timer1.Enabled:=false;
end;

end.
