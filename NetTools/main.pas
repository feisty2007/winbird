unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdRawBase, IdRawClient,
  IdIcmpClient, StdCtrls, ComCtrls, IdStack;

type
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    grp1: TGroupBox;
    lst_Result: TListBox;
    edt_IP: TEdit;
    btn_Ping: TButton;
    idcmpclnt1: TIdIcmpClient;
    ts2: TTabSheet;
    grp2: TGroupBox;
    edt1: TEdit;
    btn_tracert: TButton;
    mmResult: TMemo;
    IdIcmpClient1: TIdIcmpClient;
    procedure btn_PingClick(Sender: TObject);
    procedure idcmpclnt1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure btn_tracertClick(Sender: TObject);
    procedure IdIcmpClient1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
  private
    { Private declarations }
    findHost: string;
    hop: string;
    icmpseq, pingtime: integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn_PingClick(Sender: TObject);
var
  i: integer;
begin
  if edt_IP.Text <> '' then
  begin
    idcmpclnt1.Host := edt_IP.Text;
    idcmpclnt1.ReceiveTimeout := 1000;
    btn_Ping.Enabled := False;
    try
      for i := 0 to 3 do
      begin
        idcmpclnt1.Ping();
        Application.ProcessMessages;
      end;
    finally
      btn_Ping.Enabled := True;
    end;
  end;
end;

procedure TForm1.idcmpclnt1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
var
  sTime: string;
begin

  if AReplyStatus.MsRoundTripTime = 0 then
    sTime := '<1'
  else
    sTime := '=';
  lst_Result.Items.Add(Format('ICMP_SEQ=%d Reply from %s [%s] : Bytes=%d time%s%d ms TTL=%d',
    [AReplyStatus.SequenceId,
    edt_IP.Text,
      AReplyStatus.FromIpAddress,
      AReplyStatus.BytesReceived,
      sTime,
      AReplyStatus.MsRoundTripTime,
      AReplyStatus.TimeToLive]));
end;

procedure TForm1.btn_tracertClick(Sender: TObject);
var
  ResolvedHost: string;
  i: Integer;
begin
  if edt1.Text = '' then
    exit;

  ResolvedHost := gStack.WSGetHostByName(Edt1.Text);
  mmResult.Lines.Clear;
  mmResult.Lines.Add('Tracing route to: ' + Edt1.Text + ' [' + ResolvedHost + '] ' + 'over a maximum of 30 hops:');
  mmResult.Lines.Add('');
  IdIcmpClient1.OnReply := IdIcmpClient1Reply;
  IdIcmpClient1.ReceiveTimeout := 1000;
  btn_tracert.Enabled := False;
  try
    icmpseq := 30;
    for i := 1 to icmpseq do begin
      if findhost <> ResolvedHost then
      begin
        hop := inttostr(i);
        IdIcmpClient1.Host := edt1.Text;
        IdIcmpClient1.TTL := i;
        pingtime := 0;
        //if findhost <> '0.0.0.0' then
        IdIcmpClient1.Ping;
        Application.ProcessMessages;
        //Sleep(500);
        IdIcmpClient1.Host := findhost;
        IdIcmpClient1.TTL := icmpseq;
        pingtime := 1;
        if findhost <> '0.0.0.0' then
          IdIcmpClient1.Ping;
        Application.ProcessMessages;
        //Sleep(500);
        pingtime := 2;
        if findhost <> '0.0.0.0' then
          IdIcmpClient1.Ping;
        Application.ProcessMessages;
        //Sleep(500);
        pingtime := 3;
        if findhost <> '0.0.0.0' then
          IdIcmpClient1.Ping;
        Application.ProcessMessages;
        //Sleep(500);
      end;
    end;
  finally
    btn_tracert.Enabled := True;
  end;
  mmResult.Lines.Add('');
  mmResult.Lines.Add('Trace complete.');
end;

procedure TForm1.IdIcmpClient1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
var
  sTime: string;
begin
  findhost := AReplyStatus.FromIpAddress;
  if (AReplyStatus.MsRoundTripTime = 0) then
    sTime := '<1'
  else
    sTime := ' ';

  if (findhost = '0.0.0.0') then
    mmResult.Lines.Add(hop + ': ' + chr(9) + 'Request time out or blocked by router.')
  else

  begin
    if (pingtime = 1) then
    begin
      if (AReplyStatus.BytesReceived = 0) then
        mmResult.Lines.Add(hop + ': ' + chr(9) + '*')
      else
        if (AReplyStatus.SequenceId <> 0) then
        begin
          mmResult.SelText := (Format(hop + ': ' + chr(9) + '%s%d' + ' ms',
            [sTime, AReplyStatus.MsRoundTripTime]));
        end;
    end;

    if (pingtime = 2) then
    begin
      if (AReplyStatus.BytesReceived = 0) then
        mmResult.SelText := chr(9) + '*'
      else
        if (AReplyStatus.SequenceId <> 0) then
        begin
          mmResult.SelText := (Format(chr(9) + '%s%d' + ' ms',
            [sTime, AReplyStatus.MsRoundTripTime]));
        end;
    end;

    if (pingtime = 3) then
    begin
      if (AReplyStatus.BytesReceived = 0) then
        mmResult.SelText := chr(9) + '*'
      else
        if (AReplyStatus.SequenceId <> 0) then
        begin
          mmResult.SelText := (Format(chr(9) + '%s%d' + ' ms',
            [sTime, AReplyStatus.MsRoundTripTime])) + chr(9) + findhost;
          mmResult.Lines.Add('');
        end;
    end;

  end;
end;

end.

