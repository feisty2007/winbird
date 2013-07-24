object Form1: TForm1
  Left = 205
  Top = 155
  BorderStyle = bsDialog
  Caption = 'Network Tools'
  ClientHeight = 606
  ClientWidth = 862
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
    Left = 32
    Top = 40
    Width = 817
    Height = 545
    ActivePage = ts2
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Ping'
      object grp1: TGroupBox
        Left = 40
        Top = 24
        Width = 737
        Height = 57
        Caption = 'Input IP Address '
        TabOrder = 0
        object edt_IP: TEdit
          Left = 40
          Top = 16
          Width = 481
          Height = 21
          TabOrder = 0
        end
        object btn_Ping: TButton
          Left = 568
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Ping'
          TabOrder = 1
          OnClick = btn_PingClick
        end
      end
      object lst_Result: TListBox
        Left = 40
        Top = 96
        Width = 737
        Height = 393
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ts2: TTabSheet
      Caption = 'Trace Route'
      ImageIndex = 1
      object grp2: TGroupBox
        Left = 32
        Top = 24
        Width = 729
        Height = 65
        Caption = 'Input Host'
        TabOrder = 0
        object edt1: TEdit
          Left = 32
          Top = 16
          Width = 553
          Height = 21
          TabOrder = 0
        end
        object btn_tracert: TButton
          Left = 616
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Trace'
          TabOrder = 1
          OnClick = btn_tracertClick
        end
      end
      object mmResult: TMemo
        Left = 32
        Top = 104
        Width = 729
        Height = 385
        TabOrder = 1
      end
    end
  end
  object idcmpclnt1: TIdIcmpClient
    OnReply = idcmpclnt1Reply
    Left = 724
    Top = 248
  end
  object IdIcmpClient1: TIdIcmpClient
    OnReply = IdIcmpClient1Reply
    Left = 500
    Top = 216
  end
end
