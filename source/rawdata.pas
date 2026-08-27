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

unit rawdata;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes, Vcl.Buttons,
  Vcl.ComCtrls, System.Actions, Vcl.ActnList, spektrum, VirtualTable,
  Vcl.ExtCtrls;

type
  TfmRawData = class(TForm)
    btClose: TButton;
    pcRawData: TPageControl;
    tsRawData: TTabSheet;
    laTimestampCaption: TLabel;
    laRawTimestampCaption: TLabel;
    laRawCaption: TLabel;
    laTimestamp: TLabel;
    laFileOffsetCaption: TLabel;
    laOffset: TLabel;
    laRawTimestamp: TLabel;
    laRaw: TLabel;
    laSensorIdCaption: TLabel;
    laSensorId: TLabel;
    laRawDataCaption: TLabel;
    laRawData: TLabel;
    sbCopyOffset: TSpeedButton;
    sbCopyTimestamp: TSpeedButton;
    sbCopySensorData: TSpeedButton;
    sbCopyRaw: TSpeedButton;
    tsGpsPosRawData: TTabSheet;
    laGpsFileOffsetCaption: TLabel;
    laGpsOffset: TLabel;
    sbGpsCopyOffset: TSpeedButton;
    sbGpsCopyTimestamp: TSpeedButton;
    laGpsRawTimestamp: TLabel;
    laGpsRawTimestampCaption: TLabel;
    laGpsTimestamp: TLabel;
    laGpsTimestampCaption: TLabel;
    laGpsSensorIdCaption: TLabel;
    laGpsRawDataCaption: TLabel;
    laGpsRawData: TLabel;
    laGpsSensorId: TLabel;
    laGpsRawCaption: TLabel;
    laGpsRaw: TLabel;
    sbGpsCopySensorData: TSpeedButton;
    sbGpsCopyRaw: TSpeedButton;
    laGpsRawIdsCaption: TLabel;
    laGpsRawIds: TLabel;
    laRawIdsCaption: TLabel;
    laRawIds: TLabel;
    ActionList: TActionList;
    acPrev: TAction;
    bbPrev: TBitBtn;
    acNext: TAction;
    bbNext: TBitBtn;
    Bevel: TBevel;
    GpsBevel: TBevel;
    pcSensor: TPageControl;
    tsSensorFields: TTabSheet;
    lvStructure: TListView;
    pcGpsSensor: TPageControl;
    tsGpsSensorFields: TTabSheet;
    lvStructureGps: TListView;
    tsSensorFields2: TTabSheet;
    lvStructure2: TListView;
    procedure sbCopyOffsetClick(Sender: TObject);
    procedure sbCopyTimestampClick(Sender: TObject);
    procedure sbCopySensorDataClick(Sender: TObject);
    procedure sbCopyRawClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbGpsCopyOffsetClick(Sender: TObject);
    procedure sbGpsCopyTimestampClick(Sender: TObject);
    procedure sbGpsCopySensorDataClick(Sender: TObject);
    procedure sbGpsCopyRawClick(Sender: TObject);
    procedure acPrevUpdate(Sender: TObject);
    procedure acPrevExecute(Sender: TObject);
    procedure acNextUpdate(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    FListView: TListView;
    FTable: TVirtualTable;
    FSession: TTelemetrySession;
    FSensorData: TSensorData;

    procedure ShowSensorData;
    procedure ShowSensorRawData(const Timestamp: string);
    procedure ShowGpsSensorRawData;
    procedure ShowSmartBattData;

    procedure AddSensorHeader(const ListView: TListView;
      const RawData: TTelemetryData);
    procedure AddSensorFields(const ListView: TListView;
      const RawData: TTelemetryData; const Struct: TStruct);
    procedure ShowSensorStructure(const ListView: TListView;
      const TabSheet: TTabSheet);
    procedure ShowTxInputsStructure(const ListView: TListView;
      const TabSheet: TTabSheet);

    procedure FindSensor;

    procedure UpdateSelected(const Index: Integer);

  public
    constructor Create(AOwner: TComponent; const ListView: TListView;
      const Table: TVirtualTable;
      const Session: TTelemetrySession); reintroduce;
  end;

implementation

uses
  Clipbrd, SysUtils, Windows;

{$R *.dfm}

var
  Structs: TStructs = nil;
  SmartBatts: TStructs = nil;
  TxInputs: TStructs = nil;

{ Field defs }

function CreateField(const DataType: string; const Name: string;
  const Len: Byte): TFieldDef;
begin
  Result.DataType := DataType;
  Result.Name := Name;
  Result.Len := Len;
end;

procedure AddStruct(const Id: Byte; const Name: string;
  const Fields: TFieldDefs);
var
  i: Integer;
begin
  i := Length(Structs);
  SetLength(Structs, i + 1);
  Structs[i].Id := Id;
  Structs[i].Name := Name;
  Structs[i].Fields := Fields;
end;

procedure AddSmartBatt(const Id: Byte; const Name: string;
  const Fields: TFieldDefs);
var
  i: Integer;
begin
  i := Length(SmartBatts);
  SetLength(SmartBatts, i + 1);
  SmartBatts[i].Id := Id;
  SmartBatts[i].Name := Name;
  SmartBatts[i].Fields := Fields;
end;

procedure AddTxInputs(const Id: Byte; const Name: string;
  const Fields: TFieldDefs);
var
  i: Integer;
begin
  i := Length(TxInputs);
  SetLength(TxInputs, i + 1);
  TxInputs[i].Id := Id;
  TxInputs[i].Name := Name;
  TxInputs[i].Fields := Fields;
end;

procedure AddStructs;
begin
  { TODO -cNew Sensor : Create structures definitions for Raw Data }
  AddStruct(TELE_DEVICE_USER_16SU, 'STRU_TELE_USER_16SU',
    [CreateField('INT16', 'sField1', 1),
     CreateField('INT16', 'sField2', 1),
     CreateField('INT16', 'sField3', 1),
     CreateField('UINT16', 'uField1', 1),
     CreateField('UINT16', 'uField2', 1),
     CreateField('UINT16', 'uField3', 1),
     CreateField('UINT16', 'uField4', 1)]);
  AddStruct(TELE_DEVICE_USER_16SU32U, 'STRU_TELE_USER_16SU32U',
    [CreateField('INT16', 'sField1', 1),
     CreateField('INT16', 'sField2', 1),
     CreateField('UINT16', 'uField1', 1),
     CreateField('UINT16', 'uField2', 1),
     CreateField('UINT16', 'uField3', 1),
     CreateField('UINT32', 'u32Field', 1)]);
  AddStruct(TELE_DEVICE_USER_16SU32S, 'STRU_TELE_USER_16SU32S',
    [CreateField('INT16', 'sField1', 1),
     CreateField('INT16', 'sField2', 1),
     CreateField('UINT16', 'uField1', 1),
     CreateField('UINT16', 'uField2', 1),
     CreateField('UINT16', 'uField3', 1),
     CreateField('INT32', 's32Field', 1)]);
  AddStruct(TELE_DEVICE_USER_16U32SU, 'STRU_TELE_USER_16U32SU',
    [CreateField('UINT16', 'uField1', 1),
     CreateField('INT32', 's32Field', 1),
     CreateField('UINT32', 'u32Field1', 1),
     CreateField('UINT32', 'u32Field2', 1)]);
  AddStruct(TELE_DEVICE_PBOX, 'STRU_TELE_POWERBOX',
    [CreateField('UINT16', 'volt1', 1),
     CreateField('UINT16', 'volt2', 1),
     CreateField('UINT16', 'capacity1', 1),
     CreateField('UINT16', 'capacity2', 1),
     CreateField('UINT16', 'spare16_1', 1),
     CreateField('UINT16', 'spare16_2', 1),
     CreateField('UINT8', 'spare', 1),
     CreateField('UINT8', 'alarms', 1)]);
  AddStruct(TELE_DEVICE_VOLTAGE, 'STRU_TELE_HV',
    [CreateField('UINT16', 'voltage', 1)]);
  AddStruct(TELE_DEVICE_RX_MAH, 'STRU_TELE_RX_MAH',
    [CreateField('INT16', 'current_A', 1),
     CreateField('UINT16', 'chargeUsed_A', 1),
     CreateField('UINT16', 'volts_A', 1),
     CreateField('INT16', 'current_B', 1),
     CreateField('UINT16', 'chargeUsed_B', 1),
     CreateField('UINT16', 'volts_B', 1),
     CreateField('UINT8', 'alerts', 1),
     CreateField('UINT8', 'highCharge', 1)]);
  AddStruct(TELE_DEVICE_AMPS, 'STRU_TELE_IHIGH',
    [CreateField('INT16', 'current', 1),
     CreateField('INT16', 'dummy', 1)]);
  AddStruct(TELE_DEVICE_VARIO_S, 'STRU_TELE_VARIO_S',
    [CreateField('INT16', 'altitude', 1),
     CreateField('INT16', 'delta_0250ms', 1),
     CreateField('INT16', 'delta_0500ms', 1),
     CreateField('INT16', 'delta_1000ms', 1),
     CreateField('INT16', 'delta_1500ms', 1),
     CreateField('INT16', 'delta_2000ms', 1),
     CreateField('INT16', 'delta_3000ms', 1)]);
  AddStruct(TELE_DEVICE_ALTITUDE, 'STRU_TELE_ALT',
    [CreateField('INT16', 'altitude', 1),
     CreateField('INT16', 'maxAltitude', 1)]);
  AddStruct(TELE_DEVICE_AIRSPEED, 'STRU_TELE_SPEED',
    [CreateField('UINT16', 'airspeed', 1),
     CreateField('UINT16', 'maxAirspeed', 1)]);
  AddStruct(TELE_DEVICE_LAPTIMER, 'STRU_TELE_LAPTIMER',
    [CreateField('UINT8', 'lapNumber', 1),
     CreateField('UINT8', 'gateNumber', 1),
     CreateField('UINT32', 'lastLapTime', 1),
     CreateField('UINT32', 'gateTime', 1),
     CreateField('UINT8', 'unused', 4)]);
  AddStruct(TELE_DEVICE_TEXTGEN, 'STRU_TELE_TEXTGEN',
    [CreateField('UINT8', 'lineNumber', 1),
     CreateField('char', 'text', 13)]);
  AddStruct(TELE_DEVICE_ESC, 'STRU_TELE_ESC',
    [CreateField('UINT16', 'RPM', 1),
     CreateField('UINT16', 'voltsInput', 1),
     CreateField('UINT16', 'tempFET', 1),
     CreateField('UINT16', 'currentMotor', 1),
     CreateField('UINT16', 'tempBEC', 1),
     CreateField('UINT8', 'currentBEC', 1),
     CreateField('UINT8', 'voltsBEC', 1),
     CreateField('UINT8', 'throttle', 1),
     CreateField('UINT8', 'powerOut', 1)]);
  AddStruct(TELE_DEVICE_FUEL, 'STRU_TELE_FUEL',
    [CreateField('UINT16', 'fuelConsumed_A', 1),
     CreateField('UINT16', 'flowRate_A', 1),
     CreateField('UINT16', 'temp_A', 1),
     CreateField('UINT16', 'fuelConsumed_B', 1),
     CreateField('UINT16', 'flowRate_B', 1),
     CreateField('UINT16', 'temp_B', 1),
     CreateField('UINT16', 'spare', 1)]);
  AddStruct(TELE_DEVICE_FP_MAH, 'STRU_TELE_FP_MAH',
    [CreateField('INT16', 'current_A', 1),
     CreateField('INT16', 'chargeUsed_A', 1),
     CreateField('UINT16', 'temp_A', 1),
     CreateField('INT16', 'current_B', 1),
     CreateField('INT16', 'chargeUsed_B', 1),
     CreateField('UINT16', 'temp_B', 1),
     CreateField('UINT16', 'spare', 1)]);
  AddStruct(TELE_DEVICE_DIGITAL_AIR, 'STRU_TELE_DIGITAL_AIR',
    [CreateField('UINT16', 'digital', 1),
     CreateField('UINT16', 'spare1', 1),
     CreateField('UINT16', 'pressure', 4),
     CreateField('UINT16', 'spare2', 1)]);
  AddStruct(TELE_DEVICE_LIPOMON, 'STRU_TELE_LIPOMON',
    [CreateField('UINT16', 'cell', 6),
     CreateField('UINT16', 'temp', 1)]);
  AddStruct(TELE_DEVICE_LIPOMON_14, 'STRU_TELE_LIPOMON_14',
    [CreateField('UINT8', 'cell', 14)]);
  AddStruct(TELE_DEVICE_GMETER, 'STRU_TELE_G_METER',
    [CreateField('INT16', 'GForceX', 1),
     CreateField('INT16', 'GForceY', 1),
     CreateField('INT16', 'GForceZ', 1),
     CreateField('INT16', 'maxGForceX', 1),
     CreateField('INT16', 'maxGForceY', 1),
     CreateField('INT16', 'maxGForceZ', 1),
     CreateField('INT16', 'minGForceZ', 1)]);
  AddStruct(TELE_DEVICE_JETCAT, 'STRU_TELE_JETCAT',
    [CreateField('UINT8', 'status', 1),
     CreateField('UINT8', 'throttle', 1),
     CreateField('UINT16', 'packVoltage', 1),
     CreateField('UINT16', 'pumpVoltage', 1),
     CreateField('UINT32', 'RPM', 1),
     CreateField('UINT16', 'EGT', 1),
     CreateField('UINT8', 'offCondition', 1),
     CreateField('UINT8', 'spare', 1)]);
  AddStruct(TELE_DEVICE_JETCAT_2, 'STRU_TELE_JETCAT2',
    [CreateField('UINT16', 'FuelFlowRateMLMin', 1),
     CreateField('UINT32', 'RestFuelVolumeInTankML', 1),
     CreateField('UINT8', 'ECUbatteryPercent', 1)]);
  AddStruct(TELE_DEVICE_GPS_LOC, 'STRU_TELE_GPS_LOC',
    [CreateField('UINT16', 'altitudeLow', 1),
     CreateField('UINT32', 'latitude', 1),
     CreateField('UINT32', 'longitude', 1),
     CreateField('UINT16', 'course', 1),
     CreateField('UINT8', 'HDOP', 1),
     CreateField('UINT8', 'GPSflags', 1)]);
  AddStruct(TELE_DEVICE_GPS_STATS, 'STRU_TELE_GPS_STAT',
    [CreateField('UINT16', 'speed', 1),
     CreateField('UINT32', 'UTC', 1),
     CreateField('UINT8', 'numSats', 1),
     CreateField('UINT8', 'altitudeHigh', 1)]);
  AddStruct(TELE_DEVICE_GYRO, 'STRU_TELE_GYRO',
    [CreateField('INT16', 'gyroX', 1),
     CreateField('INT16', 'gyroY', 1),
     CreateField('INT16', 'gyroZ', 1),
     CreateField('INT16', 'maxGyroX', 1),
     CreateField('INT16', 'maxGyroY', 1),
     CreateField('INT16', 'maxGyroZ', 1)]);
  AddStruct(TELE_DEVICE_ATTMAG, 'STRU_TELE_ATTMAG',
    [CreateField('INT16', 'attRoll', 1),
     CreateField('INT16', 'attPitch', 1),
     CreateField('INT16', 'attYaw', 1),
     CreateField('INT16', 'magX', 1),
     CreateField('INT16', 'magY', 1),
     CreateField('INT16', 'magZ', 1),
     CreateField('UINT16', 'heading', 1)]);
  AddStruct(TELE_DEVICE_MULTICYLINDER, 'STRU_TELE_MULTI_TEMP',
    [CreateField('UINT8', 'temperature', 9),
     CreateField('UINT8', 'throttlePct', 1),
     CreateField('UINT16', 'RPM', 1),
     CreateField('UINT8', 'batteryV', 1),
     CreateField('UINT8', 'spare', 1)]);
  AddStruct(TELE_DEVICE_XRF_LINKSTATUS, 'STRU_TELE_XF_QOS',
    [CreateField('UINT8', 'ant1', 1),
     CreateField('UINT8', 'ant2', 1),
     CreateField('UINT8', 'quality', 1),
     CreateField('INT8', 'SNR', 1),
     CreateField('UINT8', 'activeAnt', 1),
     CreateField('UINT8', 'RFmode', 1),
     CreateField('UINT8', 'upPower', 1),
     CreateField('UINT8', 'downlink', 1),
     CreateField('UINT8', 'qualityDown', 1),
     CreateField('INT8', 'SNRdown', 1)]);
  AddStruct(TELE_DEVICE_RPM_TM1000, 'STRU_TELE_RPM',
    [CreateField('UINT16', 'microseconds', 1),
     CreateField('UINT16', 'volts', 1),
     CreateField('INT16', 'temperature', 1),
     CreateField('INT8', 'dBm_A', 1),
     CreateField('INT8', 'dBm_B', 1),
     CreateField('UINT16', 'spare', 2),
     CreateField('UINT16', 'fastbootUptime', 1)]);
  AddStruct(TELE_DEVICE_RPM_TM1100, 'STRU_TELE_RPM',
    [CreateField('UINT16', 'microseconds', 1),
     CreateField('UINT16', 'volts', 1),
     CreateField('INT16', 'temperature', 1),
     CreateField('INT8', 'dBm_A', 1),
     CreateField('INT8', 'dBm_B', 1),
     CreateField('UINT16', 'spare', 2),
     CreateField('UINT16', 'fastbootUptime', 1)]);
  AddStruct(TELE_DEVICE_QOS_TM1000, 'STRU_TELE_QOS',
    [CreateField('UINT16', 'A', 1),
     CreateField('UINT16', 'B', 1),
     CreateField('UINT16', 'L', 1),
     CreateField('UINT16', 'R', 1),
     CreateField('UINT16', 'F', 1),
     CreateField('UINT16', 'H', 1),
     CreateField('UINT16', 'rxVoltage', 1)]);
  AddStruct(TELE_DEVICE_QOS_TM1100, 'STRU_TELE_QOS',
    [CreateField('UINT16', 'A', 1),
     CreateField('UINT16', 'B', 1),
     CreateField('UINT16', 'L', 1),
     CreateField('UINT16', 'R', 1),
     CreateField('UINT16', 'F', 1),
     CreateField('UINT16', 'H', 1),
     CreateField('UINT16', 'rxVoltage', 1)]);

  // TX Inputs

  AddTxInputs(STRU_TELE_TXINPUT.TELE_CAPTURE_DIGITAL, 'STRU_TX_DIGITAL',
    [CreateField('UINT64', 'swDigital', 1)]);
  AddTxInputs(STRU_TELE_TXINPUT.TELE_CAPTURE_ANALOG_BASE, 'STRU_TX_ANALOG_B',
    [CreateField('INT16', 'knob_R', 1),
     CreateField('INT16', 'stick_Thr', 1),
     CreateField('INT16', 'stick_Ele', 1),
     CreateField('INT16', 'stick_Ail', 1),
     CreateField('INT16', 'stick_Rud', 1),
     CreateField('INT16', 'slider_L', 1),
     CreateField('INT16', 'slider_R', 1)]);
  AddTxInputs(STRU_TELE_TXINPUT.TELE_CAPTURE_ANALOG_EXT, 'STRU_TX_ANALOG_X',
    [CreateField('INT16', 'pot_3', 1),
     CreateField('INT16', 'pot_4', 1),
     CreateField('INT16', 'pot_5', 1),
     CreateField('INT16', 'pot_6', 1),
     CreateField('INT16', 'knob_L', 1),
     CreateField('INT16', 'tbd_1', 1),
     CreateField('INT16', 'tbd_2', 1)]);

  // Smart Battery

  AddStruct(TELE_DEVICE_SMARTBATT, 'STRU_SMARTBATT_HEADER',
    [CreateField('UINT8', 'typeChannel', 1),
     CreateField('UINT8', 'msgData', 13)]);
  AddSmartBatt(STRU_SMARTBATT.SMARTBATT_MSG_TYPE_REALTIME, 'STRU_SMARTBATT_REALTIME',
    [CreateField('UINT8', 'typeChannel', 1),
     CreateField('INT8', 'temperature_C', 1),
     CreateField('UINT32', 'dischargeCurrent_mA', 1),
     CreateField('UINT16', 'batteryCapacityUsage_mAh', 1),
     CreateField('UINT16', 'minCellVoltage_mV', 1),
     CreateField('UINT16', 'maxCellVoltage_mV', 1),
     CreateField('UINT8', 'rfu', 2)]);
  AddSmartBatt(STRU_SMARTBATT.SMARTBATT_MSG_TYPE_CELLS_1_6, 'STRU_SMARTBATT_CELLS',
    [CreateField('UINT8', 'typeChannel', 1),
     CreateField('INT8', 'temperature_C', 1),
     CreateField('UINT16', 'cellVoltage_mV', 6)]);
  AddSmartBatt(STRU_SMARTBATT.SMARTBATT_MSG_TYPE_CELLS_7_12, 'STRU_SMARTBATT_CELLS',
    [CreateField('UINT8', 'typeChannel', 1),
     CreateField('INT8', 'temperature_C', 1),
     CreateField('UINT16', 'cellVoltage_mV', 6)]);
  AddSmartBatt(STRU_SMARTBATT.SMARTBATT_MSG_TYPE_CELLS_13_18, 'STRU_SMARTBATT_CELLS',
    [CreateField('UINT8', 'typeChannel', 1),
     CreateField('INT8', 'temperature_C', 1),
     CreateField('UINT16', 'cellVoltage_mV', 6)]);
end;

{ TfmRawData }

procedure TfmRawData.acNextExecute(Sender: TObject);
begin
  if FListView.Selected.Index < FListView.Items.Count - 1 then
    UpdateSelected(FListView.Selected.Index + 1);
end;

procedure TfmRawData.acNextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FListView.Selected.Index < FListView.Items.Count - 1;
end;

procedure TfmRawData.acPrevExecute(Sender: TObject);
begin
  if FListView.Selected.Index > 0 then
    UpdateSelected(FListView.Selected.Index - 1);
end;

procedure TfmRawData.acPrevUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FListView.Selected.Index > 0;
end;

procedure TfmRawData.AddSensorFields(const ListView: TListView;
  const RawData: TTelemetryData; const Struct: TStruct);
var
  Item: TListItem;
  Ndx: Byte;
  j: Integer;
  Field: TFieldDef;
  DataTypeLen: Byte;
  Data: string;
  l: Integer;
  ArrNdx: Byte;
begin
  if Length(Struct.Fields) > 0 then begin
    Ndx := 6;
    for j := 0 to Length(Struct.Fields) - 1 do begin
      Field := Struct.Fields[j];

      Item := ListView.Items.Add;
      if Field.Len = 1 then
        Item.Caption := Field.Name
      else
        Item.Caption := Field.Name + '[' + IntToStr(Field.Len) + ']';
      Item.SubItems.Add(Field.DataType);

      DataTypeLen := 0;
      if (Field.DataType = 'char') then
        DataTypeLen := 1;
      if (Field.DataType = 'INT8') or (Field.DataType = 'UINT8') then
        DataTypeLen := 1;
      if (Field.DataType = 'INT16') or (Field.DataType = 'UINT16') then
        DataTypeLen := 2;
      if (Field.DataType = 'INT32') or (Field.DataType = 'UINT32') then
        DataTypeLen := 4;
      if (Field.DataType = 'INT64') or (Field.DataType = 'UINT64') then
        DataTypeLen := 8;

      if DataTypeLen = 0 then
        Item.SubItems.Add('')

      else begin
        Data := '';
        for l := 0 to DataTypeLen * Field.Len - 1 do
          Data := Data + IntToHex(RawData[Ndx + l], 2) + ' ';
        Item.SubItems.Add(Data);

        if Field.Len > 1 then begin
          ArrNdx := Ndx;
          for l := 0 to Field.Len - 1 do begin
            Item := ListView.Items.Add;
            Item.Caption := '';
            Item.SubItems.Add(Field.Name + '[' + IntToStr(l) + ']');

            case DataTypeLen of
              1: begin
                   Data := IntToHex(RawData[ArrNdx], 2);
                   Inc(ArrNdx, 1);
                 end;
              2: begin
                   Data := IntToHex(RawData[ArrNdx + 0], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 1], 2);
                   Inc(ArrNdx, 2);
                 end;
              4: begin
                   Data := IntToHex(RawData[ArrNdx + 0], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 1], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 2], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 3], 2);
                   Inc(ArrNdx, 4);
                 end;
              8: begin
                   Data := IntToHex(RawData[ArrNdx + 0], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 1], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 2], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 3], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 4], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 5], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 6], 2) + ' ' +
                           IntToHex(RawData[ArrNdx + 7], 2);
                   Inc(ArrNdx, 8);
                 end;
              else
                Data := '';
            end;

            Item.SubItems.Add(Data);
          end;
        end;
      end;
      Inc(Ndx, DataTypeLen * Field.Len);
    end;
  end;
