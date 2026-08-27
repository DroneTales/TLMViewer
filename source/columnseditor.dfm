object fmColumnsEditor: TfmColumnsEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Columns Visability Editor'
  ClientHeight = 371
  ClientWidth = 370
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
  object btOK: TButton
    Left = 206
    Top = 338
    Width = 75
    Height = 25
    Caption = '&Save'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 287
    Top = 338
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object lbColumns: TCheckListBox
    Left = 16
    Top = 8
    Width = 346
    Height = 324
    ItemHeight = 13
    TabOrder = 2
  end
  object btHideAll: TButton
    Left = 16
    Top = 338
    Width = 75
    Height = 25
    Caption = 'Hide all'
    TabOrder = 3
    OnClick = btHideAllClick
  end
  object btShowAll: TButton
    Left = 97
    Top = 338
    Width = 75
    Height = 25
    Caption = 'Show all'
    TabOrder = 4
    OnClick = btShowAllClick
  end
end
