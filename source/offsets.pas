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

unit offsets;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls, System.Classes,
  System.Actions, Vcl.ActnList;

type
  TfmOffsets = class(TForm)
    laTitle: TLabel;
    lvOffsets: TListView;
    Label1: TLabel;
    ActionList: TActionList;
    btDelete: TButton;
    btSave: TButton;
    btCanlcel: TButton;
    acDelete: TAction;
    acSave: TAction;
    acCancel: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acCancelUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  public
    FAltZeros: TList;
  end;

implementation

uses
  Dialogs, System.UITypes;

{$R *.dfm}

procedure TfmOffsets.acCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmOffsets.acCancelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := True;
end;

procedure TfmOffsets.acDeleteExecute(Sender: TObject);
begin
  if lvOffsets.Selected <> nil then begin
    FAltZeros.Add(lvOffsets.Selected.Data);
    lvOffsets.Selected.Delete;
  end;
end;

procedure TfmOffsets.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (lvOffsets.Selected <> nil);
end;

procedure TfmOffsets.acSaveExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfmOffsets.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (FAltZeros.Count > 0);
end;

procedure TfmOffsets.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FAltZeros.Count = 0 then
    CanClose := True

  else begin
    if ModalResult = mrOK then begin
      CanClose := (MessageDlg('Are you sure you want to deleted the offsets from the telemetry session?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    end else begin
      CanClose := (MessageDlg('Are you sure you want to disacard changes?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    end;
  end;
end;

procedure TfmOffsets.FormCreate(Sender: TObject);
begin
  FAltZeros := TList.Create;
end;

procedure TfmOffsets.FormDestroy(Sender: TObject);
begin
  FAltZeros.Free;
end;

end.