end;

procedure TfmRawData.AddSensorHeader(const ListView: TListView;
  const RawData: TTelemetryData);
var
  Item: TListItem;
begin
  Item := ListView.Items.Add;
  Item.Caption := 'identifier';
  Item.SubItems.Add('UINT8');
  Item.SubItems.Add(IntToHex(RawData[4], 2));

  Item := ListView.Items.Add;
  Item.Caption := 'sID';
  Item.SubItems.Add('UINT8');
  Item.SubItems.Add(IntToHex(RawData[5], 2));
end;

constructor TfmRawData.Create(AOwner: TComponent; const ListView: TListView;
  const Table: TVirtualTable; const Session: TTelemetrySession);
begin
  inherited Create(AOwner);

  FListView := ListView;
  FTable := Table;
  FSession := Session;
end;

procedure TfmRawData.FindSensor;
var
  Item: TListItem;
  Timestamp: Cardinal;
  Id: Byte;
  i: Integer;
  SensorData: TSensorData;
  SensorFound: Boolean;
begin
  FSensorData := nil;

  Item := FListView.Selected;

  FTable.RecNo := Item.Index + 1;
  Timestamp := FTable.Fields[0].AsLongWord;
  Id := FTable.Tag;

  for i := 0 to FSession.Data.Count - 1 do begin
    SensorData := TSensorData(FSession.Data[I]);
    SensorFound := ((Id = TELE_DEVICE_RPM_TM1000) and
      ((SensorData.SensorID = TELE_DEVICE_RPM_TM1000) or (SensorData.SensorID = TELE_DEVICE_RPM_TM1100))) or
      ((Id = TELE_DEVICE_QOS_TM1000) and
       ((SensorData.SensorID = TELE_DEVICE_QOS_TM1000) or (SensorData.SensorID = TELE_DEVICE_QOS_TM1100))) or
      ((Id = TELE_DEVICE_JETCAT) and
       ((SensorData.SensorID = TELE_DEVICE_JETCAT) or (SensorData.SensorID = TELE_DEVICE_JETCAT_2))) or
      (Id = SensorData.SensorID);

    if SensorFound and (SensorData.Timestamp = Timestamp) then begin
      FSensorData := SensorData;
      Break;
    end;
  end;
