object fmOffsets: TfmOffsets
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AltZero offsets'
  ClientHeight = 316
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object laTitle: TLabel
    Left = 16
    Top = 16
    Width = 310
    Height = 18
    Caption = 'AltZero offsets stored in the TLM sesstion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 32
    Top = 48
    Width = 288
    Height = 13
    Caption = 'The table below shows when the Altitude was reset to zero.'
  end
  object lvOffsets: TListView
    Left = 16
    Top = 80
    Width = 593
    Height = 185
    Columns = <
      item
        Caption = 'Timestamp'
        Width = 100
      end
      item
        Caption = 'AltZero Offset'
        Width = 100
      end
      item
        Caption = 'File position'
        Width = 100
      end
      item
        Caption = 'Raw data'
        Width = 250
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btDelete: TButton
    Left = 16
    Top = 283
    Width = 75
    Height = 25
    Action = acDelete
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btSave: TButton
    Left = 453
    Top = 283
    Width = 75
    Height = 25
    Action = acSave
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object btCanlcel: TButton
    Left = 534
    Top = 283
    Width = 75
    Height = 25
    Action = acCancel
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object ActionList: TActionList
    Left = 136
    Top = 168
    object acDelete: TAction
      Caption = '&Delete'
      Hint = 'Delete selected offset'
      OnExecute = acDeleteExecute
      OnUpdate = acDeleteUpdate
    end
    object acSave: TAction
      Caption = '&Save'
      Hint = 'Save changes'
      OnExecute = acSaveExecute
      OnUpdate = acSaveUpdate
    end
    object acCancel: TAction
      Caption = '&Cancel'
      Hint = 'Close dialog'
      ShortCut = 27
      OnExecute = acCancelExecute
      OnUpdate = acCancelUpdate
    end
  end
end
