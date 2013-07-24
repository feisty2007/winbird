object Form1: TForm1
  Left = 262
  Top = 113
  Width = 746
  Height = 675
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
  DesignSize = (
    738
    641)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 16
    Top = 32
    Width = 698
    Height = 583
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Program Manage'
      DesignSize = (
        690
        537)
      object lvSoftware: TListView
        Left = 16
        Top = 24
        Width = 666
        Height = 471
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Name'
            Width = 250
          end
          item
            Caption = 'Publisher'
            Width = 200
          end
          item
            Caption = 'Uninstall Program'
            Width = 400
          end>
        RowSelect = True
        PopupMenu = pm_UninstallProgram
        SmallImages = ilSoftwares
        TabOrder = 0
        ViewStyle = vsReport
        OnDeletion = lvSoftwareDeletion
      end
      object btnReadSoftInstallInfo: TButton
        Left = 16
        Top = 502
        Width = 75
        Height = 25
        Action = act_PM_Read
        Anchors = [akLeft, akBottom]
        TabOrder = 1
      end
      object btnUninstallSoft: TButton
        Left = 128
        Top = 502
        Width = 75
        Height = 25
        Action = act_PM_uninstall
        Anchors = [akLeft, akBottom]
        TabOrder = 2
      end
      object btnHideWinPatch: TButton
        Left = 240
        Top = 502
        Width = 75
        Height = 25
        Action = act_PM_HidePatch
        Anchors = [akLeft, akBottom]
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'System Enchanced'
      ImageIndex = 1
      object Button1: TButton
        Left = 24
        Top = 16
        Width = 241
        Height = 25
        Caption = 'Add Dos Context Menu'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 24
        Top = 56
        Width = 241
        Height = 25
        Caption = 'Unlock Regedit'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button6: TButton
        Left = 24
        Top = 96
        Width = 241
        Height = 25
        Caption = 'No AutoRun'
        TabOrder = 2
        OnClick = Button6Click
      end
      object Button11: TButton
        Left = 24
        Top = 136
        Width = 241
        Height = 25
        Caption = 'Clear Recent Document History'
        TabOrder = 3
      end
      object btn_OrderStartMenuByName: TButton
        Left = 24
        Top = 176
        Width = 241
        Height = 25
        Caption = 'Order StartMenu ByName'
        TabOrder = 4
        OnClick = btn_OrderStartMenuByNameClick
      end
      object btnShowHidden: TButton
        Left = 24
        Top = 216
        Width = 241
        Height = 25
        Caption = 'Show Hidden File'
        TabOrder = 5
        OnClick = btnShowHiddenClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Internet Explorer'
      ImageIndex = 2
      object Button3: TButton
        Left = 56
        Top = 16
        Width = 297
        Height = 25
        Caption = 'Unlock HomePage'
        TabOrder = 0
        OnClick = Button3Click
      end
      object btn_UnlockInternetOption: TButton
        Left = 56
        Top = 56
        Width = 297
        Height = 25
        Caption = 'btn_UnlockInternetOption'
        TabOrder = 1
        OnClick = btn_UnlockInternetOptionClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Clean Unused DLL'
      ImageIndex = 3
      DesignSize = (
        690
        537)
      object Button4: TButton
        Left = 16
        Top = 494
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Anasyle'
        TabOrder = 0
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 593
        Top = 494
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'clear'
        TabOrder = 1
      end
      object pnl1: TPanel
        Left = 16
        Top = 8
        Width = 658
        Height = 471
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        object spl1: TSplitter
          Left = 122
          Top = 1
          Height = 469
        end
        object tv_RegComplete: TTreeView
          Left = 1
          Top = 1
          Width = 121
          Height = 469
          Align = alLeft
          Indent = 19
          TabOrder = 0
        end
        object lv_RegComplete: TListView
          Left = 125
          Top = 1
          Width = 532
          Height = 469
          Align = alClient
          Columns = <
            item
              Caption = 'Category'
              Width = 100
            end
            item
              Caption = 'Data'
              Width = 250
            end>
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Startup Program'
      ImageIndex = 4
      DesignSize = (
        690
        537)
      object lvBootItem: TListView
        Left = 8
        Top = 32
        Width = 674
        Height = 463
        Anchors = [akLeft, akTop, akRight, akBottom]
        Checkboxes = True
        Columns = <
          item
            Caption = 'Name'
            Width = 80
          end
          item
            Caption = 'Path'
            Width = 150
          end
          item
            Caption = 'Register Path'
            Width = 100
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnLoadRegRun: TButton
        Left = 8
        Top = 502
        Width = 113
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Read'
        TabOrder = 1
        OnClick = btnLoadRegRunClick
      end
      object btnRegApplyChange: TButton
        Left = 144
        Top = 502
        Width = 129
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'ApplyChange'
        TabOrder = 2
        OnClick = btnRegApplyChangeClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Security'
      ImageIndex = 5
      object Button7: TButton
        Left = 48
        Top = 32
        Width = 289
        Height = 25
        Caption = 'Delete Default Share(Etc.C$,admin$,IPC$)'
        TabOrder = 0
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 48
        Top = 80
        Width = 289
        Height = 25
        Caption = 'Defend ICMP Attack'
        TabOrder = 1
        OnClick = Button8Click
      end
      object btn_EnableTaskManager: TButton
        Left = 48
        Top = 128
        Width = 289
        Height = 25
        Caption = 'Enable TaskManager'
        TabOrder = 2
        OnClick = btn_EnableTaskManagerClick
      end
    end
    object MultiPrint: TTabSheet
      Caption = 'MultiPrint'
      ImageIndex = 6
      DesignSize = (
        690
        537)
      object lstFiles: TListBox
        Left = 24
        Top = 16
        Width = 570
        Height = 511
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
      object Button9: TButton
        Left = 612
        Top = 16
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Open'
        TabOrder = 1
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 612
        Top = 64
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Print'
        TabOrder = 2
        OnClick = Button10Click
      end
      object btnDeletePrintFile: TButton
        Left = 609
        Top = 104
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnDeletePrintFileClick
      end
    end
    object tsSerivice: TTabSheet
      Caption = 'Service'
      ImageIndex = 8
      DesignSize = (
        690
        537)
      object lvServices: TListView
        Left = 16
        Top = 16
        Width = 658
        Height = 471
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'ServiceName'
            Width = 100
          end
          item
            Caption = 'Description'
            Width = 400
          end
          item
            Caption = 'StartType'
            Width = 100
          end
          item
            Caption = 'State'
          end>
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnReadSerivices: TButton
        Left = 16
        Top = 502
        Width = 113
        Height = 25
        Action = act_NTService_Read
        Anchors = [akLeft, akBottom]
        TabOrder = 1
      end
    end
    object ts_Login: TTabSheet
      Caption = 'Login'
      ImageIndex = 9
      object chk_AutoLogin: TCheckBox
        Left = 32
        Top = 40
        Width = 97
        Height = 17
        Caption = 'AutoLogin'
        TabOrder = 0
        OnClick = chk_AutoLoginClick
      end
      object grp1: TGroupBox
        Left = 32
        Top = 64
        Width = 361
        Height = 177
        Caption = 'Input UserName and Password'
        TabOrder = 1
        object lbl_UserName: TLabel
          Left = 24
          Top = 40
          Width = 49
          Height = 13
          Caption = 'UserName'
        end
        object lbl_Password: TLabel
          Left = 24
          Top = 80
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object edt_UserName: TEdit
          Left = 112
          Top = 40
          Width = 201
          Height = 21
          TabOrder = 0
        end
        object edt_Password: TEdit
          Left = 112
          Top = 72
          Width = 201
          Height = 21
          PasswordChar = '*'
          TabOrder = 1
        end
        object btn_AutoLogin_OK: TButton
          Left = 192
          Top = 120
          Width = 75
          Height = 25
          Caption = 'OK'
          TabOrder = 2
          OnClick = btn_AutoLogin_OKClick
        end
      end
      object grp_LogalNotice: TGroupBox
        Left = 32
        Top = 264
        Width = 369
        Height = 233
        Caption = 'Legal Notice'
        TabOrder = 2
        object lbl_ln_Caption: TLabel
          Left = 16
          Top = 40
          Width = 37
          Height = 13
          Caption = 'Caption'
        end
        object lbl_ln_Text: TLabel
          Left = 16
          Top = 72
          Width = 22
          Height = 13
          Caption = 'Text'
        end
        object edt_ln_Caption: TEdit
          Left = 96
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object mmo_ln_Text: TMemo
          Left = 96
          Top = 72
          Width = 241
          Height = 113
          Lines.Strings = (
            '')
          TabOrder = 1
        end
        object btn_ln_Set: TButton
          Left = 96
          Top = 200
          Width = 75
          Height = 25
          Caption = 'Set'
          TabOrder = 2
          OnClick = btn_ln_SetClick
        end
        object btn_ln_Clear: TButton
          Left = 264
          Top = 200
          Width = 75
          Height = 25
          Caption = 'Clear'
          TabOrder = 3
          OnClick = btn_ln_ClearClick
        end
      end
    end
    object ts_HiddenFolder: TTabSheet
      Caption = 'Hidden Folder'
      ImageIndex = 10
      object lbl1: TLabel
        Left = 40
        Top = 80
        Width = 52
        Height = 13
        Caption = 'Hidden As:'
      end
      object edt_FolderName: TEdit
        Left = 40
        Top = 40
        Width = 489
        Height = 21
        TabOrder = 0
      end
      object btn_SeleFolder: TButton
        Left = 544
        Top = 40
        Width = 97
        Height = 25
        Caption = 'SeleFolder'
        TabOrder = 1
        OnClick = btn_SeleFolderClick
      end
      object cbb_HiddenFolder: TComboBox
        Left = 112
        Top = 72
        Width = 305
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Text = 'cbb_HiddenFolder'
      end
      object btn_HiddenFolder: TButton
        Left = 432
        Top = 72
        Width = 97
        Height = 25
        Action = act_HiddenFolder_Hidden
        TabOrder = 3
      end
      object btn_UnhiddenFolder: TButton
        Left = 544
        Top = 72
        Width = 97
        Height = 25
        Action = act_HiddenFolder_Unhidden
        TabOrder = 4
      end
    end
    object ts_OemInfo: TTabSheet
      Caption = 'OemInfo'
      ImageIndex = 11
      object grp_OemInfo: TGroupBox
        Left = 16
        Top = 184
        Width = 633
        Height = 289
        Caption = 'OemInfo'
        TabOrder = 0
        object lbl_Manu: TLabel
          Left = 40
          Top = 40
          Width = 59
          Height = 13
          Caption = 'Manufactor:'
        end
        object lbl_Oem_Model: TLabel
          Left = 40
          Top = 64
          Width = 28
          Height = 13
          Caption = 'Model'
        end
        object edt_Oem_Menau: TEdit
          Left = 112
          Top = 32
          Width = 465
          Height = 21
          TabOrder = 0
        end
        object edt_Oem_Model: TEdit
          Left = 112
          Top = 56
          Width = 465
          Height = 21
          TabOrder = 1
        end
        object mmo_OEM_Support: TMemo
          Left = 40
          Top = 88
          Width = 537
          Height = 177
          Lines.Strings = (
            '')
          TabOrder = 2
        end
      end
      object btn_Read_OEM: TButton
        Left = 448
        Top = 496
        Width = 75
        Height = 25
        Caption = 'Read OEM'
        TabOrder = 1
        OnClick = btn_Read_OEMClick
      end
      object btn_SetOem: TButton
        Left = 576
        Top = 496
        Width = 75
        Height = 25
        Caption = 'Set OEM'
        TabOrder = 2
        OnClick = btn_SetOemClick
      end
    end
    object ts_ImeTool: TTabSheet
      Caption = 'Input Ime Tool'
      ImageIndex = 12
      object lst_Imes: TListBox
        Left = 24
        Top = 40
        Width = 513
        Height = 393
        ItemHeight = 13
        TabOrder = 0
      end
      object btn_ReadIme: TButton
        Left = 560
        Top = 40
        Width = 75
        Height = 25
        Caption = 'Read Ime'
        TabOrder = 1
        OnClick = btn_ReadImeClick
      end
      object btn_Ime_Up: TButton
        Left = 560
        Top = 80
        Width = 75
        Height = 25
        Action = act_Ime_Up
        TabOrder = 2
      end
      object btn_Ime_Down: TButton
        Left = 560
        Top = 120
        Width = 75
        Height = 25
        Action = act_Ime_Down
        TabOrder = 3
      end
      object btn_Ime_Apply: TButton
        Left = 560
        Top = 160
        Width = 75
        Height = 25
        Action = act_Ime_Apply
        TabOrder = 4
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Word Documnet(*.doc,*.docx)|*.doc;*.docx|Excel Document(*.xls,*.' +
      'xlsx)|*.xls;*.xlsx|All Office File|*.doc;*.docx;*.xls;*.xlsx;*.p' +
      'df|PDF file(*.pdf)|*.pdf'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 416
    Top = 288
  end
  object xpmnfst1: TXPManifest
    Left = 240
    Top = 504
  end
  object ilSoftwares: TImageList
    Left = 380
    Top = 458
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4BF7E00B3902000B28F
      1F00B18F1F00B18E1E00B08D1D00B08D1C00B08C1B00AF8C1A00AE8B1900AE8B
      1800AD8A1800AD8A140000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B7963000C4AA4E00D8C6
      8700D6C48500D4C28300D2C08100D1BE8000CFBC7E00CDBB7B00CCB97900CAB7
      7700CAB67700BAAF8900F9F7F100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B7973100D4C28000FCFC
      FC00FAFAFA00F7F6F6000049DC005D82D500EBEAEC00EBEAE900E8E6E500E5E3
      E200E2E0DE00BBB18D00F9F8F100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8983200D4C28100FCFC
      FC00FCFCFC008FA9E2000964F7000050F700A9BCE2009CA9C6007491D000E7E6
      E500E4E2E100BEB49200FAF8F100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8993400D5C28200FCFC
      FC00FCFCFC005387E600317FFA000D67F700E8E6E500E0DDDC00ADBAD400EAE9
      E700E6E5E400C0B69700FAF8F100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9993500D5C38200FCFC
      FC00FCFCFC00FFFFFF00FEFDFD00DEE6F600BCCFEE00E6E5E4007895D600ECEB
      EB00E9E8E700C3BA9A00FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BA9A3600D6C38300FCFC
      FC008FAAE300FFFFFF00FFFFFF0071A7FB00166DF8000056F700EFEFF000EFED
      ED00EBEAEA00C5BD9F00FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BB9B3800D6C48400FCFC
      FC00FCFCFC0094ADE4009DB5E8005395FD00297AF900075BEB00F4F4F300F1F0
      F000EEECEC00C8C0A400FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC9C3900D6C48400FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC008DA8E3007496DE00F7F6F500F3F3
      F200F1F0F000CBC3A800FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC9D3A00DCCFA400D7C9
      9800D6C69500D3C39000D0C18C00CFBF8900CDBC8600CBBA8200C9B87F00C7B5
      7B00C5B37800CEC5AC00FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD9E3B00F2F0EB00EFEC
      E500EBE8E000E8E5DA00E5E1D400E2DDCF00DFDACA00DCD7C500D9D3C000D6D0
      BA00D3CDB500D0C9B100FAF8F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8962800F4F2EF00F2F0
      EB00EFECE500EBE8E000E8E4DA00E5E1D400E1DDCE00DFDAC900DCD7C400D9D3
      BF00D6D0BA00D3CCB400FCFAF600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      8003000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object pm_UninstallProgram: TPopupMenu
    Left = 340
    Top = 274
    object Uninstall1: TMenuItem
      Caption = 'Uninstall'
      OnClick = btnUninstallSoftClick
    end
  end
  object actlst_Ime: TActionList
    Left = 436
    Top = 610
    object act_Ime_Up: TAction
      Category = 'Ime'
      Caption = 'Up'
      OnExecute = act_Ime_UpExecute
      OnUpdate = act_Ime_UpUpdate
    end
    object act_Ime_Down: TAction
      Category = 'Ime'
      Caption = 'Down'
      OnExecute = act_Ime_DownExecute
      OnUpdate = act_Ime_DownUpdate
    end
    object act_Ime_Apply: TAction
      Category = 'Ime'
      Caption = 'Apply'
      OnExecute = act_Ime_ApplyExecute
      OnUpdate = act_Ime_ApplyUpdate
    end
    object act_PM_Read: TAction
      Category = 'Program Manager'
      Caption = 'Read'
      OnExecute = btnReadSoftInstallInfoClick
    end
    object act_PM_uninstall: TAction
      Category = 'Program Manager'
      Caption = 'Uninstall'
      OnExecute = btnUninstallSoftClick
      OnUpdate = act_PM_uninstallUpdate
    end
    object act_PM_HidePatch: TAction
      Category = 'Program Manager'
      Caption = 'Hide Patch'
      OnExecute = btnHideWinPatchClick
      OnUpdate = act_PM_HidePatchUpdate
    end
    object act_NTService_Read: TAction
      Category = 'Service'
      Caption = 'Read Services'
      OnExecute = btnReadSerivicesClick
    end
    object act_HiddenFolder_Hidden: TAction
      Category = 'HiddenFolder'
      Caption = 'Hidden Folder'
      OnExecute = btn_HiddenFolderClick
      OnUpdate = act_HiddenFolder_HiddenUpdate
    end
    object act_HiddenFolder_Unhidden: TAction
      Category = 'HiddenFolder'
      Caption = 'Unhide Folder'
      OnExecute = btn_UnhiddenFolderClick
      OnUpdate = act_HiddenFolder_UnhiddenUpdate
    end
  end
end
