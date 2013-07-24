object frmNetsh: TfrmNetsh
  Left = 378
  Top = 295
  BorderStyle = bsNone
  Caption = 'Netsh Command Windows'
  ClientHeight = 137
  ClientWidth = 295
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_ApplyChange: TLabel
    Left = 64
    Top = 56
    Width = 75
    Height = 13
    Caption = 'Apply Change...'
  end
  object mmo_Netsh: TMemo
    Left = 16
    Top = 24
    Width = 41
    Height = 25
    TabOrder = 0
    Visible = False
  end
end
