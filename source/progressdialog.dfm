object fmProgressDialog: TfmProgressDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Loading Telemetry File...'
  ClientHeight = 122
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object laFileNameCaption: TLabel
    Left = 16
    Top = 8
    Width = 75
    Height = 14
    Caption = 'Loading file:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object laFileName: TLabel
    Left = 97
    Top = 8
    Width = 56
    Height = 14
    Caption = 'laFileName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 40
    Width = 395
    Height = 25
    DoubleBuffered = True
    ParentDoubleBuffered = False
    Smooth = True
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 168
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btCancelClick
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 376
    Top = 36
  end
end
