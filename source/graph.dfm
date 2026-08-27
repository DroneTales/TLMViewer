object fmGraph: TfmGraph
  Left = 0
  Top = 0
  Caption = 'Graph Data'
  ClientHeight = 509
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SLScope: TSLScope
    Left = 0
    Top = 0
    Width = 772
    Height = 509
    Align = alClient
    PopupMenu = PopupMenu
    ToolBar.Buttons.Setup.OnClick = SLScopeToolBarButtonsSetupClick
    ToolBar.Buttons.Run.Visible = False
    ToolBar.Buttons.Run.Enabled = False
    ToolBar.Buttons.Hold.Visible = False
    ToolBar.Buttons.Hold.Enabled = False
    TabOrder = 0
    OnOverChannel = SLScopeOverChannel
    OnLeaveChannel = SLScopeLeaveChannel
    YAxis.Button.OnClick = SLScopeYAxisButtonClick
    YAxis.OnCustomLabel = AxisCustomLable
    XAxis.Button.OnClick = SLScopeXAxisButtonClick
    XAxis.AxisLabel.Text = 'Time'
    XAxis.OnCustomLabel = SLScopeXAxisCustomLabel
    XAxis.DataView.ZeroLine.Visible = False
    Legend.Channels.OnItemClick = SLScopeLegendChannelsItemClick
    Channels = <
      item
        Name = 'Channel0'
      end>
    OnCustomMouseHitLabel = SLScopeCustomMouseHitLabel
  end
  object PopupMenu: TPopupMenu
    Left = 472
    Top = 184
    object miCopyToClipboard: TMenuItem
      Caption = 'Copy to clipboard'
      ShortCut = 16451
      OnClick = miCopyToClipboardClick
    end
    object miSeparator1: TMenuItem
      Caption = '-'
    end
    object miSettings: TMenuItem
      Caption = 'Settings...'
      OnClick = miSettingsClick
    end
  end
end
