unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, Mask, StdCtrls, ExtCtrls, ActiveX, ComObj;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    txt_oldcdkey: TStaticText;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    medt1: TMaskEdit;
    btn1: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetProductKey(str:string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const
     regKey = 'Software\Microsoft\Windows NT\CurrentVersion';
     sn = 'DigitalProductId';
     org = 'RegisteredOrganization';
     owner_s = 'RegisteredOwner';
     
function DecodeProductKey(const HexSrc: array of Byte): string;
const
  StartOffset: Integer = $34; { //Offset 34 = Array[52] }
  EndOffset: Integer   = $34 + 15; { //Offset 34 + 15(Bytes) = Array[64] }
  Digits: array[0..23] of CHAR = ('B', 'C', 'D', 'F', 'G', 'H', 'J',
    'K', 'M', 'P', 'Q', 'R', 'T', 'V', 'W', 'X', 'Y', '2', '3', '4', '6', '7', '8', '9');
  dLen: Integer = 29; { //Length of Decoded Product Key }
  sLen: Integer = 15;
  { //Length of Encoded Product Key in Bytes (An total of 30 in chars) }
var
  HexDigitalPID: array of byte;
  Des: array of CHAR;
  I, N: INTEGER;
  HN : integer;
  Value: integer;
begin
  Result := '';
  SetLength(HexDigitalPID, dLen);
  for I := StartOffset to EndOffset do
  begin
    HexDigitalPID[I - StartOffSet] := HexSrc[I];
  end;

  SetLength(Des, dLen + 1);

  for I := dLen - 1 downto 0 do
  begin
    if (((I + 1) mod 6) = 0) then
    begin
      Des[I] := '-';
    end
    else
    begin
      HN := 0;
      for N := sLen - 1 downto 0 do
      begin
        Value := (HN shl 8) or byte(HexDigitalPID[N]);
        HexDigitalPID[N] := byte(Value div 24);
        HN    := Value mod 24;
      end;
      Des[I] := Digits[HN];
    end;

  end;
  Des[dLen] := Chr(0);

  for I := 0 to Length(Des) do
  begin
    Result := Result + Des[I];
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   reg: TRegistry;
   old_sn: string;
   hexBuf: array of BYTE;
   bufSize: integer;
begin
     try
       reg := TRegistry.Create;
       
       reg.RootKey := HKEY_LOCAL_MACHINE;
       if reg.OpenKey( regKey, false) then
       begin
            bufSize := reg.GetDataSize(sn);
            SetLength( hexBuf,bufSize );

            if bufSize>0 then
            begin
                 Reg.ReadBinaryData('DigitalProductId', HexBuf[0], bufSize);
            end;
            
            old_sn := DecodeProductKey(hexBuf);
            txt_OldCdKey.Caption :=  old_sn ;
            LabeledEdit1.Text := Reg.ReadString( owner_s );
            LabeledEdit2.Text := Reg.ReadString( org );
            reg.Free;
       end;
     finally
       //reg.Free;
     end;
end;


procedure TForm1.SetProductKey(str: string);
var
  Locator: OleVariant;
  WMI: OleVariant;
  RET: OleVariant;
  Enum: IEnumVariant;
  Tmp: OleVariant;
  Value: Cardinal;
begin;
  Locator := CreateOleObject('WbemScripting.SWbemLocator');
  WMI := Locator.ConnectServer('.','','','');
  Ret := WMI.ExecQuery('SELECT * FROM Win32_WindowsProductActivation');
  Enum:= IUnknown(RET._NewEnum) as IEnumVariant;
  while (Enum.Next(1, Tmp, Value) = S_OK) do
  begin
       Tmp.SetProductKey(str);
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  str:String;
begin
  str := medt1.Text;

  if Length(Trim(str)) =0 then
  begin
    MessageDlg('请输入新的CD-Key!',mtError,mbOKCancel,-1);
    Exit;
  end;

  if MessageDlg('你确定要更改Windows的CD-Key为'+str+'吗?',mtConfirmation,mbOKCancel,-1)= mrOk then
  begin
     str := StringReplace(str,'-','',[]);

     if Length(Trim(str))=25 then
       SetProductKey(str);
  end;

end;

end.
 