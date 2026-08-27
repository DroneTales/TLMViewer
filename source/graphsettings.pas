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

unit graphsettings;

interface

uses
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.Buttons, Vcl.Samples.Spin;

type
  TfmGraphSettings = class(TForm)
    laTitle: TLabel;
    laSubRitle: TLabel;
    beTop: TBevel;
    laXAxisColor: TLabel;
    ColorDialog: TColorDialog;
    beBottom: TBevel;
    btOK: TButton;
    btCancel: TButton;
    sbSelectXAxisColor: TSpeedButton;
    shXAxisColor: TShape;
    laLegendColor: TLabel;
    shLegendColor: TShape;
    sbLegendColor: TSpeedButton;
    laTitleColor: TLabel;
    shTitleColor: TShape;
    sbTitleColor: TSpeedButton;
    laBackground: TLabel;
    shBackground: TShape;
    sbBackground: TSpeedButton;
    laGridColor: TLabel;
    shGridColor: TShape;
    sbGridColor: TSpeedButton;
    laTrackColor: TLabel;
    shTrackColor: TShape;
    sbTrackColor: TSpeedButton;
    btDefault: TButton;
    laToolbarSize: TLabel;
    seToolbarSize: TSpinEdit;
    laDataHintColor: TLabel;
    shDataHintColor: TShape;
    sbDataHintColor: TSpeedButton;
    cbSaveZooming: TCheckBox;
    cbSimpleSettings: TCheckBox;
    procedure sbSelectXAxisColorClick(Sender: TObject);
    procedure sbLegendColorClick(Sender: TObject);
    procedure sbTitleColorClick(Sender: TObject);
    procedure sbBackgroundClick(Sender: TObject);
    procedure sbGridColorClick(Sender: TObject);
    procedure sbTrackColorClick(Sender: TObject);
    procedure btDefaultClick(Sender: TObject);
    procedure sbDataHintColorClick(Sender: TObject);

  private
    procedure SelectColor(const Shape: TShape);
  end;

implementation

{$R *.dfm}

uses
  Vcl.Graphics, System.UITypes;

procedure TfmGraphSettings.btDefaultClick(Sender: TObject);
begin
  shXAxisColor.Brush.Color := clWhite;
  shLegendColor.Brush.Color := clWhite;
  shTitleColor.Brush.Color := clWhite;
  shBackground.Brush.Color := clBlack;
  shGridColor.Brush.Color := clGreen;
  shTrackColor.Brush.Color := clRed;
  shDataHintColor.Brush.Color := clWhite;

  seToolbarSize.Value := 16;

  cbSaveZooming.Checked := False;
  cbSimpleSettings.Checked := True;

  ModalResult := mrOK;
end;

procedure TfmGraphSettings.sbBackgroundClick(Sender: TObject);
begin
  SelectColor(shBackground);
end;

procedure TfmGraphSettings.sbDataHintColorClick(Sender: TObject);
begin
  SelectColor(shDataHintColor);
end;

procedure TfmGraphSettings.sbGridColorClick(Sender: TObject);
begin
  SelectColor(shGridColor);
end;

procedure TfmGraphSettings.sbLegendColorClick(Sender: TObject);
begin
  SelectColor(shLegendColor);
end;

procedure TfmGraphSettings.sbSelectXAxisColorClick(Sender: TObject);
begin
  SelectColor(shXAxisColor);
end;

procedure TfmGraphSettings.sbTitleColorClick(Sender: TObject);
begin
  SelectColor(shTitleColor);
end;

procedure TfmGraphSettings.sbTrackColorClick(Sender: TObject);
begin
  SelectColor(shTrackColor);
end;

procedure TfmGraphSettings.SelectColor(const Shape: TShape);
begin
  ColorDialog.Color := Shape.Brush.Color;
  if ColorDialog.Execute then
    Shape.Brush.Color := ColorDialog.Color;
end;

end.
