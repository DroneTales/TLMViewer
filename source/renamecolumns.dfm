object fmRenameColumns: TfmRenameColumns
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Rename User Sensor Columns'
  ClientHeight = 441
  ClientWidth = 442
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
  object Label1: TLabel
    Left = 40
    Top = 16
    Width = 363
    Height = 13
    Caption = 
      'In this dialog you can rename fields for the User Defined sensor' +
      's'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object veColumns: TValueListEditor
    Left = 8
    Top = 48
    Width = 426
    Height = 353
    DisplayOptions = [doColumnTitles, doKeyColFixed]
    FixedCols = 1
    TabOrder = 0
    TitleCaptions.Strings = (
      'Default Field Name'
      'New Field Name')
  end
  object btOK: TButton
    Left = 263
    Top = 407
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 344
    Top = 407
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btDefault: TButton
    Left = 16
    Top = 407
    Width = 75
    Height = 25
    Caption = '&Default'
    TabOrder = 3
    OnClick = btDefaultClick
  end
end
