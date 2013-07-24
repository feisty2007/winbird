object Form3: TForm3
  Left = 221
  Top = 153
  Width = 870
  Height = 640
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lv_Files: TListView
    Left = 24
    Top = 64
    Width = 809
    Height = 521
    Columns = <
      item
        Caption = 'FileName'
        Width = 255
      end
      item
        Caption = 'Title'
        Width = 100
      end
      item
        Caption = 'Artist'#13#10
        Width = 100
      end
      item
        Caption = 'Album'
        Width = 100
      end
      item
        Caption = 'Comment'
        Width = 100
      end
      item
        Caption = 'Year'
        Width = 100
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btn_SelectFiles: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Select Files'
    TabOrder = 1
    OnClick = btn_SelectFilesClick
  end
  object btn_Change: TButton
    Left = 112
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Preview'
    TabOrder = 2
    OnClick = btn_ChangeClick
  end
  object btn_Apply: TButton
    Left = 216
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 3
    OnClick = btn_ApplyClick
  end
  object dlgOpenMp3: TOpenDialog
    Filter = 'MP3 File(*.mp3)|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 344
    Top = 216
  end
end