end;

procedure TfmRawData.FormCreate(Sender: TObject);
begin
  tsGpsPosRawData.TabVisible := False;
  tsSensorFields2.TabVisible := False;
end;

procedure TfmRawData.FormShow(Sender: TObject);
begin
  ShowSensorData;
end;

procedure TfmRawData.sbCopyOffsetClick(Sender: TObject);
begin
  Clipboard.AsText := laOffset.Caption;
end;

procedure TfmRawData.sbCopyRawClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laRawData.Caption, ' ', '', [rfReplaceAll]);
end;

procedure TfmRawData.sbCopySensorDataClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laRaw.Caption, ' ', '', [rfReplaceAll]);
end;

procedure TfmRawData.sbCopyTimestampClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laRawTimestamp.Caption, ' ', '',
    [rfReplaceAll]);
end;

procedure TfmRawData.sbGpsCopyOffsetClick(Sender: TObject);
begin
  Clipboard.AsText := laGpsOffset.Caption;
end;

procedure TfmRawData.sbGpsCopyRawClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laGpsRawData.Caption, ' ', '', [rfReplaceAll]);
end;

procedure TfmRawData.sbGpsCopySensorDataClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laGpsRaw.Caption, ' ', '', [rfReplaceAll]);
end;

procedure TfmRawData.sbGpsCopyTimestampClick(Sender: TObject);
begin
  Clipboard.AsText := StringReplace(laGpsRawTimestamp.Caption, ' ', '',
    [rfReplaceAll]);
