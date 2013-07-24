object Form1: TForm1
  Left = 315
  Top = 252
  Width = 456
  Height = 317
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 208
    Width = 196
    Height = 29
    Caption = 'Send Manager 0.1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 144
    Top = 248
    Width = 92
    Height = 13
    Cursor = crHandPoint
    Caption = 'camark@sohu.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 64
    Top = 248
    Width = 65
    Height = 13
    AutoSize = False
    Caption = #32852#31995#20316#32773':'
  end
  object BitBtn1: TBitBtn
    Left = 320
    Top = 240
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkClose
  end
  object Memo1: TMemo
    Left = 32
    Top = 24
    Width = 377
    Height = 169
    Lines.Strings = (
      #36825#26159#19968#20010#21491#38190#22686#24378#36719#20214#12290#22312#36164#28304#31649#29702#22120#37324#38754#20219#24847#25991#20214#22841#19978#28857#20987#21491#38190#65292
      #23601#20250#30475#21040#26412#22914#20170#28155#21152#30340#20197'"SM"'#20026#24320#22836#30340#21491#38190#22686#24378#21151#33021#20102#12290
      ''
      #23427#26377#22235#20010#21151#33021':'
      '1-'#25226#19968#20010#25991#20214#22841#28155#21152#21040#20840#23616#36335#24452#65292#36825#26679#20320#23601#21487#20197#22312#20219#24847#22320#28857#25191#34892#36825#20010#25991
      #20214#22841#37324#38754#30340#25991#20214#20102#12290
      '2'#12289#24314#31435#20197#20170#22825#20026#21517#31216#30340#23376#25991#20214#22841
      '3'#12289#25226#19968#20010#25991#20214#22841#28155#21152#21040'"'#21457#36865#21040'"'#33756#21333#37324#38754#12290
      '4'#12289#36805#36895#36827#20837'dos'#29366#24577#12290)
    ReadOnly = True
    TabOrder = 1
  end
end
