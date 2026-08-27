object fmChangePolesAndRatio: TfmChangePolesAndRatio
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change Poles and Ratio'
  ClientHeight = 214
  ClientWidth = 320
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object gbStandard: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 73
    Caption = 'Standard Telemetry'
    TabOrder = 0
    object laStdPoles: TLabel
      Left = 32
      Top = 32
      Width = 25
      Height = 13
      Caption = 'Poles'
    end
    object laStdRatio: TLabel
      Left = 152
      Top = 32
      Width = 25
      Height = 13
      Caption = 'Ratio'
    end
    object edStdPoles: TEdit
      Left = 63
      Top = 29
      Width = 74
      Height = 21
      Alignment = taRightJustify
      TabOrder = 0
      Text = '0'
    end
    object edStdRatio: TEdit
      Left = 183
      Top = 29
      Width = 74
      Height = 21
      Alignment = taRightJustify
      TabOrder = 1
      Text = '0.00'
    end
  end
  object gnEsc: TGroupBox
    Left = 8
    Top = 96
    Width = 297
    Height = 73
    Caption = 'ESC Telemetry'
    TabOrder = 1
    object laEscPoles: TLabel
      Left = 32
      Top = 32
      Width = 25
      Height = 13
      Caption = 'Poles'
    end
    object laEscRatio: TLabel
      Left = 152
      Top = 32
      Width = 25
      Height = 13
      Caption = 'Ratio'
    end
    object edEscPoles: TEdit
      Left = 63
      Top = 29
      Width = 74
      Height = 21
      Alignment = taRightJustify
      TabOrder = 0
      Text = '0'
    end
    object edEscRatio: TEdit
      Left = 183
      Top = 29
      Width = 74
      Height = 21
      Alignment = taRightJustify
      TabOrder = 1
      Text = '0.00'
    end
  end
  object btAll: TButton
    Left = 68
    Top = 175
    Width = 75
    Height = 25
    Caption = 'All'
    ModalResult = 12
    TabOrder = 2
  end
  object btSelected: TButton
    Left = 149
    Top = 175
    Width = 75
    Height = 25
    Caption = 'Selected'
    ModalResult = 1
    TabOrder = 3
  end
  object btCancel: TButton
    Left = 230
    Top = 175
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
