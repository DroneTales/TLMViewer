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

unit channelsettings;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.CheckLst, System.Classes,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Dialogs, SLScope;

type
  TfmChannelSettings = class(TForm)
    laChannels: TLabel;
    laChannelName: TLabel;
    cbVisible: TCheckBox;
    seWidth: TSpinEdit;
    laWidth: TLabel;
    bbColor: TBitBtn;
    shColor: TShape;
    btClose: TButton;
    ColorDialog: TColorDialog;
    lbChannels: TCheckListBox;
    laPrecision: TLabel;
    sePrec: TSpinEdit;
    procedure bbColorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbChannelsClick(Sender: TObject);
    procedure lbChannelsClickCheck(Sender: TObject);
    procedure cbVisibleClick(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);

  private
    FScope: TSLScope;
    FDisableUpdates: Boolean;

    procedure UpdateChannel;
  end;

implementation

uses
  Graphics, UITypes, graph, SLDataDisplay;

{$R *.dfm}

procedure TfmChannelSettings.bbColorClick(Sender: TObject);
begin
  ColorDialog.Color := shColor.Brush.Color;
  if ColorDialog.Execute then begin
    shColor.Brush.Color := ColorDialog.Color;
    UpdateChannel;
  end;
end;

procedure TfmChannelSettings.cbVisibleClick(Sender: TObject);
begin
  lbChannels.Checked[lbChannels.ItemIndex] := cbVisible.Checked;

  UpdateChannel;
end;

procedure TfmChannelSettings.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FScope := TfmGraph(Owner).SLScope;

  for i := 0 to FScope.Channels.Count - 1 do begin
    lbChannels.Items.Add(FScope.Channels[i].YAxis.AxisLabel.Text);
    lbChannels.Checked[i] := FScope.Channels[i].Visible;
  end;

  shColor.Brush.Color := FScope.Channels[0].Color;

  lbChannels.ItemIndex := 0;

  lbChannelsClick(lbChannels);
end;

procedure TfmChannelSettings.lbChannelsClick(Sender: TObject);
var
  Ndx: Integer;
  Channel: TSLScopeChannel;
  Axis: TSLDisplayYAxis;
begin
  FDisableUpdates := True;
  try
    Ndx := lbChannels.ItemIndex;

    laChannelName.Caption := lbChannels.Items[Ndx];
    cbVisible.Checked := lbChannels.Checked[Ndx];

    Channel := FScope.Channels[Ndx];
    shColor.Brush.Color := Channel.Color;
    seWidth.Value := Channel.Width;

    if Ndx = 0 then
      Axis := FScope.YAxis
    else
      Axis := Channel.YAxis;
    sePrec.Value := Axis.Format.Precision;

  finally
    FDisableUpdates := False;
  end;
end;

procedure TfmChannelSettings.lbChannelsClickCheck(Sender: TObject);
begin
  cbVisible.Checked := lbChannels.Checked[lbChannels.ItemIndex];

  UpdateChannel;
end;

procedure TfmChannelSettings.SpinEditChange(Sender: TObject);
begin
  UpdateChannel;
end;

procedure TfmChannelSettings.UpdateChannel;
var
  Ndx: Integer;
  Axis: TSLDisplayYAxis;
  AColor: TColor;
  Channel: TSLScopeChannel;
begin
  if not FDisableUpdates then begin
    Ndx := lbChannels.ItemIndex;

    Channel := FScope.Channels[Ndx];
    if Ndx = 0 then
      Axis := FScope.YAxis
    else
      Axis := Channel.YAxis;
    AColor := shColor.Brush.Color;

    Channel.Visible := lbChannels.Checked[Ndx];
    Channel.Color := AColor;
    Channel.Width := seWidth.Value;

    Axis.Color := AColor;
    Axis.Font.Color := AColor;
    Axis.AxisLabel.Font.Color := AColor;

    if not Axis.Format.FixedPrecision then
      Axis.Format.FixedPrecision := True;
    Axis.Format.Precision := sePrec.Value;
  end;
end;

end.