end;

procedure TfmRawData.ShowGpsSensorRawData;
var
  RawData: string;
  j: Integer;
begin
  // Show GPS position data.
  lvStructureGps.Items.BeginUpdate;
  lvStructureGps.Clear;

  tsGpsSensorFields.Caption := '<UNKNOWN>';
  if (FSensorData <> nil) and (FSensorData.SensorID = TELE_DEVICE_GPS_STATS) then begin
    laGpsOffset.Caption := IntToHex(STRU_TELE_GPS(FSensorData).PosOffset, 8);
    laGpsTimestamp.Caption := ConvertTime(STRU_TELE_GPS(FSensorData).PosTimestamp);
    laGpsRawTimestamp.Caption :=
      IntToHex(LoByte(LoWord(STRU_TELE_GPS(FSensorData).PosTimestampRaw)), 2) + ' ' +
      IntToHex(HiByte(LoWord(STRU_TELE_GPS(FSensorData).PosTimestampRaw)), 2) + ' ' +
      IntToHex(LoByte(HiWord(STRU_TELE_GPS(FSensorData).PosTimestampRaw)), 2) + ' ' +
      IntToHex(HiByte(HiWord(STRU_TELE_GPS(FSensorData).PosTimestampRaw)), 2);

    laGpsSensorId.Caption := IntToHex(STRU_TELE_GPS(FSensorData).PosSensorID, 2);
    laGpsRawIds.Caption :=
      IntToHex(STRU_TELE_GPS(FSensorData).PosRawData[4], 2) + ' ' +
      IntToHex(STRU_TELE_GPS(FSensorData).PosRawData[5], 2);

    RawData := '';
    for j := 0 to SizeOf(TTelemetryData) - 7 do
      RawData := RawData + IntToHex(STRU_TELE_GPS(FSensorData).PosData[j], 2) + ' ';
    laGpsRaw.Caption := RawData;

    RawData := '';
    for j := 0 to SizeOf(TTelemetryData) - 1 do
      RawData := RawData + IntToHex(STRU_TELE_GPS(FSensorData).PosRawData[j], 2) + ' ';
    laGpsRawData.Caption := RawData;

    tsGpsPosRawData.TabVisible := True;
    tsRawData.Caption := 'GPS Status Raw Data';

    ShowSensorStructure(lvStructureGps, tsGpsSensorFields);
  end;

  lvStructureGps.Items.EndUpdate;
