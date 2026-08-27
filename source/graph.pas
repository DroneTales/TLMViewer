////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Copyright (c) 2015 Mikhail (Mike) Petrichenko. All rights reserved.        //
//                                                                            //
// This program is free software: you can redistribute it and/or modify       //
// it under the terms of the GNU Affero General Public License as published   //
// by the Free Software Foundation, either version 3 of the License, or       //
// (at your option) any later version.                                        //
//                                                                            //
// As a special exception under Section 7 of the GNU AGPLv3, the copyright    //
// holder grants permission to statically or dynamically link this program    //
// with DevArt VirtualTable and Mitov Software PlotLab, and to distribute     //
// the resulting combined executable without the obligation to disclose the   //
// source code of those specific commercial libraries.                        //
//                                                                            //
// All other components, modifications, and derivative works (including       //
// web services/SaaS interacting with this software over a network) must      //
// strictly comply with all terms and conditions of the GNU AGPLv3.           //
//                                                                            //
// This program is distributed in the hope that it will be useful,            //
// but WITHOUT ANY WARRANTY; without even the implied warranty of             //
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               //
// GNU Affero General Public License for more details.                        //
//                                                                            //
// -------------------------------------------------------------------------- //
//                                                                            //
//   https://www.tlmviewer.com                                                //
//   support@tlmviewer.com                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

unit graph;

interface

uses
  Vcl.Forms, System.Classes, Vcl.Controls, Mitov.VCLTypes, VCL.LPControl,
  SLControlCollection, LPControlDrawLayers, SLBasicDataDisplay, SLDataDisplay,
  SLDataChart, SLScope, Vcl.Menus, Vcl.ExtCtrls, Vcl.Graphics, Registry,
  Messages;

type
  TfmGraph = class(TForm)
    SLScope: TSLScope;
    PopupMenu: TPopupMenu;
    miSettings: TMenuItem;
    miCopyToClipboard: TMenuItem;
    miSeparator1: TMenuItem;
    procedure SLScopeXAxisCustomLabel(Sender: TObject; SampleValue: Real;
      var AxisLabel: string);
    procedure FormCreate(Sender: TObject);
    procedure SLScopeLeaveChannel(Sender: TObject);
    procedure SLScopeCustomMouseHitLabel(Sender: TObject; XValue: Real;
      YValue: Real; var AxisLabel: string);
    procedure SLScopeOverChannel(Sender: TObject; ChannelIndex: Integer;
      BeginSampleIndex: Integer; EndSampleIndex: Integer;
      ClickedValue: TSLRealPoint);
    procedure AxisCustomLable(Sender: TObject; SampleValue: Real;
      var AxisLabel: string);
    procedure miSettingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miCopyToClipboardClick(Sender: TObject);
    procedure SLScopeToolBarButtonsSetupClick(Sender: TObject;
      var Handled: Boolean);
    procedure SLScopeLegendChannelsItemClick(Sender: TObject;
      ChannelIndex: Integer; var Handled: Boolean);
    procedure SLScopeXAxisButtonClick(Sender: TObject; var Handled: Boolean);
    procedure SLScopeYAxisButtonClick(Sender: TObject; var Handled: Boolean);

  private
    FChannel: TSLScopeChannel;
    FSaveZooming: Boolean;
    FSimpleSettings: Boolean;

    procedure SetLinkedColors;

    procedure ShowSettingsDialog;

    function ReadBool(const Reg: TRegistry; const ValueName: string;
      const Default: Boolean): Boolean;
    function ReadColor(const Reg: TRegistry; const ValueName: string;
      const Default: TColor): TColor;
    function ReadInt(const Reg: TRegistry; const ValueName: string;
      const Default: Integer): Integer;

    procedure WriteBool(const Reg: TRegistry; const ValueName: string;
      const Val: Boolean);
    procedure WriteColor(const Reg: TRegistry; const ValueName: string;
      const Color: TColor);
    procedure WriteFloat(const Reg: TRegistry; const ValueName: string;
      const Val: Real);
    procedure WriteInt(const Reg: TRegistry; const ValueName: string;
      const Val: Integer);

    procedure SaveZooming;
    procedure LoadZooming;

    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  end;

const
  CHANNEL_TAG_NONE = 0;
  CHANNEL_TAG_TIME = 1;

implementation

{$R *.dfm}

uses
  SysUtils, spektrum, graphsettings, System.UITypes, Windows, channelsettings;

procedure TfmGraph.AxisCustomLable(Sender: TObject; SampleValue: Real;
  var AxisLabel: string);
var
  I: Integer;
  Channel: TSLScopeChannel;
