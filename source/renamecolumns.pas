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

unit renamecolumns;

interface

uses
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls;

type
  TfmRenameColumns = class(TForm)
    veColumns: TValueListEditor;
    Label1: TLabel;
    btOK: TButton;
    btCancel: TButton;
    btDefault: TButton;
    procedure btDefaultClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TfmRenameColumns.btDefaultClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 1 to veColumns.RowCount - 1 do
    veColumns.Cells[1, I] := veColumns.Keys[I];
end;

end.
