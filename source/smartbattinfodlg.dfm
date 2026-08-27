object fmSmartBattInforDlg: TfmSmartBattInforDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Smart Battery Information'
  ClientHeight = 309
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object laChemTitle: TLabel
    Left = 45
    Top = 64
    Width = 61
    Height = 13
    Caption = 'Chemistry:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laCellsTitle: TLabel
    Left = 45
    Top = 83
    Width = 76
    Height = 13
    Caption = 'Cells number:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laManuTitle: TLabel
    Left = 45
    Top = 102
    Width = 80
    Height = 13
    Caption = 'Manufacturer:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel: TBevel
    Left = 8
    Top = 48
    Width = 422
    Height = 4
    Shape = bsTopLine
  end
  object laCyclesTitle: TLabel
    Left = 45
    Top = 121
    Width = 39
    Height = 13
    Caption = 'Cycles:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laIdTitle: TLabel
    Left = 45
    Top = 16
    Width = 16
    Height = 13
    Caption = 'ID:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laId: TLabel
    Left = 183
    Top = 16
    Width = 22
    Height = 13
    Caption = 'laId'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laFullCapTitle: TLabel
    Left = 45
    Top = 140
    Width = 112
    Height = 13
    Caption = 'Full capacity (mAh):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laDiscTitle: TLabel
    Left = 45
    Top = 159
    Width = 106
    Height = 13
    Caption = 'Discharge rate (C):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laOverDiscTitle: TLabel
    Left = 45
    Top = 178
    Width = 119
    Height = 13
    Caption = 'Over discharge (mV):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laLvcTitle: TLabel
    Left = 45
    Top = 197
    Width = 116
    Height = 13
    Caption = 'LVC protection (mV):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laFullChargeTitle: TLabel
    Left = 45
    Top = 216
    Width = 102
    Height = 13
    Caption = 'Full charged (mV):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laMibTempTitle: TLabel
    Left = 45
    Top = 235
    Width = 116
    Height = 13
    Caption = 'Min temperature (C)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laMaxTempTitle: TLabel
    Left = 45
    Top = 254
    Width = 123
    Height = 13
    Caption = 'Max temperature (C):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laMaxTemp: TLabel
    Left = 184
    Top = 254
    Width = 54
    Height = 13
    Caption = 'laMaxTemp'
  end
  object laMinTemp: TLabel
    Left = 184
    Top = 235
    Width = 50
    Height = 13
    Caption = 'laMinTemp'
  end
  object laFullCharge: TLabel
    Left = 184
    Top = 216
    Width = 59
    Height = 13
    Caption = 'laFullCharge'
  end
  object laLvc: TLabel
    Left = 184
    Top = 197
    Width = 24
    Height = 13
    Caption = 'laLvc'
  end
  object laOverDischarge: TLabel
    Left = 184
    Top = 178
    Width = 79
    Height = 13
    Caption = 'laOverDischarge'
  end
  object laDischarge: TLabel
    Left = 184
    Top = 159
    Width = 55
    Height = 13
    Caption = 'laDischarge'
  end
  object laCapacity: TLabel
    Left = 184
    Top = 140
    Width = 50
    Height = 13
    Caption = 'laCapacity'
  end
  object laCycles: TLabel
    Left = 184
    Top = 121
    Width = 39
    Height = 13
    Caption = 'laCycles'
  end
  object laManufacturer: TLabel
    Left = 184
    Top = 102
    Width = 73
    Height = 13
    Caption = 'laManufacturer'
  end
  object laCells: TLabel
    Left = 184
    Top = 83
    Width = 30
    Height = 13
    Caption = 'laCells'
  end
  object laChemistry: TLabel
    Left = 183
    Top = 64
    Width = 56
    Height = 13
    Caption = 'laChemistry'
  end
  object btClose: TButton
    Left = 355
    Top = 276
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
