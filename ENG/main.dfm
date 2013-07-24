object Form1: TForm1
  Left = 386
  Top = 184
  Caption = 'Form1'
  ClientHeight = 523
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    529
    523)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 16
    Top = 32
    Width = 489
    Height = 465
    ActivePage = MultiPrint
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #24212#29992#31243#24207#31649#29702
    end
    object TabSheet2: TTabSheet
      Caption = #31995#32479#21151#33021#22686#24378
      ImageIndex = 1
      object Button1: TButton
        Left = 24
        Top = 16
        Width = 241
        Height = 25
        Caption = #28155#21152#21491#38190#36827#20837#21629#20196#34892#21151#33021
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 24
        Top = 56
        Width = 241
        Height = 25
        Caption = #35299#38500#27880#20876#34920#38145#23450
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button6: TButton
        Left = 24
        Top = 96
        Width = 241
        Height = 25
        Caption = #31105#27490#39537#21160#22120#33258#21160#36816#34892
        TabOrder = 2
        OnClick = Button6Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'IE'#35774#32622
      ImageIndex = 2
      object Button3: TButton
        Left = 56
        Top = 32
        Width = 297
        Height = 25
        Caption = #35299#38500#19981#33021#20462#25913'IE'#20027#39029#30340#38145#23450
        TabOrder = 0
        OnClick = Button3Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = #28165#38500#26080#29992'DLL'#25991#20214
      ImageIndex = 3
      DesignSize = (
        481
        437)
      object ListBox1: TListBox
        Left = 16
        Top = 24
        Width = 353
        Height = 393
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
      object Button4: TButton
        Left = 392
        Top = 24
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #20998#26512
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 392
        Top = 64
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #28165#29702
        TabOrder = 2
        OnClick = Button5Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = #31995#32479#21551#21160#39033#31649#29702
      ImageIndex = 4
    end
    object TabSheet6: TTabSheet
      Caption = #31995#32479#23433#20840
      ImageIndex = 5
      object Button7: TButton
        Left = 48
        Top = 32
        Width = 289
        Height = 25
        Caption = #21024#38500#25152#26377#40664#35748#20849#20139'('#35692#22914'C$,admin$,IPC$)'
        TabOrder = 0
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 48
        Top = 80
        Width = 289
        Height = 25
        Caption = #38450#27490'ICMP'#37325#23450#21521#25253#25991#30340#25915#20987
        TabOrder = 1
        OnClick = Button8Click
      end
    end
    object MultiPrint: TTabSheet
      Caption = 'MultiPrint'
      ImageIndex = 6
    end
  end
end
