object BatchConvert: TBatchConvert
  Left = 281
  Top = 326
  Width = 669
  Height = 410
  Caption = 'Batch Convert'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Ready: TLabel
    Left = 24
    Top = 280
    Width = 31
    Height = 13
    Caption = 'Ready'
  end
  object grp1: TGroupBox
    Left = 24
    Top = 16
    Width = 617
    Height = 249
    Caption = 'Select some mp3 file'
    TabOrder = 0
    object lst_MP3Files: TListBox
      Left = 16
      Top = 32
      Width = 489
      Height = 193
      ItemHeight = 13
      TabOrder = 0
    end
    object btnSelect: TButton
      Left = 528
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Select'
      TabOrder = 1
      OnClick = btnSelectClick
    end
    object btn_Start: TButton
      Left = 528
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = btn_StartClick
    end
  end
  object pb_Convert: TProgressBar
    Left = 24
    Top = 304
    Width = 617
    Height = 33
    TabOrder = 1
  end
  object dlgOpen1: TOpenDialog
    Filter = 'MP3 File(*.mp3)|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 464
    Top = 272
  end
end
