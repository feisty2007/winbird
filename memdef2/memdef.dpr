(*
    memdef : Program to defrag Ms-Windows 9x memory
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

program memdef;

uses
  Forms,
  Windows,
  memdefrag in 'memdefrag.pas' {Form1},
  info in 'info.pas' {Form2},
  defrag in 'defrag.pas',
  option in 'option.pas' {Form3},
  about in 'about.pas' {Form4},
  CPUMessag in 'CPUMessag.pas';

{$R *.RES}
procedure CheckPrevInst;
var  s:string;
begin
     s:=Application.className;
     if FindWindow(pchar(s),'Memory Defragmenter v 1.0')>0
        then  halt(0);
end;

begin
  CheckPrevInst;
  Application.Initialize;
  Application.Title := 'Memory Defragmenter v 1.0';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
