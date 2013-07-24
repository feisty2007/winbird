object frmSelectRange: TfrmSelectRange
  Left = 282
  Top = 315
  BorderStyle = bsDialog
  Caption = 'Select'
  ClientHeight = 140
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn_OK: TBitBtn
    Left = 512
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkCancel
  end
  object btn_Cancel: TBitBtn
    Left = 408
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object edt_SelTxt: TEdit
    Left = 24
    Top = 48
    Width = 561
    Height = 21
    TabOrder = 2
    Text = 'edt_SelTxt'
  end
end