end;

procedure TfmRawData.ShowSensorData;
begin
  FindSensor;
  if FSensorData <> nil then begin
    ShowSensorRawData(FListView.Selected.Caption);
    ShowGpsSensorRawData;
    ShowSmartBattData;
  end;
end;

procedure TfmRawData.ShowSensorRawData(const Timestamp: string);
var
  RawData: string;
  j: Integer;
begin
  lvStructure.Items.BeginUpdate;
  lvStructure.Clear;

  tsSensorFields.Caption := '<UNKNOWN>';
  if FSensorData <> nil then begin
    laOffset.Caption := IntToHex(FSensorData.Offset, 8);
    laTimestamp.Caption := Timestamp;
    laRawTimestamp.Caption :=
      IntToHex(LoByte(LoWord(FSensorData.TimestampRaw)), 2) + ' ' +
      IntToHex(HiByte(LoWord(FSensorData.TimestampRaw)), 2) + ' ' +
      IntToHex(LoByte(HiWord(FSensorData.TimestampRaw)), 2) + ' ' +
      IntToHex(HiByte(HiWord(FSensorData.TimestampRaw)), 2);

    laSensorId.Caption := IntToHex(FSensorData.SensorID, 2);
    laRawIds.Caption := IntToHex(FSensorData.RawData[4], 2) + ' ' +
      IntToHex(FSensorData.RawData[5], 2);

    RawData := '';
    for j := 0 to SizeOf(TTelemetryData) - 7 do
      RawData := RawData + IntToHex(FSensorData.Data[j], 2) + ' ';
    laRaw.Caption := RawData;

    RawData := '';
    for j := 0 to SizeOf(TTelemetryData) - 1 do
      RawData := RawData + IntToHex(FSensorData.RawData[j], 2) + ' ';
    laRawData.Caption := RawData;

    if FSensorData.SensorID = TELE_DEVICE_TXINPUTS then
      ShowTxInputsStructure(lvStructure, tsSensorFields)
    else
      ShowSensorStructure(lvStructure, tsSensorFields);

  end else begin
    laOffset.Caption := '00000000';
    laTimestamp.Caption := Timestamp;
    laRawTimestamp.Caption := '00 00 00 00';
    laRawIds.Caption := '00 00';
    laRaw.Caption := '00 00 00 00 00 00 00 00 00 00 00 00 00 00';
    laRawData.Caption := '00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00';
  end;

  lvStructure.Items.EndUpdate;
