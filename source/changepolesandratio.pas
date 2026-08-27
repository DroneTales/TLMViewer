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

unit changepolesandratio;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, System.Classes;

type
  TfmChangePolesAndRatio = class(TForm)
    gbStandard: TGroupBox;
    laStdPoles: TLabel;
    edStdPoles: TEdit;
    laStdRatio: TLabel;
    edStdRatio: TEdit;
    gnEsc: TGroupBox;
    laEscPoles: TLabel;
    laEscRatio: TLabel;
    edEscPoles: TEdit;
    edEscRatio: TEdit;
    btAll: TButton;
    btSelected: TButton;
    btCancel: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    procedure ShowDlg(const Msg: string);
  end;

implementation

{$R *.dfm}

uses
  SysUtils, Dialogs, System.UITypes;

procedure TfmChangePolesAndRatio.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  b: Integer;
  r: Single;
begin
  CanClose := False;

  if ModalResult = mrCancel then
    CanClose := True

  else begin
    if not TryStrToInt(edStdPoles.Text, b) then
      ShowDlg('Wrong value for Standard Telemetry Poles')
    else begin
      if (b < 0) or (b > 255) then
        ShowDlg('Correct value for Standard Telemetry Poles is between 0 and 255')
      else begin
        if not TryStrToFloat(edStdRatio.Text, r) then
          ShowDlg('Wrong value for Standard Telemetry Ratio')
        else begin
          if r < 0 then
            ShowDlg('Correct value for Standard Telemetry Ratio is positive')
          else begin
            if not TryStrToInt(edEscPoles.Text, b) then
              ShowDlg('Wrong value for ESC Telemetry Poles')
            else begin
              if (b < 0) or (b > 255) then
                ShowDlg('Correct value for ESC Telemetry Poles is between 0 and 255')
              else begin
                if not TryStrToFloat(edEscRatio.Text, r) then
                  ShowDlg('Wrong value for ESC Telemetry Ratio')
                else begin
                  if r < 0 then
                    ShowDlg('Correct value for ESC Telemetry Ratio is positive')
                  else
                    CanClose := True;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmChangePolesAndRatio.ShowDlg(const Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOK], 0)
end;

end.
