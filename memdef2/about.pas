(*
    ABOUT.PAS : Unit to show and handle the about dialog 
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
unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellApi;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.DFM}

procedure TForm4.Button1Click(Sender: TObject);
begin
     close;
end;

procedure TForm4.Label4Click(Sender: TObject);
begin
     ShellExecute(0, 'open', 'http://langitbiru.hypermart.net',
     '','', SW_SHOW);
end;

procedure TForm4.Label5Click(Sender: TObject);
begin
     ShellExecute(0, 'open', 'mailto:yohanes@biosys.net',
     '','', SW_SHOW);
end;

procedure TForm4.Label7Click(Sender: TObject);
begin
     ShellExecute(0, 'open', 'mailto:yohanes_n@hotmail.com',
     '','', SW_SHOW);
end;

procedure TForm4.FormShow(Sender: TObject);
begin
     ShowWindow(application.handle, SW_HIDE);
end;

end.
