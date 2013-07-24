object Form1: TForm1
  Left = 322
  Top = 237
  BorderStyle = bsDialog
  Caption = 'MP3 Rename'
  ClientHeight = 610
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_msg: TLabel
    Left = 24
    Top = 344
    Width = 35
    Height = 13
    Caption = 'lbl_msg'
  end
  object grp1: TGroupBox
    Left = 24
    Top = 32
    Width = 553
    Height = 97
    Caption = 'Select File'
    TabOrder = 0
    object edt_Mp3File: TEdit
      Left = 24
      Top = 32
      Width = 401
      Height = 21
      TabOrder = 0
    end
    object btn1: TButton
      Left = 448
      Top = 32
      Width = 75
      Height = 25
      Caption = '..'
      TabOrder = 1
      OnClick = btn1Click
    end
  end
  object btn_Read: TButton
    Left = 24
    Top = 144
    Width = 75
    Height = 25
    Caption = 'id3v1'
    TabOrder = 1
    OnClick = btn_ReadClick
  end
  object grp_Result: TGroupBox
    Left = 24
    Top = 184
    Width = 553
    Height = 153
    Caption = 'Result'
    TabOrder = 2
    object lblTitle: TLabel
      Left = 96
      Top = 24
      Width = 30
      Height = 13
      Caption = 'lblTitle'
    end
    object lbl_Title: TLabel
      Left = 24
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object lbl_Artist: TLabel
      Left = 24
      Top = 48
      Width = 23
      Height = 13
      Caption = 'Artist'
    end
    object lblArtist: TLabel
      Left = 96
      Top = 48
      Width = 33
      Height = 13
      Caption = 'lblArtist'
    end
    object lbl_Comment: TLabel
      Left = 24
      Top = 72
      Width = 44
      Height = 13
      Caption = 'Comment'
    end
    object lblComment: TLabel
      Left = 96
      Top = 72
      Width = 54
      Height = 13
      Caption = 'lblComment'
    end
    object lbl_Album: TLabel
      Left = 24
      Top = 96
      Width = 29
      Height = 13
      Caption = 'Album'
    end
    object lblAlbum: TLabel
      Left = 96
      Top = 96
      Width = 39
      Height = 13
      Caption = 'lblAlbum'
    end
    object lbl_Year: TLabel
      Left = 288
      Top = 16
      Width = 22
      Height = 13
      Caption = 'Year'
    end
    object lblYear: TLabel
      Left = 368
      Top = 16
      Width = 32
      Height = 13
      Caption = 'lblYear'
    end
    object lbl_Genre: TLabel
      Left = 288
      Top = 40
      Width = 29
      Height = 13
      Caption = 'Genre'
    end
    object lblGenre: TLabel
      Left = 368
      Top = 40
      Width = 39
      Height = 13
      Caption = 'lblGenre'
    end
  end
  object btn_Write: TButton
    Left = 344
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 3
    OnClick = btn_WriteClick
  end
  object btn_BatchConvert: TButton
    Left = 480
    Top = 144
    Width = 105
    Height = 25
    Caption = 'BatchConvert'
    TabOrder = 4
    OnClick = btn_BatchConvertClick
  end
  object btn_ReadAPETag: TButton
    Left = 104
    Top = 144
    Width = 75
    Height = 25
    Caption = 'APETag'
    TabOrder = 5
    OnClick = btn_ReadAPETagClick
  end
  object lst_ApeTag: TListBox
    Left = 24
    Top = 368
    Width = 553
    Height = 225
    ItemHeight = 13
    TabOrder = 6
  end
  object btn_ReadWMA: TButton
    Left = 184
    Top = 144
    Width = 75
    Height = 25
    Caption = 'WMA'
    TabOrder = 7
    OnClick = btn_ReadWMAClick
  end
  object chk_ApeTag: TCheckBox
    Left = 416
    Top = 152
    Width = 65
    Height = 17
    Caption = 'ApeTag'
    TabOrder = 8
  end
  object id3v2: TButton
    Left = 264
    Top = 144
    Width = 75
    Height = 25
    Caption = 'id3v2'
    TabOrder = 9
    OnClick = id3v2Click
  end
  object btn2: TButton
    Left = 496
    Top = 344
    Width = 75
    Height = 25
    Caption = 'MP3 Change'
    TabOrder = 10
    OnClick = btn2Click
  end
  object dlgOpen1: TOpenDialog
    Filter = 'MP3 File(*.mp3)|*.mp3|WMA File(*.wma0|*.wma'
    Left = 520
    Top = 336
  end
end
