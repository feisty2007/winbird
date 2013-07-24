object Form1: TForm1
  Left = 369
  Top = 275
  Width = 434
  Height = 320
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object rg_CaptureOption: TRadioGroup
    Left = 24
    Top = 16
    Width = 361
    Height = 137
    Caption = 'Capture Option'
    ItemIndex = 0
    Items.Strings = (
      'Whole Desktop'
      'Active Window'
      'Active Window With Title Bar')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 176
    Width = 121
    Height = 25
    Caption = 'Turn Off Monitor'
    TabOrder = 1
    OnClick = TurnoffMonitor
  end
end
