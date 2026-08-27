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

unit about;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Graphics,
  System.Classes, Vcl.Imaging.jpeg;

type
  TfmAbout = class(TForm)
    Image: TImage;
    laAppName: TLabel;
    laAuthor: TLabel;
    laCopyright: TLabel;
    laWWW: TLabel;
    laEMail: TLabel;
    btClose: TButton;
    laThirdPatry: TLabel;
    laVirtualTable: TLabel;
    Bevel: TBevel;
    laPlotLab: TLabel;
    laVersion: TLabel;
    laSponsoredBy: TLabel;
    laSoftServiceCompany: TLabel;
    laBluetoothFramework: TLabel;
    laWiFiFramework: TLabel;
    laBuyMeACoffee: TLabel;
    procedure LableMouseEnter(Sender: TObject);
    procedure LableMouseLeave(Sender: TObject);
    procedure laWWWClick(Sender: TObject);
    procedure laEMailClick(Sender: TObject);
    procedure laVirtualTableClick(Sender: TObject);
    procedure laPlotLabClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure laSoftServiceCompanyClick(Sender: TObject);
    procedure laBluetoothFrameworkClick(Sender: TObject);
    procedure laWiFiFrameworkClick(Sender: TObject);
    procedure laBuyMeACoffeeClick(Sender: TObject);
    procedure laCryptoClick(Sender: TObject);
  end;

function GetVersion: string;

implementation

{$R *.dfm}

uses
  Windows, ShellAPI, System.UITypes, Clipbrd;

const
  MAIL_LINK = 'mailto:support@tlmviewer.com';
  GRAPH_LINK = 'http://www.mitov.com/products/plotlab#overview';
  VTABLE_LINK = 'https://www.devart.com/virtualdac/';
  WIFI_FRAMEWORK_LINK = 'http://www.btframework.com/wififramework.htm';
  TLM_VIEWER_LINK = 'http://www.tlmviewer.com';
  BTFRAMEWORK_LINK = 'http://www.btframework.com/bluetoothframework.htm';
  BTFRAMEWORK_SITE_LINK = 'http://www.btframework.com';
  BY_ME_A_COFFEE_LINK = 'https://www.tlmviewer.com/donate.htm';

function GetVersion: string;
var
  Path: array[0..MAX_PATH - 1] of Char;
  Size: DWORD;
  Buf: Pointer;
  Value: Pointer;
  Len: UINT;
  Null: Cardinal;
begin
  Result := '';
  Value := nil;

	GetModuleFileName(HInstance, Path, MAX_PATH);
	Size := GetFileVersionInfoSize(Path, Null);
	if Size > 0 then begin
    Buf := GetMemory(Size);
		if Buf <> nil then begin
			if GetFileVersionInfo(Path, 0, Size, Buf) then begin
        Value := nil;
				Len := 0;
				if VerQueryValue(Buf, 'StringFileInfo\040904E4\FileVersion', Value, Len) then
          Result := string(PChar(Value));
			end;

      FreeMemory(Buf)
    end;
	end;
end;

procedure TfmAbout.laWiFiFrameworkClick(Sender: TObject);
begin
  ShellExecute(0, 'open', WIFI_FRAMEWORK_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laWWWClick(Sender: TObject);
begin
  ShellExecute(0, 'open', TLM_VIEWER_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laBluetoothFrameworkClick(Sender: TObject);
begin
  ShellExecute(0, 'open', BTFRAMEWORK_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laCryptoClick(Sender: TObject);
begin
  Clipboard.AsText := TLabel(Sender).Caption;
end;

procedure TfmAbout.laBuyMeACoffeeClick(Sender: TObject);
begin
  ShellExecute(0, 'open', BY_ME_A_COFFEE_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laEMailClick(Sender: TObject);
begin
  ShellExecute(0, 'open', MAIL_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laPlotLabClick(Sender: TObject);
begin
  ShellExecute(0, 'open', GRAPH_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laSoftServiceCompanyClick(Sender: TObject);
begin
  ShellExecute(0, 'open', BTFRAMEWORK_SITE_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laVirtualTableClick(Sender: TObject);
begin
  ShellExecute(0, 'open', VTABLE_LINK, nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  laVersion.Caption := GetVersion;
end;

procedure TfmAbout.LableMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clBlue;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TfmAbout.LableMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clNavy;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

end.
