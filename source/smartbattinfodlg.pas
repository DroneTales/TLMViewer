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

unit smartbattinfodlg;

interface

uses
  Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, System.Classes, spektrum;

type
  TfmSmartBattInforDlg = class(TForm)
    laChemTitle: TLabel;
    laCellsTitle: TLabel;
    laManuTitle: TLabel;
    Bevel: TBevel;
    laCyclesTitle: TLabel;
    laIdTitle: TLabel;
    laId: TLabel;
    laFullCapTitle: TLabel;
    laDiscTitle: TLabel;
    laOverDiscTitle: TLabel;
    laLvcTitle: TLabel;
    laFullChargeTitle: TLabel;
    laMibTempTitle: TLabel;
    laMaxTempTitle: TLabel;
    laMaxTemp: TLabel;
    laMinTemp: TLabel;
    laFullCharge: TLabel;
    laLvc: TLabel;
    laOverDischarge: TLabel;
    laDischarge: TLabel;
    laCapacity: TLabel;
    laCycles: TLabel;
    laManufacturer: TLabel;
    laCells: TLabel;
    laChemistry: TLabel;
    btClose: TButton;

  public
    class procedure ShowDialog(const Num: Byte;
      const Session: TTelemetrySession);
  end;

implementation

{$R *.dfm}

uses
  main, SysUtils;

{ TfmSmartBattInforDlg }

class procedure TfmSmartBattInforDlg.ShowDialog(const Num: Byte;
  const Session: TTelemetrySession);
var
  Dlg: TfmSmartBattInforDlg;
  Batt: STRU_SMARTBATT.TSmartBatteryInfo;
  Id: STRU_SMARTBATT.TSmartBatteryId;
  Limits: STRU_SMARTBATT.TSmartBatteryLimits;
  i: Integer;
begin
  Dlg := TfmSmartBattInforDlg.Create(fmMain);

  Dlg.laId.Caption := '';
  Dlg.laMaxTemp.Caption := '';
  Dlg.laMinTemp.Caption := '';
  Dlg.laFullCharge.Caption := '';
  Dlg.laLvc.Caption := '';
  Dlg.laOverDischarge.Caption := '';
  Dlg.laDischarge.Caption := '';
  Dlg.laCapacity.Caption := '';
  Dlg.laCycles.Caption := '';
  Dlg.laManufacturer.Caption := '';
  Dlg.laCells.Caption := '';
  Dlg.laChemistry.Caption := '';

  for i := 0 to Length(Session.SmartBatts) - 1 do begin
    if Session.SmartBatts[i].Index = Num then begin
      Batt := Session.SmartBatts[i];
      Break;
    end;
  end;

  if Batt.IdSet then begin
    Id := Batt.Id;

    Dlg.laId.Caption := IntToHex(Id.Id[0], 2) + IntToHex(Id.Id[1], 2) +
      IntToHex(Id.Id[2], 2) + IntToHex(Id.Id[3], 2) + IntToHex(Id.Id[4], 2) +
      IntToHex(Id.Id[5], 2) + IntToHex(Id.Id[6], 2) + IntToHex(Id.Id[7], 2);
    case Id.Chemistry of
      0: Dlg.laChemistry.Caption := 'LiHv';
      1: Dlg.laChemistry.Caption := 'LiPo';
      2: Dlg.laChemistry.Caption := 'LiIon';
      3: Dlg.laChemistry.Caption := 'LiFe';
      4: Dlg.laChemistry.Caption := 'Pb';
      5: Dlg.laChemistry.Caption := 'Ni-MH/Cd';
      else Dlg.laChemistry.Caption := 'Unknown';
    end;
    Dlg.laCells.Caption := IntToStr(Id.Cells);
    Dlg.laManufacturer.Caption := IntToStr(Id.Manufacturer);
    Dlg.laCycles.Caption := IntToStr(Id.Cycles);
  end;

  if Batt.LimitsSet then begin
    Limits := Batt.Limits;

    Dlg.laCapacity.Caption := IntToStr(Limits.FullCapacity);
    Dlg.laDischarge.Caption := Format('%.1f', [Limits.DischargeCurrentRating]);
    Dlg.laOverDischarge.Caption := IntToStr(Limits.OverDischarge);
    Dlg.laLvc.Caption := IntToStr(Limits.ZeroCapacity);
    Dlg.laFullCharge.Caption := IntToStr(Limits.FullyCharged);
    Dlg.laMinTemp.Caption := IntToStr(Limits.MinWorkingTemp);
    Dlg.laMaxTemp.Caption := IntToStr(Limits.MaxWorkingTemp);
  end;

  Dlg.ShowModal;
  Dlg.Free;
end;

end.
