object fmChannelSettings: TfmChannelSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Channel settings'
  ClientHeight = 310
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object laChannels: TLabel
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    Caption = 'Channels'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laChannelName: TLabel
    Left = 200
    Top = 27
    Width = 87
    Height = 13
    Caption = 'laChannelName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laWidth: TLabel
    Left = 208
    Top = 78
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object shColor: TShape
    Left = 289
    Top = 133
    Width = 48
    Height = 25
  end
  object laPrecision: TLabel
    Left = 208
    Top = 106
    Width = 42
    Height = 13
    Caption = 'Precision'
  end
  object cbVisible: TCheckBox
    Left = 208
    Top = 46
    Width = 65
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Visible'
    TabOrder = 1
    OnClick = cbVisibleClick
  end
  object seWidth: TSpinEdit
    Left = 264
    Top = 69
    Width = 73
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 3
    Value = 1
    OnChange = SpinEditChange
  end
  object bbColor: TBitBtn
    Left = 208
    Top = 133
    Width = 75
    Height = 25
    Caption = 'Color...'
    TabOrder = 4
    OnClick = bbColorClick
  end
  object btClose: TButton
    Left = 375
    Top = 277
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object lbChannels: TCheckListBox
    Left = 24
    Top = 27
    Width = 161
    Height = 275
    OnClickCheck = lbChannelsClickCheck
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbChannelsClick
  end
  object sePrec: TSpinEdit
    Left = 264
    Top = 97
    Width = 73
    Height = 22
    MaxValue = 2
    MinValue = 0
    TabOrder = 2
    Value = 2
    OnChange = SpinEditChange
  end
  object ColorDialog: TColorDialog
    Left = 232
    Top = 248
  end
end
