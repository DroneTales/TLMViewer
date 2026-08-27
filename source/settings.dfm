object fmSettings: TfmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Application Settings'
  ClientHeight = 459
  ClientWidth = 445
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
  DesignSize = (
    445
    459)
  PixelsPerInch = 96
  TextHeight = 13
  object beBottom: TBevel
    Left = 10
    Top = 407
    Width = 426
    Height = 10
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object btOK: TButton
    Left = 156
    Top = 427
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 237
    Top = 427
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 425
    Height = 393
    ActivePage = tsModel
    DoubleBuffered = True
    ParentDoubleBuffered = False
    Style = tsFlatButtons
    TabOrder = 2
    object tsGlobalSettings: TTabSheet
      Caption = 'Global Settings'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        417
        362)
      object laTitle: TLabel
        Left = 8
        Top = 16
        Width = 151
        Height = 13
        Caption = 'Global Application Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object laSubTitle: TLabel
        Left = 32
        Top = 35
        Width = 223
        Height = 13
        Caption = 'Here you can adjust global application settings'
      end
      object beTop: TBevel
        Left = 3
        Top = 54
        Width = 414
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
        ExplicitWidth = 286
      end
      object laTempUnits: TLabel
        Left = 18
        Top = 255
        Width = 62
        Height = 13
        Caption = 'Temperature'
      end
      object laLengthUnits: TLabel
        Left = 210
        Top = 255
        Width = 82
        Height = 13
        Caption = 'Distance/Altitude'
      end
      object laPostprocessing: TLabel
        Left = 3
        Top = 290
        Width = 86
        Height = 13
        Caption = 'Postprocessing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object laApperture: TLabel
        Left = 18
        Top = 344
        Width = 89
        Height = 13
        Caption = 'Smoothing window'
      end
      object laParser: TLabel
        Left = 18
        Top = 83
        Width = 31
        Height = 13
        Caption = 'Parser'
      end
      object laTimeZone: TLabel
        Left = 219
        Top = 130
        Width = 48
        Height = 13
        Caption = 'Time zone'
      end
      object laUnits: TLabel
        Left = 3
        Top = 226
        Width = 29
        Height = 13
        Caption = 'Units'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object beUnits: TBevel
        Left = 38
        Top = 226
        Width = 379
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object beCommonSettings: TBevel
        Left = 59
        Top = 105
        Width = 358
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object bePostProcessing: TBevel
        Left = 95
        Top = 290
        Width = 322
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object laFiltering: TLabel
        Left = 18
        Top = 318
        Width = 38
        Height = 13
        Caption = 'Filtering'
      end
      object laAltZeroProcessing: TLabel
        Left = 3
        Top = 162
        Width = 106
        Height = 13
        Caption = 'AltZero processing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object beAltZeroProcessing: TBevel
        Left = 115
        Top = 162
        Width = 302
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object laAltZeroProcessingForVariometer: TLabel
        Left = 151
        Top = 191
        Width = 52
        Height = 13
        Caption = 'Variometer'
      end
      object laAltZeroProcessingForGps: TLabel
        Left = 289
        Top = 191
        Width = 19
        Height = 13
        Caption = 'GPS'
      end
      object laCommonSettings: TLabel
        Left = 3
        Top = 107
        Width = 50
        Height = 13
        Caption = 'Common'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object laAltZeroProcessingForAltimeter: TLabel
        Left = 18
        Top = 191
        Width = 43
        Height = 13
        Caption = 'Altimeter'
      end
      object cbTempUnits: TComboBox
        Left = 86
        Top = 252
        Width = 90
        Height = 21
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = False
        TabOrder = 7
        Items.Strings = (
          'Celcius'
          'Fahrenheit')
      end
      object cbLengthUnits: TComboBox
        Left = 298
        Top = 252
        Width = 90
        Height = 21
        Style = csDropDownList
        TabOrder = 8
        Items.Strings = (
          'Metric'
          'Imperial')
      end
      object cbPostProcessing: TComboBox
        Left = 62
        Top = 314
        Width = 188
        Height = 21
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 9
        Text = 'Simple filter'
        OnChange = cbPostProcessingChange
        Items.Strings = (
          'None'
          'Simple filter'
          'Peak filter'
          'Smooth')
      end
      object tbApperture: TTrackBar
        Left = 108
        Top = 340
        Width = 150
        Height = 21
        Max = 6
        Min = 1
        Position = 1
        PositionToolTip = ptTop
        TabOrder = 11
      end
      object cbParser: TComboBox
        Left = 55
        Top = 80
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'New parser (recommended)'
        Items.Strings = (
          'New parser (recommended)'
          'Old parser (legacy)'
          'Ask each time')
      end
      object cbEnabledRxFiltering: TCheckBox
        Left = 264
        Top = 314
        Width = 115
        Height = 17
        Caption = 'Enable RX filtering'
        TabOrder = 10
      end
      object cbUseMenuForColumns: TCheckBox
        Left = 18
        Top = 129
        Width = 157
        Height = 17
        Caption = 'Use menu for Columns Editor'
        TabOrder = 2
      end
      object cbTimeZone: TComboBox
        Left = 273
        Top = 127
        Width = 115
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        Items.Strings = (
          'USE SYSTEM'
          'UTC-12:00'
          'UTC-11:00'
          'UTC-10:00'
          'UTC-09:30'
          'UTC-09:00'
          'UTC-08:00'
          'UTC-07:00'
          'UTC-06:00'
          'UTC-05:00'
          'UTC-04:00'
          'UTC-03:30'
          'UTC-03:00'
          'UTC-02:00'
          'UTC-01:00'
          'UTC+00:00'
          'UTC+01:00'
          'UTC+02:00'
          'UTC+03:00'
          'UTC+03:30'
          'UTC+04:00'
          'UTC+04:30'
          'UTC+05:00'
          'UTC+05:30'
          'UTC+05:45'
          'UTC+06:00'
          'UTC+06:30'
          'UTC+07:00'
          'UTC+08:00'
          'UTC+08:45'
          'UTC+09:00'
          'UTC+09:30'
          'UTC+10:00'
          'UTC+10:30'
          'UTC+11:00'
          'UTC+12:00'
          'UTC+12:45'
          'UTC+13:00'
          'UTC+14:00')
      end
      object cbFixNameReading: TCheckBox
        Left = 236
        Top = 82
        Width = 178
        Height = 17
        Caption = 'Fix name reading (experimental)'
        TabOrder = 1
      end
      object cbAltZeroProcessingForVariometer: TComboBox
        Left = 209
        Top = 188
        Width = 74
        Height = 22
        Style = csOwnerDrawFixed
        ItemIndex = 0
        TabOrder = 5
        Text = 'Ignore'
        Items.Strings = (
          'Ignore'
          'Virtual'
          'Real')
      end
      object cbAltZeroProcessingForGps: TComboBox
        Left = 314
        Top = 188
        Width = 74
        Height = 22
        Style = csOwnerDrawFixed
        ItemIndex = 0
        TabOrder = 6
        Text = 'Ignore'
        Items.Strings = (
          'Ignore'
          'Virtual')
      end
      object cbAltZeroProcessingForAltimeter: TComboBox
        Left = 67
        Top = 188
        Width = 74
        Height = 22
        Style = csOwnerDrawFixed
        ItemIndex = 0
        TabOrder = 4
        Text = 'Ignore'
        Items.Strings = (
          'Ignore'
          'Virtual'
          'Real')
      end
    end
    object tsModel: TTabSheet
      Caption = 'tsModel'
      ImageIndex = 1
      DesignSize = (
        417
        362)
      object laAFade: TLabel
        Left = 23
        Top = 141
        Width = 32
        Height = 13
        Caption = 'A fade'
        Enabled = False
      end
      object laModelTitle: TLabel
        Left = 8
        Top = 16
        Width = 128
        Height = 13
        Caption = 'Model specific settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object laModelSubTitle: TLabel
        Left = 32
        Top = 35
        Width = 207
        Height = 13
        Caption = 'Here you can adjust model specific settings'
      end
      object beWarnings: TBevel
        Left = 0
        Top = 91
        Width = 414
        Height = 10
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object laBFade: TLabel
        Left = 117
        Top = 141
        Width = 31
        Height = 13
        Caption = 'B fade'
        Enabled = False
      end
      object laRFade: TLabel
        Left = 302
        Top = 141
        Width = 32
        Height = 13
        Caption = 'R fade'
        Enabled = False
      end
      object laLFade: TLabel
        Left = 210
        Top = 141
        Width = 30
        Height = 13
        Caption = 'L fade'
        Enabled = False
      end
      object laTotalFades: TLabel
        Left = 50
        Top = 168
        Width = 54
        Height = 13
        Caption = 'Total fades'
        Enabled = False
      end
      object laFrameLoss: TLabel
        Left = 166
        Top = 168
        Width = 51
        Height = 13
        Caption = 'Frame loss'
        Enabled = False
      end
      object laHolds: TLabel
        Left = 279
        Top = 168
        Width = 26
        Height = 13
        Caption = 'Holds'
        Enabled = False
      end
      object laTimegap: TLabel
        Left = 23
        Top = 244
        Width = 43
        Height = 13
        Caption = 'Time gap'
        Enabled = False
      end
      object laMs: TLabel
        Left = 142
        Top = 244
        Width = 13
        Height = 13
        Caption = 'ms'
        Enabled = False
      end
      object beTimeGap: TBevel
        Left = 0
        Top = 195
        Width = 414
        Height = 11
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object edAFade: TEdit
        Left = 61
        Top = 138
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 1
        Text = '0'
      end
      object edBFade: TEdit
        Left = 154
        Top = 138
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 2
        Text = '0'
      end
      object edRFade: TEdit
        Left = 340
        Top = 138
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 4
        Text = '0'
      end
      object edLFade: TEdit
        Left = 246
        Top = 138
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 3
        Text = '0'
      end
      object edTotalFades: TEdit
        Left = 110
        Top = 165
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 5
        Text = '0'
      end
      object edFrameLoss: TEdit
        Left = 223
        Top = 165
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 6
        Text = '0'
      end
      object edHolds: TEdit
        Left = 311
        Top = 165
        Width = 50
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        NumbersOnly = True
        TabOrder = 7
        Text = '0'
      end
      object cbUse: TCheckBox
        Left = 8
        Top = 107
        Width = 209
        Height = 17
        Caption = 'Enable telemetry warnings'
        TabOrder = 0
        OnClick = cbUseClick
      end
      object cbTimegap: TCheckBox
        Left = 8
        Top = 212
        Width = 190
        Height = 17
        Caption = 'Enable time gap warning'
        TabOrder = 8
        OnClick = cbTimegapClick
      end
      object edTimegap: TEdit
        Left = 71
        Top = 242
        Width = 65
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        TabOrder = 9
        Text = '44'
      end
    end
  end
end
