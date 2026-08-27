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

unit settings;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, System.Classes,
  Vcl.ComCtrls;

type
  TfmSettings = class(TForm)
    beBottom: TBevel;
    btOK: TButton;
    btCancel: TButton;
    PageControl: TPageControl;
    tsGlobalSettings: TTabSheet;
    laTitle: TLabel;
    laSubTitle: TLabel;
    beTop: TBevel;
    laTempUnits: TLabel;
    cbTempUnits: TComboBox;
    laLengthUnits: TLabel;
    cbLengthUnits: TComboBox;
    laPostprocessing: TLabel;
    cbPostProcessing: TComboBox;
    laApperture: TLabel;
    tbApperture: TTrackBar;
    tsModel: TTabSheet;
    laAFade: TLabel;
    laModelTitle: TLabel;
    laModelSubTitle: TLabel;
    beWarnings: TBevel;
    edAFade: TEdit;
    laBFade: TLabel;
    edBFade: TEdit;
    laRFade: TLabel;
    edRFade: TEdit;
    laLFade: TLabel;
    edLFade: TEdit;
    laTotalFades: TLabel;
    edTotalFades: TEdit;
    laFrameLoss: TLabel;
    edFrameLoss: TEdit;
    laHolds: TLabel;
    edHolds: TEdit;
    cbUse: TCheckBox;
    laParser: TLabel;
    cbParser: TComboBox;
    cbEnabledRxFiltering: TCheckBox;
    cbTimegap: TCheckBox;
    laTimegap: TLabel;
    edTimegap: TEdit;
    laMs: TLabel;
    cbUseMenuForColumns: TCheckBox;
    cbTimeZone: TComboBox;
    laTimeZone: TLabel;
    cbFixNameReading: TCheckBox;
    beTimeGap: TBevel;
    laUnits: TLabel;
    beUnits: TBevel;
    beCommonSettings: TBevel;
    bePostProcessing: TBevel;
    laFiltering: TLabel;
    laAltZeroProcessing: TLabel;
    beAltZeroProcessing: TBevel;
    laAltZeroProcessingForVariometer: TLabel;
    cbAltZeroProcessingForVariometer: TComboBox;
    laAltZeroProcessingForGps: TLabel;
    cbAltZeroProcessingForGps: TComboBox;
    laCommonSettings: TLabel;
    laAltZeroProcessingForAltimeter: TLabel;
    cbAltZeroProcessingForAltimeter: TComboBox;
    procedure cbPostProcessingChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbTimegapClick(Sender: TObject);
    procedure cbUseClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TfmSettings.cbPostProcessingChange(Sender: TObject);
begin
  laApperture.Enabled := cbPostProcessing.ItemIndex = 3;
  tbApperture.Enabled := laApperture.Visible;
  cbEnabledRxFiltering.Enabled := cbPostProcessing.ItemIndex > 1;

  if cbPostProcessing.ItemIndex > 0 then
    cbTimegap.Checked := False;
  cbTimegap.Enabled := cbPostProcessing.ItemIndex = 0;

  cbTimegapClick(cbTimegap);
end;

procedure TfmSettings.cbTimegapClick(Sender: TObject);
begin
  laTimegap.Enabled := cbTimegap.Checked;
  laMs.Enabled := cbTimegap.Checked;

  edTimegap.Enabled := cbTimegap.Checked;

  if cbTimegap.Checked then
    cbUse.Checked := False;
end;

procedure TfmSettings.cbUseClick(Sender: TObject);
begin
  if cbUse.Checked then
    cbTimegap.Checked := False;

  laAFade.Enabled := cbUse.Checked;
  laBFade.Enabled := cbUse.Checked;
  laLFade.Enabled := cbUse.Checked;
  laRFade.Enabled := cbUse.Checked;
  laTotalFades.Enabled := cbUse.Checked;
  laFrameLoss.Enabled := cbUse.Checked;
  laHolds.Enabled := cbUse.Checked;

  edAFade.Enabled := cbUse.Checked;
  edBFade.Enabled := cbUse.Checked;
  edLFade.Enabled := cbUse.Checked;
  edRFade.Enabled := cbUse.Checked;
  edTotalFades.Enabled := cbUse.Checked;
  edFrameLoss.Enabled := cbUse.Checked;
  edHolds.Enabled := cbUse.Checked;
end;

procedure TfmSettings.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;

procedure TfmSettings.FormShow(Sender: TObject);
begin
  laApperture.Enabled := cbPostProcessing.ItemIndex = 3;
  tbApperture.Enabled := laApperture.Visible;
  cbEnabledRxFiltering.Enabled := cbPostProcessing.ItemIndex > 1;

  if cbPostProcessing.ItemIndex > 0 then
    cbTimegap.Checked := False;
  cbTimegap.Enabled := cbPostProcessing.ItemIndex = 0;

  cbTimegapClick(cbTimegap);
end;

end.