begin
  for I := 0 to SLScope.Channels.Count - 1 do begin
    Channel := SLScope.Channels[I];
    if (Channel.YAxis = Sender) and (Channel.Tag = CHANNEL_TAG_TIME) then
      AxisLabel := ConvertTime(Abs(Round(SampleValue)));
  end;
end;

procedure TfmGraph.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
begin
  FChannel := nil;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\GraphGlobal', False) then begin
      SLScope.XAxis.Color := ReadColor(Reg, 'XAxix', SLScope.XAxis.Color);
      SLScope.Legend.Font.Color := ReadColor(Reg, 'Legend',
        SLScope.Legend.Labels.Caption.Font.Color);
      SLScope.Title.Font.Color := ReadColor(Reg, 'Title',
        SLScope.Title.Font.Color);
      SLScope.Color := ReadColor(Reg, 'Background', SLScope.Color);
      SLScope.DataView.Border.Pen.Color := ReadColor(Reg, 'Grid',
        SLScope.DataView.Border.Pen.Color);
      SLScope.YAxis.TrackColor := ReadColor(Reg, 'TrackColor',
        SLScope.YAxis.TrackColor);
      SLScope.Highlighting.MouseHitPoint.PointLabel.Font.Color := ReadColor(Reg,
        'DataHintColor',
        SLScope.Highlighting.MouseHitPoint.PointLabel.Font.Color);

      SLScope.ToolBar.Buttons.Size.Height := ReadInt(Reg, 'ToobarSize',
        SLScope.ToolBar.Buttons.Size.Height);
      SLScope.ToolBar.Buttons.Size.Width := SLScope.ToolBar.Buttons.Size.Height;

      SLScope.NavigateMode := TSLDisplayNavigateMode(ReadInt(Reg, 'NavMode',
        Integer(nmZoom)));

      FSaveZooming := ReadBool(Reg, 'SaveZooming', False);
      FSimpleSettings := ReadBool(Reg, 'SimpleSettings', True);
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmGraph.FormDestroy(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\GraphGlobal', True) then begin
      WriteColor(Reg, 'XAxix', SLScope.XAxis.Color);
      WriteColor(Reg, 'Legend', SLScope.Legend.Font.Color);
      WriteColor(Reg, 'Title', SLScope.Title.Font.Color);
      WriteColor(Reg, 'Background', SLScope.Color);
      WriteColor(Reg, 'Grid', SLScope.DataView.Border.Pen.Color);
      WriteColor(Reg, 'TrackColor', SLScope.YAxis.TrackColor);
      WriteColor(Reg, 'DataHintColor',
        SLScope.Highlighting.MouseHitPoint.PointLabel.Font.Color);

      WriteInt(Reg, 'ToobarSize', SLScope.ToolBar.Buttons.Size.Height);
      WriteInt(Reg, 'NavMode', Integer(SLScope.NavigateMode));

      WriteBool(Reg, 'SaveZooming', FSaveZooming);
      WriteBool(Reg, 'SimpleSettings', FSimpleSettings);
    end;

  finally
    Reg.Free;
  end;

  SaveZooming;
end;

procedure TfmGraph.FormShow(Sender: TObject);
var
  I: Integer;
begin
  SetLinkedColors;

  LoadZooming;

  // OnClick handlers for all Y axis
  for I := 0 to SLScope.YAxis.AdditionalAxes.Count - 1 do
    SLScope.YAxis.AdditionalAxes[I].Axis.Button.OnClick := SLScopeYAxisButtonClick;
end;

procedure TfmGraph.SaveZooming;
var
  Reg: TRegistry;
  I: Integer;
  ChName: string;
begin
  if not FSaveZooming then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\GraphZoom', True) then begin
      WriteBool(Reg, 'Zoomed', SLScope.Zooming.IsZoomed);
      if SLScope.Zooming.IsZoomed then begin
        WriteFloat(Reg, 'XAxix_Min', SLScope.XAxis.Zooming.Min);
        WriteFloat(Reg, 'XAxix_Max', SLScope.XAxis.Zooming.Max);

        for I := 0 to SLScope.Channels.Count - 1 do begin
          ChName := SLScope.Channels[I].Name;
          WriteFloat(Reg, ChName + '_min',
            SLScope.Channels[I].YAxis.Zooming.Min);
          WriteFloat(Reg, ChName + '_max',
            SLScope.Channels[I].YAxis.Zooming.Max);
        end;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmGraph.LoadZooming;
var
  Reg: TRegistry;
  I: Integer;
  ChName: string;
  Min: Real;
  Max: Real;
  Zoomed: Boolean;
begin
  if not FSaveZooming then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\GraphZoom', False) then begin
      Zoomed := ReadBool(Reg, 'Zoomed', False);
      if Zoomed then begin
        if Reg.ValueExists('XAxix_Min') and Reg.ValueExists('XAxix_Max') then
        begin
          Min := Reg.ReadFloat('XAxix_Min');
          Max := Reg.ReadFloat('XAxix_Max');
          SLScope.XAxis.ZoomToData(Min, Max, True);
        end;

        for I := 0 to SLScope.Channels.Count - 1 do begin
          chName := SLScope.Channels[I].Name;
          if Reg.ValueExists(chName + '_min') and Reg.ValueExists(chName + '_max') then
          begin
            Min := Reg.ReadFloat(ChName + '_min');
            Max := Reg.ReadFloat(ChName + '_max');
            SLScope.Channels[I].YAxis.ZoomToData(Min, Max, True);
          end;
        end;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmGraph.miCopyToClipboardClick(Sender: TObject);
begin
  SLScope.ToolBar.Buttons.Copy.PerformClick;
end;

procedure TfmGraph.miSettingsClick(Sender: TObject);
var
  Form: TfmGraphSettings;
begin
  Form := TfmGraphSettings.Create(Self);
  try
    Form.shXAxisColor.Brush.Color := SLScope.XAxis.Color;
    Form.shLegendColor.Brush.Color := SLScope.Legend.Font.Color;
    Form.shTitleColor.Brush.Color := SLScope.Title.Font.Color;
    Form.shBackground.Brush.Color := SLScope.Color;
    Form.shGridColor.Brush.Color := SLScope.DataView.Border.Pen.Color;
    Form.shTrackColor.Brush.Color := SLScope.YAxis.TrackColor;
    Form.shDataHintColor.Brush.Color :=
      SLScope.Highlighting.MouseHitPoint.PointLabel.Font.Color;
    Form.cbSaveZooming.Checked := FSaveZooming;
    Form.cbSimpleSettings.Checked := FSimpleSettings;

    Form.seToolbarSize.Value := SLScope.ToolBar.Buttons.Size.Height;

    if Form.ShowModal = mrOK then begin
      SLScope.XAxis.Color := Form.shXAxisColor.Brush.Color;
      SLScope.Legend.Font.Color := Form.shLegendColor.Brush.Color;
      SLScope.Title.Font.Color := Form.shTitleColor.Brush.Color;
      SLScope.Color := Form.shBackground.Brush.Color;
      SLScope.DataView.Border.Pen.Color := Form.shGridColor.Brush.Color;
      SLScope.YAxis.TrackColor := Form.shTrackColor.Brush.Color;
      SLScope.Highlighting.MouseHitPoint.PointLabel.Font.Color :=
        Form.shDataHintColor.Brush.Color;

      SLScope.ToolBar.Buttons.Size.Height := Form.seToolbarSize.Value;
      SLScope.ToolBar.Buttons.Size.Width := Form.seToolbarSize.Value;

      FSaveZooming := Form.cbSaveZooming.Checked;
      FSimpleSettings := Form.cbSimpleSettings.Checked;

      SetLinkedColors;
    end;

  finally
    Form.Free;
  end;
end;

function TfmGraph.ReadBool(const Reg: TRegistry; const ValueName: string;
  const Default: Boolean): Boolean;
begin
  if Reg.ValueExists(ValueName) then
    Result := Reg.ReadBool(ValueName)
  else
    Result := Default;
end;

function TfmGraph.ReadColor(const Reg: TRegistry; const ValueName: string;
  const Default: TColor): TColor;
begin
  if Reg.ValueExists(ValueName) then
    Result := TColor(Reg.ReadInteger(ValueName))
  else
    Result := Default;
end;

function TfmGraph.ReadInt(const Reg: TRegistry; const ValueName: string;
  const Default: Integer): Integer;
begin
  if Reg.ValueExists(ValueName) then
    Result := Reg.ReadInteger(ValueName)
  else
    Result := Default;
end;

procedure TfmGraph.SetLinkedColors;
var
  I: Integer;
begin
  SLScope.XAxis.DataView.Lines.Pen.Color := SLScope.DataView.Border.Pen.Color;
  SLScope.YAxis.DataView.Lines.Pen.Color := SLScope.DataView.Border.Pen.Color;

  SLScope.XAxis.DataView.ZeroLine.Pen.Color := SLScope.DataView.Border.Pen.Color;
  SLScope.YAxis.DataView.ZeroLine.Pen.Color := SLScope.DataView.Border.Pen.Color;

  SLScope.XAxis.Font.Color := SLScope.XAxis.Color;
  SLScope.XAxis.AxisLabel.Font.Color := SLScope.XAxis.Color;

  SLScope.Legend.Channels.Caption.Font.Color := SLScope.Legend.Font.Color;

  SLScope.XAxis.TrackColor := SLScope.YAxis.TrackColor;
  for I := 0 to SLScope.YAxis.AdditionalAxes.Count - 1 do
    SLScope.YAxis.AdditionalAxes[I].Axis.TrackColor := SLScope.YAxis.TrackColor;
end;

procedure TfmGraph.ShowSettingsDialog;
var
  Frm: TfmChannelSettings;
begin
  Frm := TfmChannelSettings.Create(Self);
  try
    Frm.ShowModal;

    SetLinkedColors;

  finally
    Frm.Free;
  end;
end;

procedure TfmGraph.SLScopeCustomMouseHitLabel(Sender: TObject; XValue: Real;
  YValue: Real; var AxisLabel: string);
begin
  if (FChannel <> nil) and FChannel.YAxis.Format.FixedPrecision then begin
    if FChannel.Tag = CHANNEL_TAG_TIME then
      AxisLabel := ConvertTime(Abs(Round(YValue)))
    else begin
      AxisLabel := Format('%.' +
        IntToStr(FChannel.YAxis.Format.Precision) + 'f', [YValue]);
    end;

    AxisLabel := ConvertTime(Abs(Round(XValue * 100))) + ' : ' + AxisLabel;
  end;
end;

procedure TfmGraph.SLScopeLeaveChannel(Sender: TObject);
begin
  FChannel := nil;
end;

procedure TfmGraph.SLScopeOverChannel(Sender: TObject; ChannelIndex,
  BeginSampleIndex, EndSampleIndex: Integer; ClickedValue: TSLRealPoint);
begin
  FChannel := SLScope.Channels[ChannelIndex];
end;

procedure TfmGraph.SLScopeXAxisCustomLabel(Sender: TObject; SampleValue: Real;
  var AxisLabel: string);
begin
  AxisLabel := ConvertTime(Abs(Round(SampleValue * 100)));

  if SampleValue < 0 then
    AxisLabel := '-' + AxisLabel;
end;

procedure TfmGraph.WMSysCommand(var Message: TWMSysCommand);
begin
  if (fsModal in FormState) or (not Application.MainForm.Visible) then begin
    case Message.CmdType and $FFF0 of
      SC_MINIMIZE:
        ShowWindow(Application.Handle, SW_SHOWMINNOACTIVE);

      SC_RESTORE:
        ShowWindow(Application.Handle, SW_SHOWNORMAL);
    end;
  end;

  inherited;
end;

procedure TfmGraph.WriteBool(const Reg: TRegistry; const ValueName: string;
  const Val: Boolean);
begin
  Reg.WriteBool(ValueName, Val);
end;

procedure TfmGraph.WriteColor(const Reg: TRegistry; const ValueName: string;
  const Color: TColor);
begin
  Reg.WriteInteger(ValueName, Integer(Color));
end;

procedure TfmGraph.WriteFloat(const Reg: TRegistry; const ValueName: string;
  const Val: Real);
begin
  Reg.WriteFloat(ValueName, Val);
end;

procedure TfmGraph.WriteInt(const Reg: TRegistry; const ValueName: string;
  const Val: Integer);
begin
  Reg.WriteInteger(ValueName, Val);
end;

procedure TfmGraph.SLScopeLegendChannelsItemClick(Sender: TObject;
  ChannelIndex: Integer; var Handled: Boolean);
begin
  if FSimpleSettings then begin
    ShowSettingsDialog;
    Handled := True;
  end else
    Handled := False;
end;

procedure TfmGraph.SLScopeToolBarButtonsSetupClick(Sender: TObject;
  var Handled: Boolean);
begin
  if FSimpleSettings then begin
    ShowSettingsDialog;
    Handled := True;
  end else
    Handled := False;
end;

procedure TfmGraph.SLScopeXAxisButtonClick(Sender: TObject;
  var Handled: Boolean);
begin
  if FSimpleSettings then begin
    ShowSettingsDialog;
    Handled := True;
  end else
    Handled := False;
end;

procedure TfmGraph.SLScopeYAxisButtonClick(Sender: TObject;
  var Handled: Boolean);
begin
  if FSimpleSettings then begin
    ShowSettingsDialog;
    Handled := True;
  end else
    Handled := False;
end;

end.
