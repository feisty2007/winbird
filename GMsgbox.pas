unit GMsgbox;

interface
uses
  Windows;

type
  TGMsgBox = class
  public
    class procedure ShowInfo(Wnd: HWND; caption, msg: string);
    class function ShowWarn(wnd: HWND; caption, msg: string): longint;
  end;

implementation

{ TGMsgBox }



{ TGMsgBox }

class procedure TGMsgBox.ShowInfo(Wnd: HWND; caption, msg: string);
begin
  MessageBox(Wnd, PAnsiChar(msg), PAnsiChar(caption), MB_OK or MB_ICONINFORMATION);
end;

class function TGMsgBox.ShowWarn(wnd: HWND; caption, msg: string): longint;
begin
  result := MessageBox(wnd, PAnsiChar(msg), PAnsiChar(caption), MB_OKCANCEL or MB_ICONWARNING);
end;

end.
