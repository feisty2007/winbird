object frmOptions: TfrmOptions
  Left = 401
  Top = 216
  BorderStyle = bsDialog
  Caption = 'Option'
  ClientHeight = 437
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 8
    Top = 16
    Width = 433
    Height = 369
    ActivePage = ts_Main
    TabOrder = 0
    object ts_Main: TTabSheet
      Caption = 'Main'
      ImageIndex = 1
    end
    object ts_FileAttribute: TTabSheet
      Caption = 'File Infomation'
      object grp_InCludefileInfo: TGroupBox
        Left = 8
        Top = 16
        Width = 409
        Height = 305
        Caption = 'Include'
        TabOrder = 0
        object chk_FileName: TCheckBox
          Left = 32
          Top = 32
          Width = 97
          Height = 17
          Caption = 'File Name'
          TabOrder = 0
        end
        object chk_FileTypeName: TCheckBox
          Left = 32
          Top = 56
          Width = 145
          Height = 17
          Caption = 'File Type'
          TabOrder = 1
        end
        object chk_FileSize: TCheckBox
          Left = 32
          Top = 88
          Width = 97
          Height = 17
          Caption = 'File Size'
          TabOrder = 2
        end
        object chk_FileTime: TCheckBox
          Left = 32
          Top = 120
          Width = 97
          Height = 17
          Caption = 'File Time'
          TabOrder = 3
        end
        object grp_FileTime: TGroupBox
          Left = 32
          Top = 144
          Width = 361
          Height = 49
          TabOrder = 4
          object chk_ftCreate: TCheckBox
            Left = 16
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Create'
            TabOrder = 0
          end
          object chk_ftModify: TCheckBox
            Left = 120
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Modify'
            TabOrder = 1
          end
          object chk_ftLastAccess: TCheckBox
            Left = 232
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Last Access'
            TabOrder = 2
          end
        end
        object chk_FileAttribute: TCheckBox
          Left = 32
          Top = 208
          Width = 97
          Height = 17
          Caption = 'File Attribute'
          TabOrder = 5
        end
      end
    end
  end
  object btn_OK: TBitBtn
    Left = 272
    Top = 400
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 360
    Top = 400
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
