object Form1: TForm1
  Left = 430
  Top = 230
  BorderStyle = bsDialog
  Caption = 'Check Keyboard State'
  ClientHeight = 170
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object shp_CapsLock: TShape
    Left = 64
    Top = 32
    Width = 65
    Height = 49
    Shape = stCircle
  end
  object shp_NumLock: TShape
    Left = 208
    Top = 32
    Width = 65
    Height = 49
    Shape = stCircle
  end
  object lbl_CapsLock: TLabel
    Left = 72
    Top = 104
    Width = 51
    Height = 13
    Caption = 'Caps Lock'
  end
  object lbl_NumLock: TLabel
    Left = 216
    Top = 104
    Width = 49
    Height = 13
    Caption = 'Num Lock'
  end
  object btn1: TButton
    Left = 360
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Check'
    TabOrder = 0
    OnClick = btn1Click
  end
  object tmr_CHK: TTimer
    OnTimer = tmr_CHKTimer
    Left = 360
    Top = 40
  end
end
