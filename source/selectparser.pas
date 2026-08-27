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

unit selectparser;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, System.Classes, Vcl.ExtCtrls;

type
  TfmSelectParser = class(TForm)
    paTop: TPanel;
    laTitle: TLabel;
    laDescription: TLabel;
    laSelectCaption: TLabel;
    rbNew: TRadioButton;
    laNewDescription: TLabel;
    rbOld: TRadioButton;
    laOldDescription: TLabel;
    cbDoNotAsk: TCheckBox;
    laDoNotAskDescription: TLabel;
    btOpen: TButton;
    beBottom: TBevel;
    btCancel: TButton;
    laHow: TLabel;
    laFileName: TLabel;
  end;

implementation

{$R *.dfm}

end.
