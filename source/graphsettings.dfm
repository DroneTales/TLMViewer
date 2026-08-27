object fmGraphSettings: TfmGraphSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Global Graph Settings'
  ClientHeight = 376
  ClientWidth = 326
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
  object laTitle: TLabel
    Left = 8
    Top = 16
    Width = 170
    Height = 13
    Caption = 'Manage Global Graph Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laSubRitle: TLabel
    Left = 32
    Top = 35
    Width = 270
    Height = 13
    Caption = 'This is global settings for the graph applied to any graph'
  end
  object beTop: TBevel
    Left = 8
    Top = 54
    Width = 310
    Height = 10
    Shape = bsBottomLine
  end
  object laXAxisColor: TLabel
    Left = 32
    Top = 86
    Width = 57
    Height = 13
    Caption = 'X Axis Color'
  end
  object beBottom: TBevel
    Left = 13
    Top = 324
    Width = 305
    Height = 10
    Shape = bsBottomLine
  end
  object sbSelectXAxisColor: TSpeedButton
    Left = 229
    Top = 77
    Width = 23
    Height = 22
    Hint = 'Select X Axis Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbSelectXAxisColorClick
  end
  object shXAxisColor: TShape
    Left = 134
    Top = 77
    Width = 89
    Height = 22
  end
  object laLegendColor: TLabel
    Left = 32
    Top = 114
    Width = 63
    Height = 13
    Caption = 'Legend Color'
  end
  object shLegendColor: TShape
    Left = 134
    Top = 105
    Width = 89
    Height = 22
  end
  object sbLegendColor: TSpeedButton
    Left = 229
    Top = 105
    Width = 23
    Height = 22
    Hint = 'Select Legend Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbLegendColorClick
  end
  object laTitleColor: TLabel
    Left = 32
    Top = 142
    Width = 48
    Height = 13
    Caption = 'Title Color'
  end
  object shTitleColor: TShape
    Left = 134
    Top = 133
    Width = 89
    Height = 22
  end
  object sbTitleColor: TSpeedButton
    Left = 229
    Top = 133
    Width = 23
    Height = 22
    Hint = 'Select Graph Title Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbTitleColorClick
  end
  object laBackground: TLabel
    Left = 32
    Top = 170
    Width = 84
    Height = 13
    Caption = 'Background Color'
  end
  object shBackground: TShape
    Left = 134
    Top = 161
    Width = 89
    Height = 22
  end
  object sbBackground: TSpeedButton
    Left = 229
    Top = 161
    Width = 23
    Height = 22
    Hint = 'Select Graph Background Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbBackgroundClick
  end
  object laGridColor: TLabel
    Left = 32
    Top = 198
    Width = 47
    Height = 13
    Caption = 'Grid Color'
  end
  object shGridColor: TShape
    Left = 134
    Top = 189
    Width = 89
    Height = 22
  end
  object sbGridColor: TSpeedButton
    Left = 229
    Top = 189
    Width = 23
    Height = 22
    Hint = 'Select Graph Grid Lines Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbGridColorClick
  end
  object laTrackColor: TLabel
    Left = 32
    Top = 226
    Width = 54
    Height = 13
    Caption = 'Track Color'
  end
  object shTrackColor: TShape
    Left = 134
    Top = 217
    Width = 89
    Height = 22
  end
  object sbTrackColor: TSpeedButton
    Left = 229
    Top = 217
    Width = 23
    Height = 22
    Hint = 'Select Track Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbTrackColorClick
  end
  object laToolbarSize: TLabel
    Left = 32
    Top = 282
    Width = 57
    Height = 13
    Caption = 'Toolbar size'
  end
  object laDataHintColor: TLabel
    Left = 32
    Top = 254
    Width = 73
    Height = 13
    Caption = 'Data Hint Color'
  end
  object shDataHintColor: TShape
    Left = 134
    Top = 245
    Width = 89
    Height = 22
  end
  object sbDataHintColor: TSpeedButton
    Left = 229
    Top = 245
    Width = 23
    Height = 22
    Hint = 'Select Data Hint Font Color'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    OnClick = sbDataHintColorClick
  end
  object btOK: TButton
    Left = 146
    Top = 340
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btCancel: TButton
    Left = 227
    Top = 340
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btDefault: TButton
    Left = 20
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Default'
    TabOrder = 3
    OnClick = btDefaultClick
  end
  object seToolbarSize: TSpinEdit
    Left = 133
    Top = 273
    Width = 90
    Height = 22
    EditorEnabled = False
    Increment = 16
    MaxValue = 256
    MinValue = 16
    TabOrder = 0
    Value = 16
  end
  object cbSaveZooming: TCheckBox
    Left = 32
    Top = 301
    Width = 97
    Height = 17
    Caption = 'Save zooming'
    TabOrder = 1
  end
  object cbSimpleSettings: TCheckBox
    Left = 155
    Top = 301
    Width = 97
    Height = 17
    Caption = 'Simple settings'
    TabOrder = 2
  end
  object ColorDialog: TColorDialog
    Left = 272
    Top = 120
  end
end
