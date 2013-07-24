object FormAddProfile: TFormAddProfile
  Left = 320
  Top = 136
  BorderStyle = bsDialog
  Caption = 'Add new Profile'
  ClientHeight = 640
  ClientWidth = 465
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
  object pgc_Profile: TPageControl
    Left = 16
    Top = 16
    Width = 425
    Height = 561
    ActivePage = ts_Gernel
    TabOrder = 0
    object ts_Gernel: TTabSheet
      Caption = 'Gernel'
      object grp_General: TGroupBox
        Left = 24
        Top = 16
        Width = 353
        Height = 201
        Caption = 'General'
        TabOrder = 0
        object lbl_ProfileName: TLabel
          Left = 16
          Top = 32
          Width = 57
          Height = 13
          Caption = 'ProfileName'
        end
        object lbl_Image: TLabel
          Left = 16
          Top = 72
          Width = 32
          Height = 13
          Caption = 'Image:'
        end
        object edt_ProfileName: TEdit
          Left = 96
          Top = 32
          Width = 225
          Height = 21
          TabOrder = 0
        end
        object cbb_ProfileImage: TComboBox
          Left = 96
          Top = 72
          Width = 120
          Height = 74
          Style = csOwnerDrawVariable
          ItemHeight = 68
          TabOrder = 1
          OnDrawItem = cbb_ProfileImageDrawItem
          OnMeasureItem = cbb_ProfileImageMeasureItem
        end
      end
    end
    object ts_Network: TTabSheet
      Caption = 'Network'
      ImageIndex = 1
      object grp_Adapter: TGroupBox
        Left = 8
        Top = 16
        Width = 385
        Height = 105
        Caption = 'Adapter'
        TabOrder = 0
        object cbb_Adapters: TComboBox
          Left = 40
          Top = 48
          Width = 297
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
        end
      end
      object grp_IPAddress: TGroupBox
        Left = 8
        Top = 136
        Width = 385
        Height = 193
        Caption = 'IP Address'
        TabOrder = 1
        object lbl_IP: TLabel
          Left = 48
          Top = 88
          Width = 54
          Height = 13
          Caption = 'IP Address:'
        end
        object lbl_Mask: TLabel
          Left = 32
          Top = 120
          Width = 66
          Height = 13
          Caption = 'Subnet Mask:'
        end
        object lbl_DefaultGateWay: TLabel
          Left = 16
          Top = 152
          Width = 85
          Height = 13
          Caption = 'Default GateWay:'
        end
        object rb_DHCP: TRadioButton
          Left = 40
          Top = 32
          Width = 225
          Height = 17
          Caption = 'Auto Obtain an IP Address'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rb_DHCPClick
        end
        object rb_SetIP: TRadioButton
          Left = 40
          Top = 56
          Width = 193
          Height = 17
          Caption = 'Use the following IP Address:'
          TabOrder = 1
          OnClick = rb_SetIPClick
        end
        object ipdrscntrl_IP: TIPAddressControl
          Left = 112
          Top = 80
          Width = 121
          Height = 25
          TabOrder = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        object ipdrscntrl_Mask: TIPAddressControl
          Left = 112
          Top = 112
          Width = 121
          Height = 25
          Field0 = 255
          Field1 = 255
          Field2 = 255
          TabOrder = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        object ipdrscntrl_GateWay: TIPAddressControl
          Left = 112
          Top = 152
          Width = 121
          Height = 25
          TabOrder = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
      end
      object grp_DNS: TGroupBox
        Left = 8
        Top = 336
        Width = 385
        Height = 161
        Caption = 'DNS Server Address'
        TabOrder = 2
        object lbl_PrimaryDNSServer: TLabel
          Left = 40
          Top = 88
          Width = 97
          Height = 13
          Caption = 'Primary DNS Server:'
        end
        object lbl_SecondDNSServer: TLabel
          Left = 40
          Top = 112
          Width = 100
          Height = 13
          Caption = 'Second DNS Server:'
        end
        object rb_AutoDNS: TRadioButton
          Left = 40
          Top = 32
          Width = 257
          Height = 17
          Caption = 'Auto Obtain DNS server address'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rb_AutoDNSClick
        end
        object rb_useDNS: TRadioButton
          Left = 40
          Top = 56
          Width = 249
          Height = 17
          Caption = 'Use follwong DNS server address:'
          TabOrder = 1
          OnClick = rb_useDNSClick
        end
        object ipdrscntrl_PriDNS: TIPAddressControl
          Left = 144
          Top = 80
          Width = 121
          Height = 25
          TabOrder = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        object ipdrscntrl_SecDNS: TIPAddressControl
          Left = 144
          Top = 112
          Width = 121
          Height = 25
          TabOrder = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
      end
      object btn_useCurrentSettings: TButton
        Left = 8
        Top = 504
        Width = 385
        Height = 25
        Action = act_UseCurrentSetting
        TabOrder = 3
      end
    end
    object ts_IE: TTabSheet
      Caption = 'Internet Explorer'
      ImageIndex = 2
      object grp_InternetExploreHomePage: TGroupBox
        Left = 16
        Top = 16
        Width = 377
        Height = 137
        Caption = 'Internet Explore HomePage'
        TabOrder = 0
        object lbl_TypeHomePageUrl: TLabel
          Left = 32
          Top = 48
          Width = 99
          Height = 13
          Caption = 'Type Home Page Url'
        end
        object chk_ChangeIEHomePage: TCheckBox
          Left = 32
          Top = 24
          Width = 153
          Height = 17
          Action = act_IE_ChangeHomePage
          TabOrder = 0
        end
        object edt_IEHomePage: TEdit
          Left = 32
          Top = 72
          Width = 297
          Height = 21
          TabOrder = 1
        end
      end
    end
    object ts_Printers: TTabSheet
      Caption = 'Printer'
      ImageIndex = 3
      object grp_Printers: TGroupBox
        Left = 24
        Top = 16
        Width = 369
        Height = 145
        Caption = 'Printer'
        TabOrder = 0
        object lbl_DefaultPrinter: TLabel
          Left = 24
          Top = 64
          Width = 70
          Height = 13
          Caption = 'Default Printer:'
        end
        object chk_ChagePrinter: TCheckBox
          Left = 24
          Top = 32
          Width = 97
          Height = 17
          Action = act_ChangePrinter
          TabOrder = 0
        end
        object cbb_Printers: TComboBox
          Left = 104
          Top = 64
          Width = 217
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
        end
      end
    end
    object ts_Shell: TTabSheet
      Caption = 'Shell'
      ImageIndex = 4
      object grp_ShellCommand: TGroupBox
        Left = 16
        Top = 16
        Width = 377
        Height = 137
        Caption = 'Shell Command'
        TabOrder = 0
        object chk_ExecuteShellCommand: TCheckBox
          Left = 24
          Top = 24
          Width = 249
          Height = 17
          Action = act_Shell_Cmd
          TabOrder = 0
        end
        object btn_BrowseShellCmd: TButton
          Left = 280
          Top = 80
          Width = 75
          Height = 25
          Caption = 'Browse..'
          TabOrder = 1
        end
        object edt_ShellCommand: TEdit
          Left = 24
          Top = 48
          Width = 329
          Height = 21
          TabOrder = 2
        end
      end
    end
  end
  object btn_OK: TBitBtn
    Left = 24
    Top = 592
    Width = 75
    Height = 25
    Action = act_ProfileOK
    TabOrder = 1
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 360
    Top = 592
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object actlst_dhcp: TActionList
    Left = 240
    Top = 592
    object act_ProfileOK: TAction
      Caption = 'OK'
      OnExecute = act_ProfileOKExecute
      OnUpdate = act_ProfileOKUpdate
    end
    object act_UseCurrentSetting: TAction
      Caption = 'Use Current Network Settings'
      OnExecute = act_UseCurrentSettingExecute
    end
    object act_ChangePrinter: TAction
      Caption = 'Change Printer'
      OnUpdate = act_ChangePrinterUpdate
    end
    object act_IE_ChangeHomePage: TAction
      Caption = 'Change Home Page'
      OnUpdate = act_IE_ChangeHomePageUpdate
    end
    object act_Shell_Cmd: TAction
      Caption = 'Execute Shell Command'
      OnUpdate = act_Shell_CmdUpdate
    end
  end
end
