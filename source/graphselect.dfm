object fmGraphSelect: TfmGraphSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Data for Graph'
  ClientHeight = 438
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    564
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object laTitle: TLabel
    Left = 8
    Top = 16
    Width = 131
    Height = 13
    Caption = 'Build Data Combination'
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
    Width = 376
    Height = 13
    Caption = 
      'Here you can combine data from different sensors to show them on' +
      ' one graph'
  end
  object beBottom: TBevel
    Left = 8
    Top = 385
    Width = 548
    Height = 10
    Shape = bsBottomLine
  end
  object beTop: TBevel
    Left = 8
    Top = 54
    Width = 548
    Height = 10
    Shape = bsBottomLine
  end
  object lvSensors: TListView
    Left = 8
    Top = 70
    Width = 544
    Height = 309
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
      end
      item
        Caption = 'Data Name'
        Width = 300
      end>
    ColumnClick = False
    DoubleBuffered = True
    GridLines = True
    HideSelection = False
    GroupView = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btOK: TButton
    Left = 384
    Top = 405
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 465
    Top = 405
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
