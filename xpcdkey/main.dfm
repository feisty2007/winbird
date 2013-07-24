object Form1: TForm1
  Left = 235
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Windows XP SP2 CD-Key '#24207#21495#26356#25442#22120
  ClientHeight = 243
  ClientWidth = 464
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
  object lbl1: TLabel
    Left = 32
    Top = 16
    Width = 107
    Height = 13
    Caption = #24403#21069'Windows CD-Key'
  end
  object Label1: TLabel
    Left = 32
    Top = 64
    Width = 84
    Height = 13
    Caption = #36755#20837#26032#30340'CD-Key'
  end
  object txt_oldcdkey: TStaticText
    Left = 32
    Top = 40
    Width = 64
    Height = 17
    Alignment = taCenter
    Caption = 'txt_oldcdkey'
    TabOrder = 0
  end
  object LabeledEdit1: TLabeledEdit
    Left = 32
    Top = 144
    Width = 121
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = #29992#25143#21517
    TabOrder = 1
  end
  object LabeledEdit2: TLabeledEdit
    Left = 32
    Top = 200
    Width = 121
    Height = 21
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = #32452#32455
    TabOrder = 2
  end
  object medt1: TMaskEdit
    Left = 32
    Top = 88
    Width = 392
    Height = 21
    EditMask = '000000\-00000\-00000\-00000\-00000;1;_'
    MaxLength = 30
    TabOrder = 3
    Text = '      -     -     -     -     '
  end
  object btn1: TButton
    Left = 368
    Top = 200
    Width = 75
    Height = 25
    Caption = #20462#25913
    TabOrder = 4
    OnClick = btn1Click
  end
end