end;

procedure TfmRawData.ShowSensorStructure(const ListView: TListView;
  const TabSheet: TTabSheet);
var
  Id: Byte;
  i: integer;
  Struct: TStruct;
  RawData: TTelemetryData;
begin
  if Length(Structs) > 0 then begin
    if ListView = lvStructure then
      Id := FSensorData.SensorID
    else
      Id := TELE_DEVICE_GPS_LOC;

    for i := 0 to Length(Structs) - 1 do begin
      Struct := Structs[i];
      if Struct.Id = Id then begin
        if ListView = lvStructure then
          RawData := FSensorData.RawData
        else
          RawData := STRU_TELE_GPS(FSensorData).PosRawData;

        TabSheet.Caption := Struct.Name;

        AddSensorHeader(ListView, RawData);
        AddSensorFields(ListView, RawData, Struct);

        Break;
      end;
    end;
  end;
end;

procedure TfmRawData.ShowSmartBattData;
var
  MsgId: Byte;
  i: Integer;
  SmartBatt: TStruct;
  RawData: TTelemetryData;
begin
  // Show Smart Battery detailed struct.
  lvStructure2.Items.BeginUpdate;
  lvStructure2.Items.Clear;

  tsSensorFields2.Caption := '<UNKNOWN>';
  if (FSensorData <> nil) and (FSensorData.SensorID = TELE_DEVICE_SMARTBATT) then begin
    MsgId := FSensorData.RawData[6] and STRU_SMARTBATT.SMARTBATT_MSG_TYPE_MASK_MSGTYPE;

    for i := 0 to Length(SmartBatts) - 1 do begin
      SmartBatt := SmartBatts[i];
      if SmartBatt.Id = MsgId then begin
        RawData := FSensorData.RawData;

        tsSensorFields2.Caption := SmartBatt.Name;
        AddSensorFields(lvStructure2, RawData, SmartBatt);

        Break;
      end;
    end;

    tsSensorFields2.TabVisible := True;
  end;

  lvStructure2.Items.EndUpdate;
end;

procedure TfmRawData.ShowTxInputsStructure(const ListView: TListView;
  const TabSheet: TTabSheet);
var
  Id: Byte;
  i: integer;
  Struct: TStruct;
begin
  if Length(TxInputs) > 0 then begin
    Id := FSensorData.RawData[5];

    for i := 0 to Length(TxInputs) - 1 do begin
      Struct := TxInputs[i];
      if Struct.Id = Id then begin
        TabSheet.Caption := Struct.Name;

        AddSensorHeader(ListView, FSensorData.RawData);
        AddSensorFields(ListView, FSensorData.RawData, Struct);

        Break;
      end;
    end;
  end;
end;

procedure TfmRawData.UpdateSelected(const Index: Integer);
begin
  if FListView.Selected <> nil then begin
    FListView.Selected.Selected := False;
    FListView.Selected := nil;
  end;

  FListView.Selected := FListView.Items[Index];
  FListView.Selected.MakeVisible(false);

  ShowSensorData;
end;

initialization
  AddStructs;

end.
