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

unit main;

interface

uses
  Vcl.Forms, System.Classes, Vcl.Dialogs, Vcl.Controls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, spektrum, Data.DB,
  MemDS, VirtualTable, Messages, Registry, SLControlCollection, VCL.LPControl,
  LPControlDrawLayers, SLBasicDataDisplay, SLDataDisplay, SLDataChart, SLScope,
  Vcl.Graphics, Vcl.Menus, Windows, rawdata, DateUtils;

const
  SENSORS_COUNT = 12;

type
  TListViewSortMark = ( smNone, smUp, smDown );
  TPostprocessing = ( ppNone, ppFilter, ppPeak, ppSmooth );

  TRxWarnings = record
    A: Word;
    B: Word;
    R: Word;
    L: Word;
    Fades: Word;
    Frames: Word;
    Holds: Word;
    Use: Boolean;
  end;

  TTimeGap = record
    Enabled: Boolean;
    Gap: Word; // ms.
  end;

  TTimestampArray = array of Cardinal;
  TSensorRecord = record
    Timestamp: Cardinal;
    Value: Variant;
  end;
  TSensorArray = array of TSensorRecord;

  TfmMain = class(TForm)
    OpenDialog: TOpenDialog;
    btOpen: TButton;
    lvSessions: TListView;
    PageControl: TPageControl;
    tsStandard: TTabSheet;
    tsRX: TTabSheet;
    lvRX: TListView;
    ProgressBar: TProgressBar;
    laFile: TLabel;
    laFileName: TLabel;
    tsAccel: TTabSheet;
    lvAccel: TListView;
    tsAirSpeed: TTabSheet;
    lvAirSpeed: TListView;
    tsAlt: TTabSheet;
    lvAlt: TListView;
    tsCurrent: TTabSheet;
    tsPowerBox: TTabSheet;
    lvPowerBox: TListView;
    btExport: TButton;
    SaveDialog: TSaveDialog;
    ImageList: TImageList;
    Image: TImage;
    btAbout: TButton;
    lvCurrent: TListView;
    lvStandard: TListView;
    tsFlightPack: TTabSheet;
    lvFlightPack: TListView;
    tsRXPack: TTabSheet;
    lvRXPack: TListView;
    tsESC: TTabSheet;
    lvESC: TListView;
    laParsing: TLabel;
    laParsingProgress: TLabel;
    btGraphData: TButton;
    vtStandard: TVirtualTable;
    vtStandardTimestamp: TLongWordField;
    vtStandardRPM: TSingleField;
    vtStandardTemperature: TSingleField;
    vtStandardVoltage: TSingleField;
    vtRX: TVirtualTable;
    vtRXTimestamp: TLongWordField;
    vtRXA: TLongWordField;
    vtRXB: TLongWordField;
    vtRXR: TLongWordField;
    vtRXL: TLongWordField;
    vtRXFrameLoss: TLongWordField;
    vtRXHolds: TLongWordField;
    vtRXVolt: TSingleField;
    vtFlightPack: TVirtualTable;
    vtFlightPackTimestamp: TLongWordField;
    vtRXPack: TVirtualTable;
    vtRXPackTimestamp: TLongWordField;
    vtRXPackCurrentA: TSingleField;
    vtRXPackVoltA: TSingleField;
    vtAirSpeed: TVirtualTable;
    vtAirSpeedTimestamp: TLongWordField;
    vtAirSpeedAirspeed: TLongWordField;
    vtAccel: TVirtualTable;
    vtAccelTimestamp: TLongWordField;
    vtAccelX: TSingleField;
    vtAccelXMax: TSingleField;
    vtAccelY: TSingleField;
    vtAccelYMax: TSingleField;
    vtAccelZ: TSingleField;
    vtAccelZMin: TSingleField;
    vtAccelZMax: TSingleField;
    vtAlt: TVirtualTable;
    vtAltTimestamp: TLongWordField;
    vtAltAlt: TSingleField;
    vtCurrent: TVirtualTable;
    vtCurrentTimestamp: TLongWordField;
    vtCurrentCurrent: TSingleField;
    vtPowerBox: TVirtualTable;
    vtPowerBoxTimestamp: TLongWordField;
    vtPowerBoxVolt1: TSingleField;
    vtPowerBoxCap1: TLongWordField;
    vtPowerBoxVolt2: TSingleField;
    vtPowerBoxCap2: TLongWordField;
    vtESC: TVirtualTable;
    vtESCTimestamp: TLongWordField;
    vtESCBECCurrent: TSingleField;
    vtESCBECVolt: TSingleField;
    vtESCBECTemp: TSingleField;
    vtESCCurrent: TSingleField;
    vtESCVolt: TSingleField;
    vtESCFETTemp: TSingleField;
    vtESCThrottle: TSingleField;
    vtTemp: TVirtualTable;
    tsVario: TTabSheet;
    lvVario: TListView;
    vtVario: TVirtualTable;
    vtVarioTimestamp: TLongWordField;
    vtVarioAlt: TSingleField;
    vtVarioClimb: TSingleField;
    vtRXPackCapacityA: TSingleField;
    vtAltMaxAltitude: TSingleField;
    cbCombine: TCheckBox;
    tsGPS: TTabSheet;
    lvGPS: TListView;
    vtGPS: TVirtualTable;
    vtGPSTimestamp: TLongWordField;
    vtGPSSpeed: TSingleField;
    vtGPSSats: TByteField;
    vtGPSUTCTime: TLongWordField;
    vtGPSAlt: TSingleField;
    vtGPSHeading: TSingleField;
    vtGPSLatitude: TSingleField;
    vtGPSLongitude: TSingleField;
    btSettings: TButton;
    pmListView: TPopupMenu;
    vtESCRPM: TSingleField;
    vtESCOutput: TSingleField;
    pmPages: TPopupMenu;
    vtAirSpeedMaxAirspeed: TLongWordField;
    vtFlightPackCurrentB: TSingleField;
    vtFlightPackCapacityB: TSingleField;
    vtFlightPackTemperatureB: TSingleField;
    vtRXPackCapacityB: TSingleField;
    vtRXPackCurrentB: TSingleField;
    vtRXPackVoltB: TSingleField;
    vtRXPackPowerA: TSingleField;
    vtRXPackPowerB: TSingleField;
    vtESCBECPower: TSingleField;
    vtESCPower: TSingleField;
    cbExportAll: TCheckBox;
    vtLapTimer: TVirtualTable;
    tsLapTimer: TTabSheet;
    lvLapTimer: TListView;
    vtLapTimerTimestamp: TLongWordField;
    vtLapTimerLapNumber: TByteField;
    vtLapTimerGateNumber: TByteField;
    vtLapTimerLastLapTime: TLongWordField;
    vtLapTimerGateTime: TLongWordField;
    tsLipomon: TTabSheet;
    lvLipomon: TListView;
    vtLipomon: TVirtualTable;
    vtLipomonTimestamp: TLongWordField;
    vtLipomonCell1: TSingleField;
    vtLipomonCell2: TSingleField;
    vtLipomonCell3: TSingleField;
    vtLipomonCell4: TSingleField;
    vtLipomonCell5: TSingleField;
    vtLipomonCell6: TSingleField;
    vtLipomonTemp: TSingleField;
    vtStandardA: TShortintField;
    vtStandardB: TShortintField;
    vtLipomon14: TVirtualTable;
    vtLipomon14Timestamp: TLongWordField;
    vtLipomon14Cell1: TSingleField;
    vtLipomon14Cell2: TSingleField;
    vtLipomon14Cell3: TSingleField;
    vtLipomon14Cell4: TSingleField;
    vtLipomon14Cell5: TSingleField;
    vtLipomon14Cell6: TSingleField;
    vtLipomon14Cell7: TSingleField;
    vtLipomon14Cell8: TSingleField;
    vtLipomon14Cell9: TSingleField;
    vtLipomon14Cell10: TSingleField;
    vtLipomon14Cell11: TSingleField;
    vtLipomon14Cell12: TSingleField;
    vtLipomon14Cell13: TSingleField;
    vtLipomon14Cell14: TSingleField;
    tsLipomon14: TTabSheet;
    lvLipomon14: TListView;
    vtGyro: TVirtualTable;
    vtGyroTimestamp: TLongWordField;
    vtGyroX: TSingleField;
    vtGyroY: TSingleField;
    vtGyroZ: TSingleField;
    vtGyroMaxX: TSingleField;
    vtGyroMaxY: TSingleField;
    vtGyroMaxZ: TSingleField;
    tsGyro: TTabSheet;
    lvGyro: TListView;
    vtPowerBoxAlarms: TByteField;
    vtTurbine: TVirtualTable;
    vtTurbineTimestamp: TLongWordField;
    vtTurbineStatus: TByteField;
    vtTurbineThrottle: TByteField;
    vtTurbinePackVoltage: TSingleField;
    vtTurbinePumpVoltage: TSingleField;
    vtTurbineRPM: TLongWordField;
    vtTurbineTemperature: TSingleField;
    vtTurbineOffCondition: TByteField;
    vtTurbineFuelFlow: TWordField;
    vtTurbineRestFuel: TLongWordField;
    tsTurbine: TTabSheet;
    lvTurbine: TListView;
    vtCompass: TVirtualTable;
    vtCompassTimestamp: TLongWordField;
    vtCompassRoll: TSingleField;
    vtCompassPitch: TSingleField;
    vtCompassYaw: TSingleField;
    vtCompassMagX: TSmallintField;
    vtCompassMagY: TSmallintField;
    vtCompassMagZ: TSmallintField;
    tsCompass: TTabSheet;
    lvCompass: TListView;
    vt16s16u: TVirtualTable;
    vt16s16uTimestamp: TLongWordField;
    vt16s16uSignedField1: TSmallintField;
    vt16s16uSignedField2: TSmallintField;
    vt16s16uSignedField3: TSmallintField;
    vt16s16uUnsignedField1: TWordField;
    vt16s16uUnsignedField2: TWordField;
    vt16s16uUnsignedField3: TWordField;
    ts16s16u: TTabSheet;
    lv16s16u: TListView;
    ts16s16u32u: TTabSheet;
    lv16s16u32u: TListView;
    vt16s16u32u: TVirtualTable;
    vt16s16u32uTimestamp: TLongWordField;
    vt16s16u32uSignedField1: TSmallintField;
    vt16s16u32uSignedField2: TSmallintField;
    vt16s16u32uUnsignedField1: TWordField;
    vt16s16u32uUnsignedField2: TWordField;
    vt16s16u32uUnsignedField3: TWordField;
    vt16s16u32uUnsignedField4: TLongWordField;
    ts16s16u32s: TTabSheet;
    lv16s16u32s: TListView;
    vt16s16u32s: TVirtualTable;
    vt16s16u32sTimestamp: TLongWordField;
    vt16s16u32sSignedField1: TSmallintField;
    vt16s16u32sSignedField2: TSmallintField;
    vt16s16u32sUnsignedField1: TWordField;
    vt16s16u32sUnsignedField2: TWordField;
    vt16s16u32sUnsignedField3: TWordField;
    vt16s16u32sSignedField3: TIntegerField;
    ts16u32s32u: TTabSheet;
    lv16u32s32u: TListView;
    vt16u32s32u: TVirtualTable;
    vt16u32s32uTimestamp: TLongWordField;
    vt16u32s32uUnsignedField1: TWordField;
    vt16u32s32uSignedField1: TIntegerField;
    vt16u32s32uUnsignedField2: TLongWordField;
    vt16u32s32uUnsignedField3: TLongWordField;
    vt16s16uUnsignedField4: TWordField;
    vtGPSDistance: TSingleField;
    pmSessions: TPopupMenu;
    miSessionsChangePolesandRatio: TMenuItem;
    tsTextGen: TTabSheet;
    lvTextGen: TListView;
    vtTextGen: TVirtualTable;
    vtTextGenTimestamp: TLongWordField;
    vtTextGenLineNumer: TSmallintField;
    vtTextGenText: TStringField;
    miSessionsDeleteSession: TMenuItem;
    vtCrossfires: TVirtualTable;
    vtCrossfiresTimestamp: TLongWordField;
    vtCrossfiresAntenna1: TSmallintField;
    vtCrossfiresAntenna2: TSmallintField;
    vtCrossfiresQuality: TByteField;
    vtCrossfiresSNR: TShortintField;
    vtCrossfiresActiveAntenna: TByteField;
    vtCrossfiresRFMode: TByteField;
    vtCrossfiresUpPower: TWordField;
    vtCrossfiresDownLink: TSmallintField;
    vtCrossfiresQualityDown: TByteField;
    vtCrossfiresSNRDown: TShortintField;
    tsCrossfire: TTabSheet;
    lvCrossfire: TListView;
    vtFuel: TVirtualTable;
    vtFuelTimestamp: TLongWordField;
    vtFuelConsumedA: TSingleField;
    vtFuelFlowRateA: TSingleField;
    vtFuelTempA: TSingleField;
    vtFuelConsumedB: TSingleField;
    vtFuelFlowRateB: TSingleField;
    vtFuelTempB: TSingleField;
    tsFuel: TTabSheet;
    lvFuel: TListView;
    tsSmartBatt1: TTabSheet;
    lvSmartBatt1: TListView;
    vtSmartBatt1: TVirtualTable;
    vtSmartBatt1Timestamp: TLongWordField;
    vtSmartBatt1Temperature: TShortintField;
    vtSmartBatt1Discharge: TLongWordField;
    vtSmartBatt1Usage: TWordField;
    vtSmartBatt1Min: TWordField;
    vtSmartBatt1Max: TWordField;
    vtSmartBatt1Cell1: TWordField;
    vtSmartBatt1Cell2: TWordField;
    vtSmartBatt1Cell3: TWordField;
    vtSmartBatt1Cell4: TWordField;
    vtSmartBatt1Cell5: TWordField;
    vtSmartBatt1Cell6: TWordField;
    vtSmartBatt1Cell7: TWordField;
    vtSmartBatt1Cell8: TWordField;
    vtSmartBatt1Cell9: TWordField;
    vtSmartBatt1Cell10: TWordField;
    vtSmartBatt1Cell11: TWordField;
    vtSmartBatt1Cell12: TWordField;
    vtSmartBatt1Cell13: TWordField;
    vtSmartBatt1Cell14: TWordField;
    vtSmartBatt1Cell15: TWordField;
    vtSmartBatt1Cell16: TWordField;
    vtSmartBatt1Cell17: TWordField;
    vtSmartBatt1Cell18: TWordField;
    tsSmartBatt2: TTabSheet;
    lvSmartBatt2: TListView;
    vtSmartBatt2: TVirtualTable;
    vtSmartBatt2Timestamp: TLongWordField;
    vtSmartBatt2Temperature: TShortintField;
    vtSmartBatt2Sicharge: TLongWordField;
    vtSmartBatt2Usage: TWordField;
    vtSmartBatt2Min: TWordField;
    vtSmartBatt2Max: TWordField;
    vtSmartBatt2Cell1: TWordField;
    vtSmartBatt2Cell2: TWordField;
    vtSmartBatt2Cell3: TWordField;
    vtSmartBatt2Cell4: TWordField;
    vtSmartBatt2Cell5: TWordField;
    vtSmartBatt2Cell6: TWordField;
    vtSmartBatt2Cell7: TWordField;
    vtSmartBatt2Cell8: TWordField;
    vtSmartBatt2Cell9: TWordField;
    vtSmartBatt2Cell10: TWordField;
    vtSmartBatt2Cell11: TWordField;
    vtSmartBatt2Cell12: TWordField;
    vtSmartBatt2Cell13: TWordField;
    vtSmartBatt2Cell14: TWordField;
    vtSmartBatt2Cell15: TWordField;
    vtSmartBatt2Cell16: TWordField;
    vtSmartBatt2Cell17: TWordField;
    vtSmartBatt2Cell18: TWordField;
    btBattInfo1: TButton;
    btBattInfo2: TButton;
    vtTankPressure: TVirtualTable;
    vtTankPressureTimestamp: TLongWordField;
    vtTankPressurePressure1: TSingleField;
    vtTankPressurePressure2: TSingleField;
    vtTankPressurePressure3: TSingleField;
    vtTankPressurePressure4: TSingleField;
    tsTankPressure: TTabSheet;
    lvTankPressure: TListView;
    tsMultiCylinder: TTabSheet;
    lvMultiCylinder: TListView;
    vtMultiCylinder: TVirtualTable;
    vtMultiCylinderTimestamp: TLongWordField;
    vtMultiCylinderCylinder1: TWordField;
    vtMultiCylinderCylinder2: TWordField;
    vtMultiCylinderCylinder3: TWordField;
    vtMultiCylinderCylinder4: TWordField;
    vtMultiCylinderCylinder5: TWordField;
    vtMultiCylinderCylinder6: TWordField;
    vtMultiCylinderCylinder7: TWordField;
    vtMultiCylinderCylinder8: TWordField;
    vtMultiCylinderCylinder9: TWordField;
    vtMultiCylinderThrottle: TByteField;
    vtMultiCylinderRpm: TWordField;
    vtMultiCylinderBatt: TSingleField;
    btTrackDetails: TButton;
    vtCompassHeading: TSingleField;
    vtTxInput: TVirtualTable;
    vtTxInputTimestamp: TLongWordField;
    vtTxInputA: TByteField;
    vtTxInputB: TByteField;
    vtTxInputC: TByteField;
    vtTxInputD: TByteField;
    vtTxInputE: TByteField;
    vtTxInputF: TByteField;
    vtTxInputG: TByteField;
    vtTxInputH: TByteField;
    vtTxInputI: TByteField;
    vtTxInputJ: TByteField;
    vtTxInputK: TByteField;
    vtTxInputL: TByteField;
    vtTxInputM: TByteField;
    vtTxInputN: TByteField;
    vtTxInputO: TByteField;
    vtTxInputP: TByteField;
    vtTxInputS: TByteField;
    vtTxInputT: TByteField;
    vtTxInputLTP: TByteField;
    vtTxInputRTP: TByteField;
    vtTxInputLST: TByteField;
    vtTxInputRST: TByteField;
    vtTxInputTRN: TByteField;
    vtTxInputCLR: TByteField;
    vtTxInputBCK: TByteField;
    vtTxInputROL: TByteField;
    vtTxInputFNC: TByteField;
    vtTxInputLLEVER: TByteField;
    vtTxInputRLEVER: TByteField;
    vtTxInputRFU1: TByteField;
    vtTxInputRFU2: TByteField;
    vtTxInputRFU3: TByteField;
    vtTxInputRKNOB: TSmallintField;
    vtTxInputLKNOB: TSmallintField;
    vtTxInputTHR: TSmallintField;
    vtTxInputELE: TSmallintField;
    vtTxInputAIL: TSmallintField;
    vtTxInputRUD: TSmallintField;
    vtTxInputLSLIDER: TSmallintField;
    vtTxInputRSLIDER: TSmallintField;
    vtTxInputPOT3: TSmallintField;
    vtTxInputPOT4: TSmallintField;
    vtTxInputPOT5: TSmallintField;
    vtTxInputPOT6: TSmallintField;
    vtTxInputTBD1: TSmallintField;
    vtTxInputTBD2: TSmallintField;
    tsTxInput: TTabSheet;
    lvTxInput: TListView;
    tsVoltage: TTabSheet;
    lvVoltage: TListView;
    vtVoltage: TVirtualTable;
    vtVoltageTimestamp: TLongWordField;
    vtVoltageVoltage: TSingleField;
    btGpsSettings: TButton;
    vtGPSFix: TByteField;
    btVarioOffsets: TButton;
    btAltOffsets: TButton;
    miSessionsExport: TMenuItem;
    btGpsOffsets: TButton;
    vtStandardUptime: TWordField;
    btDocs: TButton;
    vtStandardFastbooted: TSmallintField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btGraphDataClick(Sender: TObject);
    procedure btExportClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btAboutClick(Sender: TObject);
    procedure lvSessionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewData(Sender: TObject; Item: TListItem);
    procedure vtGPSUTCTimeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure btSettingsClick(Sender: TObject);
    procedure pmListViewPopup(Sender: TObject);
    procedure ListViewMenuItemClick(Sender: TObject);
    procedure ListViewChangeVisibleColumnsClick(Sender: TObject);
    procedure ListViewMenuRenameItemClick(Sender: TObject);
    procedure ListViewMenuShowSmartBattInfoClick(Sender: TObject);
    procedure ListViewMenuGpsTrackInfoClick(Sender: TObject);
    procedure ListViewMenuSetAltZeroClick(Sender: TObject);
    procedure ListViewMenuCopyRecordsClick(Sender: TObject);
    procedure ListViewMenuDeleteRecordsClick(Sender: TObject);
    procedure ListViewMenuFileRawDataClick(Sender: TObject);
    procedure ListViewMenuRestoreColumnDefaultsClick(Sender: TObject);
    procedure pmPagesPopup(Sender: TObject);
    procedure PagesMenuItemClick(Sender: TObject);
    procedure FieldGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure lvRXCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure vtPowerBoxAlarmsGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure NullableFieldGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure vtTurbineStatusGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure vtTurbineOffConditionGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure pmSessionsPopup(Sender: TObject);
    procedure miSessionsChangePolesandRatioClick(Sender: TObject);
    procedure miSessionsDeleteSessionClick(Sender: TObject);
    procedure cbCombineClick(Sender: TObject);
    procedure btBattInfoClick(Sender: TObject);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btTrackDetailsClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure lvSessionsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cbExportAllClick(Sender: TObject);
    procedure btGpsSettingsClick(Sender: TObject);
    procedure lvGPSCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure vtGPSFixGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure btOffsetsClick(Sender: TObject);
    procedure miSessionsExportClick(Sender: TObject);
    procedure btDocsClick(Sender: TObject);
    procedure vtStandardFastbootedGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  private type
    TByteFile = file of Byte;

  private
    FSessions: TList;
    FNoStore: Boolean;
    FTempUnits: TTempUnits;
    FLengthUnits: TLengthUnits;
    FPostProcessing: TPostprocessing;
    FUseMenuForColumns: Boolean;
    FApperture: Byte;
    FWarnings: TRxWarnings;
    FCurrentWarnings: TRxWarnings;
    FOpeningFile: Boolean;
    FUseNewParser: Boolean;
    FFullFileName: string; // Used when switched parser.
    FDoNotAsk: Boolean;
    FEnableRxFiltering: Boolean;
    FSessionChanged: Boolean;
    FTimeGap: TTimeGap;
    FTabs: TList;
    FTimeZoneIndex: Byte;
    FFixNameReading: Boolean;
    FAltZeroProcessing: TAltZeroProcessing;
    FGpsAltZeroProcessing: TAltZeroProcessing;
    FVarioAltZeroProcessing: TAltZeroProcessing;

    FAltOffset: Single;
    FAltOffsetUseSensor: Boolean;
    FGpsOffset: Single;
    FGpsOffsetUseSensor: Boolean;
    FVarioOffset: Single;
    FVarioOffsetUseSensor: Boolean;
    FAltZeros: TList;

    FPageName: string;

    // Event handler for the Timestamp field. Do not remove or modify!
    procedure GetTimeStampText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    // WM_DROPFILES message handler. Do not remove or modify!
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;

    function IsSwitch(const Name: string; const Multy: Boolean): Boolean;

    {$REGION Single Graph Functions}
    procedure BuildSingleGraph;
    function SGBuildGraph(const Scope: TSLScope;
      const SensorName: string): Boolean;
    procedure SGRestoreGraphSettings(const Form: TForm; const Scope: TSLScope;
      const KeyName: string);
    procedure SGSaveGraphSettings(const Form: TForm; const Scope: TSLScope;
      const KeyName: string);
    {$ENDREGION}

    {$REGION Mixed data helper functions}
    function MixGetSensorName(const Table: TVirtualTable): string;

    procedure MixShowSensors(const TargetListView: TListView);
    procedure MixRestoreSensorsSettings(const ListView: TListView;
      const Csv: Boolean);
    procedure MixSaveSensorsSettings(const ListView: TListView;
      const Csv: Boolean);
    procedure MixBuildTablesList(const Tables: TList; const ListView: TListView;
      var RecCnt: Integer);
    {$ENDREGION}

    {$REGION Mix Graph Functions}
    procedure BuildMixGraph;
    procedure MGPrepareData(const Tables: TList);
    procedure MGBuildGraph(const Scope: TSLScope);
    procedure MGRestoreGraphSettings(const Form: TForm; const Scope: TSLScope);
    procedure MGSaveGraphSettings(const Form: TForm; const Scope: TSLScope);
    {$ENDREGION}

    {$REGION Initialization functions}
    procedure RegWriteStr(const Reg: TRegistry; const Key, Value: string);
    procedure InitTable(const Page: TTabSheet; const Table: TVirtualTable;
      const SensorId: Byte);
    procedure InitTables;
    procedure RestoreTableDefaultFields(const Table: TVirtualTable);
    procedure InitListViews;
    {$ENDREGION}

    {$REGION Export functions}
    {$REGION CSV export functions}
    procedure AddTextToLine(const Text: string; var Line: string);
    procedure MoveCompletedLineToList(const Strings: TStringList;
      var Line: string);

    procedure SaveToCSVFile(const Table: TVirtualTable; const Append: Boolean);
    procedure SaveToKMLFile(const Table: TVirtualTable);
    procedure ExecuteExport(const Table: TVirtualTable; const Append: Boolean);

    procedure ExportMixedData;
    {$ENDREGION}

    {$REGION TLM export functions}
    procedure ExportTlmWriteHeader(const F: TByteFile;
      const Session: TTelemetrySession);
    procedure ExportTlmWriteSensor(const F: TByteFile;
      const Sensor: TSensorData);
    procedure ExportTlmWriteFooter(const F: TByteFile;
      const Session: TTelemetrySession);
    procedure ExportTlmSingleSession(Item: TListItem);
    procedure ExportTlmAllSessions;
    procedure ExportTlm(Session: TListItem);
   {$ENDREGION}

    procedure DoExport(const Session: TListItem);
    {$ENDREGION}

    {$REGION Show sensors data}
    procedure RestoreWarnings(const Item: TListItem);
    procedure RestoreTimeGap(const Item: TListItem);
    procedure ShowSensorsData(const Session: TTelemetrySession;
      out RssiA: Boolean; out RssiB: Boolean; out RssiLemon: Boolean);
    procedure SetUpdate(const Start: Boolean);
    procedure PrepareSensors;
    {$ENDREGION}

    {$REGION Work with pages}
    procedure ShowTabs;
    procedure LoadPages;
    procedure SavePages;
    {$ENDREGION}

    {$REGION Sensor processing}
    function GetMed(Arr: array of Single): Single;
    procedure PushTimestamp(const Timestamp: Cardinal; var Ndx: Integer;
      var Arr: TTimestampArray);
    procedure PushSensor(const Timestamp: Cardinal; const Value: Single;
      var Ndx: Integer; var Arr: TSensorArray);
    procedure ProcessSensor(const Ndx: Integer; const SrcArr: TSensorArray;
      var DstArr: TSensorArray);
    {$ENDREGION}

    {$REGION Sensors}
    procedure AddTab(const Ts: TTabSheet);
    function IsTabAdded(const Ts: TTabSheet): Boolean;

    procedure AddVoltage(const Sensor: STRU_TELE_HV);
    procedure AddCurrent(const Sensor: STRU_TELE_IHIGH);
    procedure AppendPowerBox(const Timestamp: Cardinal; const Volt1: Variant;
      const Cap1: Variant; const Volt2: Variant; const Cap2: Variant;
      const Alarms: Variant);
    procedure AddPowerBox(const Sensor: STRU_TELE_POWERBOX);
    procedure AddLapTimer(const Sensor: STRU_TELE_LAPTIMER);
    procedure AddAirSpeed(const Sensor: STRU_TELE_SPEED);
    procedure AddAlt(const Sensor: STRU_TELE_ALT);
    procedure AddAccel(const Sensor: STRU_TELE_G_METER);
    procedure AddJetCat(const Sensor1: STRU_TELE_JETCAT;
      const Sensor2: STRU_TELE_JETCAT2; const Timestamp: Cardinal);
    procedure AddGps(const Sensor: STRU_TELE_GPS);
    procedure AddRxPack(const Sensor: STRU_TELE_RX_MAH);
    procedure AddGyro(const Sensor: STRU_TELE_GYRO);
    procedure AddCompass(const Sensor: STRU_TELE_ATTMAG);
    procedure AddEsc(const Sensor: STRU_TELE_ESC);
    procedure AddFuel(const Sensor: STRU_TELE_FUEL);
    procedure AddFlightPack(const Sensor: STRU_TELE_FP_MAH);
    procedure AddTankPressure(const Sensor: STRU_TELE_DIGITAL_AIR);
    procedure AddLipomon(const Sensor: STRU_TELE_LIPOMON);
    procedure AddLipomon14(const Sensor: STRU_TELE_LIPOMON_14);
    procedure AddVario(const Sensor: STRU_TELE_VARIO_S);
    procedure Add16s16u(const Sensor: STRU_TELE_USER_16SU);
    procedure Add16s16u32u(const Sensor: STRU_TELE_USER_16SU32U);
    procedure Add16s16u32s(const Sensor: STRU_TELE_USER_16SU32S);
    procedure Add16u32s32u(const Sensor: STRU_TELE_USER_16U32SU);
    procedure AddMultiCylinder(const Sensor: STRU_TELE_MULTI_TEMP);
    procedure AddCrossfire(const Sensor: STRU_TELE_XF_QOS);
    procedure AddRpm(const Sensor: STRU_TELE_RPM);
    procedure AddRx(const Sensor: STRU_TELE_QOS);
    procedure AddTextGen(const Sensor: STRU_TELE_TEXTGEN);
    procedure AddSmartBatt(const Sensor: STRU_SMARTBATT);
    procedure AddTxInput(const Sensor: STRU_TELE_TXINPUT);

    procedure ClearOffsets;
    procedure SetOffsets(const Sensor: STRU_TELE_ALT_ZERO);
    {$ENDREGION}

    function GetListViewMark(const ListView: TListView;
      const Column: TListColumn): TListViewSortMark;

    {$REGION List View Columns Building}
    procedure SaveColumnDefaults;
    procedure SetRssiHeadersSpm4650(const RssiA: Boolean; const RssiB: Boolean);
    procedure SetRssiHeadersLemon(const Rssi: Boolean);
    procedure SetSmartBattCells;
    procedure RestoreListViewColumns(const ListView: TListView;
      const Default: Boolean = False);
    procedure SaveAllListViewColumns(const Default: Boolean = False);
    procedure SaveListViewColumns(const ListView: TListView;
      const Default: Boolean = False);
    procedure SaveFieldsState(const Item: TListItem);
    procedure RestoreFieldsState(const Item: TListItem; const RssiA: Boolean;
      const RssiB: Boolean; const RssiLemon: Boolean);
    procedure RebuildListView(const ListView: TListView;
      const Default: Boolean = False);
    procedure RebuildActiveListView;
    {$ENDREGION}

    {$REGION Units}
    procedure SetTempUnits;
    procedure SetLengthUnits;
    {$ENDREGION}

    procedure PrepareTempTable(const SourceTable: TVirtualTable);
    procedure CopyDataToTempTable(const Table: TVirtualTable);
    procedure ReleaseTempTable;

    {$REGION Graph settings}
    function GetPrecision(const Field: TField): Integer;
    procedure SetChannelTag(const Channel: TSLScopeChannel; const Str: string);
    procedure SetFirstChannel(const Scope: TSLScope; const Prec: Integer;
      const DisplayLabel: string; const Visible: Boolean);
    procedure SetNextChannel(const Scope: TSLScope; const Prec: Integer;
      const DisplayLabel: string; const Visible: Boolean);
    procedure SetYAxisColor(const Axis: TSLDisplayAxis; const Color: TColor);
    {$ENDREGION}

    procedure StartOperation(const Caption: string; Max: Integer);
    procedure ShowProgress(const Pos: Integer);
    procedure EndOperation;

    procedure SetListViewMark(const ListView: TListView; const Column: Integer;
      const Mark: TListViewSortMark);
    procedure SetImage(const ID: Integer);

    function RegReadInt(const Reg: TRegistry; const Name: string;
      const Def: Integer): Integer;

    procedure SavePosition(const Form: TForm);
    procedure RestorePosition(const Form: TForm);

    procedure ProcessTLMFile(const FileName: string; const Sessions: TList;
      const UseNewParser: Boolean; const FixNameReading: Boolean);
    procedure OpenTLMFile(const FileName: string);
    procedure RefreshSessions;
    procedure RefreshSession;
    procedure ShowSessions;
    function FindGroup(const Header: string): TListGroup;
    procedure AddGroupItem(const Session: TTelemetrySession;
      const GroupID: Integer; const Caption: string);
    procedure SetSessionTime(const Item: TListItem;
      const Session: TTelemetrySession);
    procedure UpdateSessionsTime;
    procedure ClearTelemetry;
    procedure Clear;
    procedure ClearSessionsListView;
    procedure EnableButtons(const Enabled: Boolean);
    procedure UpdateGraphDataButton;
    procedure UpdateMixDataCheckBox;

    function GetActiveListView: TListView;
    function GetPageListView(const Page: TTabSheet): TListView;
    function GetListView(const Index: Integer): TListView;
    function GetTable(const ListView: TListView): TVirtualTable;
    function GetFieldByColumn(const Table: TVirtualTable;
      const Column: TListColumn): TField;
    function GetSensorTable(const SensorId: Byte): TVirtualTable;

    {$REGION Session editing}
    // Checks if session has been changed and saves it.
    procedure SaveSession(const Item: TListItem);
    procedure DeleteSessionRecords;
    {$ENDREGION}

    {$REGION Settings}
    { TODO -cSettings : Load settings }
    procedure InitSettings;
    procedure LoadSettings(const Reset: Boolean);
    procedure SaveSettings;
    {$ENDREGION}

    procedure ShowGpsTrackInfo;

  public
    property OpeningFile: Boolean read FOpeningFile;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  SysUtils, System.UITypes, Winapi.CommCtrl, ShellApi, ShlObj, System.Types,
  Mitov.VCLTypes, Variants, Clipbrd, Math,

  progressdialog, about, graph, graphselect, settings, splash, renamecolumns,
  changepolesandratio, selectparser, smartbattinfodlg, gpstrackinfo,
  columnseditor, gpssettingsinfo, offsets;

{ TfmMain }

const
  IMG_ID_OPEN_FILE = 0;
  IMG_ID_SELECT_SESSION = 1;
  IMG_ID_MODEL_START = 2;

  NA = 'n/a';

  MIN_TIME = $FFFFFFFF;

  RADIUS = 6371000;

function ToRad(const Deg: Single): Single;
begin
  Result := Deg * PI / 180;
end;

procedure TfmMain.btGpsSettingsClick(Sender: TObject);
var
  Info: TfmGpsSettingsInfo;
  Session: TTelemetrySession;
  Dist: Word;
  Units: string;
begin
  Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);

  Info := TfmGpsSettingsInfo.Create(Self);

  case Session.GpsSettings.AltitudeKind of
    akMSL:
      begin
        Info.laAltitudeKind.Caption := 'Mean Sea Level';
        Info.laAltitudeKindShort.Caption := 'MSL';
      end;

    akAGL:
      begin
        Info.laAltitudeKind.Caption := 'Above Ground Level';
        Info.laAltitudeKindShort.Caption := 'AGL';
      end;

    else begin
      Info.laAltitudeKind.Caption := 'Unknown';
      Info.laAltitudeKindShort.Caption := '';
    end;
  end;

  Dist := Session.GpsSettings.Distance;
  if FLengthUnits = luImperial then begin
    Dist := Round(Dist * 3.28084);
    Units := ' ft';
  end else
    Units := ' m';
  Info.laMaxDistance.Caption := IntToStr(Dist) + Units;

  case Session.GpsSettings.Alarm of
    STRU_TELE_GPS.GPS_ALARM_NONE:
      Info.laAlarmType.Caption := 'None';
    STRU_TELE_GPS.GPS_ALARM_TONE:
      Info.laAlarmType.Caption := 'Tone';
    STRU_TELE_GPS.GPS_ALARM_VIBE:
      Info.laAlarmType.Caption := 'Vibe';
    STRU_TELE_GPS.GPS_ALARM_VOICE:
      Info.laAlarmType.Caption := 'Voice';
    STRU_TELE_GPS.GPS_ALARM_TONE_VIBE:
      Info.laAlarmType.Caption := 'Tone & Vibe';
    STRU_TELE_GPS.GPS_ALARM_TONE_VOICE:
      Info.laAlarmType.Caption := 'Tone & Voice';
    STRU_TELE_GPS.GPS_ALARM_VIBE_VOICE:
      Info.laAlarmType.Caption := 'Vibe & Voice';
    STRU_TELE_GPS.GPS_ALARM_TONE_VIBE_VOICE:
      Info.laAlarmType.Caption := 'Tone & Vibe & Voice';
    else
      Info.laAlarmType.Caption := 'Unknown';
  end;

  Info.ShowModal;
  Info.Free;
end;

procedure TfmMain.btGraphDataClick(Sender: TObject);
begin
  if cbCombine.Checked then
    BuildMixGraph
  else
    BuildSingleGraph;
end;

function TfmMain.FindGroup(const Header: string): TListGroup;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to lvSessions.Groups.Count - 1 do begin
    if lvSessions.Groups[I].Header = Header then begin
      Result := lvSessions.Groups[I];
      Break;
    end;
  end;

  if Result = nil then begin
    Result := lvSessions.Groups.Add;
    Result.Header := Header;
    Result.State := [lgsNormal, lgsCollapsed, lgsCollapsible];
  end;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveSession(lvSessions.Selected);

  CanClose := True;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  FileName: string;
  Reg: TRegistry;
  Reset: Boolean;
  I: Integer;
  Param: string;
begin
  { TODO -cSettings : InitializeSettings }
  FormatSettings.DecimalSeparator := '.';
  InitSettings;

  FAltZeros := TList.Create;
  FPageName := '';

  FSessions := TList.Create;
  SetImage(IMG_ID_OPEN_FILE);

  FTabs := TList.Create;

  Clear;

  // Parse command line paramerters
  Reset := False;
  FileName := '';
  FNoStore := False;
  if ParamCount > 0 then begin
    for I := 1 to ParamCount do begin
      Param := LowerCase(ParamStr(I));
      if (Param = '/reset') or (Param = '-reset') then begin
        Reset := True;
        Continue;
      end;

      if (Param = '/nostore') or (Param = '-nostore') then begin
        FNoStore := True;
        Continue;
      end;

      Param := ParamStr(I);
      if FileExists(Param) then begin
        FileName := Param;
        Continue;
      end;
    end;
  end;

  LoadSettings(Reset);

  // Restore settings
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    // Set file association
    RegWriteStr(Reg, '\Software\Classes\.tlm', 'SpektrumTLMFiles');
    RegWriteStr(Reg, '\Software\Classes\SpektrumTLMFiles',
      'Spektrum Telemetry Log Files');
    RegWriteStr(Reg, '\Software\Classes\SpektrumTLMFiles\DefaultIcon',
      Application.ExeName);

    if FNoStore then begin
      RegWriteStr(Reg, '\Software\Classes\SpektrumTLMFiles\shell\open\command',
        Application.ExeName + ' /nostore "%1"')
    end else begin
      RegWriteStr(Reg, '\Software\Classes\SpektrumTLMFiles\shell\open\command',
        Application.ExeName + ' "%1"');
    end;

    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);

  finally
    Reg.Free;
  end;

  // Restore window position and columns
  if FNoStore then
    Position := poScreenCenter
  else
    RestorePosition(Self);

  DragAcceptFiles(Handle, True);

  InitTables;
  InitListViews;

  SetTempUnits;
  SetLengthUnits;

  SaveColumnDefaults;

  if FileName <> '' then begin
    FOpeningFile := True;

    try
      OpenTLMFile(FileName);
    finally
      fmSplash.Free;
      fmSplash := nil;
    end;

  end else
    FOpeningFile := False;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);

  SaveSettings;
  SaveAllListViewColumns;
  SavePosition(Self);
  SavePages;

  Clear;

  FAltZeros.Free;
  FSessions.Free;
  FTabs.Free;
end;

procedure TfmMain.btExportClick(Sender: TObject);
begin
  DoExport(nil);
end;

procedure TfmMain.btOpenClick(Sender: TObject);
begin
  SaveSession(lvSessions.Selected);

  if OpenDialog.Execute then
    OpenTLMFile(OpenDialog.FileName);
end;

procedure TfmMain.btSettingsClick(Sender: TObject);
var
  fmSet: TfmSettings;
  PostProcessingChanged: Boolean;
  TempChanged: Boolean;
  UnitsChanged: Boolean;
  Tmp: TRxWarnings;
  TgTmp: TTimeGap;
  WarningsChanged: Boolean;
  Reg: TRegistry;
  ParserChanged: Boolean;
  Rebuild: Boolean;
  TmpFileName: string;
  UseNewParser: Boolean;
  Key: string;
  RxFilteringChanged: Boolean;
  TimegapChanged: Boolean;
  TimezoneChanged: Boolean;
  FixNameReadingChanged: Boolean;
  AltZeroChanged: Boolean;
begin
  PostProcessingChanged := False;
  TempChanged := False;
  UnitsChanged := False;
  WarningsChanged := False;
  ParserChanged := False;
  RxFilteringChanged := False;
  TimegapChanged := False;
  TimezoneChanged := False;
  FixNameReadingChanged := False;
  AltZeroChanged := False;

  fmSet := TfmSettings.Create(Self);
  try
    fmSet.cbTempUnits.ItemIndex := Integer(FTempUnits);
    fmSet.cbLengthUnits.ItemIndex := Integer(FLengthUnits);
    fmSet.cbPostProcessing.ItemIndex := Integer(FPostProcessing);
    fmSet.cbUseMenuForColumns.Checked := FUseMenuForColumns;
    fmSet.cbFixNameReading.Checked := FFixNameReading;
    fmSet.tbApperture.Position := FApperture;
    fmSet.cbEnabledRxFiltering.Checked := FEnableRxFiltering;
    if FDoNotAsk then begin
      if FUseNewParser then
        fmSet.cbParser.ItemIndex := 0
      else
        fmSet.cbParser.ItemIndex := 1;
    end else
      fmSet.cbParser.ItemIndex := 2;

    fmSet.cbTimeZone.ItemIndex := FTimeZoneIndex;

    fmSet.cbAltZeroProcessingForAltimeter.ItemIndex := Integer(FAltZeroProcessing);
    fmSet.cbAltZeroProcessingForGps.ItemIndex := Integer(FGpsAltZeroProcessing);
    fmSet.cbAltZeroProcessingForVariometer.ItemIndex := Integer(FVarioAltZeroProcessing);

    // Warnings reading
    if lvSessions.Selected = nil then
      fmSet.tsModel.TabVisible := False
    else begin
      fmSet.tsModel.Caption := lvSessions.Selected.SubItems[0];
      fmSet.edAFade.Text := IntToStr(FWarnings.A);
      fmSet.edBFade.Text := IntToStr(FWarnings.B);
      fmSet.edRFade.Text := IntToStr(FWarnings.R);
      fmSet.edLFade.Text := IntToStr(FWarnings.L);
      fmSet.edTotalFades.Text := IntToStr(FWarnings.Fades);
      fmSet.edHolds.Text := IntToStr(FWarnings.Holds);
      fmSet.edFrameLoss.Text := IntToStr(FWarnings.Frames);
      fmSet.cbUse.Checked := FWarnings.Use;

      fmSet.cbTimegap.Checked := FTimeGap.Enabled;
      fmSet.edTimegap.Text := IntToStr(FTimeGap.Gap);
    end;

    if fmSet.ShowModal = mrOK then begin
      FUseMenuForColumns := fmSet.cbUseMenuForColumns.Checked;
      if fmSet.cbFixNameReading.Checked <> FFixNameReading then begin
        FFixNameReading := fmSet.cbFixNameReading.Checked;
        FixNameReadingChanged := True;
      end;
      if fmSet.cbTimeZone.ItemIndex <> FTimeZoneIndex then begin
        FTimeZoneIndex := fmSet.cbTimeZone.ItemIndex;
        TimezoneChanged := True;
      end;

      if fmSet.cbAltZeroProcessingForAltimeter.ItemIndex <> Integer(FAltZeroProcessing) then begin
        FAltZeroProcessing:= TAltZeroProcessing(fmSet.cbAltZeroProcessingForAltimeter.ItemIndex);
        AltZeroChanged := True;
      end;

      if fmSet.cbAltZeroProcessingForGps.ItemIndex <> Integer(FGpsAltZeroProcessing) then begin
        FGpsAltZeroProcessing:= TAltZeroProcessing(fmSet.cbAltZeroProcessingForGps.ItemIndex);
        AltZeroChanged := True;
      end;

      if fmSet.cbAltZeroProcessingForVariometer.ItemIndex <> Integer(FVarioAltZeroProcessing) then begin
         FVarioAltZeroProcessing := TAltZeroProcessing(fmSet.cbAltZeroProcessingForVariometer.ItemIndex);
         AltZeroChanged := True;
      end;

      // Warnings saving.
      if lvSessions.Selected <> nil then begin
        Tmp.A := StrToInt(fmSet.edAFade.Text);
        Tmp.B := StrToInt(fmSet.edBFade.Text);
        Tmp.R := StrToInt(fmSet.edRFade.Text);
        Tmp.L := StrToInt(fmSet.edLFade.Text);
        Tmp.Fades := StrToInt(fmSet.edTotalFades.Text);
        Tmp.Holds := StrToInt(fmSet.edHolds.Text);
        Tmp.Frames := StrToInt(fmSet.edFrameLoss.Text);
        Tmp.Use := fmSet.cbUse.Checked;
        WarningsChanged := (FWarnings.A <> Tmp.A) or (FWarnings.B <> Tmp.B) or
          (FWarnings.R <> Tmp.R) or (FWarnings.L <> Tmp.L) or
          (FWarnings.Fades <> Tmp.Fades) or (FWarnings.Frames <> Tmp.Frames) or
          (FWarnings.Holds <> Tmp.Holds) or (FWarnings.Use <> Tmp.Use);

        if WarningsChanged then begin
          FWarnings := Tmp;

          Reg := TRegistry.Create;
          try
            Reg.RootKey := HKEY_CURRENT_USER;
            Key := REG_KEY + '\' + lvSessions.Selected.SubItems[0] +
              '\Warnings';
            if Reg.OpenKey(Key, True) then begin
              try
                Reg.WriteInteger('A', FWarnings.A);
                Reg.WriteInteger('B', FWarnings.B);
                Reg.WriteInteger('R', FWarnings.R);
                Reg.WriteInteger('L', FWarnings.L);
                Reg.WriteInteger('Fades', FWarnings.Fades);
                Reg.WriteInteger('Frames', FWarnings.Frames);
                Reg.WriteInteger('Holds', FWarnings.Holds);
                Reg.WriteBool('Use', FWarnings.Use);

              finally
                Reg.CloseKey;
              end;
            end;

          finally
            Reg.Free;
          end;
        end;

        TgTmp.Enabled := fmSet.cbTimegap.Checked;
        TgTmp.Gap := StrToInt(fmSet.edTimegap.Text);
        TimegapChanged := (TgTmp.Enabled <> FTimeGap.Enabled) or
          (TgTmp.Gap <> FTimeGap.Gap);
        if TimegapChanged then begin
          FTimeGap := TgTmp;

          Reg := TRegistry.Create;
          try
            Reg.RootKey := HKEY_CURRENT_USER;
            Key := REG_KEY + '\' + lvSessions.Selected.SubItems[0] + '\Timegap';
            if Reg.OpenKey(Key, True) then begin
              try
                Reg.WriteBool('Enabled', FTimeGap.Enabled);
                Reg.WriteInteger('Gap', FTimeGap.Gap);

              finally
                Reg.CloseKey;
              end;
            end;

          finally
            Reg.Free;
          end;
        end;
      end;

      if FTempUnits <> TTempUnits(fmSet.cbTempUnits.ItemIndex) then begin
        TempChanged := True;
        FTempUnits := TTempUnits(fmSet.cbTempUnits.ItemIndex);
      end;
      if FLengthUnits <> TLengthUnits(fmSet.cbLengthUnits.ItemIndex) then begin
        UnitsChanged := True;
        FLengthUnits := TLengthUnits(fmSet.cbLengthUnits.ItemIndex);
      end;
      if FPostProcessing <> TPostProcessing(fmSet.cbPostProcessing.ItemIndex) then
      begin
        FPostProcessing := TPostProcessing(fmSet.cbPostProcessing.ItemIndex);
        PostProcessingChanged := True;
      end;
      if FApperture <> fmSet.tbApperture.Position then begin
        FApperture := fmSet.tbApperture.Position;
        if FPostProcessing = ppSmooth then
          PostProcessingChanged := True;
      end;
      if (FEnableRxFiltering <> fmSet.cbEnabledRxFiltering.Checked) and
         fmSet.cbEnabledRxFiltering.Visible
      then begin
        FEnableRxFiltering := fmSet.cbEnabledRxFiltering.Checked;
        RxFilteringChanged := True;
      end;

      // Process only if we actually changed the parser. If only changed to Ask
      // do nothing even file has already been opened.
      if fmSet.cbParser.ItemIndex < 2 then begin
        UseNewParser := fmSet.cbParser.ItemIndex = 0;
        if FUseNewParser <> UseNewParser then begin
          ParserChanged := True;
          FUseNewParser := UseNewParser;
        end;
        FDoNotAsk := True;
      end else
        FDoNotAsk := False;
    end;

  finally
    fmSet.Free;
  end;

  if TimezoneChanged then
    UpdateSessionsTime;

  if TempChanged then
    SetTempUnits;
  if UnitsChanged then
    SetLengthUnits;

  if (ParserChanged or FixNameReadingChanged) and (FFullFileName <> '') then
  begin
    TmpFileName := FFullFileName;
    if ParserChanged then
      OpenTLMFile(TmpFileName)
    else
      ProcessTLMFile(TmpFileName, FSessions, FUseNewParser, FFixNameReading);

  end else begin
    Rebuild := PostProcessingChanged or UnitsChanged or TempChanged or
      WarningsChanged or RxFilteringChanged or TimegapChanged or AltZeroChanged;
    if (lvSessions.Selected <> nil) and Rebuild then
      RefreshSession;
  end;
end;

procedure TfmMain.btTrackDetailsClick(Sender: TObject);
begin
  ShowGpsTrackInfo;
end;

procedure TfmMain.BuildMixGraph;
var
  CombineForm: TfmGraphSelect;
  Tables: TList;
  RecCnt: Integer;
  GraphForm: TfmGraph;
begin
  CombineForm := TfmGraphSelect.Create(Self);
  try
    MixShowSensors(CombineForm.lvSensors);
    MixRestoreSensorsSettings(CombineForm.lvSensors, False);

    if CombineForm.ShowModal = mrOK then begin
      MixSaveSensorsSettings(CombineForm.lvSensors, False);

      // Prepare graph table
      vtTemp.FieldDefs.Clear;
      vtTemp.FieldDefs.Add('Timestamp', ftLongWord);
      vtTemp.FieldDefs.Add('ChannelID', ftInteger);
      vtTemp.FieldDefs.Add('ChannelName', ftString, 266);
      vtTemp.FieldDefs.Add('DataValue', ftSingle);
      vtTemp.FieldDefs.Add('Prec', ftInteger);
      vtTemp.Open;

      try
        Tables := TList.Create;
        try
          MixBuildTablesList(Tables, CombineForm.lvSensors, RecCnt);
          if Tables.Count = 0 then
            MessageDlg('No data was selected.', mtWarning, [mbOK], 0)

          else begin
            StartOperation('Preparing data...', RecCnt);
            try
              MGPrepareData(Tables);

              StartOperation('Building graph...', vtTemp.RecordCount - 1);

              GraphForm := TfmGraph.Create(Self);
              try
                GraphForm.Caption := 'Graph Data - ' + laFileName.Caption;
                GraphForm.SLScope.Title.Text := laFileName.Caption +
                  ' - Mixed Graph';
                MGBuildGraph(GraphForm.SLScope);

                MGRestoreGraphSettings(GraphForm, GraphForm.SLScope);
                GraphForm.ShowModal;
                MGSaveGraphSettings(GraphForm, GraphForm.SLScope);

              finally
                GraphForm.Free;
              end;

            finally
              EndOperation;
            end;
          end;

        finally
          Tables.Free;
        end;

      finally
        ReleaseTempTable;
      end;
    end;

  finally
    CombineForm.Free;
  end;
end;

procedure TfmMain.BuildSingleGraph;
var
  ListView: TListView;
  Table: TVirtualTable;
  GraphForm: TfmGraph;
begin
  ListView := GetActiveListView;
  if ListView <> nil then begin
    Table := GetTable(ListView);
    if Table <> nil then begin
      PrepareTempTable(Table);
      try
        StartOperation('Preparing data...', Table.RecordCount - 1);
        try
          CopyDataToTempTable(Table);

          GraphForm := TfmGraph.Create(Self);
          try
            GraphForm.Caption := 'Graph Data - ' + laFileName.Caption;
            GraphForm.SLScope.Title.Text := laFileName.Caption + ' - ' +
              PageControl.ActivePage.Caption;

            StartOperation('Building graph...', Table.RecordCount - 1);
            if SGBuildGraph(GraphForm.SLScope, PageControl.ActivePage.Caption) then
            begin
              SGRestoreGraphSettings(GraphForm, GraphForm.SLScope,
                ListView.Name);

              GraphForm.ShowModal;

              SGSaveGraphSettings(GraphForm, GraphForm.SLScope, ListView.Name);

            end else
              MessageDlg('No data for graph', mtWarning, [mbOK], 0);

          finally
            GraphForm.Free;
          end;

        finally
          EndOperation;
        end;

      finally
        ReleaseTempTable;
      end;
    end;
  end;
end;

procedure TfmMain.cbCombineClick(Sender: TObject);
begin
  // In mix mode we can not export all sessions!
  if cbCombine.Checked then
    cbExportAll.Checked := False;

  UpdateGraphDataButton;
end;

procedure TfmMain.cbExportAllClick(Sender: TObject);
begin
  btExport.Enabled := cbExportAll.Checked or (lvSessions.Selected <> nil);
end;

procedure TfmMain.Add16s16u(const Sensor: STRU_TELE_USER_16SU);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Process: Boolean;
begin
  // We process only simple filtering for this sensor.
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    // We just skip only all invalid data. Any other data is added.
    // No filtering.
    Process := Sensor.SignedField1.Valid or Sensor.SignedField2.Valid or
               Sensor.SignedField3.Valid or Sensor.UnsignedField1.Valid or
               Sensor.UnsignedField2.Valid or Sensor.UnsignedField3.Valid or
               Sensor.UnsignedField4.Valid or (FPostProcessing = ppNone);

    if Process then begin
      vt16s16u.AppendRecord([Sensor.Timestamp,
                             Sensor.SignedField1.Value,
                             Sensor.SignedField2.Value,
                             Sensor.SignedField3.Value,
                             Sensor.UnsignedField1.Value,
                             Sensor.UnsignedField2.Value,
                             Sensor.UnsignedField3.Value,
                             Sensor.UnsignedField4.Value]);

      if FPostProcessing = ppNone then begin
        if FTimeGap.Enabled and (not TabAdded) then begin
          if CurTime = MIN_TIME then
            CurTime := Sensor.Timestamp
          else begin
            if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
              AddTab(ts16s16u);
              TabAdded := True;
            end;
            CurTime := Sensor.Timestamp;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.Add16s16u32s(const Sensor: STRU_TELE_USER_16SU32S);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Process: Boolean;
begin
  // We process only simple filtering for this sensor.
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    // We just skip only all invalid data. Any other data is added.
    // No filtering.
    Process := Sensor.SignedField1.Valid or Sensor.SignedField2.Valid or
      Sensor.UnsignedField1.Valid or Sensor.UnsignedField2.Valid or
      Sensor.UnsignedField3.Valid or Sensor.SignedField3.Valid or
      (FPostProcessing = ppNone);

    if Process then begin
      vt16s16u32s.AppendRecord([Sensor.Timestamp,
                                Sensor.SignedField1.Value,
                                Sensor.SignedField2.Value,
                                Sensor.UnsignedField1.Value,
                                Sensor.UnsignedField2.Value,
                                Sensor.UnsignedField3.Value,
                                Sensor.SignedField3.Value]);

      if FPostProcessing = ppNone then begin
        if FTimeGap.Enabled and (not TabAdded) then begin
          if CurTime = MIN_TIME then
            CurTime := Sensor.Timestamp
          else begin
            if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
              AddTab(ts16s16u32s);
              TabAdded := True;
            end;
            CurTime := Sensor.Timestamp;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.Add16s16u32u(const Sensor: STRU_TELE_USER_16SU32U);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Process: Boolean;
begin
  // We process only simple filtering for this sensor.
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    // We just skip only all invalid data. Any other data is added.
    // No filtering.
    Process := Sensor.SignedField1.Valid or Sensor.SignedField2.Valid or
               Sensor.UnsignedField1.Valid or Sensor.UnsignedField2.Valid or
               Sensor.UnsignedField3.Valid or Sensor.UnsignedField4.Valid or
               (FPostProcessing = ppNone);

    if Process then begin
      vt16s16u32u.AppendRecord([Sensor.Timestamp,
                                Sensor.SignedField1.Value,
                                Sensor.SignedField2.Value,
                                Sensor.UnsignedField1.Value,
                                Sensor.UnsignedField2.Value,
                                Sensor.UnsignedField3.Value,
                                Sensor.UnsignedField4.Value]);

      if FPostProcessing = ppNone then begin
        if FTimeGap.Enabled and (not TabAdded) then begin
          if CurTime = MIN_TIME then
            CurTime := Sensor.Timestamp
          else begin
            if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
              AddTab(ts16s16u32u);
              TabAdded := True;
            end;
            CurTime := Sensor.Timestamp;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.Add16u32s32u(const Sensor: STRU_TELE_USER_16U32SU);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Process: Boolean;
begin
  // We process only simple filtering for this sensor.
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    // We just skip only all invalid data. Any other data is added.
    // No filtering.
    Process := Sensor.UnsignedField1.Valid or Sensor.SignedField1.Valid or
               Sensor.UnsignedField2.Valid or Sensor.UnsignedField3.Valid or
               (FPostProcessing = ppNone);

    if Process then begin
      vt16u32s32u.AppendRecord([Sensor.Timestamp,
                                Sensor.UnsignedField1.Value,
                                Sensor.SignedField1.Value,
                                Sensor.UnsignedField2.Value,
                                Sensor.UnsignedField3.Value]);

      if FPostProcessing = ppNone then begin
        if FTimeGap.Enabled and (not TabAdded) then begin
          if CurTime = MIN_TIME then
            CurTime := Sensor.Timestamp
          else begin
            if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
              AddTab(ts16u32s32u);
              TabAdded := True;
            end;
            CurTime := Sensor.Timestamp;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddAccel(const Sensor: STRU_TELE_G_METER);
{$J+}
const
  Axis: array [0..2] of Single = ( 0, 0, 0 );
  AxisMax: array [0..2] of Single = ( 0, 0, 0 );
  ZMin: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  AxisArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  AxisNdx: array [0..2] of Integer = ( 0, 0, 0 );
  AxisMaxArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  AxisMaxNdx: array [0..2] of Integer = ( 0, 0, 0 );
  ZMinArr: TSensorArray = nil;
  ZMinNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurAxis: array [0..2] of Variant;
  CurAxisMax: array [0..2] of Variant;
  CurZMin: Variant;
  TmpAxisArr: array [0..2] of TSensorArray;
  TmpAxisMaxArr: array [0..2] of TSensorArray;
  TmpZMinArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 2 do begin
            ProcessSensor(AxisNdx[J], AxisArr[J], TmpAxisArr[J]);
            ProcessSensor(AxisMaxNdx[J], AxisMaxArr[J], TmpAxisMaxArr[J]);

            CurAxis[J] := NULL;
            CurAxisMax[J] := NULL;

            AxisNdx[J] := 0;
            AxisMaxNdx[J] := 0;
          end;

          ProcessSensor(ZMinNdx, ZMinArr, TmpZMinArr);

          ZMinNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 2 do begin
                if AxisNdx[J] = Length(TmpAxisArr[J]) then
                  CurAxis[J] := NULL
                else begin
                  if TmpAxisArr[J][AxisNdx[J]].Timestamp = Timestamp then begin
                    CurAxis[J] := TmpAxisArr[J][AxisNdx[J]].Value;
                    Inc(AxisNdx[J]);
                  end;
                end;

                if AxisMaxNdx[J] = Length(TmpAxisMaxArr[J]) then
                  CurAxisMax[J] := NULL
                else begin
                  if TmpAxisMaxArr[J][AxisMaxNdx[J]].Timestamp = Timestamp then
                  begin
                    CurAxisMax[J] := TmpAxisMaxArr[J][AxisMaxNdx[J]].Value;
                    Inc(AxisMaxNdx[J]);
                  end;
                end;
              end;

              if ZMinNdx = Length(TmpZMinArr) then
                CurZMin := NULL
              else begin
                if (TmpZMinArr <> nil) and
                   (TmpZMinArr[ZMinNdx].Timestamp = Timestamp)
                then begin
                  CurZMin := TmpZMinArr[ZMinNdx].Value;
                  Inc(ZMinNdx);
                end;
              end;

              vtAccel.AppendRecord([Timestamp, CurAxis[0], CurAxisMax[0],
                CurAxis[1], CurAxisMax[1], CurAxis[2], CurZMin, CurAxisMax[2]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 2 do begin
            TmpAxisArr[J] := nil;
            TmpAxisMaxArr[J] := nil;
          end;
          TmpZMinArr := nil;
        end;
      end;

    finally
      for J := 0 to 2 do begin
        Axis[J] := 0;
        AxisMax[J] := 0;

        AxisArr[J] := nil;
        AxisNdx[J] := 0;

        AxisMaxArr[J] := nil;
        AxisMaxNdx[J] := 0;
      end;
      TimestampArr := nil;
      TimestampNdx := 0;

      ZMin := 0;

      ZMinArr := nil;
      ZMinNdx := 0;
    end

  end else begin
    for J := 0 to 2 do begin
      if Sensor.Axis[J].Valid then
        CurAxis[J] := Sensor.Axis[J].Value
      else
        CurAxis[J] := NULL;

      if Sensor.AxisMax[J].Valid then
        CurAxisMax[J] := Sensor.AxisMax[J].Value
      else
        CurAxisMax[J] := NULL;
    end;

    if Sensor.ZMin.Valid then
      CurZMin := Sensor.ZMin.Value
    else
      CurZMin := NULL;

    if FPostProcessing = ppNone then begin
      vtAccel.AppendRecord([Sensor.Timestamp, CurAxis[0], CurAxisMax[0],
        CurAxis[1], CurAxisMax[1], CurAxis[2], CurZMin, CurAxisMax[2]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsAccel);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 2 do begin
        if (CurAxis[J] <> NULL) and ((CurAxis[J] < -40) or (CurAxis[J] > 40)) then
          CurAxis[J] := NULL;
        if (CurAxisMax[J] <> NULL) and ((CurAxisMax[J] < -40) or (CurAxisMax[J] > 40)) then
          CurAxisMax[J] := NULL;
      end;
      if (CurZMin <> NULL) and ((CurZMin < -40) or (CurZMin > 40)) then
        CurZMin := NULL;

      for J := 0 to 2 do begin
        NotNull := (CurAxis[J] <> NULL) or (CurAxisMax[J] <> NULL);
        if NotNull then
          Break;
      end;
      NotNull := NotNull or (CurZMin <> NULL);

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 2 do begin
            if (CurAxisMax[J] <> NULL) and (CurAxisMax[J] > AxisMax[J]) then
              AxisMax[J] := CurAxisMax[J];

            if CurAxis[J] <> NULL then
              Axis[J] := CurAxis[J];
          end;
          if (CurZMin <> NULL) and (CurZMin <= ZMin) then
            ZMin := CurZMin;

          vtAccel.AppendRecord([Sensor.Timestamp, Axis[0], AxisMax[0], Axis[1],
            AxisMax[1], Axis[2], ZMin, AxisMax[2]]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 2 do begin
            if CurAxis[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurAxis[J], AxisNdx[J], AxisArr[J]);
            if CurAxisMax[J] <> NULL then begin
              PushSensor(Sensor.Timestamp, CurAxisMax[J], AxisMaxNdx[J],
                AxisMaxArr[J]);
            end;
          end;

          if CurZMin <> NULL then
            PushSensor(Sensor.Timestamp, CurZMin, ZMinNdx, ZMinArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddAirSpeed(const Sensor: STRU_TELE_SPEED);
{$J+}
const
  Speed: Cardinal = 0;
  MaxSpeed: Cardinal = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  SpeedArr: TSensorArray = nil;
  SpeedNdx: Integer = 0;
  MaxSpeedArr: TSensorArray = nil;
  MaxSpeedNdx: Integer = 0;
  MaxSpeedSet: Boolean = False;
  MaxSpeedBySpeed: Cardinal = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurSpeed: Variant;
  CurMaxSpeed: Variant;
  TmpSpeedArr: TSensorArray;
  TmpMaxSpeedArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          ProcessSensor(SpeedNdx, SpeedArr, TmpSpeedArr);
          ProcessSensor(MaxSpeedNdx, MaxSpeedArr, TmpMaxSpeedArr);

          CurSpeed := NULL;
          CurMaxSpeed := NULL;

          SpeedNdx := 0;
          MaxSpeedNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];

              if SpeedNdx = Length(TmpSpeedArr) then
                CurSpeed := NULL
              else begin
                if TmpSpeedArr[SpeedNdx].Timestamp = Timestamp then begin
                  CurSpeed := TmpSpeedArr[SpeedNdx].Value;
                  Inc(SpeedNdx);
                end;
              end;

              if MaxSpeedNdx = Length(TmpMaxSpeedArr) then
                CurMaxSpeed := NULL
              else begin
                if TmpMaxSpeedArr[MaxSpeedNdx].Timestamp = Timestamp then begin
                  CurMaxSpeed := TmpMaxSpeedArr[MaxSpeedNdx].Value;
                  Inc(MaxSpeedNdx);
                end;
              end;

              vtAirSpeed.AppendRecord([Timestamp, CurSpeed, CurMaxSpeed]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpSpeedArr := nil;
          TmpMaxSpeedArr := nil;
        end;
      end;

    finally
      Speed := 0;
      MaxSpeed := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      SpeedArr := nil;
      SpeedNdx := 0;
      MaxSpeedArr := nil;
      MaxSpeedNdx := 0;

      MaxSpeedSet := False;
      MaxSpeedBySpeed := 0;
    end

  end else begin
    if Sensor.Speed[FLengthUnits].Valid then
      CurSpeed := Sensor.Speed[FLengthUnits].Value
    else
      CurSpeed := NULL;
    if (CurSpeed <> NULL) and (not MaxSpeedSet) and (CurSpeed > MaxSpeedBySpeed) then
      MaxSpeedBySpeed := CurSpeed;

    if Sensor.SpeedMax[FLengthUnits].Valid then begin
      CurMaxSpeed := Sensor.SpeedMax[FLengthUnits].Value;
      if not MaxSpeedSet then begin
        if CurMaxSpeed > MaxSpeedBySpeed then
          CurMaxSpeed := NULL
        else
          MaxSpeedSet := True;
      end;
    end else
      CurMaxSpeed := NULL;

    if FPostProcessing = ppNone then begin
      vtAirSpeed.AppendRecord([Sensor.Timestamp, CurSpeed, CurMaxSpeed]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsAirSpeed);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurSpeed <> NULL) or (CurMaxSpeed <> NULL) then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          if (CurMaxSpeed <> NULL) and (CurMaxSpeed >= MaxSpeed) then
            MaxSpeed := CurMaxSpeed;

          if CurSpeed <> NULL then
            Speed := CurSpeed;

          vtAirSpeed.AppendRecord([Sensor.Timestamp, Speed, MaxSpeed]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          if CurSpeed <> NULL then
            PushSensor(Sensor.Timestamp, CurSpeed, SpeedNdx, SpeedArr);

          if CurMaxSpeed <> NULL then
            PushSensor(Sensor.Timestamp, CurMaxSpeed, MaxSpeedNdx, MaxSpeedArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddAlt(const Sensor: STRU_TELE_ALT);

  procedure ApplyOffset(var Alt: Variant);
  begin
    if Alt <> NULL then begin
      if FAltOffsetUseSensor then begin
        FAltOffset := Alt;
        FAltOffsetUseSensor := False;
      end;
      Alt := Alt - FAltOffset;
    end;
  end;

{$J+}
const
  Alt: Single = 0;
  AltMax: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  AltArr: TSensorArray = nil;
  AltNdx: Integer = 0;
  AltMaxArr: TSensorArray = nil;
  AltMaxNdx: Integer = 0;
  AltMaxSet: Boolean = False;
  AltMaxByAlt: Single = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurAlt: Variant;
  CurAltMax: Variant;
  TmpAltArr: TSensorArray;
  TmpAltMaxArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          ProcessSensor(AltNdx, AltArr, TmpAltArr);
          ProcessSensor(AltMaxNdx, AltMaxArr, TmpAltMaxArr);

          CurAlt := NULL;
          CurAltMax := NULL;

          AltNdx := 0;
          AltMaxNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              if AltNdx = Length(TmpAltArr) then
                CurAlt := NULL
              else begin
                if TmpAltArr[AltNdx].Timestamp = Timestamp then begin
                  CurAlt := TmpAltArr[AltNdx].Value;
                  Inc(AltNdx);
                end;
              end;

              if AltMaxNdx = Length(TmpAltMaxArr) then
                CurAltMax := NULL
              else begin
                if TmpAltMaxArr[AltMaxNdx].Timestamp = Timestamp then begin
                  CurAltMax := TmpAltMaxArr[AltMaxNdx].Value;
                  Inc(AltMaxNdx);
                end;
              end;

              ApplyOffset(CurAlt);
              vtAlt.AppendRecord([Timestamp, CurAlt, CurAltMax]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpAltArr := nil;
          TmpAltMaxArr := nil;
        end;
      end;

    finally
      Alt := 0;
      AltMax := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      AltArr := nil;
      AltNdx := 0;
      AltMaxArr := nil;
      AltMaxNdx := 0;

      AltMaxSet := False;
      AltMaxByAlt := 0;
    end

  end else begin
    if Sensor.Alt[FLengthUnits].Valid then
      CurAlt := Sensor.Alt[FLengthUnits].Value
    else
      CurAlt := NULL;
    if (CurAlt <> NULL) and (not AltMaxSet) and (CurAlt > AltMaxByAlt) then
      AltMaxByAlt := CurAlt;

    if Sensor.AltMax[FLengthUnits].Valid then begin
      CurAltMax := Sensor.AltMax[FLengthUnits].Value;
      if not AltMaxSet then begin
        if CurAltMax > AltMaxByAlt then
          CurAltMax := NULL
        else
          AltMaxSet := True;
      end;
    end else
      CurAltMax := NULL;

    if FPostProcessing = ppNone then begin
      ApplyOffset(CurAlt);
      vtAlt.AppendRecord([Sensor.Timestamp, CurAlt, CurAltMax]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsAlt);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurAlt <> NULL) or (CurAltMax <> NULL) then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          if (CurAltMax <> NULL) and (CurAltMax >= AltMax) then
            AltMax := CurAltMax;

          if CurAlt <> NULL then begin
            ApplyOffset(CurAlt);
            Alt := CurAlt;
          end;
          vtAlt.AppendRecord([Sensor.Timestamp, Alt, AltMax]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          if CurAlt <> NULL then
            PushSensor(Sensor.Timestamp, CurAlt, AltNdx, AltArr);

          if CurAltMax <> NULL then
            PushSensor(Sensor.Timestamp, CurAltMax, AltMaxNdx, AltMaxArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddCompass(const Sensor: STRU_TELE_ATTMAG);
{$J+}
const
  Axis: array [0..2] of Single = ( 0, 0, 0 );
  Mag: array [0..2] of SmallInt = ( 0, 0, 0 );
  Heading: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  AxisArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  AxisNdx: array [0..2] of Integer = ( 0, 0, 0 );
  MagArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  MagNdx: array [0..2] of Integer = ( 0, 0, 0 );
  HeadingArr: TSensorArray = nil;
  HeadingNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurAxis: array [0..2] of Variant;
  CurMag: array [0..2] of Variant;
  CurHeading: Variant;
  TmpAxisArr: array [0..2] of TSensorArray;
  TmpMagArr: array [0..2] of TSensorArray;
  TmpHeadingArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 2 do begin
            ProcessSensor(AxisNdx[J], AxisArr[J], TmpAxisArr[J]);
            ProcessSensor(MagNdx[J], MagArr[J], TmpMagArr[J]);

            CurAxis[J] := NULL;
            CurMag[J] := NULL;

            AxisNdx[J] := 0;
            MagNdx[J] := 0;
          end;

          ProcessSensor(HeadingNdx, HeadingArr, TmpHeadingArr);
          CurHeading := NULL;
          HeadingNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 2 do begin
                if AxisNdx[J] = Length(TmpAxisArr[J]) then
                  CurAxis[J] := NULL
                else begin
                  if TmpAxisArr[J][AxisNdx[J]].Timestamp = Timestamp then begin
                    CurAxis[J] := TmpAxisArr[J][AxisNdx[J]].Value;
                    Inc(AxisNdx[J]);
                  end;
                end;

                if MagNdx[J] = Length(TmpMagArr[J]) then
                  CurMag[J] := NULL
                else begin
                  if TmpMagArr[J][MagNdx[J]].Timestamp = Timestamp then begin
                    CurMag[J] := TmpMagArr[J][MagNdx[J]].Value;
                    Inc(MagNdx[J]);
                  end;
                end;
              end;

              if HeadingNdx = Length(TmpHeadingArr) then
                CurHeading := NULL
              else begin
                if TmpHeadingArr[HeadingNdx].Timestamp = Timestamp then begin
                  CurHeading := TmpHeadingArr[HeadingNdx].Value;
                  Inc(HeadingNdx);
                end;
              end;

              vtCompass.AppendRecord([Timestamp, CurAxis[0], CurAxis[1],
                CurAxis[2], CurMag[0], CurMag[1], CurMag[2]. CurHeading]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 2 do begin
            TmpAxisArr[J] := nil;
            TmpMagArr[J] := nil;
          end;
          TmpHeadingArr := nil;
        end;
      end;

    finally
      for J := 0 to 2 do begin
        Axis[J] := 0;
        Mag[J] := 0;

        AxisArr[J] := nil;
        AxisNdx[J] := 0;

        MagArr[J] := nil;
        MagNdx[J] := 0;
      end;
      HeadingArr := nil;
      HeadingNdx := 0;
      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    for J := 0 to 2 do begin
      if Sensor.Axis[J].Valid then
        CurAxis[J] := Sensor.Axis[J].Value
      else
        CurAxis[J] := NULL;

      if Sensor.Mag[J].Valid then
        CurMag[J] := Sensor.Mag[J].Value
      else
        CurMag[J] := NULL;
    end;
    if Sensor.Heading.Valid then
      CurHeading := Sensor.Heading.Value
    else
      CurHeading := NULL;


    if FPostProcessing = ppNone then begin
      vtCompass.AppendRecord([Sensor.Timestamp, CurAxis[0], CurAxis[1],
        CurAxis[2], CurMag[0], CurMag[1], CurMag[2], CurHeading]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsCompass);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurAxis[0] <> NULL) or (CurAxis[1] <> NULL) or (CurAxis[1] <> NULL) or
         (CurMag[0] <> NULL) or (CurMag[1] <> NULL) or (CurMag[1] <> NULL) or
         (CurHeading <> NULL)
      then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 2 do begin
            if CurAxis[J] <> NULL then
              Axis[J] := CurAxis[J];
            if CurMag[J] <> NULL then
              Mag[J] := CurMag[J];
          end;
          if CurHeading <> NULL then
            Heading := CurHeading;

          vtCompass.AppendRecord([Sensor.Timestamp, Axis[0], Axis[1], Axis[2],
            Mag[0], Mag[1], Mag[2], Heading]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          PushSensor(Sensor.Timestamp, CurHeading, HeadingNdx, HeadingArr);
          for J := 0 to 2 do begin
            if CurAxis[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurAxis[J], AxisNdx[J], AxisArr[J]);
            if CurMag[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurMag[J], MagNdx[J], MagArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddCrossfire(const Sensor: STRU_TELE_XF_QOS);
{$J+}
const
  Ant1: SmallInt = 0;
  Ant2: SmallInt = 0;
  Quality: Byte = 0;
  SNR: ShortInt = 0;
  ActiveAnt: Byte = 0;
  RFMode: Byte = 0;
  UpPower: Word = 0;
  DownLink: SmallInt = 0;
  QualityDown: Byte = 0;
  SNRDown: ShortInt = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurAnt1: Variant;
  CurAnt2: Variant;
  CurQuality: Variant;
  CurSNR: Variant;
  CurActiveAnt: Variant;
  CurRFMode: Variant;
  CurUpPower: Variant;
  CurDownLink: Variant;
  CurQualityDown: Variant;
  CurSNRDown: Variant;
begin
  if Sensor = nil then begin
    Ant1 := 0;
    Ant2 := 0;
    Quality := 0;
    SNR := 0;
    ActiveAnt := 0;
    RFMode := 0;
    UpPower := 0;
    DownLink := 0;
    QualityDown := 0;
    SNRDown := 0;
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    if Sensor.Ant1.Valid then
      CurAnt1 := Sensor.Ant1.Value
    else
      CurAnt1 := NULL;
    if Sensor.Ant2.Valid then
      CurAnt2 := Sensor.Ant2.Value
    else
      CurAnt2 := NULL;
    if Sensor.Quality.Valid then
      CurQuality := Sensor.Quality.Value
    else
      CurQuality := NULL;
    if Sensor.SNR.Valid then
      CurSNR := Sensor.SNR.Value
    else
      CurSNR := NULL;
    if Sensor.ActiveAnt.Valid then
      CurActiveAnt := Sensor.ActiveAnt.Value
    else
      CurActiveAnt := NULL;
    if Sensor.RFMode.Valid then
      CurRFMode := Sensor.RFMode.Value
    else
      CurRFMode := NULL;
    if Sensor.UpPower.Valid then
      CurUpPower := Sensor.UpPower.Value
    else
      CurUpPower := NULL;
    if Sensor.DownLink.Valid then
      CurDownLink := Sensor.DownLink.Value
    else
      CurDownLink := NULL;
    if Sensor.QualityDown.Valid then
      CurQualityDown := Sensor.QualityDown.Value
    else
      CurQualityDown := NULL;
    if Sensor.SNRDown.Valid then
      CurSNRDown := Sensor.SNRDown.Value
    else
      CurSNRDown := NULL;

    if FPostProcessing = ppNone then begin
      vtCrossfires.AppendRecord([Sensor.Timestamp, CurAnt1, CurAnt2, CurQuality,
        CurSNR, CurActiveAnt, CurRFMode, CurUpPower, CurDownLink,
        CurQualityDown, CurSNRDown]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsCrossfire);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurAnt1 <> NULL) and (CurAnt2 <> NULL) and (CurQuality <> NULL) and
         (CurSNR <> NULL) and (CurActiveAnt <> NULL) and (CurRFMode <> NULL) and
         (CurUpPower <> NULL) and (CurDownLink <> NULL) and
         (CurQualityDown <> NULL) and (CurSNRDown <> NULL)
      then begin
        if CurAnt1 <> NULL then
          Ant1 := CurAnt1;
        if CurAnt2 <> NULL then
          Ant2 := CurAnt2;
        if CurQuality <> NULL then
          Quality := CurQuality;
        if CurSNR <> NULL then
          SNR := CurSNR;
        if CurActiveAnt <> NULL then
          ActiveAnt := CurActiveAnt;
        if CurRFMode <> NULL then
          RFMode := CurRFMode;
        if CurUpPower <> NULL then
          UpPower := CurUpPower;
        if CurDownLink <> NULL then
          DownLink := CurDownLink;
        if CurQualityDown <> NULL then
          QualityDown := CurQualityDown;
        if CurSNRDown <> NULL then
          SNRDown := CurSNRDown;

        vtCrossfires.AppendRecord([Sensor.Timestamp, Ant1, Ant2, Quality, SNR,
          ActiveAnt, RFMode, UpPower, DownLink, QualityDown, SNRDown]);
      end;
    end;
  end;
end;

procedure TfmMain.AddVoltage(const Sensor: STRU_TELE_HV);
{$J+}
const
  VoltageArr: TSensorArray = nil;
  VoltageNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = false;
{$J-}
var
  CurVoltage: Variant;
  TmpVoltageArr: TSensorArray;
  I: Integer;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (VoltageNdx > 0) then begin
        try
          ProcessSensor(VoltageNdx, VoltageArr, TmpVoltageArr);

          StartOperation('Postprocessing...', VoltageNdx);
          try
            for I := 0 to VoltageNdx - 1 do begin
              ShowProgress(I);

              vtVoltage.AppendRecord([TmpVoltageArr[I].Timestamp,
                TmpVoltageArr[I].Value]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpVoltageArr := nil;
        end;
      end;

    finally
      VoltageArr := nil;
      VoltageNdx := 0;
    end

  end else begin
    if Sensor.Voltage.Valid then
      CurVoltage := Sensor.Voltage.Value
    else
      CurVoltage := NULL;

    if FPostProcessing = ppNone then begin
      vtVoltage.AppendRecord([Sensor.Timestamp, CurVoltage]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsCurrent);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if CurVoltage <> NULL then begin
        if FPostProcessing in [ppFilter, ppPeak] then
          vtVoltage.AppendRecord([Sensor.Timestamp, CurVoltage])
        else
          PushSensor(Sensor.Timestamp, CurVoltage, VoltageNdx, VoltageArr);
      end;
    end;
  end;
end;

procedure TfmMain.AddCurrent(const Sensor: STRU_TELE_IHIGH);
{$J+}
const
  CurrentArr: TSensorArray = nil;
  CurrentNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = false;
{$J-}
var
  CurCurrent: Variant;
  TmpCurrentArr: TSensorArray;
  I: Integer;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (CurrentNdx > 0) then begin
        try
          ProcessSensor(CurrentNdx, CurrentArr, TmpCurrentArr);

          StartOperation('Postprocessing...', CurrentNdx);
          try
            for I := 0 to CurrentNdx - 1 do begin
              ShowProgress(I);

              vtCurrent.AppendRecord([TmpCurrentArr[I].Timestamp,
                TmpCurrentArr[I].Value]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpCurrentArr := nil;
        end;
      end;

    finally
      CurrentArr := nil;
      CurrentNdx := 0;
    end

  end else begin
    if Sensor.Current.Valid then
      CurCurrent := Sensor.Current.Value
    else
      CurCurrent := NULL;

    if FPostProcessing = ppNone then begin
      vtCurrent.AppendRecord([Sensor.Timestamp, CurCurrent]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsCurrent);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurCurrent <> NULL) and (CurCurrent >= -150) and (CurCurrent <= 150)
      then begin
        if FPostProcessing in [ppFilter, ppPeak] then
          vtCurrent.AppendRecord([Sensor.Timestamp, CurCurrent])
        else
          PushSensor(Sensor.Timestamp, CurCurrent, CurrentNdx, CurrentArr);
      end;
    end;
  end;
end;

procedure TfmMain.AddEsc(const Sensor: STRU_TELE_ESC);
const
  RPM_PEAK = 500;
{$J+}
const
  BECCurrent: Single = 0;
  BECVolt: Single = 0;
  BECTemp: Single = 0;
  Current: Single = 0;
  FETTemp: Single = 0;
  Output: Single = 0;
  RPM: Single = 0;
  Throttle: Single = 0;
  Volt: Single = 0;
  BECPower: Single = 0;
  Power: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  BECCurrentArr: TSensorArray = nil;
  BECCurrentNdx: Integer = 0;
  BECVoltArr: TSensorArray = nil;
  BECVoltNdx: Integer = 0;
  BECTempArr: TSensorArray = nil;
  BECTempNdx: Integer = 0;
  CurrentArr: TSensorArray = nil;
  CurrentNdx: Integer = 0;
  FETTempArr: TSensorArray = nil;
  FETTempNdx: Integer = 0;
  OutputArr: TSensorArray = nil;
  OutputNdx: Integer = 0;
  RPMArr: TSensorArray = nil;
  RPMNdx: Integer = 0;
  ThrottleArr: TSensorArray = nil;
  ThrottleNdx: Integer = 0;
  VoltArr: TSensorArray = nil;
  VoltNdx: Integer = 0;
  BECPowerArr: TSensorArray = nil;
  BECPowerNdx: Integer = 0;
  PowerArr: TSensorArray = nil;
  PowerNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurBECCurrent: Variant;
  CurBECVolt: Variant;
  CurBECTemp: Variant;
  CurBECTempCheck: Variant;
  CurCurrent: Variant;
  CurFETTemp: Variant;
  CurFETTempCheck: Variant;
  CurOutput: Variant;
  CurRPM: Variant;
  CurThrottle: Variant;
  CurVolt: Variant;
  CurBECPower: Variant;
  CurPower: Variant;
  TmpBECCurrentArr: TSensorArray;
  TmpBECVoltArr: TSensorArray;
  TmpBECTempArr: TSensorArray;
  TmpCurrentArr: TSensorArray;
  TmpFETTempArr: TSensorArray;
  TmpOutputArr: TSensorArray;
  TmpRPMArr: TSensorArray;
  TmpThrottleArr: TSensorArray;
  TmpVoltArr: TSensorArray;
  TmpBECPowerArr: TSensorArray;
  TmpPowerArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          ProcessSensor(BECCurrentNdx, BECCurrentArr, TmpBECCurrentArr);
          ProcessSensor(BECTempNdx, BECTempArr, TmpBECTempArr);
          ProcessSensor(CurrentNdx, CurrentArr, TmpCurrentArr);
          ProcessSensor(FETTempNdx, FETTempArr, TmpFETTempArr);
          ProcessSensor(OutputNdx, OutputArr, TmpOutputArr);
          ProcessSensor(RPMNdx, RPMArr, TmpRPMArr);
          ProcessSensor(ThrottleNdx, ThrottleArr, TmpThrottleArr);
          ProcessSensor(VoltNdx, VoltArr, TmpVoltArr);
          ProcessSensor(BECPowerNdx, BECPowerArr, TmpBECPowerArr);
          ProcessSensor(PowerNdx, PowerArr, TmpPowerArr);

          CurBECCurrent := NULL;
          CurBECVolt := NULL;
          CurBECTemp := NULL;
          CurCurrent := NULL;
          CurFETTemp := NULL;
          CurOutput := NULL;
          CurRPM := NULL;
          CurThrottle := NULL;
          CurVolt := NULL;
          CurBECPower := NULL;
          CurPower := 0;

          BECCurrentNdx := 0;
          BECVoltNdx := 0;
          BECTempNdx := 0;
          CurrentNdx := 0;
          FETTempNdx := 0;
          OutputNdx := 0;
          RPMNdx := 0;
          ThrottleNdx := 0;
          VoltNdx := 0;
          BECPowerNdx := 0;
          PowerNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];

              if BECCurrentNdx = Length(TmpBECCurrentArr) then
                CurBECCurrent := NULL
              else begin
                if TmpBECCurrentArr[BECCurrentNdx].Timestamp = Timestamp then
                begin
                  CurBECCurrent := TmpBECCurrentArr[BECCurrentNdx].Value;
                  Inc(BECCurrentNdx);
                end;
              end;

              if BECVoltNdx = Length(TmpBECVoltArr) then
                CurBECVolt := NULL
              else begin
                if TmpBECVoltArr[BECVoltNdx].Timestamp = Timestamp then begin
                  CurBECVolt := TmpBECVoltArr[BECVoltNdx].Value;
                  Inc(BECVoltNdx);
                end;
              end;

              if BECTempNdx = Length(TmpBECTempArr) then
                CurBECTemp := NULL
              else begin
                if TmpBECTempArr[BECTempNdx].Timestamp = Timestamp then begin
                  CurBECTemp := TmpBECTempArr[BECTempNdx].Value;
                  Inc(BECTempNdx);
                end;
              end;

              if CurrentNdx = Length(TmpCurrentArr) then
                CurCurrent := NULL
              else begin
                if TmpCurrentArr[CurrentNdx].Timestamp = Timestamp then begin
                  CurCurrent := TmpCurrentArr[CurrentNdx].Value;
                  Inc(CurrentNdx);
                end;
              end;

              if FETTempNdx = Length(TmpFETTempArr) then
                CurFETTemp := NULL
              else begin
                if TmpFETTempArr[FETTempNdx].Timestamp = Timestamp then begin
                  CurFETTemp := TmpFETTempArr[FETTempNdx].Value;
                  Inc(FETTempNdx);
                end;
              end;

              if OutputNdx = Length(TmpOutputArr) then
                CurOutput := NULL
              else begin
                if TmpOutputArr[OutputNdx].Timestamp = Timestamp then begin
                  CurOutput := TmpOutputArr[OutputNdx].Value;
                  Inc(OutputNdx);
                end;
              end;

              if RPMNdx = Length(TmpRPMArr) then
                CurRPM := NULL
              else begin
                if TmpRPMArr[RPMNdx].Timestamp = Timestamp then begin
                  CurRPM := TmpRPMArr[RPMNdx].Value;
                  Inc(RPMNdx);
                end;
              end;

              if ThrottleNdx = Length(TmpThrottleArr) then
                CurThrottle := NULL
              else begin
                if TmpThrottleArr[ThrottleNdx].Timestamp = Timestamp then begin
                  CurThrottle := TmpThrottleArr[ThrottleNdx].Value;
                  Inc(ThrottleNdx);
                end;
              end;

              if VoltNdx = Length(TmpVoltArr) then
                CurVolt := NULL
              else begin
                if TmpVoltArr[VoltNdx].Timestamp = Timestamp then begin
                  CurVolt := TmpVoltArr[VoltNdx].Value;
                  Inc(VoltNdx);
                end;
              end;

              if BECPowerNdx = Length(TmpBECPowerArr) then
                CurBECPower := NULL
              else begin
                if TmpBECPowerArr[BECPowerNdx].Timestamp = Timestamp then begin
                  CurBECPower := TmpBECPowerArr[BECPowerNdx].Value;
                  Inc(BECPowerNdx);
                end;
              end;

              if PowerNdx = Length(TmpPowerArr) then
                CurPower := NULL
              else begin
                if TmpPowerArr[PowerNdx].Timestamp = Timestamp then begin
                  CurPower := TmpPowerArr[PowerNdx].Value;
                  Inc(PowerNdx);
                end;
              end;

              vtESC.AppendRecord([Timestamp, CurBECCurrent, CurBECVolt,
                CurBECPower, CurBECTemp, CurCurrent, CurVolt, CurPower,
                CurFETTemp, CurThrottle, CurOutput, CurRPM]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpBECCurrentArr := nil;
          TmpBECVoltArr := nil;
          TmpBECTempArr := nil;
          TmpCurrentArr := nil;
          TmpFETTempArr := nil;
          TmpOutputArr := nil;
          TmpRPMArr := nil;
          TmpThrottleArr := nil;
          TmpVoltArr := nil;
          TmpBECPowerArr := nil;
          TmpPowerArr := nil;
        end;
      end;

    finally
      BECCurrent := 0;
      BECVolt := 0;
      BECTemp := 0;
      Current := 0;
      FETTemp := 0;
      Output := 0;
      RPM := 0;
      Throttle := 0;
      Volt := 0;
      BECPower := 0;
      Power := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      BECCurrentArr := nil;
      BECCurrentNdx := 0;
      BECVoltArr := nil;
      BECVoltNdx := 0;
      BECTempArr := nil;
      BECTempNdx := 0;
      CurrentArr := nil;
      CurrentNdx := 0;
      FETTempArr := nil;
      FETTempNdx := 0;
      OutputArr := nil;
      OutputNdx := 0;
      RPMArr := nil;
      RPMNdx := 0;
      ThrottleArr := nil;
      ThrottleNdx := 0;
      VoltArr := nil;
      VoltNdx := 0;
      BECPowerArr := nil;
      BECPowerNdx := 0;
      PowerArr := nil;
      PowerNdx := 0;
    end

  end else begin
    if Sensor.BECCurrent.Valid then
      CurBECCurrent := Sensor.BECCurrent.Value
    else
      CurBECCurrent := NULL;
    if Sensor.BECVolt.Valid then
      CurBECVolt := Sensor.BECVolt.Value
    else
      CurBECVolt := NULL;
    if Sensor.BECTemp[FTempUnits].Valid then begin
      CurBECTemp := Sensor.BECTemp[FTempUnits].Value;
      CurBECTempCheck := Sensor.BECTemp[tuCelcius].Value;
    end else begin
      CurBECTemp := NULL;
      CurBECTempCheck := NULL;
    end;
    if Sensor.Current.Valid then
      CurCurrent := Sensor.Current.Value
    else
      CurCurrent := NULL;
    if Sensor.FETTemp[FTempUnits].Valid then begin
      CurFETTemp := Sensor.FETTemp[FTempUnits].Value;
      CurFETTempCheck := Sensor.FETTemp[tuCelcius].Value;
    end else begin
      CurFETTemp := NULL;
      CurFETTempCheck := NULL;
    end;
    if Sensor.Output.Valid then
      CurOutput := Sensor.Output.Value
    else
      CurOutput := NULL;
    if Sensor.RPM.Valid then
      CurRPM := Sensor.RPM.Value
    else
      CurRPM := NULL;
    if Sensor.Throttle.Valid then
      CurThrottle := Sensor.Throttle.Value
    else
      CurThrottle := NULL;
    if Sensor.Volt.Valid then
      CurVolt := Sensor.Volt.Value
    else
      CurVolt := NULL;
    if Sensor.BECPower.Valid then
      CurBECPower := Sensor.BECPower.Value
    else
      CurBECPower := NULL;
    if Sensor.Power.Valid then
      CurPower := Sensor.Power.Value
    else
      CurPower := NULL;

    if FPostProcessing = ppNone then begin
      vtESC.AppendRecord([Sensor.Timestamp, CurBECCurrent, CurBECVolt,
        CurBECPower, CurBECTemp, CurCurrent, CurVolt, CurPower, CurFETTemp,
        CurThrottle, CurOutput, CurRPM]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsESC);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurFETTempCheck <> NULL) and (CurFETTempCheck >= 999.9) then
        CurFETTemp := NULL;
      if (CurBECTempCheck <> NULL) and (CurBECTempCheck >= 999.9) then
        CurBECTemp := NULL;

      if (CurBECCurrent <> NULL) or (CurBECVolt <> NULL) or
         (CurBECPower <> NULL) or (CurBECTemp <> NULL) or
         (CurCurrent <> NULL) or (CurVolt <> NULL) or (CurPower <> NULL) or
         (CurFETTemp <> NULL) or (CurThrottle <> NULL) or (CurOutput <> NULL) or
         (CurRPM <> NULL)
      then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          if CurBECCurrent <> NULL then
            BECCurrent := CurBECCurrent;
          if CurBECVolt <> NULL then
            BECVolt := CurBECVolt;
          if CurBECTemp <> NULL then
            BECTemp := CurBECTemp;
          if CurCurrent <> NULL then
            Current := CurCurrent;
          if CurFETTemp <> NULL then
            FETTemp := CurFETTemp;
          if CurOutput <> NULL then
            Output := CurOutput;
          if CurThrottle <> NULL then
            Throttle := CurThrottle;
          if CurVolt <> NULL then
            Volt := CurVolt;
          if CurBECPower <> NULL then
            BECPower := CurBECPower;
          if CurPower <> NULL then
            Power := CurPower;
          if CurRPM <> NULL then begin
            if FPostProcessing = ppFilter then
              RPM := CurRPM
            else begin
              if (RPM + RPM_PEAK >= CurRPM) and (RPM - RPM_PEAK <= CurRPM) then
                RPM := CurRPM;
            end;
          end;

          vtESC.AppendRecord([Sensor.Timestamp, BECCurrent, BECVolt, BECPower,
            BECTemp, Current, Volt, Power, FETTemp, Throttle, Output, RPM]);


        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          if CurBECCurrent <> NULL then
            PushSensor(Sensor.Timestamp, CurBECCurrent, BECCurrentNdx, BECCurrentArr);
          if CurBECVolt <> NULL then
            PushSensor(Sensor.Timestamp, CurBECVolt, BECVoltNdx, BECVoltArr);
          if CurBECTemp <> NULL then
            PushSensor(Sensor.Timestamp, CurBECTemp, BECTempNdx, BECTempArr);
          if CurCurrent <> NULL then
            PushSensor(Sensor.Timestamp, CurCurrent, CurrentNdx, CurrentArr);
          if CurFETTemp <> NULL then
            PushSensor(Sensor.Timestamp, CurFETTemp, FETTempNdx, FETTempArr);
          if CurOutput <> NULL then
            PushSensor(Sensor.Timestamp, CurOutput, OutputNdx, OutputArr);
          if CurRPM <> NULL then
            PushSensor(Sensor.Timestamp, CurRPM, RPMNdx, RPMArr);
          if CurThrottle <> NULL then
            PushSensor(Sensor.Timestamp, CurThrottle, ThrottleNdx, ThrottleArr);
          if CurVolt <> NULL then
            PushSensor(Sensor.Timestamp, CurVolt, VoltNdx, VoltArr);
          if CurBECPower <> NULL then
            PushSensor(Sensor.Timestamp, CurBECPower, BECPowerNdx, BECPowerArr);
          if CurPower <> NULL then
            PushSensor(Sensor.Timestamp, CurPower, PowerNdx, PowerArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddFlightPack(const Sensor: STRU_TELE_FP_MAH);
{$J+}
const
  Cur: array [0..1] of Single = ( 0, 0 );
  Cap: array [0..1] of Single = ( 0, 0 );
  Temp: array [0..1] of Single = ( 0, 0 );
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  CurArr: array [0..1] of TSensorArray = ( nil, nil );
  CurNdx: array [0..1] of Integer = ( 0, 0 );
  CapArr: array [0..1] of TSensorArray = ( nil, nil );
  CapNdx: array [0..1] of Integer = ( 0, 0 );
  TempArr: array [0..1] of TSensorArray = ( nil, nil );
  TempNdx: array [0..1] of Integer = ( 0, 0 );
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurCur: array [0..1] of Variant;
  CurCap: array [0..1] of Variant;
  CurTemp: array [0..1] of Variant;
  CurTempCheck: array [0..1] of Variant;
  TmpCurArr: array [0..1] of TSensorArray;
  TmpCapArr: array [0..1] of TSensorArray;
  TmpTempArr: array [0..1] of TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 1 do begin
            ProcessSensor(CapNdx[J], CapArr[J], TmpCapArr[J]);
            ProcessSensor(CurNdx[J], CurArr[J], TmpCurArr[J]);
            ProcessSensor(TempNdx[J], TempArr[J], TmpTempArr[J]);

            CurCap[J] := NULL;
            CurCur[J] := NULL;
            CurTemp[J] := NULL;

            CapNdx[J] := 0;
            CurNdx[J] := 0;
            TempNdx[J] := 0;
          end;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 1 do begin
                if CapNdx[J] = Length(TmpCapArr[J]) then
                  CurCap[J] := NULL
                else begin
                  if TmpCapArr[J][CapNdx[J]].Timestamp = Timestamp then begin
                    CurCap[J] := TmpCapArr[J][CapNdx[J]].Value;
                    Inc(CapNdx[J]);
                  end;
                end;

                if CurNdx[J] = Length(TmpCurArr[J]) then
                  CurCur[J] := NULL
                else begin
                  if TmpCurArr[J][CurNdx[J]].Timestamp = Timestamp then begin
                    CurCur[J] := TmpCurArr[J][CurNdx[J]].Value;
                    Inc(CurNdx[J]);
                  end;
                end;

                if TempNdx[J] = Length(TmpTempArr[J]) then
                  CurTemp[J] := NULL
                else begin
                  if TmpTempArr[J][TempNdx[J]].Timestamp = Timestamp then begin
                    CurTemp[J] := TmpTempArr[J][TempNdx[J]].Value;
                    Inc(TempNdx[J]);
                  end;
                end;
              end;

              vtFlightPack.AppendRecord([Timestamp, CurCur[0], CurCap[0],
                CurTemp[0], CurCur[1], CurCap[1], CurTemp[1]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 1 do begin
            TmpCapArr[J] := nil;
            TmpCurArr[J] := nil;
            TmpTempArr[J] := nil;
          end;
        end;
      end;

    finally
      for J := 0 to 1 do begin
        Cur[J] := 0;
        Cap[J] := 0;
        Temp[J] := 0;

        CapArr[J] := nil;
        CapNdx[J] := 0;

        CurArr[J] := nil;
        CurNdx[J] := 0;

        TempArr[J] := nil;
        TempNdx[J] := 0;
      end;

      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    for J := 0 to 1 do begin
      if Sensor.Current[J].Valid then
        CurCur[J] := Sensor.Current[J].Value
      else
        CurCur[J] := NULL;

      if Sensor.Capacity[J].Valid then
        CurCap[J] := Sensor.Capacity[J].Value
      else
        CurCap[J] := NULL;

      if Sensor.Temp[FTempUnits][J].Valid then begin
        CurTemp[J] := Sensor.Temp[FTempUnits][J].Value;
        CurTempCheck[J] := Sensor.Temp[tuCelcius][J].Value;
      end else begin
        CurTemp[J] := NULL;
        CurTempCheck[J] := NULL;
      end;
    end;

    if FPostProcessing = ppNone then begin
      vtFlightPack.AppendRecord([Sensor.Timestamp, CurCur[0], CurCap[0],
        CurTemp[0], CurCur[1], CurCap[1], CurTemp[1]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsFlightPack);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 1 do begin
        if (CurTempCheck[J] <> NULL) and (CurTempCheck[J] > 150) then
          CurTemp[J] := NULL;
      end;

      for J := 0 to 1 do begin
        NotNull := (CurCap[J] <> NULL) or (CurCur[J] <> NULL) or (CurTemp[J] <> NULL);
        if NotNull then
          Break;
      end;

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 1 do begin
            if CurCur[J] <> NULL then
              Cur[J] := CurCur[J];
            if CurCap[J] <> NULL then
              Cap[J] := CurCap[J];
            if CurTemp[J] <> NULL then
              Temp[J] := CurTemp[J];
          end;

          vtFlightPack.AppendRecord([Sensor.Timestamp, Cur[0], Cap[0], Temp[0],
            Cur[1], Cap[1], Temp[1]]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 1 do begin
            if CurCap[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCap[J], CapNdx[J], CapArr[J]);
            if CurCur[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCur[J], CurNdx[J], CurArr[J]);
            if CurTemp[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurTemp[J], TempNdx[J], TempArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddFuel(const Sensor: STRU_TELE_FUEL);
{$J+}
const
  Cons: array [0..1] of Single = ( 0, 0 );
  Rate: array [0..1] of Single = ( 0, 0 );
  Temp: array [0..1] of Single = ( 0, 0 );
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  ConsArr: array [0..1] of TSensorArray = ( nil, nil );
  ConsNdx: array [0..1] of Integer = ( 0, 0 );
  RateArr: array [0..1] of TSensorArray = ( nil, nil );
  RateNdx: array [0..1] of Integer = ( 0, 0 );
  TempArr: array [0..1] of TSensorArray = ( nil, nil );
  TempNdx: array [0..1] of Integer = ( 0, 0 );
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurCons: array [0..1] of Variant;
  CurRate: array [0..1] of Variant;
  CurTemp: array [0..1] of Variant;
  CurTempCheck: array [0..1] of Variant;
  TmpConsArr: array [0..1] of TSensorArray;
  TmpRateArr: array [0..1] of TSensorArray;
  TmpTempArr: array [0..1] of TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 1 do begin
            ProcessSensor(RateNdx[J], RateArr[J], TmpRateArr[J]);
            ProcessSensor(ConsNdx[J], ConsArr[J], TmpConsArr[J]);
            ProcessSensor(TempNdx[J], TempArr[J], TmpTempArr[J]);

            CurRate[J] := NULL;
            CurCons[J] := NULL;
            CurTemp[J] := NULL;

            RateNdx[J] := 0;
            ConsNdx[J] := 0;
            TempNdx[J] := 0;
          end;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 1 do begin
                if RateNdx[J] = Length(TmpRateArr[J]) then
                  CurRate[J] := NULL
                else begin
                  if TmpRateArr[J][RateNdx[J]].Timestamp = Timestamp then begin
                    CurRate[J] := TmpRateArr[J][RateNdx[J]].Value;
                    Inc(RateNdx[J]);
                  end;
                end;

                if ConsNdx[J] = Length(TmpConsArr[J]) then
                  CurCons[J] := NULL
                else begin
                  if TmpConsArr[J][ConsNdx[J]].Timestamp = Timestamp then begin
                    CurCons[J] := TmpConsArr[J][ConsNdx[J]].Value;
                    Inc(ConsNdx[J]);
                  end;
                end;

                if TempNdx[J] = Length(TmpTempArr[J]) then
                  CurTemp[J] := NULL
                else begin
                  if TmpTempArr[J][TempNdx[J]].Timestamp = Timestamp then begin
                    CurTemp[J] := TmpTempArr[J][TempNdx[J]].Value;
                    Inc(TempNdx[J]);
                  end;
                end;
              end;

              vtFuel.AppendRecord([Timestamp, CurCons[0], CurRate[0],
                CurTemp[0], CurCons[1], CurRate[1], CurTemp[1]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 1 do begin
            TmpRateArr[J] := nil;
            TmpConsArr[J] := nil;
            TmpTempArr[J] := nil;
          end;
        end;
      end;

    finally
      for J := 0 to 1 do begin
        Cons[J] := 0;
        Rate[J] := 0;
        Temp[J] := 0;

        RateArr[J] := nil;
        RateNdx[J] := 0;

        ConsArr[J] := nil;
        ConsNdx[J] := 0;

        TempArr[J] := nil;
        TempNdx[J] := 0;
      end;

      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    if Sensor.ConsumedA.Valid then
      CurCons[0] := Sensor.ConsumedA.Value
    else
      CurCons[0] := NULL;
    if Sensor.ConsumedB.Valid then
      CurCons[1] := Sensor.ConsumedB.Value
    else
      CurCons[1] := NULL;

    if Sensor.FlowRateA.Valid then
      CurRate[0] := Sensor.FlowRateA.Value
    else
      CurRate[0] := NULL;
    if Sensor.FlowRateB.Valid then
      CurRate[1] := Sensor.FlowRateB.Value
    else
      CurRate[1] := NULL;

    if Sensor.TempA[FTempUnits].Valid then begin
      CurTemp[0] := Sensor.TempA[FTempUnits].Value;
      CurTempCheck[0] := Sensor.TempA[tuCelcius].Value;
    end else begin
      CurTemp[0] := NULL;
      CurTempCheck[0] := NULL;
    end;
    if Sensor.TempB[FTempUnits].Valid then begin
      CurTemp[1] := Sensor.TempB[FTempUnits].Value;
      CurTempCheck[1] := Sensor.TempB[tuCelcius].Value;
    end else begin
      CurTemp[1] := NULL;
      CurTempCheck[1] := NULL;
    end;

    if FPostProcessing = ppNone then begin
      vtFuel.AppendRecord([Sensor.Timestamp, CurCons[0], CurRate[0], CurTemp[0],
        CurCons[1], CurRate[1], CurTemp[1]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsFuel);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 1 do begin
        if (CurTempCheck[J] <> NULL) and (CurTempCheck[J] > 150) then
          CurTemp[J] := NULL;
      end;

      for J := 0 to 1 do begin
        NotNull := (CurRate[J] <> NULL) or (CurCons[J] <> NULL) or (CurTemp[J] <> NULL);
        if NotNull then
          Break;
      end;

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 1 do begin
            if CurCons[J] <> NULL then
              Cons[J] := CurCons[J];
            if CurRate[J] <> NULL then
              Rate[J] := CurRate[J];
            if CurTemp[J] <> NULL then
              Temp[J] := CurTemp[J];
          end;

          vtFuel.AppendRecord([Sensor.Timestamp, Cons[0], Rate[0], Temp[0],
            Cons[1], Rate[1], Temp[1]]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 1 do begin
            if CurRate[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurRate[J], RateNdx[J], RateArr[J]);
            if CurCons[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCons[J], ConsNdx[J], ConsArr[J]);
            if CurTemp[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurTemp[J], TempNdx[J], TempArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddGps(const Sensor: STRU_TELE_GPS);

  procedure ApplyOffset(var Alt: Single);
  begin
    if FGpsOffsetUseSensor then begin
      FGpsOffset := Alt;
      FGpsOffsetUseSensor := False;
    end;
    Alt := Alt - FGpsOffset;
  end;

{$J+}
const
  HomeSet: Boolean = False;
  HomeLat: Single = 0;
  HomeLong: Single = 0;
  PrevDistance: Single = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}

var
  Distance: Single;
  DeltaLat: Single;
  DeltaLon: Single;
  HomeLatRad: Single;
  LatRad: Single;
  Alpha: Single;
  c: Single;
  DistanceSet: Boolean;
  Alt: Single;
begin
  if Sensor = nil then begin
    HomeSet := False;
    HomeLat := 0;
    HomeLong := 0;
    PrevDistance := 0;
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    if FPostProcessing <> ppNone then begin
      if (Sensor.Heading = 0) and (Sensor.Alt[FLengthUnits] = 0) and
         (Sensor.Latitude = 0) and (Sensor.Longitude = 0)
      then
        Exit;
    end;

    if (not HomeSet) and (Sensor.VisibleSats > 6) and (Sensor.Latitude <> 0) and
       (Sensor.Longitude <> 0)
    then begin
      HomeSet := True;
      HomeLat := Sensor.Latitude;
      HomeLong := Sensor.Longitude;
      PrevDistance := 0;
    end;

    Distance := 0;
    DistanceSet := False;
    if HomeSet and (Sensor.VisibleSats > 3) and (Sensor.Latitude <> 0) and
       (Sensor.Longitude <> 0)
    then begin
      DeltaLat := ToRad(Sensor.Latitude - HomeLat);
      DeltaLon := ToRad(Sensor.Longitude - HomeLong);
      HomeLatRad := ToRad(HomeLat);
      LatRad := ToRad(Sensor.Latitude);
      Alpha := sin(DeltaLat / 2) * sin(DeltaLat / 2) + sin(DeltaLon / 2) *
        sin(DeltaLon / 2) * cos(HomeLatRad) * cos(LatRad);
      C := 2 * arctan2(sqrt(Alpha), sqrt(1 - Alpha));
      Distance := RADIUS * c;

      if (FPostProcessing = ppPeak) or (FPostProcessing = ppSmooth) then begin
        if Abs(PrevDistance - Distance) > 1000 then
          Exit;
      end;

      DistanceSet := True;
    end;

    if DistanceSet then
      PrevDistance := Distance
    else
      Distance := PrevDistance;

    if FLengthUnits = luImperial then
      Distance := Distance * 3.28084;

    Alt := Sensor.Alt[FLengthUnits];
    ApplyOffset(Alt);
    vtGPS.AppendRecord([Sensor.Timestamp, Sensor.Time,
      Sensor.Speed[FLengthUnits], Alt, Sensor.Heading, Sensor.Latitude,
      Sensor.Longitude, Distance, Sensor.VisibleSats, Sensor.Fix]);

    if FTimeGap.Enabled and (not TabAdded) then begin
      if CurTime = MIN_TIME then
        CurTime := Sensor.Timestamp
      else begin
        if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
          AddTab(tsGPS);
          TabAdded := True;
        end;
        CurTime := Sensor.Timestamp;
      end;
    end;
  end;
end;

procedure TfmMain.AddGroupItem(const Session: TTelemetrySession;
  const GroupID: Integer; const Caption: string);
var
  Item: TListItem;
  Str: string;
begin
  Item := lvSessions.Items.Add;
  Item.GroupID := GroupID;
  Item.Caption := Caption;
  Item.SubItems.Add(Session.ModelName);
  if Session.RtcSet and (Session.BindType = TTelemetrySession.SPRM_COMMON_BIND_NOBINDINFO) then
    Item.SubItems.Add('iXxx')
  else
    Item.SubItems.Add(Session.BindTypeName);

  Str := IntToStr(Session.Poles) + ' / ' + Format('%.2f', [Session.Ratio]);
  Item.SubItems.Add(Str);
  Str := IntToStr(Session.PolesESC) + ' / ' + Format('%.2f', [Session.RatioESC]);
  Item.SubItems.Add(Str);

  Item.SubItems.Add('');
  SetSessionTime(Item, Session);
end;

procedure TfmMain.AddGyro(const Sensor: STRU_TELE_GYRO);
{$J+}
const
  Axis: array [0..2] of Single = ( 0, 0, 0 );
  AxisMax: array [0..2] of Single = ( 0, 0, 0 );
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  AxisArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  AxisNdx: array [0..2] of Integer = ( 0, 0, 0 );
  AxisMaxArr: array [0..2] of TSensorArray = ( nil, nil, nil );
  AxisMaxNdx: array [0..2] of Integer = ( 0, 0, 0 );
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurAxis: array [0..2] of Variant;
  CurAxisMax: array [0..2] of Variant;
  TmpAxisArr: array [0..2] of TSensorArray;
  TmpAxisMaxArr: array [0..2] of TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 2 do begin
            ProcessSensor(AxisNdx[J], AxisArr[J], TmpAxisArr[J]);
            ProcessSensor(AxisMaxNdx[J], AxisMaxArr[J], TmpAxisMaxArr[J]);

            CurAxis[J] := NULL;
            CurAxisMax[J] := NULL;

            AxisNdx[J] := 0;
            AxisMaxNdx[J] := 0;
          end;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 2 do begin
                if AxisNdx[J] = Length(TmpAxisArr[J]) then
                  CurAxis[J] := NULL
                else begin
                  if TmpAxisArr[J][AxisNdx[J]].Timestamp = Timestamp then begin
                    CurAxis[J] := TmpAxisArr[J][AxisNdx[J]].Value;
                    Inc(AxisNdx[J]);
                  end;
                end;

                if AxisMaxNdx[J] = Length(TmpAxisMaxArr[J]) then
                  CurAxisMax[J] := NULL
                else begin
                  if TmpAxisMaxArr[J][AxisMaxNdx[J]].Timestamp = Timestamp then
                  begin
                    CurAxisMax[J] := TmpAxisMaxArr[J][AxisMaxNdx[J]].Value;
                    Inc(AxisMaxNdx[J]);
                  end;
                end;
              end;

              vtGyro.AppendRecord([Timestamp, CurAxis[0], CurAxis[1],
                 CurAxis[2], CurAxisMax[0], CurAxisMax[1], CurAxisMax[2]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 2 do begin
            TmpAxisArr[J] := nil;
            TmpAxisMaxArr[J] := nil;
          end;
        end;
      end;

    finally
      for J := 0 to 2 do begin
        Axis[J] := 0;
        AxisMax[J] := 0;

        AxisArr[J] := nil;
        AxisNdx[J] := 0;

        AxisMaxArr[J] := nil;
        AxisMaxNdx[J] := 0;
      end;

      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    for J := 0 to 2 do begin
      if Sensor.Axis[J].Valid then
        CurAxis[J] := Sensor.Axis[J].Value
      else
        CurAxis[J] := NULL;

      if Sensor.AxisMax[J].Valid then
        CurAxisMax[J] := Sensor.AxisMax[J].Value
      else
        CurAxisMax[J] := NULL;
    end;

    if FPostProcessing = ppNone then begin
      vtGyro.AppendRecord([Sensor.Timestamp, CurAxis[0], CurAxis[1], CurAxis[2],
        CurAxisMax[0], CurAxisMax[1], CurAxisMax[2]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsGyro);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 2 do begin
        NotNull := (CurAxis[J] <> NULL) or (CurAxisMax[J] <> NULL);
        if NotNull then
          Break;
      end;

      if NotNull then begin
        if (FPostProcessing = ppFilter) or (FPostProcessing = ppPeak) then begin
          for J := 0 to 2 do begin
            if CurAxis[J] <> NULL then
              Axis[J] := CurAxis[J];

            if CurAxisMax[J] <> NULL then
              AxisMax[J] := CurAxisMax[J];
          end;

          vtGyro.AppendRecord([Sensor.Timestamp, Axis[0], Axis[1], Axis[2],
            AxisMax[0], AxisMax[1], AxisMax[2]]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 2 do begin
            if CurAxis[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurAxis[J], AxisNdx[J], AxisArr[J]);

            if CurAxisMax[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurAxisMax[J], AxisMaxNdx[J], AxisMaxArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddJetCat(const Sensor1: STRU_TELE_JETCAT;
  const Sensor2: STRU_TELE_JETCAT2; const Timestamp: Cardinal);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Status: Variant;
  Throttle: Variant;
  PackVoltage: Variant;
  PumpVoltage: Variant;
  RPM: Variant;
  Temp: Variant;
  OffCond: Variant;
  FuelFlow: Variant;
  RestFuel: Variant;
begin
  if (Sensor1 <> nil) and (Sensor2 <> nil) then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    // Do not use smooth filtering.
    // Later we may need this code part (when sensor is nil) to initialize
    // specific filtering
    if Sensor1.Status.Valid then
      Status := Sensor1.Status.Value
    else
      Status := NULL;

    if Sensor1.Throttle.Valid then
      Throttle := Sensor1.Throttle.Value
    else
      Throttle := NULL;

    if Sensor1.PackVoltage.Valid then
      PackVoltage := Sensor1.PackVoltage.Value
    else
      PackVoltage := NULL;

    if Sensor1.PumpVoltage.Valid then
      PumpVoltage := Sensor1.PumpVoltage.Value
    else
      PumpVoltage := NULL;

    if Sensor1.RPM.Valid then
      RPM := Sensor1.RPM.Value
    else
      RPM := NULL;

    if Sensor1.Temperature[FTempUnits].Valid then
      Temp := Sensor1.Temperature[FTempUnits].Value
    else
      Temp := NULL;

    if Sensor1.OffCondition.Valid then
      OffCond := Sensor1.OffCondition.Value
    else
      OffCond := NULL;

    if Sensor2.FuelFlow.Valid then
      FuelFlow := Sensor2.FuelFlow.Value
    else
      FuelFlow := NULL;

    if Sensor2.RestFuel.Valid then
      RestFuel := Sensor2.RestFuel.Value
    else
      RestFuel := NULL;

    if FPostProcessing = ppNone then begin
      vtTurbine.AppendRecord([Timestamp, Status, Throttle,
        PackVoltage, PumpVoltage, RPM, Temp, OffCond, FuelFlow, RestFuel]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Timestamp
        else begin
          if Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsTurbine);
            TabAdded := True;
          end;
          CurTime := Timestamp;
        end;
      end;

    end else begin
      if (Status <> NULL) and (Throttle <> NULL) and (PackVoltage <> NULL) and
         (PumpVoltage <> NULL) and (RPM <> NULL) and (Temp <> NULL) and
         (OffCond <> NULL)
      then begin
        vtTurbine.AppendRecord([Timestamp, Status, Throttle, PackVoltage,
          PumpVoltage, RPM, Temp, OffCond, FuelFlow, RestFuel]);
      end;
    end;
  end;
end;

procedure TfmMain.AddLapTimer(const Sensor: STRU_TELE_LAPTIMER);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  LapNumber: Variant;
  GateNumber: Variant;
  LastLapTime: Variant;
  GateTime: Variant;
begin
  // Do not use smooth filtering.
  // Later we may need this code part (when sensor is nil) to initialize
  // specific filtering
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    if Sensor.LapNumber.Valid then
      LapNumber := Sensor.LapNumber.Value
    else
      LapNumber := NULL;

    if Sensor.GateNumber.Valid then
      GateNumber := Sensor.GateNumber.Value
    else
      GateNumber := NULL;

    if Sensor.LastLapTime.Valid then
      LastLapTime := Sensor.LastLapTime.Value
    else
      LastLapTime := NULL;

    if Sensor.GateTime.Valid then
      GateTime := Sensor.GateTime.Value
    else
      GateTime := NULL;

    if FPostProcessing = ppNone then begin
      vtLapTimer.AppendRecord([Sensor.Timestamp, LapNumber, GateNumber,
        LastLapTime, GateTime]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsLapTimer);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (LapNumber <> NULL) and (GateNumber <> NULL) and
         (LastLapTime <> NULL) and (GateTime <> NULL) then
      begin
        // Temporary skip all the "invalid" data. However it may need real
        // filtering. So leave it as is for now but when will have real data
        // modify it (probably it will have repeatable data or something).
        vtLapTimer.AppendRecord([Sensor.Timestamp, LapNumber, GateNumber,
          LastLapTime, GateTime]);
      end;
    end;
  end;
end;

procedure TfmMain.AddLipomon(const Sensor: STRU_TELE_LIPOMON);
{$J+}
const
  Temp: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  CellsArr: array [0..5] of TSensorArray = ( nil, nil, nil, nil, nil, nil );
  CellsNdx: array [0..5] of Integer = ( 0, 0, 0, 0, 0, 0 );
  TempArr: TSensorArray = nil;
  TempNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  TmpCellsArr: array [0..5] of TSensorArray;
  TmpTempArr: TSensorArray;
  CurCells: array [0..5] of Variant;
  CurTemp: Variant;
  I: Integer;
  Timestamp: Cardinal;
  J: Integer;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 5 do begin
            ProcessSensor(CellsNdx[J], CellsArr[J], TmpCellsArr[J]);

            CurCells[J] := 0;
            CellsNdx[J] := 0;
          end;

          ProcessSensor(TempNdx, TempArr, TmpTempArr);

          CurTemp := 0;
          TempNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 5 do begin
                if CellsNdx[J] = Length(TmpCellsArr[J]) then
                  CurCells[J] := NULL
                else begin
                  if TmpCellsArr[J][CellsNdx[J]].Timestamp = Timestamp then
                  begin
                    CurCells[J] := TmpCellsArr[J][CellsNdx[J]].Value;
                    Inc(CellsNdx[J]);
                  end;
                end;
              end;

              if TempNdx = Length(TmpTempArr) then
                CurTemp := NULL
              else begin
                if TmpTempArr[TempNdx].Timestamp = Timestamp then begin
                  CurTemp := TmpTempArr[TempNdx].Value;
                  Inc(TempNdx);
                end;
              end;

              vtLipomon.AppendRecord([Timestamp, CurCells[0], CurCells[1],
                CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurTemp]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 5 do
            TmpCellsArr[J] := nil;
          TmpTempArr := nil;
        end;
      end;

    finally
      Temp := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      for J := 0 to 5 do begin
        CellsArr[J] := nil;
        CellsNdx[J] := 0;
      end;
      TempArr := nil;
      TempNdx := 0;
    end

  end else begin
    for J := 0 to 5 do
      if Sensor.Cells[J].Valid then
        CurCells[J] := Sensor.Cells[J].Value
      else
        CurCells[J] := NULL;
      if Sensor.Temp[FTempUnits].Valid then
        CurTemp := Sensor.Temp[FTempUnits].Value
      else
        CurTemp := NULL;

    if FPostProcessing = ppNone then begin
      vtLipomon.AppendRecord([Sensor.Timestamp, CurCells[0], CurCells[1],
        CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurTemp]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsLipomon);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 5 do begin
        NotNull := CurCells[J] <> NULL;
        if NotNull then
          Break;
      end;
      if NotNull then
        NotNull := CurTemp <> NULL;

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          vtLipomon.AppendRecord([Sensor.Timestamp, CurCells[0], CurCells[1],
            CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurTemp])

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 5 do begin
            if CurCells[J] <> NULL then begin
              PushSensor(Sensor.Timestamp, CurCells[J], CellsNdx[J],
                CellsArr[J]);
            end;
          end;

          if CurTemp <> NULL then
            PushSensor(Sensor.Timestamp, CurTemp, TempNdx, TempArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddLipomon14(const Sensor: STRU_TELE_LIPOMON_14);
{$J+}
const
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  CellsArr: array [0..13] of TSensorArray = ( nil, nil, nil, nil, nil, nil, nil,
                                              nil, nil, nil, nil, nil, nil, nil );
  CellsNdx: array [0..13] of Integer = ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  TmpCellsArr: array [0..13] of TSensorArray;
  CurCells: array [0..13] of Variant;
  I: Integer;
  Timestamp: Cardinal;
  J: Integer;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 13 do begin
            ProcessSensor(CellsNdx[J], CellsArr[J], TmpCellsArr[J]);

            CurCells[J] := 0;
            CellsNdx[J] := 0;
          end;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 13 do begin
                if CellsNdx[J] = Length(TmpCellsArr[J]) then
                  CurCells[J] := NULL
                else begin
                  if TmpCellsArr[J][CellsNdx[J]].Timestamp = Timestamp then
                  begin
                    CurCells[J] := TmpCellsArr[J][CellsNdx[J]].Value;
                    Inc(CellsNdx[J]);
                  end;
                end;
              end;

              vtLipomon14.AppendRecord([Timestamp, CurCells[0], CurCells[1],
                CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurCells[6],
                CurCells[7], CurCells[8], CurCells[9], CurCells[10],
                CurCells[11], CurCells[12], CurCells[13]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 5 do
            TmpCellsArr[J] := nil;
        end;
      end;

    finally
      TimestampArr := nil;
      TimestampNdx := 0;
      for J := 0 to 13 do begin
        CellsArr[J] := nil;
        CellsNdx[J] := 0;
      end;
    end

  end else begin
    for J := 0 to 13 do begin
      if Sensor.Cells[J].Valid then
        CurCells[J] := Sensor.Cells[J].Value
      else
        CurCells[J] := NULL;
    end;

    if FPostProcessing = ppNone then begin
      vtLipomon14.AppendRecord([Sensor.Timestamp, CurCells[0], CurCells[1],
        CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurCells[6],
        CurCells[7], CurCells[8], CurCells[9], CurCells[10], CurCells[11],
        CurCells[12], CurCells[13]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsLipomon14);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 13 do begin
        NotNull := CurCells[J] <> NULL;
        if NotNull then
          Break;
      end;

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          vtLipomon14.AppendRecord([Sensor.Timestamp, CurCells[0], CurCells[1],
            CurCells[2], CurCells[3], CurCells[4], CurCells[5], CurCells[6],
            CurCells[7], CurCells[8], CurCells[9], CurCells[10], CurCells[11],
            CurCells[12], CurCells[13]])

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);
          for J := 0 to 13 do begin
            if CurCells[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCells[J], CellsNdx[J], CellsArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddMultiCylinder(const Sensor: STRU_TELE_MULTI_TEMP);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  i: Byte;
  Process: Boolean;
  Temp: array [0..8] of Variant;
  Throttle: Variant;
  Rpm: Variant;
  Batt: Variant;
begin
  // We process only simple filtering for this sensor.
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    // We just skip only all invalid data. Any other data is added. No filtering.
    Process := False;
    for i := 0 to 8 do
      Process := Process or Sensor.Temp[FTempUnits][i].Valid;
    Process := Sensor.Throttle.Valid or Sensor.Rpm.Valid or Sensor.Batt.Valid or
      (FPostProcessing = ppNone);

    if Process then begin
      for i := 0 to 8 do begin
        if Sensor.Temp[FTempUnits][i].Valid then
          Temp[i] := Sensor.Temp[FTempUnits][i].Value
        else
          Temp[i] := NULL;
      end;
      if Sensor.Throttle.Valid then
        Throttle := Sensor.Throttle.Value
      else
        Throttle := NULL;
      if Sensor.Rpm.Valid then
        Rpm := Sensor.Rpm.Value
      else
        Rpm := NULL;
      if Sensor.Batt.Valid then
        Batt := Sensor.Batt.Value
      else
        Batt := NULL;

      vtMultiCylinder.AppendRecord([Sensor.Timestamp,
        Temp[0], Temp[1], Temp[2], Temp[3], Temp[4], Temp[5], Temp[6], Temp[7],
        Temp[8], Throttle, Rpm, Batt]);

      if FPostProcessing = ppNone then begin
        if FTimeGap.Enabled and (not TabAdded) then begin
          if CurTime = MIN_TIME then
            CurTime := Sensor.Timestamp
          else begin
            if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
              AddTab(tsMultiCylinder);
              TabAdded := True;
            end;
            CurTime := Sensor.Timestamp;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddPowerBox(const Sensor: STRU_TELE_POWERBOX);
const
  VOLT_PEAK = 5;
{$J+}
const
  Caps: array [0..1] of Word = ( 0, 0 );
  Volts: array [0..1] of Single = ( 0.0, 0.0 );
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  CapsArr: array [0..1] of TSensorArray = ( nil, nil );
  CapsNdx: array [0..1] of Integer = ( 0, 0 );
  VoltsArr: array [0..1] of TSensorArray = ( nil, nil );
  VoltsNdx: array [0..1] of Integer = ( 0, 0 );
  AlarmsArr: TSensorArray = nil;
  AlarmsNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurCaps: array [0..1] of Variant;
  CurVolts: array [0..1] of Variant;
  CurAlarms: Variant;
  TmpCapsArr: array [0..1] of TSensorArray;
  TmpVoltsArr: array [0..1] of TSensorArray;
  I: Integer;
  J: Byte;
  Timestamp: Cardinal;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 1 do begin
            ProcessSensor(CapsNdx[J], CapsArr[J], TmpCapsArr[J]);
            ProcessSensor(VoltsNdx[J], VoltsArr[J], TmpVoltsArr[J]);

            CurCaps[J] := NULL;
            CurVolts[J] := NULL;

            CapsNdx[J] := 0;
            VoltsNdx[J] := 0;
          end;

          CurAlarms := NULL;

          AlarmsNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 1 do begin
                if CapsNdx[J] = Length(TmpCapsArr[J]) then
                  CurCaps[J] := NULL
                else begin
                  if TmpCapsArr[J][CapsNdx[J]].Timestamp = Timestamp then begin
                    CurCaps[J] := TmpCapsArr[J][CapsNdx[J]].Value;
                    Inc(CapsNdx[J]);
                  end;
                end;

                if VoltsNdx[J] = Length(TmpVoltsArr[J]) then
                  CurVolts[J] := NULL
                else begin
                  if TmpVoltsArr[J][VoltsNdx[J]].Timestamp = Timestamp then
                  begin
                    CurVolts[J] := TmpVoltsArr[J][VoltsNdx[J]].Value;
                    Inc(VoltsNdx[J]);
                  end;
                end;
              end;

              if AlarmsNdx = Length(AlarmsArr) then
                CurAlarms := NULL
              else begin
                if AlarmsArr[AlarmsNdx].Timestamp = Timestamp then begin
                  CurAlarms := AlarmsArr[AlarmsNdx].Value;
                  Inc(AlarmsNdx);
                end;
              end;

              AppendPowerBox(Timestamp, CurVolts[0], CurCaps[0], CurVolts[1],
                CurCaps[1], CurAlarms);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 1 do begin
            TmpCapsArr[J] := nil;
            TmpVoltsArr[J] := nil;
          end;
        end;
      end;

    finally
      for J := 0 to 1 do begin
        Caps[J] := 0;
        Volts[J] := 0;

        CapsArr[J] := nil;
        CapsNdx[J] := 0;

        VoltsArr[J] := nil;
        VoltsNdx[J] := 0;
      end;

      AlarmsArr := nil;
      AlarmsNdx := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    for J := 0 to 1 do begin
      if Sensor.Caps[J].Valid then
        CurCaps[J] := Sensor.Caps[J].Value
      else
        CurCaps[J] := NULL;

      if Sensor.Volts[J].Valid then
        CurVolts[J] := Sensor.Volts[J].Value
      else
        CurVolts[J] := NULL;
    end;

    if Sensor.Alarms.Valid then
      CurAlarms := Sensor.Alarms.Value
    else
      CurAlarms := NULL;

    if FPostProcessing = ppNone then begin
      AppendPowerBox(Sensor.Timestamp, CurVolts[0], CurCaps[0], CurVolts[1],
        CurCaps[1], CurAlarms);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsPowerBox);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurCaps[0] <> NULL) or (CurCaps[1] <> NULL) or
         (CurVolts[0] <> NULL) or (CurVolts[1] <> NULL)
      then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 1 do begin
            if CurCaps[J] <> NULL then
              Caps[J] := CurCaps[J];

            if CurVolts[J] <> NULL then
              Volts[J] := CurVolts[J];
          end;

          AppendPowerBox(Sensor.Timestamp, Volts[0], Caps[0], Volts[1], Caps[1],
            CurAlarms);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 1 do begin
            if CurCaps[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCaps[J], CapsNdx[J], CapsArr[J]);

            if CurVolts[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurVolts[J], VoltsNdx[J], VoltsArr[J]);
          end;

          if CurAlarms <> NULL then
            PushSensor(Sensor.Timestamp, CurAlarms, AlarmsNdx, AlarmsArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddRpm(const Sensor: STRU_TELE_RPM);
const
  RPM_PEAK = 500;
{$J+}
const
  RPM: Single = 0;
  Volt: Single = 0;
  Temp: Single = 0;
  A: ShortInt = 0;
  B: ShortInt = 0;
  FastBoot: ShortInt = 0;
  Uptime: Word = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  RPMArr: TSensorArray = nil;
  RPMNdx: Integer = 0;
  VoltArr: TSensorArray = nil;
  VoltNdx: Integer = 0;
  TempArr: TSensorArray = nil;
  TempNdx: Integer = 0;
  AArr: TSensorArray = nil;
  ANdx: Integer = 0;
  BArr: TSensorArray = nil;
  BNdx: Integer = 0;
  FastBootArr: TSensorArray = nil;
  FastBootNdx: Integer = 0;
  UptimeArr: TSensorArray = nil;
  UptimeNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurRPM: Variant;
  CurVolt: Variant;
  CurTemp: Variant;
  CurTempCheck: Variant;
  CurA: Variant;
  CurB: Variant;
  CurFastBoot: Variant;
  CurUptime: Variant;
  TmpRPMArr: TSensorArray;
  TmpVoltArr: TSensorArray;
  TmpTempArr: TSensorArray;
  TmpAArr: TSensorArray;
  TmpBArr: TSensorArray;
  TmpFastBootArr: TSensorArray;
  TmpUptimeArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  InsRPM: Variant;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          ProcessSensor(RPMNdx, RPMArr, TmpRPMArr);
          ProcessSensor(VoltNdx, VoltArr, TmpVoltArr);
          ProcessSensor(TempNdx, TempArr, TmpTempArr);
          ProcessSensor(ANdx, AArr, TmpAArr);
          ProcessSensor(BNdx, BArr, TmpBArr);
          ProcessSensor(FastBootNdx, FastBootArr, TmpFastBootArr);
          ProcessSensor(UptimeNdx, UptimeArr, TmpUptimeArr);

          CurRPM := NULL;
          CurVolt := NULL;
          CurTemp := NULL;
          CurA := NULL;
          CurB := NULL;
          CurFastBoot := NULL;
          CurUptime := NULL;

          RPMNdx := 0;
          VoltNdx := 0;
          TempNdx := 0;
          ANdx := 0;
          BNdx := 0;
          FastBootNdx := 0;
          UptimeNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              if RPMNdx = Length(TmpRPMArr) then
                CurRPM := NULL
              else begin
                if TmpRPMArr[RPMNdx].Timestamp = Timestamp then begin
                  CurRPM := TmpRPMArr[RPMNdx].Value;
                  Inc(RPMNdx);
                end;
              end;
              if VoltNdx = Length(TmpVoltArr) then
                CurVolt := NULL
              else begin
                if TmpVoltArr[VoltNdx].Timestamp = Timestamp then begin
                  CurVolt := TmpVoltArr[VoltNdx].Value;
                  Inc(VoltNdx);
                end;
              end;
              if TempNdx = Length(TmpTempArr) then
                CurTemp := NULL
              else begin
                if TmpTempArr[TempNdx].Timestamp = Timestamp then begin
                  CurTemp := TmpTempArr[TempNdx].Value;
                  Inc(TempNdx);
                end;
              end;
              if ANdx = Length(TmpAArr) then
                CurA := NULL
              else begin
                if TmpAArr[ANdx].Timestamp = Timestamp then begin
                  CurA := TmpAArr[ANdx].Value;
                  Inc(ANdx);
                end;
              end;
              if BNdx = Length(TmpBArr) then
                CurB := NULL
              else begin
                if TmpBArr[BNdx].Timestamp = Timestamp then begin
                  CurB := TmpBArr[BNdx].Value;
                  Inc(BNdx);
                end;
              end;
              if FastBootNdx = Length(TmpFastBootArr) then
                CurFastBoot := NULL
              else begin
                if TmpFastBootArr[FastBootNdx].Timestamp = Timestamp then begin
                  CurFastBoot := TmpFastBootArr[FastBootNdx].Value;
                  Inc(FastBootNdx);
                end;
              end;
              if UptimeNdx = Length(TmpUptimeArr) then
                CurUptime := NULL
              else begin
                if TmpUptimeArr[UptimeNdx].Timestamp = Timestamp then begin
                  CurUptime := TmpUptimeArr[UptimeNdx].Value;
                  Inc(UptimeNdx);
                end;
              end;

              if (CurRPM <> NULL) and (CurRPM <= 999) then
                InsRPM := NULL
              else
                InsRPM := CurRPM;

              vtStandard.AppendRecord([Timestamp, InsRPM, CurTemp, CurVolt,
                CurA, CurB, CurFastBoot, CurUptime]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpRPMArr := nil;
          TmpVoltArr := nil;
          TmpTempArr := nil;
          TmpAArr := nil;
          TmpBArr := nil;
          TmpFastBootArr := nil;
          TmpUptimeArr := nil;
        end;
      end;

    finally
      RPM := 0;
      Volt := 0;
      Temp := 0;
      A := 0;
      B := 0;
      FastBoot := 0;
      Uptime := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      RPMArr := nil;
      RPMNdx := 0;
      VoltArr := nil;
      VoltNdx := 0;
      TempArr := nil;
      TempNdx := 0;
      AArr := nil;
      ANdx := 0;
      BArr := nil;
      BNdx := 0;
      FastBootArr := nil;
      FastBootNdx := 0;
      UptimeArr := nil;
      UptimeNdx := 0;
    end

  end else begin
    if Sensor.RPM.Valid then
      CurRPM := Sensor.RPM.Value
    else
      CurRPM := NULL;
    if Sensor.Volt.Valid then
      CurVolt := Sensor.Volt.Value
    else
      CurVolt := NULL;
    if Sensor.Temp[FTempUnits].Valid then begin
      CurTemp := Sensor.Temp[FTempUnits].Value;
      CurTempCheck := Sensor.Temp[tuCelcius].Value;
    end else begin
      CurTemp := NULL;
      CurTempCheck := NULL;
    end;
    if Sensor.A.Valid then
      CurA := Sensor.A.Value
    else
      CurA := NULL;
    if Sensor.B.Valid then
      CurB := Sensor.B.Value
    else
      CurB := NULL;
    if Sensor.FastBoot.Valid then
      CurFastBoot := Sensor.FastBoot.Value
    else
      CurFastBoot := NULL;
    if Sensor.Uptime.Valid then
      CurUptime := Sensor.Uptime.Value
    else
      CurUptime := NULL;

    if FPostProcessing = ppNone then begin
      if (CurRPM <> NULL) and (CurRPM <= 999) then
        InsRPM := NULL
      else
        InsRPM := CurRPM;

      vtStandard.AppendRecord([Sensor.Timestamp, InsRPM, CurTemp, CurVolt,
        CurA, CurB, CurFastBoot, CurUptime]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsStandard);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurRPM <> NULL) or (CurTemp <> NULL) or (CurVolt <> NULL) or
         (CurA <> NULL) or (CurB <> NULL) or (CurFastBoot <> NULL) or
         (CurUptime <> NULL)
      then begin
        if (CurTempCheck <> NULL) and ((CurTempCheck < -50) or (CurTempCheck > 200)) then
          CurTemp := NULL;

        if FPostProcessing in [ppFilter, ppPeak] then begin
          if CurRPM <> NULL then begin
            if FPostProcessing = ppFilter then
              RPM := CurRPM
            else begin
              if (RPM + RPM_PEAK >= CurRPM) and (RPM - RPM_PEAK <= CurRPM) then
                RPM := CurRPM;
            end;
          end;
          if CurTemp <> NULL then
            Temp := CurTemp;
          if CurVolt <> NULL then
            Volt := CurVolt;
          if CurA <> NULL then
            A := CurA;
          if CurB <> NULL then
            B := CurB;
          if CurFastBoot <> NULL then
            FastBoot := CurFastBoot;
          if CurUptime <> NULL then
            Uptime := CurUptime;

          if RPM <= 999 then
            InsRPM := NULL
          else
            InsRPM := RPM;
          vtStandard.AppendRecord([Sensor.Timestamp, InsRPM, Temp, Volt, A, B,
            FastBoot, Uptime]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);
          if (CurRPM <> NULL) and (CurRPM > 999) then
            PushSensor(Sensor.Timestamp, CurRPM, RPMNdx, RPMArr);
          if CurVolt <> NULL then
            PushSensor(Sensor.Timestamp, CurVolt, VoltNdx, VoltArr);
          if CurTemp <> NULL then
            PushSensor(Sensor.Timestamp, CurTemp, TempNdx, TempArr);
          if CurA <> NULL then
            PushSensor(Sensor.Timestamp, CurA, ANdx, AArr);
          if CurB <> NULL then
            PushSensor(Sensor.Timestamp, CurB, BNdx, BArr);
          if CurFastBoot <> NULL then
            PushSensor(Sensor.Timestamp, CurFastBoot, FastBootNdx, FastBootArr);
          if CurUptime <> NULL then
            PushSensor(Sensor.Timestamp, CurUptime, UptimeNdx, UptimeArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AddRx(const Sensor: STRU_TELE_QOS);
const
  RX_PEAK = 100;
{$J+}
const
  A: Cardinal = 0;
  NullA: Boolean = True;
  B: Cardinal = 0;
  NullB: Boolean = True;
  R: Cardinal = 0;
  NullR: Boolean = True;
  L: Cardinal = 0;
  NullL: Boolean = True;
  FrameLoss: Cardinal = 0;
  Holds: Cardinal = 0;
  Volt: Single = 0;
  NullVolt: Boolean = True;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurA: Variant;
  CurB: Variant;
  CurR: Variant;
  CurL: Variant;
  CurFrameLoss: Variant;
  CurHolds: Variant;
  CurVolt: Variant;
  InsA: Variant;
  InsB: Variant;
  InsR: Variant;
  InsL: Variant;
  InsVolt: Variant;
begin
  if Sensor = nil then begin
    A := 0;
    NullA := True;
    B := 0;
    NullB := True;
    R := 0;
    NullR := True;
    L := 0;
    NullL := True;
    FrameLoss := 0;
    Holds := 0;
    Volt := 0;
    NullVolt := True;
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    if Sensor.A.Valid then
      CurA := Sensor.A.Value
    else
      CurA := NULL;
    if Sensor.B.Valid then
      CurB := Sensor.B.Value
    else
      CurB := NULL;
    if Sensor.R.Valid then
      CurR := Sensor.R.Value
    else
      CurR := NULL;
    if Sensor.L.Valid then
      CurL := Sensor.L.Value
    else
      CurL := NULL;
    if Sensor.FrameLoss.Valid then
      CurFrameLoss := Sensor.FrameLoss.Value
    else
      CurFrameLoss := NULL;
    if Sensor.Holds.Valid then
      CurHolds := Sensor.Holds.Value
    else
      CurHolds := NULL;
    if Sensor.Volt.Valid then
      CurVolt := Sensor.Volt.Value
    else
      CurVolt := NULL;

    if FPostProcessing = ppNone then begin
      if FWarnings.Use then begin
        if not FCurrentWarnings.Use then begin
          FCurrentWarnings.Use := ((CurA <> NULL) and (CurA > 60000)) or
                                  ((CurB <> NULL) and (CurB > 60000)) or
                                  ((CurR <> NULL) and (CurR > 60000)) or
                                  ((CurL <> NULL) and (CurL > 60000));
        end;

        if (CurA <> NULL) and (CurA < 60000) and (CurA > FCurrentWarnings.A) then
          FCurrentWarnings.A := CurA;
        if (CurB <> NULL) and (CurB < 60000) and (CurB > FCurrentWarnings.B) then
          FCurrentWarnings.B := CurB;
        if (CurR <> NULL) and (CurR < 60000) and (CurR > FCurrentWarnings.R) then
          FCurrentWarnings.R := CurR;
        if (CurL <> NULL) and (CurL < 60000) and (CurL > FCurrentWarnings.L) then
          FCurrentWarnings.L := CurL;

        if FCurrentWarnings.A > FCurrentWarnings.Fades then
          FCurrentWarnings.Fades := FCurrentWarnings.A;
        if FCurrentWarnings.B > FCurrentWarnings.Fades then
          FCurrentWarnings.Fades := FCurrentWarnings.B;
        if FCurrentWarnings.R > FCurrentWarnings.Fades then
          FCurrentWarnings.Fades := FCurrentWarnings.R;
        if FCurrentWarnings.L > FCurrentWarnings.Fades then
          FCurrentWarnings.Fades := FCurrentWarnings.L;

        if (CurFrameLoss <> NULL) and (CurFrameLoss < 60000) and
           (CurFrameLoss > FCurrentWarnings.Frames)
        then
          FCurrentWarnings.Frames := CurFrameLoss;
        if (CurHolds <> NULL) and (CurHolds < 60000) and
           (CurHolds > FCurrentWarnings.Holds)
        then
          FCurrentWarnings.Holds := CurHolds;
      end;

      vtRX.AppendRecord([Sensor.Timestamp, CurA, CurB, CurL, CurR, CurFrameLoss,
        CurHolds, CurVolt]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsRX);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if Sensor.IsLemon.Valid and Sensor.IsLemon.Value and (CurA <> NULL) and
         (CurA > 100)
      then
        CurA := NULL;

      if (CurA <> NULL) or (CurB <> NULL) or (CurR <> NULL) or
         (CurL <> NULL) or ((CurFrameLoss <> NULL) and (CurHolds <> NULL)) or
         (CurVolt <> NULL)
      then begin
        if CurA <> NULL then begin
          if NullA then
            NullA := False;
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            A := CurA
          else begin
            if (A + RX_PEAK >= CurA) and (Integer(A) - RX_PEAK <= CurA) then
              A := CurA;
          end;
        end;
        if CurB <> NULL then begin
          if NullB then
            NullB := False;
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            B := CurB
          else begin
            if (B + RX_PEAK >= CurB) and (Integer(B) - RX_PEAK <= CurB) then
              B := CurB;
          end;
        end;
        if CurR <> NULL then begin
          if NullR then
            NullR := False;
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            R := CurR
          else begin
            if (R + RX_PEAK >= CurR) and (Integer(R) - RX_PEAK <= CurR) then
              R := CurR;
          end;
        end;
        if CurL <> NULL then begin
          if NullL then
            NullL := False;
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            L := CurL
          else begin
            if (L + RX_PEAK >= CurL) and (Integer(L) - RX_PEAK <= CurL) then
              L := CurL;
          end;
        end;
        if CurFrameLoss <> NULL then begin
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            FrameLoss := CurFrameLoss
          else begin
            if (FrameLoss + RX_PEAK >= CurFrameLoss) and (Integer(FrameLoss) - RX_PEAK <= CurFrameLoss) then
              FrameLoss := CurFrameLoss;
          end;
        end;
        if CurHolds <> NULL then begin
          if (FPostProcessing = ppFilter) or (not FEnableRxFiltering) then
            Holds := CurHolds
          else begin
            if (Holds + RX_PEAK >= CurHolds) and (Integer(Holds) - RX_PEAK <= CurHolds) then
              Holds := CurHolds;
          end;
        end;
        if CurVolt <> NULL then begin
          Volt := CurVolt;
          NullVolt := False;
        end;

        if FWarnings.Use then begin
          if not FCurrentWarnings.Use then begin
            FCurrentWarnings.Use := ((CurA <> NULL) and (CurA > 60000)) or
                                    ((CurB <> NULL) and (CurB > 60000)) or
                                    ((CurR <> NULL) and (CurR > 60000)) or
                                    ((CurL <> NULL) and (CurL > 60000));
          end;

          if (CurA <> NULL) and (CurA < 60000) and (CurA > FCurrentWarnings.A) then
            FCurrentWarnings.A := CurA;
          if (CurB <> NULL) and (CurB < 60000) and (CurB > FCurrentWarnings.B) then
            FCurrentWarnings.B := CurB;
          if (CurR <> NULL) and (CurR < 60000) and (CurR > FCurrentWarnings.R) then
            FCurrentWarnings.R := CurR;
          if (CurL <> NULL) and (CurL < 60000) and (CurL > FCurrentWarnings.L) then
            FCurrentWarnings.L := CurL;

          if FCurrentWarnings.A > FCurrentWarnings.Fades then
            FCurrentWarnings.Fades := FCurrentWarnings.A;
          if FCurrentWarnings.B > FCurrentWarnings.Fades then
            FCurrentWarnings.Fades := FCurrentWarnings.B;
          if FCurrentWarnings.R > FCurrentWarnings.Fades then
            FCurrentWarnings.Fades := FCurrentWarnings.R;
          if FCurrentWarnings.L > FCurrentWarnings.Fades then
            FCurrentWarnings.Fades := FCurrentWarnings.L;

          if (CurFrameLoss <> NULL) and (CurFrameLoss < 60000) and
             (CurFrameLoss > FCurrentWarnings.Frames)
          then
            FCurrentWarnings.Frames := CurFrameLoss;
          if (CurHolds <> NULL) and (CurHolds < 60000) and
             (CurHolds > FCurrentWarnings.Holds)
          then
            FCurrentWarnings.Holds := CurHolds;
        end;

        if not NullA then
          InsA := A
        else
          InsA := NULL;
        if not NullB then
          InsB := B
        else
          InsB := NULL;
        if not NullR then
          InsR := R
        else
          InsR := Null;
        if not NullL then
          InsL := L
        else
          InsL := NULL;
        if not NullVolt then
          InsVolt := Volt
        else
          InsVolt := NULL;

        vtRX.AppendRecord([Sensor.Timestamp, InsA, InsB, InsL, InsR, FrameLoss,
          Holds, InsVolt]);
      end;
    end;
  end;
end;

procedure TfmMain.AddRxPack(const Sensor: STRU_TELE_RX_MAH);
{$J+}
const
  Caps: array [0..1] of Single = ( 0, 0 );
  Curs: array [0..1] of Single = ( 0, 0 );
  Volts: array [0..1] of Single = ( 0, 0 );
  Powers: array [0..1] of Single = ( 0, 0 );
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  CapsArr: array [0..1] of TSensorArray = ( nil, nil );
  CapsNdx: array [0..1] of Integer = ( 0, 0 );
  CursArr: array [0..1] of TSensorArray = ( nil, nil );
  CursNdx: array [0..1] of Integer = ( 0, 0 );
  VoltsArr: array [0..1] of TSensorArray = ( nil, nil );
  VoltsNdx: array [0..1] of Integer = ( 0, 0 );
  PowersArr: array [0..1] of TSensorArray = ( nil, nil );
  PowersNdx: array [0..1] of Integer = ( 0, 0 );
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurCaps: array [0..1] of Variant;
  CurCurs: array [0..1] of Variant;
  CurVolts: array [0..1] of Variant;
  CurPowers: array [0..1] of Variant;
  TmpCapsArr: array [0..1] of TSensorArray;
  TmpCursArr: array [0..1] of TSensorArray;
  TmpVoltsArr: array [0..1] of TSensorArray;
  TmpPowersArr: array [0..1] of TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
  J: Byte;
  NotNull: Boolean;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          for J := 0 to 1 do begin
            ProcessSensor(CapsNdx[J], CapsArr[J], TmpCapsArr[J]);
            ProcessSensor(CursNdx[J], CursArr[J], TmpCursArr[J]);
            ProcessSensor(VoltsNdx[J], VoltsArr[J], TmpVoltsArr[J]);
            ProcessSensor(PowersNdx[J], PowersArr[J], TmpPowersArr[J]);

            CurCaps[J] := NULL;
            CurCurs[J] := NULL;
            CurVolts[J] := NULL;
            CurPowers[J] := NULL;

            CapsNdx[J] := 0;
            CursNdx[J] := 0;
            VoltsNdx[J] := 0;
            PowersNdx[J] := 0;
          end;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              for J := 0 to 1 do begin
                if CapsNdx[J] = Length(TmpCapsArr[J]) then
                  CurCaps[J] := NULL
                else begin
                  if TmpCapsArr[J][CapsNdx[J]].Timestamp = Timestamp then begin
                    CurCaps[J] := TmpCapsArr[J][CapsNdx[J]].Value;
                    Inc(CapsNdx[J]);
                  end;
                end;

                if CursNdx[J] = Length(TmpCursArr[J]) then
                  CurCurs[J] := NULL
                else begin
                  if TmpCursArr[J][CursNdx[J]].Timestamp = Timestamp then begin
                    CurCurs[J] := TmpCursArr[J][CursNdx[J]].Value;
                    Inc(CursNdx[J]);
                  end;
                end;

                if VoltsNdx[J] = Length(TmpVoltsArr[J]) then
                  CurVolts[J] := NULL
                else begin
                  if TmpVoltsArr[J][VoltsNdx[J]].Timestamp = Timestamp then begin
                    CurVolts[J] := TmpVoltsArr[J][VoltsNdx[J]].Value;
                    Inc(VoltsNdx[J]);
                  end;
                end;

                if PowersNdx[J] = Length(TmpPowersArr[J]) then
                  CurPowers[J] := NULL
                else begin
                  if TmpPowersArr[J][PowersNdx[J]].Timestamp = Timestamp then begin
                    CurPowers[J] := TmpPowersArr[J][PowersNdx[J]].Value;
                    Inc(PowersNdx[J]);
                  end;
                end;
              end;

              vtRXPack.AppendRecord([Timestamp, CurCaps[0], CurCurs[0],
                CurVolts[0], CurPowers[0], CurCaps[1], CurCurs[1], CurVolts[1],
                CurPowers[1]]);
            end;

          finally
            EndOperation;
          end;

        finally
          for J := 0 to 1 do begin
            TmpCapsArr[J] := nil;
            TmpCursArr[J] := nil;
            TmpVoltsArr[J] := nil;
            TmpPowersArr[J] := nil;
          end;
        end;
      end;

    finally
      for J := 0 to 1 do begin
        Caps[J] := 0;
        Curs[J] := 0;
        Volts[J] := 0;
        Powers[J] := 0;

        CapsArr[J] := nil;
        CapsNdx[J] := 0;

        CursArr[J] := nil;
        CursNdx[J] := 0;

        VoltsArr[J] := nil;
        VoltsNdx[J] := 0;

        PowersArr[J] := nil;
        PowersNdx[J] := 0;
      end;

      TimestampArr := nil;
      TimestampNdx := 0;
    end

  end else begin
    for J := 0 to 1 do begin
      if Sensor.Capacity[J].Valid then
        CurCaps[J] := Sensor.Capacity[J].Value
      else
        CurCaps[J] := NULL;

      if Sensor.Current[J].Valid then
        CurCurs[J] := Sensor.Current[J].Value
      else
        CurCurs[J] := NULL;

      if Sensor.Volt[J].Valid then
        CurVolts[J] := Sensor.Volt[J].Value
      else
        CurVolts[J] := NULL;

      if Sensor.Power[J].Valid then
        CurPowers[J] := Sensor.Power[J].Value
      else
        CurPowers[J] := NULL;
    end;

    if FPostProcessing = ppNone then begin
      vtRXPack.AppendRecord([Sensor.Timestamp, CurCaps[0], CurCurs[0],
        CurVolts[0], CurPowers[0], CurCaps[1], CurCurs[1], CurVolts[1],
        CurPowers[1]]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsRXPack);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      for J := 0 to 1 do begin
        if (CurCaps[J] <> NULL) and (CurCaps[J] < 0) then
          CurCaps[J] := NULL;
        if (CurCurs[J] <> NULL) and (CurCurs[J] < 0) then
          CurCurs[J] := NULL;
        if (CurVolts[J] <> NULL) and ((CurVolts[J] < 0) or (CurVolts[J] > 16)) then
          CurVolts[J] := NULL;
      end;

      for J := 0 to 1 do begin
        NotNull := (CurCaps[J] <> NULL) or (CurCurs[J] <> NULL) or
          (CurVolts[J] <> NULL) or (CurPowers[J] <> NULL);
        if NotNull then
          Break;
      end;

      if NotNull then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          for J := 0 to 1 do begin
            if CurCaps[J] <> NULL then
              Caps[J] := CurCaps[J];
            if CurCurs[J] <> NULL then
              Curs[J] := CurCurs[J];
            if CurVolts[J] <> NULL then
              Volts[J] := CurVolts[J];
            if CurPowers[J] <> NULL then
              Powers[J] := CurPowers[J];
          end;

          vtRXPack.AppendRecord([Sensor.Timestamp, Caps[0], Curs[0], Volts[0],
            Powers[0], Caps[1], Curs[1], Volts[1], Powers[1]]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);

          for J := 0 to 1 do begin
            if CurCaps[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCaps[J], CapsNdx[J], CapsArr[J]);

            if CurCurs[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurCurs[J], CursNdx[J], CursArr[J]);

            if CurVolts[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurVolts[J], VoltsNdx[J], VoltsArr[J]);

            if CurPowers[J] <> NULL then
              PushSensor(Sensor.Timestamp, CurPowers[J], PowersNdx[J], PowersArr[J]);
          end;
        end;
      end;
    end;
  end;
end;

// For make the AddSmartBatt simple use global variables :(
const
  MAX_BATTS = 2;

var
  Temperature: array [0..MAX_BATTS - 1] of Variant;
  DischargeCurrent: array [0..MAX_BATTS - 1] of Variant;
  CapacityUsage: array [0..MAX_BATTS - 1] of Variant;
  MinCellVoltage: array [0..MAX_BATTS - 1] of Variant;
  MaxCellVoltage: array [0..MAX_BATTS - 1] of Variant;
  Cells1: array [0..MAX_BATTS - 1] of Variant;
  Cells2: array [0..MAX_BATTS - 1] of Variant;
  Cells3: array [0..MAX_BATTS - 1] of Variant;
  Cells4: array [0..MAX_BATTS - 1] of Variant;
  Cells5: array [0..MAX_BATTS - 1] of Variant;
  Cells6: array [0..MAX_BATTS - 1] of Variant;
  Cells7: array [0..MAX_BATTS - 1] of Variant;
  Cells8: array [0..MAX_BATTS - 1] of Variant;
  Cells9: array [0..MAX_BATTS - 1] of Variant;
  Cells10: array [0..MAX_BATTS - 1] of Variant;
  Cells11: array [0..MAX_BATTS - 1] of Variant;
  Cells12: array [0..MAX_BATTS - 1] of Variant;
  Cells13: array [0..MAX_BATTS - 1] of Variant;
  Cells14: array [0..MAX_BATTS - 1] of Variant;
  Cells15: array [0..MAX_BATTS - 1] of Variant;
  Cells16: array [0..MAX_BATTS - 1] of Variant;
  Cells17: array [0..MAX_BATTS - 1] of Variant;
  Cells18: array [0..MAX_BATTS - 1] of Variant;

procedure TfmMain.AddSmartBatt(const Sensor: STRU_SMARTBATT);
var
  i: Integer;
  Table: TVirtualTable;
begin
  { TODO -cTimegap : Should be implemented }
  // Temporary no timegap for this sensor.
  if Sensor = nil then begin
    for i := 0 to MAX_BATTS - 1 do begin
      Temperature[i] := NULL;
      DischargeCurrent[i] := NULL;
      CapacityUsage[i] := NULL;
      MinCellVoltage[i] := NULL;
      MaxCellVoltage[i] := NULL;
      Cells1[i] := NULL;
      Cells2[i] := NULL;
      Cells3[i] := NULL;
      Cells4[i] := NULL;
      Cells5[i] := NULL;
      Cells6[i] := NULL;
      Cells7[i] := NULL;
      Cells8[i] := NULL;
      Cells9[i] := NULL;
      Cells10[i] := NULL;
      Cells11[i] := NULL;
      Cells12[i] := NULL;
      Cells13[i] := NULL;
      Cells14[i] := NULL;
      Cells15[i] := NULL;
      Cells16[i] := NULL;
      Cells17[i] := NULL;
      Cells18[i] := NULL;
    end;

  end else begin
    if (Sensor.BattNum <> INVALID_DATA_UINT8) and (Sensor.BattNum < MAX_BATTS) then
    begin
      if Sensor.RealTimeSet then begin
        if Sensor.RealTime.Temperature.Valid then
          Temperature[Sensor.BattNum] := Sensor.RealTime.Temperature.Value
        else
          Temperature[Sensor.BattNum] := NULL;
        if Sensor.RealTime.DischargeCurrent.Valid then
          DischargeCurrent[Sensor.BattNum] := Sensor.RealTime.DischargeCurrent.Value
        else
          DischargeCurrent[Sensor.BattNum] := NULL;
        if Sensor.RealTime.CapacityUsage.Valid then
          CapacityUsage[Sensor.BattNum] := Sensor.RealTime.CapacityUsage.Value
        else
          CapacityUsage[Sensor.BattNum] := NULL;
        if Sensor.RealTime.MinCellVoltage.Valid then
          MinCellVoltage[Sensor.BattNum] := Sensor.RealTime.MinCellVoltage.Value
        else
          MinCellVoltage[Sensor.BattNum] := NULL;
        if Sensor.RealTime.MaxCellVoltage.Valid then
          MaxCellVoltage[Sensor.BattNum] := Sensor.RealTime.MaxCellVoltage.Value
        else
          MaxCellVoltage[Sensor.BattNum] := NULL;
      end;

      if Sensor.Cells1Set then begin
        if Sensor.Cells1.Temperature.Valid then
          Temperature[Sensor.BattNum] := Sensor.Cells1.Temperature.Value
        else
          Temperature[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[0].Valid then
          Cells1[Sensor.BattNum] := Sensor.Cells1.Cells[0].Value
        else
          Cells1[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[1].Valid then
          Cells2[Sensor.BattNum] := Sensor.Cells1.Cells[1].Value
        else
          Cells2[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[2].Valid then
          Cells3[Sensor.BattNum] := Sensor.Cells1.Cells[2].Value
        else
          Cells3[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[3].Valid then
          Cells4[Sensor.BattNum] := Sensor.Cells1.Cells[3].Value
        else
          Cells4[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[4].Valid then
          Cells5[Sensor.BattNum] := Sensor.Cells1.Cells[4].Value
        else
          Cells5[Sensor.BattNum] := NULL;
        if Sensor.Cells1.Cells[5].Valid then
          Cells6[Sensor.BattNum] := Sensor.Cells1.Cells[5].Value
        else
          Cells6[Sensor.BattNum] := NULL;
      end;

      if Sensor.Cells2Set then begin
        if Sensor.Cells2.Temperature.Valid then
          Temperature[Sensor.BattNum] := Sensor.Cells2.Temperature.Value
        else
          Temperature[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[0].Valid then
          Cells7[Sensor.BattNum] := Sensor.Cells2.Cells[0].Value
        else
          Cells7[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[1].Valid then
          Cells8[Sensor.BattNum] := Sensor.Cells2.Cells[1].Value
        else
          Cells8[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[2].Valid then
          Cells9[Sensor.BattNum] := Sensor.Cells2.Cells[2].Value
        else
          Cells9[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[3].Valid then
          Cells10[Sensor.BattNum] := Sensor.Cells2.Cells[3].Value
        else
          Cells10[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[4].Valid then
          Cells11[Sensor.BattNum] := Sensor.Cells2.Cells[4].Value
        else
          Cells11[Sensor.BattNum] := NULL;
        if Sensor.Cells2.Cells[5].Valid then
          Cells12[Sensor.BattNum] := Sensor.Cells2.Cells[5].Value
        else
          Cells12[Sensor.BattNum] := NULL;
      end;

      if Sensor.Cells3Set then begin
        if Sensor.Cells3.Temperature.Valid then
          Temperature[Sensor.BattNum] := Sensor.Cells3.Temperature.Value
        else
          Temperature[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[0].Valid then
          Cells13[Sensor.BattNum] := Sensor.Cells3.Cells[0].Value
        else
          Cells13[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[1].Valid then
          Cells14[Sensor.BattNum] := Sensor.Cells3.Cells[1].Value
        else
          Cells14[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[2].Valid then
          Cells15[Sensor.BattNum] := Sensor.Cells3.Cells[2].Value
        else
          Cells15[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[3].Valid then
          Cells16[Sensor.BattNum] := Sensor.Cells3.Cells[3].Value
        else
          Cells16[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[4].Valid then
          Cells17[Sensor.BattNum] := Sensor.Cells3.Cells[4].Value
        else
          Cells17[Sensor.BattNum] := NULL;
        if Sensor.Cells3.Cells[5].Valid then
          Cells18[Sensor.BattNum] := Sensor.Cells3.Cells[5].Value
        else
          Cells18[Sensor.BattNum] := NULL;
      end;

      if Sensor.RealTimeSet or Sensor.Cells1Set or Sensor.Cells2Set or Sensor.Cells3Set then
      begin
        if Sensor.BattNum = 0 then
          Table := vtSmartBatt1
        else
          Table := vtSmartBatt2;

        Table.AppendRecord([Sensor.Timestamp, Temperature[Sensor.BattNum],
          DischargeCurrent[Sensor.BattNum], CapacityUsage[Sensor.BattNum],
          MinCellVoltage[Sensor.BattNum], MaxCellVoltage[Sensor.BattNum],
          Cells1[Sensor.BattNum], Cells2[Sensor.BattNum],
          Cells3[Sensor.BattNum], Cells4[Sensor.BattNum],
          Cells5[Sensor.BattNum], Cells6[Sensor.BattNum],
          Cells7[Sensor.BattNum], Cells8[Sensor.BattNum],
          Cells9[Sensor.BattNum], Cells10[Sensor.BattNum],
          Cells11[Sensor.BattNum], Cells12[Sensor.BattNum],
          Cells13[Sensor.BattNum], Cells14[Sensor.BattNum],
          Cells15[Sensor.BattNum], Cells16[Sensor.BattNum],
          Cells17[Sensor.BattNum], Cells18[Sensor.BattNum]]);
      end;
    end;
  end;
end;

procedure TfmMain.AddTxInput(const Sensor: STRU_TELE_TXINPUT);
{$J+}
const
  A: Byte  = 0;
  ANull: Boolean = True;
  B: Byte = 0;
  BNull: Boolean = True;
  C: Byte = 0;
  CNull: Boolean = True;
  D: Byte = 0;
  DNull: Boolean = True;
  E: Byte = 0;
  ENull: Boolean = True;
  F: Byte = 0;
  FNull: Boolean = True;
  G: Byte = 0;
  GNull: Boolean = True;
  H: Byte = 0;
  HNull: Boolean = True;
  I: Byte = 0;
  INull: Boolean = True;
  J: Byte = 0;
  JNull: Boolean = True;
  K: Byte = 0;
  KNull: Boolean = True;
  L: Byte = 0;
  LNull: Boolean = True;
  M: Byte = 0;
  MNull: Boolean = True;
  N: Byte = 0;
  NNull: Boolean = True;
  O: Byte = 0;
  ONull: Boolean = True;
  P: Byte = 0;
  PNull: Boolean = True;
  S: Byte = 0;
  SNull: Boolean = True;
  T: Byte = 0;
  TNull: Boolean = True;
  LTP: Byte = 0;
  LTPNull: Boolean = True;
  RTP: Byte = 0;
  RTPNull: Boolean = True;
  LST: Byte = 0;
  LSTNull: Boolean = True;
  RST: Byte = 0;
  RSTNull: Boolean = True;
  TRN: Byte = 0;
  TRNNull: Boolean = True;
  CLR: Byte = 0;
  CLRNull: Boolean = True;
  BCK: Byte = 0;
  BCKNull: Boolean = True;
  ROL: Byte = 0;
  ROLNull: Boolean = True;
  FNC: Byte = 0;
  FNCNull: Boolean = True;
  LLEVER: Byte = 0;
  LLEVERNull: Boolean = True;
  RLEVER: Byte = 0;
  RLEVERNull: Boolean = True;
  RFU1: Byte = 0;
  RFU1Null: Boolean = True;
  RFU2: Byte = 0;
  RFU2Null: Boolean = True;
  RFU3: Byte = 0;
  RFU3Null: Boolean = True;
  RKnob: SmallInt = 0;
  RKnobNull: Boolean = True;
  LKnob: SmallInt = 0;
  LKnobNull: Boolean = True;
  Throttle: SmallInt = 0;
  ThrottleNull: Boolean = True;
  Elevator: SmallInt = 0;
  ElevatorNull: Boolean = True;
  Aileron: SmallInt = 0;
  AileronNull: Boolean = True;
  Rudder: SmallInt = 0;
  RudderNull: Boolean = True;
  LSlider: SmallInt = 0;
  LSliderNull: Boolean = True;
  RSlider: SmallInt = 0;
  RSliderNull: Boolean = True;
  Pot3: SmallInt = 0;
  Pot3Null: Boolean = True;
  Pot4: SmallInt = 0;
  Pot4Null: Boolean = True;
  Pot5: SmallInt = 0;
  Pot5Null: Boolean = True;
  Pot6: SmallInt = 0;
  Pot6Null: Boolean = True;
  TBD1: SmallInt = 0;
  TBD1Null: Boolean = True;
  TBD2: SmallInt = 0;
  TBD2Null: Boolean = True;
{$J-}
var
  CurA: Variant;
  CurB: Variant;
  CurC: Variant;
  CurD: Variant;
  CurE: Variant;
  CurF: Variant;
  CurG: Variant;
  CurH: Variant;
  CurI: Variant;
  CurJ: Variant;
  CurK: Variant;
  CurL: Variant;
  CurM: Variant;
  CurN: Variant;
  CurO: Variant;
  CurP: Variant;
  CurS: Variant;
  CurT: Variant;
  CurLTP: Variant;
  CurRTP: Variant;
  CurLST: Variant;
  CurRST: Variant;
  CurTRN: Variant;
  CurCLR: Variant;
  CurBCK: Variant;
  CurROL: Variant;
  CurFNC: Variant;
  CurLLEVER: Variant;
  CurRLEVER: Variant;
  CurRFU1: Variant;
  CurRFU2: Variant;
  CurRFU3: Variant;
  CurRKnob: Variant;
  CurLKnob: Variant;
  CurThrottle: Variant;
  CurElevator: Variant;
  CurAileron: Variant;
  CurRudder: Variant;
  CurLSlider: Variant;
  CurRSlider: Variant;
  CurPot3: Variant;
  CurPot4: Variant;
  CurPot5: Variant;
  CurPot6: Variant;
  CurTBD1: Variant;
  CurTBD2: Variant;
begin
  if Sensor = nil then begin
    A := 0;
    ANull := True;
    B := 0;
    BNull := True;
    C := 0;
    CNull := True;
    D := 0;
    DNull := True;
    E := 0;
    ENull := True;
    F := 0;
    FNull := True;
    G := 0;
    GNull := True;
    H := 0;
    HNull := True;
    I := 0;
    INull := True;
    J := 0;
    JNull := True;
    K := 0;
    KNull := True;
    L := 0;
    LNull := True;
    M := 0;
    MNull := True;
    N := 0;
    NNull := True;
    O := 0;
    ONull := True;
    P := 0;
    PNull := True;
    S := 0;
    SNull := True;
    T := 0;
    TNull := True;
    LTP := 0;
    LTPNull := True;
    RTP := 0;
    RTPNull := True;
    LST := 0;
    LSTNull := True;
    RST := 0;
    RSTNull := True;
    TRN := 0;
    TRNNull := True;
    CLR := 0;
    CLRNull := True;
    BCK := 0;
    BCKNull := True;
    ROL := 0;
    ROLNull := True;
    FNC := 0;
    FNCNull := True;
    LLEVER := 0;
    LLEVERNull := True;
    RLEVER := 0;
    RLEVERNull := True;
    RFU1 := 0;
    RFU1Null := True;
    RFU2 := 0;
    RFU2Null := True;
    RFU3 := 0;
    RFU3Null := True;
    RKnob := 0;
    RKnobNull := True;
    LKnob := 0;
    LKnobNull := True;
    Throttle := 0;
    ThrottleNull := True;
    Elevator := 0;
    ElevatorNull := True;
    Aileron := 0;
    AileronNull := True;
    Rudder := 0;
    RudderNull := True;
    LSlider := 0;
    LSliderNull := True;
    RSlider := 0;
    RSliderNull := True;
    Pot3 := 0;
    Pot3Null := True;
    Pot4 := 0;
    Pot4Null := True;
    Pot5 := 0;
    Pot5Null := True;
    Pot6 := 0;
    Pot6Null := True;
    TBD1 := 0;
    TBD1Null := True;
    TBD2 := 0;
    TBD2Null := True;

  end else begin
    // No filtering no timegaps!
    case Sensor.CaptureId of
      STRU_TELE_TXINPUT.TELE_CAPTURE_DIGITAL,
      STRU_TELE_TXINPUT.TELE_CAPTURE_TOUCH:
        begin
          A := Sensor.Switches.A;
          ANull := False;
          B := Sensor.Switches.B;
          BNull := False;
          C := Sensor.Switches.C;
          CNull := False;
          D := Sensor.Switches.D;
          DNull := False;
          E := Sensor.Switches.E;
          ENull := False;
          F := Sensor.Switches.F;
          FNull := False;
          G := Sensor.Switches.G;
          GNull := False;
          H := Sensor.Switches.H;
          HNull := False;
          I := Sensor.Switches.I;
          INull := False;
          J := Sensor.Switches.J;
          JNull := False;
          K := Sensor.Switches.K;
          KNull := False;
          L := Sensor.Switches.L;
          LNull := False;
          M := Sensor.Switches.M;
          MNull := False;
          N := Sensor.Switches.N;
          NNull := False;
          O := Sensor.Switches.O;
          ONull := False;
          P := Sensor.Switches.P;
          PNull := False;
          S := Sensor.Switches.S;
          SNull := False;
          T := Sensor.Switches.T;
          TNull := False;
          LTP := Sensor.Switches.LTP;
          LTPNull := False;
          RTP := Sensor.Switches.RTP;
          RTPNull := False;
          LST := Sensor.Switches.LST;
          LSTNUll := False;
          RST := Sensor.Switches.RST;
          RSTNull := False;
          TRN := Sensor.Switches.TRN;
          TRNNUll := False;
          CLR := Sensor.Switches.CLR;
          CLRNull := False;
          BCK := Sensor.Switches.BCK;
          BCKNull := False;
          ROL := Sensor.Switches.ROL;
          ROLNull := False;
          FNC := Sensor.Switches.FNC;
          FNCNull := False;
          LLEVER := Sensor.Switches.LLEVER;
          LLEVERNull := False;
          RLEVER := Sensor.Switches.RLEVER;
          RLEVERNull := False;
          RFU1 := Sensor.Switches.RFU1;
          RFU1Null := False;
          RFU2 := Sensor.Switches.RFU2;
          RFU2Null := False;
          RFU3 := Sensor.Switches.RFU3;
          RFU3Null := False;
        end;

      STRU_TELE_TXINPUT.TELE_CAPTURE_ANALOG_BASE:
        begin
          RKnob := Sensor.Sticks.knob_R;
          RKnobNull := False;
          Throttle := Sensor.Sticks.stick_Thr;
          ThrottleNull := False;
          Elevator := Sensor.Sticks.stick_Ele;
          ElevatorNull := False;
          Aileron := Sensor.Sticks.stick_Ail;
          AileronNull := False;
          Rudder := Sensor.Sticks.stick_Rud;
          RudderNull := False;
          LSlider := Sensor.Sticks.slider_L;
          LSliderNull := False;
          RSlider := Sensor.Sticks.slider_R;
          RSliderNull := False;
        end;

      STRU_TELE_TXINPUT.TELE_CAPTURE_ANALOG_EXT:
        begin
          Pot3 := Sensor.Pots.pot_3;
          Pot3Null := False;
          Pot4 := Sensor.Pots.pot_4;
          Pot4Null := False;
          Pot5 := Sensor.Pots.pot_5;
          Pot5Null := False;
          Pot6 := Sensor.Pots.pot_6;
          Pot6Null := False;
          LKnob := Sensor.Pots.knob_L;
          LKnobNull := False;
          TBD1 := Sensor.Pots.tbd_1;
          TBD1Null := False;
          TBD2 := Sensor.Pots.tbd_2;
          TBD2Null := False;
        end;
    end;

    if ANull then
      CurA := NULL
    else
      CurA := A;
    if BNull then
      CurB := NULL
    else
      CurB := B;
    if CNull then
      CurC := NULL
    else
      CurC := C;
    if DNull then
      CurD := NULL
    else
      CurD := D;
    if ENull then
      CurE := NULL
    else
      CurE := E;
    if FNull then
      CurF := NULL
    else
      CurF := F;
    if GNull then
      CurG := NULL
    else
      CurG := G;
    if HNull then
      CurH := NULL
    else
      CurH := H;
    if INull then
      CurI := NULL
    else
      CurI := I;
    if JNull then
      CurJ := NULL
    else
      CurJ := J;
    if KNull then
      CurK := NULL
    else
      CurK := K;
    if LNull then
      CurL := NULL
    else
      CurL := L;
    if MNull then
      CurM := NULL
    else
      CurM := M;
    if NNull then
      CurN := NULL
    else
      CurN := N;
    if ONull then
      CurO := NULL
    else
      CurO := O;
    if PNull then
      CurP := NULL
    else
      CurP := P;
    if ANull then
      CurA := NULL
    else
      CurA := A;
    if SNull then
      CurS := NULL
    else
      CurS := S;
    if TNull then
      CurT := NULL
    else
      CurT := T;
    if LTPNull then
      CurLTP := NULL
    else
      CurLTP := LTP;
    if RTPNull then
      CurRTP := NULL
    else
      CurRTP := RTP;
    if LSTNull then
      CurLST := NULL
    else
      CurLST := LST;
    if RSTNull then
      CurRST := NULL
    else
      CurRST := RST;
    if TRNNull then
      CurTRN := NULL
    else
      CurTRN := TRN;
    if CLRNull then
      CurCLR := NULL
    else
      CurCLR := CLR;
    if BCKNull then
      CurBCK := NULL
    else
      CurBCK := BCK;
    if ROLNull then
      CurROL := NULL
    else
      CurROL := ROL;
    if FNCNull then
      CurFNC := NULL
    else
      CurFNC := FNC;
    if LLEVERNull then
      CurLLEVER := NULL
    else
      CurLLEVER := LLEVER;
    if RLEVERNull then
      CurRLEVER := NULL
    else
      CurRLEVER := RLEVER;
    if RFU1Null then
      CurRFU1 := NULL
    else
      CurRFU1 := RFU1;
    if RFU2Null then
      CurRFU2 := NULL
    else
      CurRFU2 := RFU2;
    if RFU3Null then
      CurRFU3 := NULL
    else
      CurRFU3 := RFU3;
    if RKnobNull then
      CurRKnob := NULL
    else
      CurRKnob := RKnob;
    if LKnobNull then
      CurLKnob := NULL
    else
      CurLKnob := LKnob;
    if ThrottleNull then
      CurThrottle := NULL
    else
      CurThrottle := Throttle;
    if ElevatorNull then
      CurElevator := NULL
    else
      CurElevator := Elevator;
    if AileronNull then
      CurAileron := NULL
    else
      CurAileron := Aileron;
    if RudderNull then
      CurRudder := NULL
    else
      CurRudder := Rudder;
    if LSliderNull then
      CurLSlider := NULL
    else
      CurLSlider := LSlider;
    if RSliderNull then
      CurRSlider := NULL
    else
      CurRSlider := RSlider;
    if Pot3Null then
      CurPot3 := NULL
    else
      CurPot3 := Pot3;
    if Pot4Null then
      CurPot4 := NULL
    else
      CurPot4 := Pot4;
    if Pot5Null then
      CurPot5 := NULL
    else
      CurPot5 := Pot5;
    if Pot6Null then
      CurPot6 := NULL
    else
      CurPot6 := Pot6;
    if TBD1Null then
      CurTBD1 := NULL
    else
      CurTBD1 := TBD1;
    if TBD2Null then
      CurTBD2 := NULL
    else
      CurTBD2 := TBD2;

    vtTxInput.AppendRecord([Sensor.Timestamp, CurA, CurB, CurC, CurD, CurE, CurF,
      CurG, CurH, CurI, CurJ, CurK, CurL, CurM, CurN, CurO, CurP, CurS, CurT,
      CurLTP, CurRTP, CurLST, CurRST, CurTRN, CurCLR, CurBCK, CurROL, CurFNC,
      CurLLEVER, CurRLEVER, CurRFU1, CurRFU2, CurRFU3, CurRKnob, CurLKnob,
      CurThrottle, CurElevator, CurAileron, CurRudder, CurLSlider, CurRSlider,
      CurPot3, CurPot4, CurPot5, CurPot6, CurTBD1, CurTBD2]);
  end;
end;

procedure TfmMain.AddTab(const Ts: TTabSheet);
begin
  if FTabs.IndexOf(Ts) = -1  then
    FTabs.Add(Ts);
end;

procedure TfmMain.AddTankPressure(const Sensor: STRU_TELE_DIGITAL_AIR);
{$J+}
const
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  Pressure: array [0..3] of Variant;
  i: Byte;
begin
  // Do not use smooth filtering.
  // Later we may need this code part (when sensor is nil) to initialize
  // specific filtering
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

  end else begin
    for i := 0 to 3 do begin
      if Sensor.Pressure[i].Valid then
        Pressure[i] := Sensor.Pressure[i].Value
      else
        Pressure[i] := NULL;
    end;

    vtTankPressure.AppendRecord([Sensor.Timestamp, Pressure[0], Pressure[1],
      Pressure[2], Pressure[3]]);

    if FTimeGap.Enabled and (not TabAdded) then begin
      if CurTime = MIN_TIME then
        CurTime := Sensor.Timestamp
      else begin
        if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
          AddTab(tsTankPressure);
          TabAdded := True;
        end;
        CurTime := Sensor.Timestamp;
      end;
    end;
  end;
end;

procedure TfmMain.AddTextGen(const Sensor: STRU_TELE_TEXTGEN);
begin
  // No filtering for this sensor. No timegap warnings as well.
  if Sensor <> nil then
    vtTextGen.AppendRecord([Sensor.Timestamp, Sensor.LineNum, Sensor.Text]);
end;

procedure TfmMain.AddTextToLine(const Text: string; var Line: string);
begin
  Line := Line + Text + FormatSettings.ListSeparator;
end;

procedure TfmMain.AddVario(const Sensor: STRU_TELE_VARIO_S);

  procedure ApplyOffset(var Alt: Variant);
  begin
    if Alt <> NULL then begin
      if FVarioOffsetUseSensor then begin
        FVarioOffset := Alt;
        FVarioOffsetUseSensor := False;
      end;
      Alt := Alt - FVarioOffset;
    end;
  end;

const
  CLIMB_PEAK = 5;
{$J+}
const
  Climb: Single = 0;
  Alt: Single = 0;
  TimestampArr: TTimestampArray = nil;
  TimestampNdx: Integer = 0;
  ClimbArr: TSensorArray = nil;
  ClimbNdx: Integer = 0;
  AltArr: TSensorArray = nil;
  AltNdx: Integer = 0;
  CurTime: Cardinal = MIN_TIME;
  TabAdded: Boolean = False;
{$J-}
var
  CurClimb: Variant;
  CurAlt: Variant;
  TmpClimbArr: TSensorArray;
  TmpAltArr: TSensorArray;
  I: Integer;
  Timestamp: Cardinal;
begin
  if Sensor = nil then begin
    CurTime := MIN_TIME;
    TabAdded := False;

    try
      if (FPostProcessing = ppSmooth) and (TimestampNdx > 0) then begin
        try
          ProcessSensor(AltNdx, AltArr, TmpAltArr);
          ProcessSensor(ClimbNdx, ClimbArr, TmpClimbArr);

          CurAlt := NULL;
          CurClimb := NULL;

          AltNdx := 0;
          ClimbNdx := 0;

          StartOperation('Postprocessing...', TimestampNdx);
          try
            for I := 0 to TimestampNdx - 1 do begin
              ShowProgress(I);

              Timestamp := TimestampArr[I];
              if AltNdx = Length(TmpAltArr) then
                CurAlt := NULL
              else begin
                if TmpAltArr[AltNdx].Timestamp = Timestamp then begin
                  CurAlt := TmpAltArr[AltNdx].Value;
                  Inc(AltNdx);
                end;
              end;

              if ClimbNdx = Length(TmpClimbArr) then
                CurClimb := NULL
              else begin
                if TmpClimbArr[ClimbNdx].Timestamp = Timestamp then begin
                  CurClimb := TmpClimbArr[ClimbNdx].Value;
                  Inc(ClimbNdx);
                end;
              end;

              ApplyOffset(CurAlt);
              vtVario.AppendRecord([Timestamp, CurAlt, CurClimb]);
            end;

          finally
            EndOperation;
          end;

        finally
          TmpAltArr := nil;
          TmpClimbArr := nil;
        end;
      end;

    finally
      Climb := 0;
      Alt := 0;

      TimestampArr := nil;
      TimestampNdx := 0;
      AltArr := nil;
      AltNdx := 0;
      ClimbArr := nil;
      ClimbNdx := 0;
    end

  end else begin
    if Sensor.Climb[FLengthUnits].Valid then
      CurClimb := Sensor.Climb[FLengthUnits].Value
    else
      CurClimb := NULL;
    if Sensor.Alt[FLengthUnits].Valid then
      CurAlt := Sensor.Alt[FLengthUnits].Value
    else
      CurAlt := NULL;

    if FPostProcessing = ppNone then begin
      ApplyOffset(CurAlt);
      vtVario.AppendRecord([Sensor.Timestamp, CurAlt, CurClimb]);

      if FTimeGap.Enabled and (not TabAdded) then begin
        if CurTime = MIN_TIME then
          CurTime := Sensor.Timestamp
        else begin
          if Sensor.Timestamp - CurTime > FTimeGap.Gap then begin
            AddTab(tsVario);
            TabAdded := True;
          end;
          CurTime := Sensor.Timestamp;
        end;
      end;

    end else begin
      if (CurAlt <> NULL) or (CurClimb <> NULL) then begin
        if FPostProcessing in [ppFilter, ppPeak] then begin
          if CurAlt <> NULL then begin
            ApplyOffset(CurAlt);
            Alt := CurAlt;
          end;

          if CurClimb <> NULL then begin
            if FPostProcessing = ppFilter then
              Climb := CurClimb
            else begin
              if (Climb + CLIMB_PEAK >= CurClimb) and (Climb - CLIMB_PEAK <= CurClimb) then
                Climb := CurClimb;
            end;
          end;

          vtVario.AppendRecord([Sensor.Timestamp, Alt, Climb]);

        end else begin
          PushTimestamp(Sensor.Timestamp, TimestampNdx, TimestampArr);
          if CurAlt <> NULL then
            PushSensor(Sensor.Timestamp, CurAlt, AltNdx, AltArr);
          if CurClimb <> NULL then
            PushSensor(Sensor.Timestamp, CurClimb, ClimbNdx, ClimbArr);
        end;
      end;
    end;
  end;
end;

procedure TfmMain.AppendPowerBox(const Timestamp: Cardinal;
  const Volt1: Variant; const Cap1: Variant; const Volt2: Variant;
  const Cap2: Variant; const Alarms: Variant);
begin
  if Alarms = 0 then
    vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, Alarms])

  else begin
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_1) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_1]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_2) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_2]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_1) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_1]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_2) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_2]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RPM) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RPM]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_TEMPERATURE) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_TEMPERATURE]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_1) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_1]);
    if (Alarms and STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_2) <> 0 then
      vtPowerBox.AppendRecord([Timestamp, Volt1, Cap1, Volt2, Cap2, STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_2]);
  end;
end;

procedure TfmMain.btAboutClick(Sender: TObject);
begin
  with TfmAbout.Create(Self) do begin
    ShowModal;
    Free;
  end;
end;

procedure TfmMain.btOffsetsClick(Sender: TObject);
var
  fmOffsets: TfmOffsets;
  i: Integer;
  Sensor: STRU_TELE_ALT_ZERO;
  Item: TListItem;
  j: Integer;
  Str: string;
  Session: TTelemetrySession;
  Refresh: Boolean;
begin
  fmOffsets := TfmOffsets.Create(Self);

  for i := 0 to FAltZeros.Count - 1 do begin
    Sensor := STRU_TELE_ALT_ZERO(FAltZeros[i]);
    Item := fmOffsets.lvOffsets.Items.Add;
    Item.Caption := ConvertTime(Sensor.Timestamp);
    Item.SubItems.Add(
      // Reverse the sign when show offset!
      FloatToStrF(0 - Sensor.AltZero[FLengthUnits].Value, ffFixed, 7, 2));
    if Sensor.Offset = STRU_TELE_ALT_ZERO.USER_DEFINED_FILE_OFFSET then
      Item.SubItems.Add('<user defined>')
    else
      Item.SubItems.Add(IntToHex(Sensor.Offset, 8));

    Str := '';
    for j := 0 to SizeOf(TTelemetryData) - 7 do
      Str := Str + IntToHex(Sensor.Data[j], 2) + ' ';
    Item.SubItems.Add(Str);

    Item.Data := Sensor;
  end;

  Refresh := (fmOffsets.ShowModal = mrOK) and (fmOffsets.FAltZeros.Count > 0);
  if Refresh then begin
    Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);
    for i := 0 to fmOffsets.FAltZeros.Count - 1 do begin
      Sensor := STRU_TELE_ALT_ZERO(fmOffsets.FAltZeros[i]);

      FAltZeros.Remove(Sensor);
      Session.Data.Remove(Sensor);

      Sensor.Free;
    end;
  end;

  fmOffsets.Free;

  if Refresh then
    RefreshSession;
end;

procedure TfmMain.btBattInfoClick(Sender: TObject);
begin
  ListViewMenuShowSmartBattInfoClick(nil);
end;

procedure TfmMain.btDocsClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://www.tlmviewer.com/help.htm', nil, nil,
    SW_SHOWNORMAL);
end;

procedure TfmMain.ListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    DeleteSessionRecords;
end;

procedure TfmMain.ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Mark: TListViewSortMark;
  Val1: Cardinal;
  Val2: Cardinal;
  Table: TVirtualTable;
  Clr: TColor;
begin
  Clr := clBlack;

  Mark := GetListViewMark(TListView(Sender), TListView(Sender).Columns[0]);
  if (FPostProcessing = ppNone) and (FTimeGap.Enabled) and (Mark in [smDown, smUp]) then begin
    Table := GetTable(TListView(Sender));
    if ((Mark = smDown) and (Item.Index > 0)) or ((Mark = smUp) and (Item.Index < Table.RecordCount - 1)) then begin
      Table.RecNo := Item.Index + 1;
      Val1 := Table.Fields[0].AsLongWord;
      if Mark = smDown then
        Table.Prior
      else
        Table.Next;
      Val2 := Table.Fields[0].AsLongWord;
      if Val1 - Val2 > FTimeGap.Gap then
        Clr := clRed;
    end;
  end;

  if Sender.Canvas.Brush.Color <> Clr then begin
    if Clr = clRed then begin
      Sender.Canvas.Font.Color := clWhite;
      Sender.Canvas.Brush.Color := Clr;
    end else begin
      Sender.Canvas.Font.Color := clBlack;
      Sender.Canvas.Brush.Color := clWhite;
    end;
  end;
end;

procedure TfmMain.lvGPSCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  Session: TTelemetrySession;
  Clr: TColor;
  Dist: Double;
  SessionDist: Double;
begin
  Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);
  Clr := clBlack;

  if Session.GpsSettings.Alarm <> STRU_TELE_GPS.GPS_ALARM_NONE then begin
    vtGPS.RecNo := Item.Index + 1;
    Dist := vtGPSDistance.AsSingle; // Already in selected units.

    SessionDist := Session.GpsSettings.Distance; // Always in meters!
    if FLengthUnits = luImperial then
      SessionDist := SessionDist * 3.28084;

    if Dist > SessionDist then
      Clr := clRed;
  end;

  // This is the only way to change color to default Black after Red -
  // set it to some unused. Bug? Probably.
  lvGPS.Canvas.Font.Color := clBlue;
  lvGPS.Canvas.Font.Color := Clr;
end;

procedure TfmMain.lvRXCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  Clr: TColor;
begin
  Clr := clBlack;

  if FWarnings.Use then begin
    vtRX.RecNo := Item.Index + 1;

    if ((lvRX.Columns[SubItem].Caption = 'A') and (FWarnings.A <= vtRXA.AsLongWord)) or
       ((lvRX.Columns[SubItem].Caption = 'B') and (FWarnings.B <= vtRXB.AsLongWord)) or
       ((lvRX.Columns[SubItem].Caption = 'R') and (FWarnings.R <= vtRXR.AsLongWord)) or
       ((lvRX.Columns[SubItem].Caption = 'L') and (FWarnings.L <= vtRXL.AsLongWord)) or
       ((lvRX.Columns[SubItem].Caption = 'Frame Loss') and (FWarnings.Frames <= vtRXFrameLoss.AsLongWord)) or
       ((lvRX.Columns[SubItem].Caption = 'Holds') and (FWarnings.Holds <= vtRXHolds.AsLongWord))
    then
      Clr := clRed;
  end;

  // This is the only way to change color to default Black after Red -
  // set it to some unused. Bug? Probably.
  lvRX.Canvas.Font.Color := clBlue;
  lvRX.Canvas.Font.Color := Clr;
end;

procedure TfmMain.lvSessionsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  cbExportAll.Enabled := lvSessions.Items.Count > 0;
end;

procedure TfmMain.lvSessionsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  I: Integer;
  RssiA: Boolean;
  RssiB: Boolean;
  RssiLemon: Boolean;
  Session: TTelemetrySession;
begin
  if (Item <> nil) and (not Selected) then begin
    SaveSession(Item);

    SaveAllListViewColumns;
    SaveFieldsState(Item);
  end;

  if not Selected then begin
    if PageControl.ActivePage <> nil then
      FPageName := PageControl.ActivePage.Name
    else
      FPageName := '';
  end;

  ClearTelemetry;

  EnableButtons(False);
  SetImage(IMG_ID_SELECT_SESSION);

  if (not Selected) or (Item = nil) then
    Exit;

  RestoreWarnings(Item);
  RestoreTimeGap(Item);

  Session := TTelemetrySession(FSessions[Item.Index]);

  ShowSensorsData(Session, RssiA, RssiB, RssiLemon);
  btBattInfo1.Enabled := Length(Session.SmartBatts) > 0;
  btBattInfo2.Enabled := btBattInfo1.Enabled;

  RestoreFieldsState(Item, RssiA, RssiB, RssiLemon);

  ShowTabs;

  LoadPages;

  if Selected and (FPageName <> '') then begin
    for I := 0 to PageControl.PageCount - 1 do begin
      if PageControl.Pages[I].Name = FPageName then begin
        if PageControl.Pages[I].TabVisible then
          PageControl.ActivePage := PageControl.Pages[I];
        FPageName := '';
        Break;
      end;
    end;
  end;

  if FWarnings.Use then begin
    if FCurrentWarnings.Holds >= FWarnings.Holds then
      MessageDlg('Too many HOLDS. Re-evaluate the system!', mtWarning, [mbOK], 0)
    else begin
      if FCurrentWarnings.Frames >= FWarnings.Frames then
        MessageDlg('Too many FRAMES LOSS!', mtWarning, [mbOK], 0)
      else begin
        if FCurrentWarnings.Fades >= FWarnings.Fades then
          MessageDlg('Too many frame loss on one of the FADE!', mtWarning, [mbOK], 0)
        else begin
          if FCurrentWarnings.Use then
            MessageDlg('Telemetry signal problem detected!', mtWarning, [mbOK], 0);
        end;
      end;
    end;
  end;

  UpdateGraphDataButton;
  UpdateMixDataCheckBox;
end;

procedure TfmMain.MGBuildGraph(const Scope: TSLScope);
type
  TValue = record
    Val: Single;
    ValSet: Boolean;
  end;

var
  I: Integer;
  ChanID: Integer;
  DispName: string;
  CylMin: TValue;
  CylMax: TValue;
  PresMin: TValue;
  PresMax: TValue;
  Val: Single;
begin
  Scope.Channels.BeginUpdate;
  try
    { TODO -cAutoscale : Multi graph  init }
    CylMin.Val := 0;
    CylMin.ValSet := False;
    CylMax.Val := 0;
    CylMax.ValSet := False;

    PresMin.Val := 0;
    PresMin.ValSet := False;
    PresMax.Val := 0;
    PresMax.ValSet := False;

    vtTemp.First;
    for I := 0 to vtTemp.RecordCount - 1 do begin
      ShowProgress(I);

      ChanID := vtTemp.FieldByName('ChannelID').AsInteger;
      DispName := vtTemp.FieldByName('ChannelName').AsString;
      if ChanID = 0 then
        SetFirstChannel(Scope, vtTemp.FieldByName('Prec').AsInteger, DispName, True)
      else begin
        if ChanID > Scope.Channels.Count - 1 then
          SetNextChannel(Scope, vtTemp.FieldByName('Prec').AsInteger, DispName, True);
      end;

      if (vtTemp.FieldByName('DataValue').AsSingle <> INVALID_DATA_UINT32) and
         (not vtTemp.FieldByName('DataValue').IsNull) then
      begin
        Val := vtTemp.FieldByName('DataValue').AsSingle;

        Scope.Channels[ChanID].Data.AddXYPoint(vtTemp.Fields[0].AsLongWord / 100, Val);

        { TODO -cAutoscale : Multi graph calc }
        if Pos('Cylinder ', DispName) = 1 then begin
          if not CylMin.ValSet then begin
            CylMin.Val := Val;
            CylMin.ValSet := True;
          end else begin
            if CylMin.Val > Val then
              CylMin.Val := Val;
          end;

          if not CylMax.ValSet then begin
            CylMax.Val := Val;
            CylMax.ValSet := True;
          end else begin
            if CylMax.Val < Val then
              CylMax.Val := Val;
          end;
        end;
        if Pos('Pressure ', DispName) = 1 then begin
          if not PresMin.ValSet then begin
            PresMin.Val := Val;
            PresMin.ValSet := True;
          end else begin
            if PresMin.Val > Val then
              PresMin.Val := Val;
          end;

          if not PresMax.ValSet then begin
            PresMax.Val := Val;
            PresMax.ValSet := True;
          end else begin
            if PresMax.Val < Val then
              PresMax.Val := Val;
          end;
        end;
      end;

      vtTemp.Next;
    end;

    { TODO -cAutoscale : Multi graph setup }
    for I := 0 to Scope.Channels.Count - 1 do begin
      if Pos('Cylinder ', Scope.Channels[I].YAxis.AxisLabel.Text) = 1 then
        Scope.Channels[I].YAxis.ZoomTo(CylMin.Val, CylMax.Val);
      if Pos('Pressure ', Scope.Channels[I].YAxis.AxisLabel.Text) = 1 then
        Scope.Channels[I].YAxis.ZoomTo(PresMin.Val, PresMax.Val);
      // Autoscale for inputs
      if Pos('(Input)', Scope.Channels[I].YAxis.AxisLabel.Text) > 0  then begin
        if IsSwitch(Scope.Channels[I].YAxis.AxisLabel.Text, True) then
          Scope.Channels[I].YAxis.ZoomTo(-4, 4)
        else
          Scope.Channels[I].YAxis.ZoomTo(-2050, 2050);
      end;
    end;

  finally
    Scope.Channels.EndUpdate;
  end;
end;

procedure TfmMain.MixBuildTablesList(const Tables: TList;
  const ListView: TListView; var RecCnt: Integer);
var
  I: Integer;
  Item: TListItem;
  Table: TVirtualTable;
begin
  RecCnt := 0;
  for I := 0 to ListView.Items.Count - 1 do begin
    Item := ListView.Items[I];
    Table := TVirtualTable(Item.Data);
    Table.Fields[Item.ImageIndex].Tag := 0; // Do not show in graph

    if Item.Checked then begin
      Table.Fields[Item.ImageIndex].Tag := 1; // Show in graph
      if Tables.IndexOf(Table) = -1 then begin // Add into list
        Tables.Add(Table);
        RecCnt := RecCnt + Table.RecordCount;
      end;
    end;
  end;
end;

function TfmMain.MixGetSensorName(const Table: TVirtualTable): string;
var
  I: Integer;
  ListView: TListView;
  Page: TTabSheet;
begin
  Result := '';
  for I := 0 to PageControl.PageCount - 1 do begin
    Page := PageControl.Pages[I];
    if TVirtualTable(Page.Tag) = Table then begin
      ListView := GetPageListView(Page);
      if ListView <> nil then begin
        Result := ' (' + ListView.Hint + ')';
        Break;
      end;
    end;
  end;
end;

procedure TfmMain.MGPrepareData(const Tables: TList);
var
  Cnt: Integer;
  ChanID: Integer;
  PrevChanID: Integer;
  I: Integer;
  X: Integer;
  Y: Integer;
  Table: TVirtualTable;
begin
  Cnt := 1;
  ChanID := 0;
  for I := 0 to Tables.Count - 1 do begin
    Table := TVirtualTable(Tables[I]);
    Table.DisableControls; // We have to disable controls for faster operation.
    try
      Table.First;
      PrevChanID := ChanID;

      for X := 0 to Table.RecordCount - 1 do begin
        ShowProgress(Cnt);
        Inc(Cnt);
        ChanID := PrevChanID;

        for Y := 1 to Table.Fields.Count - 1 do begin
          if Table.Fields[Y].Tag = 1 then begin
            vtTemp.AppendRecord([Table.Fields[0].Value, ChanID,
              Table.Fields[Y].DisplayLabel + MixGetSensorName(Table),
              Table.Fields[Y].Value, GetPrecision(Table.Fields[Y])]);
            Inc(ChanID);
          end;
        end;

        Table.Next;
      end;

    finally
      Table.EnableControls; // Do not forget to enable control back.
    end;
  end;

  vtTemp.IndexFieldNames := 'ChannelID ASC, Timestamp ASC';
end;

procedure TfmMain.MGRestoreGraphSettings(const Form: TForm; const Scope: TSLScope);
var
  Reg: TRegistry;
  X: Integer;
  Axis: TSLDisplayYAxis;
  Key: string;
begin
  if FNoStore then begin
    Form.Position := poMainFormCenter;
    Exit;
  end;

  RestorePosition(Form);

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    Key := REG_KEY + '\' + lvSessions.Selected.SubItems[0] + '\Mix_Graph';
    if Reg.OpenKey(Key, False) then begin
      for X := 0 to Scope.Channels.Count - 1 do begin
        if Reg.ValueExists(Scope.Channels[X].Name + '_clr') then
          Scope.Channels[X].Color := TColor(Reg.ReadInteger(Scope.Channels[X].Name + '_clr'));

        if Reg.ValueExists(Scope.Channels[X].Name + '_width') then
          Scope.Channels[X].Width := Reg.ReadInteger(Scope.Channels[X].Name + '_width');

        // 25.09.2018
        // Precision
        if Reg.ValueExists(Scope.Channels[X].Name + '_prec') then begin
          if X = 0 then
            Axis := Scope.YAxis
          else
            Axis := Scope.Channels[X].YAxis;
          Axis.Format.FixedPrecision := True;
          Axis.Format.Precision := Reg.ReadInteger(Scope.Channels[X].Name + '_prec');
        end;
        // ==========
      end;
    end;

  finally
    Reg.Free;
  end;

  for X := 0 to Scope.Channels.Count - 1 do
    SetYAxisColor(Scope.Channels[X].YAxis, Scope.Channels[X].Color);
end;

procedure TfmMain.MixRestoreSensorsSettings(const ListView: TListView;
  const Csv: Boolean);
var
  RegKey: string;
  Reg: TRegistry;
  X: Integer;
  Value: string;
begin
  if FNoStore then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Csv then
      RegKey := REG_KEY + '\MIX_CSV\' + lvSessions.Selected.Subitems[0]
    else
      RegKey := REG_KEY + '\MIX\' + lvSessions.Selected.Subitems[0];

    if Reg.OpenKey(RegKey, False) then begin
      try
        for X := 0 to ListView.Items.Count - 1 do begin
          Value := ListView.Items[X].SubItems[0] + '_' +
            ListView.Items[X].SubItems[1];
          if Reg.ValueExists(Value) then
            ListView.Items[X].Checked := Reg.ReadBool(Value);
        end;

      finally
        Reg.CloseKey;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.MixShowSensors(const TargetListView: TListView);
var
  I: Integer;
  X: Integer;
  Page: TTabSheet;
  ListView: TListView;
  Group: TListGroup;
  Item: TListItem;
  Table: TVirtualTable;
  Add: Boolean;
begin
  for I := 0 to PageControl.PageCount - 1 do begin
    Page := PageControl.Pages[I];
    if Page.TabVisible then begin
      if Page <> tsTextGen then begin
        ListView := GetPageListView(Page);
        if ListView = nil then
          Continue;

        Table := GetTable(ListView);
        if Table = nil then
          Continue;

        Group := TargetListView.Groups.Add;
        Group.Header := Page.Caption;
        Group.State := [lgsNormal];
        for X := 1 to Table.Fields.Count - 1 do begin
          // SmartBatt : MixGraph
          if (Table = vtSmartBatt1) or (Table = vtSmartBatt2) then
            Add := Table.Fields[X].EditMask = ''
          else
            Add := True;

          if Add then begin
            Item := TargetListView.Items.Add;
            Item.GroupID := Group.GroupID;
            Item.Data := Table;
            Item.ImageIndex := X; // Field index
            Item.SubItems.Add(Table.Fields[X].DisplayLabel);
            Item.SubItems.Add(Group.Header);
            Item.Checked := Page.Visible and Table.Fields[X].Visible;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.miSessionsChangePolesandRatioClick(Sender: TObject);
var
  Frm: TfmChangePolesAndRatio;
  Session: TTelemetrySession;
  Res: TModalResult;
  i: Integer;
begin
  Frm := TfmChangePolesAndRatio.Create(Self);
  Frm.btSelected.Enabled := lvSessions.Selected <> nil;

  if lvSessions.Selected <> nil then
    Session := TTelemetrySession(FSessions[lvSessions.Selected.Index])
  else
    Session := TTelemetrySession(FSessions[0]);

  Frm.edStdPoles.Text := IntToStr(Session.Poles);
  Frm.edStdRatio.Text := Format('%.2f', [Session.Ratio]);
  Frm.edEscPoles.Text := IntToStr(Session.PolesESC);
  Frm.edEscRatio.Text := Format('%.2f', [Session.RatioESC]);

  Res := Frm.ShowModal;

  if Res <> mrCancel then begin
    case Res of
      mrOk:
        begin
          Session.SetEscPolesAndRatio(StrToInt(Frm.edEscPoles.Text),
            Trunc(StrToFloat(Frm.edEscRatio.Text) * 100));
          Session.SetPolesAndRatio(StrToInt(Frm.edStdPoles.Text),
            Trunc(StrToFloat(Frm.edStdRatio.Text) * 100));

          Session.UpdateSensors;
        end;

      mrAll:
        for i := 0 to FSessions.Count - 1 do begin
          Session := TTelemetrySession(FSessions[i]);

          Session.SetEscPolesAndRatio(StrToInt(Frm.edEscPoles.Text),
            Trunc(StrToFloat(Frm.edEscRatio.Text) * 100));
          Session.SetPolesAndRatio(StrToInt(Frm.edStdPoles.Text),
            Trunc(StrToFloat(Frm.edStdRatio.Text) * 100));

          Session.UpdateSensors;
        end;
    end;

    RefreshSessions;
  end;

  Frm.Free;
end;

procedure TfmMain.miSessionsDeleteSessionClick(Sender: TObject);
var
  Ndx: Integer;
begin
  Ndx := lvSessions.Selected.Index;
  if MessageDlg('Delete session #' + IntToStr(Ndx + 1) + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    FSessions.Delete(Ndx);

    RefreshSessions;
  end;
end;

procedure TfmMain.miSessionsExportClick(Sender: TObject);
begin
  if lvSessions.Selected <> nil then
    DoExport(lvSessions.Selected);
end;

procedure TfmMain.MoveCompletedLineToList(const Strings: TStringList; var Line: string);
begin
  Strings.Add(System.Copy(Line, 1, Length(Line) - 1));
  Line := '';
end;

procedure TfmMain.NullableFieldGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := NA
  else begin
    if Sender is TSingleField then
      Text := Format('%.2f', [Sender.AsSingle])
    else begin
      if Sender is TLongWordField then
        Text := Format('%u', [Sender.AsLongWord])
      else begin
        if (Sender is TByteField) and (Sender.DataSet = vtTxInput) then
          Text := 'Pos ' + Sender.AsString
        else begin
          if Sender is TIntegerField then
            Text := Format('%d', [Sender.AsInteger])
          else
            Text := Sender.AsString;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.MGSaveGraphSettings(const Form: TForm; const Scope: TSLScope);
var
  Reg: TRegistry;
  X: Integer;
  Axis: TSLDisplayYAxis;
begin
  if FNoStore then
    Exit;

  SavePosition(Form);

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(REG_KEY + '\' + lvSessions.Selected.SubItems[0] + '\Mix_Graph', True) then begin
      for X := 0 to Scope.Channels.Count - 1 do begin
        Reg.WriteInteger(Scope.Channels[X].Name + '_clr', Integer(Scope.Channels[X].Color));
        Reg.WriteInteger(Scope.Channels[X].Name + '_width', Scope.Channels[X].Width);

        if X = 0 then
          Axis := Scope.YAxis
        else
          Axis := Scope.Channels[X].YAxis;
        Reg.WriteInteger(Scope.Channels[X].Name + '_prec', Axis.Format.Precision);
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.MixSaveSensorsSettings(const ListView: TListView; const Csv: Boolean);
var
  RegKey: string;
  Reg: TRegistry;
  Value: string;
  X: Integer;
begin
  if FNoStore then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Csv then
      RegKey := REG_KEY + '\MIX_CSV\' + lvSessions.Selected.Subitems[0]
    else
      RegKey := REG_KEY + '\MIX\' + lvSessions.Selected.Subitems[0];

    if Reg.OpenKey(RegKey, True) then begin
      try
        for X := 0 to ListView.Items.Count - 1 do begin
          Value := ListView.Items[X].SubItems[0] + '_' + ListView.Items[X].SubItems[1];
          Reg.WriteBool(Value, ListView.Items[X].Checked);
        end;

      finally
        Reg.CloseKey;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.ListViewChangeVisibleColumnsClick(Sender: TObject);
var
  ListView: TListView;
  Table: TVirtualTable;
  fmColumns: TfmColumnsEditor;
  i: Integer;
  Add: Boolean;
  Ndx: Integer;
begin
  ListView := GetActiveListView;
  if ListView = nil then
    Exit;

  Table := GetTable(ListView);
  if Table = nil then
    Exit;

  fmColumns := TfmColumnsEditor.Create(Self);
  for i := 1 to Table.Fields.Count - 1 do begin
    // SmartBatt : Build ListView Popup Menu
    if (Table = vtSmartBatt1) or (Table = vtSmartBatt2) then
      Add := (Table.Fields[i].EditMask = '')
    else
      Add := True;

    if Add then begin
      Ndx := fmColumns.lbColumns.Items.AddObject(Table.Fields[I].DisplayLabel,
        Table.Fields[i]);
      fmColumns.lbColumns.Checked[Ndx] := Table.Fields[i].Visible;
    end;
  end;

  if fmColumns.ShowModal = mrOK then begin
    for i := 0 to fmColumns.lbColumns.Items.Count - 1 do
      TField(fmColumns.lbColumns.Items.Objects[i]).Visible := fmColumns.lbColumns.Checked[i];
    RebuildActiveListView;
  end;
  fmColumns.Free;
end;

procedure TfmMain.ListViewColumnClick(Sender: TObject; Column: TListColumn);
var
  Mark: TListViewSortMark;
  Page: TTabSheet;
  Table: TVirtualTable;
  ListView: TListView;
  Field: TField;
  OldColumn: TListColumn;
begin
  ListView := TListView(Sender);
  Page := TTabSheet(TListView(Sender).Parent);

  if FTimeGap.Enabled and (FPostProcessing = ppNone) and (Column.Index > 0) then
    Exit;

  if Column.Index = ListView.Tag then begin
    Mark := GetListViewMark(ListView, Column);
    if Mark = smUp then
      Mark := smDown
    else
      Mark := smUp;

  end else begin
    OldColumn := ListView.Columns[ListView.Tag];
    Mark := GetListViewMark(ListView, OldColumn);
    SetListViewMark(ListView, ListView.Tag, smNone);
    ListView.Tag := Column.Index;
  end;

  SetListViewMark(ListView, Column.Index, Mark);

  if (Page <> nil) and (Page.Tag <> 0) then begin
    Table := TVirtualTable(Page.Tag);
    Field := GetFieldByColumn(Table, Column);
    if Field <> nil then begin
      if Mark = smDown then
        Table.IndexFieldNames := Field.FieldName + ' ASC'
      else
        Table.IndexFieldNames := Field.FieldName + ' DESC'

    end else begin
      Table.IndexFieldNames := '';
      SetListViewMark(ListView, Column.Index, smNone);
    end;

    ListView.Invalidate;
  end;
end;

procedure TfmMain.ListViewData(Sender: TObject; Item: TListItem);
var
  Table: TVirtualTable;
  I: Integer;
  ListView: TListView;
  Field: TField;
begin
  ListView := TListView(Sender);

  Table := GetTable(ListView);
  if Table = nil then
    Exit;

  if not Table.Active then
    Exit;

  Table.RecNo := Item.Index + 1;

  Item.Caption := ConvertTime(Table.Fields[0].AsLongWord);
  Item.StateIndex := Table.Fields[0].AsLongWord;
  for I := 1 to ListView.Columns.Count - 1 do begin
    Field := GetFieldByColumn(Table, ListView.Columns[I]);
    if Field <> nil then
      Item.SubItems.Add(Field.DisplayText)
    else
      Item.SubItems.Add('');
  end;
end;

procedure TfmMain.ListViewMenuCopyRecordsClick(Sender: TObject);
var
  ListView: TListView;
  Item: TListItem;
  Data: string;
  Line: string;
  i: Integer;
begin
  if lvSessions.Selected = nil then
    Exit;

  ListView := GetActiveListView;
  if ListView.Selected = nil then
    Exit;

  Data := '';
  Item := ListView.Selected;
  while Item <> nil do begin
    Line := Item.Caption + ',';
    for i := 0 to Item.SubItems.Count - 1 do
      Line := Line + Item.SubItems[i] + ',';
    Data := Data + Line + #13#10;
    Item := ListView.GetNextItem(Item, sdBelow, [isSelected]);
  end;

  if Data <> '' then begin
    SetLength(Data, Length(Data) - 1);
    if Data <> '' then
      Clipboard.AsText := Data;
  end;
end;

procedure TfmMain.ListViewMenuDeleteRecordsClick(Sender: TObject);
begin
  DeleteSessionRecords;
end;

procedure TfmMain.ListViewMenuFileRawDataClick(Sender: TObject);
var
  Table: TVirtualTable;
  ListView: TListView;
  Session: TTelemetrySession;
  RawForm: TfmRawData;
begin
  if FPostProcessing = ppSmooth then
    Exit;

  if lvSessions.Selected = nil then
    Exit;

  ListView := GetActiveListView;
  if ListView.Selected = nil then
    Exit;

  Table := GetTable(ListView);
  if Table = nil then
    Exit;
  if not Table.Active then
    Exit;

  Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);

  RawForm := TfmRawData.Create(Self, ListView, Table, Session);
  RawForm.Caption := PageControl.ActivePage.Caption + ' Raw Data';
  RawForm.tsRawData.Caption := RawForm.Caption;
  RawForm.ShowModal;
  RawForm.Free;

  if ListView.Selected <> nil then
    ListView.Selected.Focused := True;
end;

procedure TfmMain.ListViewMenuGpsTrackInfoClick(Sender: TObject);
begin
  ShowGpsTrackInfo;
end;

procedure TfmMain.ListViewMenuSetAltZeroClick(Sender: TObject);
var
  ListView: TListView;
  Session: TTelemetrySession;
  Timestamp: Cardinal;
  SensorId: Byte;
  Ndx: Integer;
  Offset: SmallInt;
  IntOffset: Integer;
  Data: TTelemetryData;
  Sensor: STRU_TELE_ALT_ZERO;
  i: Integer;
  Found: Boolean;
begin
  ListView := GetActiveListView;
  if ListView <> nil then begin
    Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);
    Timestamp := ListView.Selected.StateIndex;

    if ListView = lvAlt then
      SensorId := TELE_DEVICE_ALTITUDE
    else begin
      if ListView = lvVario then
        SensorId := TELE_DEVICE_VARIO_S
      else
        SensorId := TELE_DEVICE_GPS_LOC;
    end;

    Ndx := -1;
    for i := 0 to Session.Data.Count - 1 do begin
      Found := (TSensorData(Session.Data[i]).Timestamp = Timestamp) and
        ((TSensorData(Session.Data[i]).SensorID = SensorId) or
         ((SensorId = TELE_DEVICE_GPS_LOC) and (TSensorData(Session.Data[i]).SensorID = TELE_DEVICE_GPS_STATS)));
      if Found then begin
        Ndx := i;
        Break;
      end;
    end;

    Sensor := nil;
    if Ndx > -1 then begin
      ZeroMemory(@Data[0], SizeOf(TTelemetryData));
      PCardinal(@Data[0])^ := TSensorData(Session.Data[i]).TimestampRaw;
      Data[4] := TELE_DEVICE_ALT_ZERO;

      if SensorId <> TELE_DEVICE_GPS_LOC then begin
        Offset := ((TSensorData(Session.Data[i]).Data[0]) shl 8) or TSensorData(Session.Data[i]).Data[1];
        IntOffset := Offset;
        Data[8] := LoByte(LoWord(IntOffset));
        Data[9] := HiByte(LoWord(IntOffset));
        Data[10] := LoByte(HiWord(IntOffset));
        Data[11] := HiByte(HiWord(IntOffset));
      end;

      Sensor := STRU_TELE_ALT_ZERO.Create(Session,
        STRU_TELE_ALT_ZERO.USER_DEFINED_FILE_OFFSET, Data);
      Session.Data.Insert(Ndx, Sensor);
    end;

    if Sensor <> nil then
      RefreshSession;
  end;
end;

procedure TfmMain.ListViewMenuItemClick(Sender: TObject);
begin
  TField(TMenuItem(Sender).Tag).Visible := not TField(TMenuItem(Sender).Tag).Visible;
  RebuildActiveListView;
end;

procedure TfmMain.LoadPages;
var
  Reg: TRegistry;
  I: Integer;
  ListView: TListView;
begin
  if FNoStore then
    Exit;

  LockWindowUpdate(PageControl.Handle);
  try
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(REG_KEY + '\' + TTelemetrySession(FSessions[lvSessions.Selected.Index]).ModelName + '\pages',
                     False)
      then begin
        try
          for I := 0 to PageControl.PageCount - 1 do begin
            if Reg.ValueExists(PageControl.Pages[I].Caption) then begin
              ListView := GetPageListView(PageControl.Pages[I]);
              if (ListView = nil) or ((ListView <> nil) and (ListView.Items.Count > 0)) then
                PageControl.Pages[I].TabVisible := Reg.ReadBool(PageControl.Pages[I].Caption);
            end;
          end;

        finally
          Reg.CloseKey;
        end;
      end;

    finally
      Reg.Free;
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfmMain.LoadSettings(const Reset: Boolean);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reset then begin
      if Reg.KeyExists(REG_KEY) then
        Reg.DeleteKey(REG_KEY);

      if FNoStore and Reg.OpenKey(REG_KEY, True) then begin
        try
          Reg.WriteBool('NoStore', FNoStore);
        finally
          Reg.CloseKey;
        end;
      end;

    end else begin
      if not FNoStore then begin
        if Reg.OpenKey(REG_KEY, False) then begin
          try
            if Reg.ValueExists('NoStore') then
              FNoStore := Reg.ReadBool('NoStore');

            if not FNoStore then begin
              if Reg.ValueExists('MixGraph') then
                cbCombine.Checked := Reg.ReadBool('MixGraph');
              if Reg.ValueExists('TempUnits') then
                FTempUnits := TTempUnits(Reg.ReadInteger('TempUnits'));
              if Reg.ValueExists('LengthUnits') then
                FLengthUnits := TLengthUnits(Reg.ReadInteger('LengthUnits'));
              if Reg.ValueExists('PostProcessing') then
                FPostProcessing := TPostProcessing(Reg.ReadInteger('PostProcessing'));
              if Reg.ValueExists('Apperture') then
                FApperture := Reg.ReadInteger('Apperture');
              if Reg.ValueExists('UseNewParser') then
                FUseNewParser := Reg.ReadBool('UseNewParser');
              if Reg.ValueExists('DoNotAsk') then
                FDoNotAsk := Reg.ReadBool('DoNotAsk');
              if Reg.ValueExists('FixNameReading') then
                FFixNameReading := Reg.ReadBool('FixNameReading');

              if Reg.ValueExists('EnableRxFiltering') then
                FEnableRxFiltering := Reg.ReadBool('EnableRxFiltering');
              if Reg.ValueExists('UseMenuForColumns') then
                FUseMenuForColumns := Reg.ReadBool('UseMenuForColumns');

              if Reg.ValueExists('TimeZoneIndex') then
                FTimeZoneIndex := Reg.ReadInteger('TimeZoneIndex');

              if Reg.ValueExists('AltZero') then
                FAltZeroProcessing := TAltZeroProcessing(Reg.ReadInteger('AltZero'));
              if Reg.ValueExists('AltZeroGps') then
                FGpsAltZeroProcessing := TAltZeroProcessing(Reg.ReadInteger('AltZeroGps'));
              if Reg.ValueExists('AltZeroVario') then
                FVarioAltZeroProcessing := TAltZeroProcessing(Reg.ReadInteger('AltZeroVario'));
            end;

          finally
            Reg.CloseKey;
          end;
        end;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

function TfmMain.GetTable(const ListView: TListView): TVirtualTable;
var
  Page: TTabSheet;
begin
  Result := nil;

  if not (ListView.Parent is TTabSheet) then
    Exit;

  Page := TTabSheet(ListView.Parent);
  if Page.Tag = 0 then
    Exit;

  Result := TVirtualTable(Page.Tag);
end;

procedure TfmMain.GetTimeStampText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := ConvertTime(Sender.AsLongWord);
end;

procedure TfmMain.InitListViews;
var
  i: Integer;
  ListView: TListView;
begin
  for i := 0 to PageControl.PageCount - 1 do begin
    ListView := GetPageListView(PageControl.Pages[i]);
    ListView.Color := clWhite;
    ListView.Font.Color := clBlack;
  end;
end;

procedure TfmMain.InitSettings;
begin
  FTempUnits := tuCelcius;
  FLengthUnits := luMetric;
  FPostProcessing := ppFilter;
  FApperture := 3;
  // Switch to new by default!
  FUseNewParser := True;
  // Ask always by default!
  FDoNotAsk := False;
  // Disbale RX filtering except Simple!
  FEnableRxFiltering := False;
  // No one session has been changed.
  FSessionChanged := False;
  // By default use dialog for visible columns.
  FUseMenuForColumns := False;
  // By default use system timezone.
  FTimeZoneIndex := 0;
  FFixNameReading := True;
  // Do not process AltZero message by default.
  FAltZeroProcessing := azIgnore;
  FGpsAltZeroProcessing := azIgnore;
  FVarioAltZeroProcessing := azIgnore;
end;

procedure TfmMain.InitTable(const Page: TTabSheet; const Table: TVirtualTable;
  const SensorId: Byte);
var
  Reg: TRegistry;
  X: Integer;
begin
  Page.Tag := NativeInt(Table);
  Table.Tag := SensorId;

  // Also create default records.
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\default\fields\' + Table.Name, True) then begin
      try
        for X := 1 to Table.Fields.Count - 1 do
          Reg.WriteString(Table.Fields[X].FieldName, Table.Fields[X].DisplayLabel)
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.InitTables;
begin
  { TODO -cNew Sensor : Init vTable and ListView here }
  InitTable(ts16s16u, vt16s16u, TELE_DEVICE_USER_16SU);
  InitTable(ts16s16u32u, vt16s16u32u, TELE_DEVICE_USER_16SU32U);
  InitTable(ts16s16u32s, vt16s16u32s, TELE_DEVICE_USER_16SU32S);
  InitTable(ts16u32s32u, vt16u32s32u, TELE_DEVICE_USER_16U32SU);
  InitTable(tsPowerBox, vtPowerBox, TELE_DEVICE_PBOX);
  InitTable(tsVoltage, vtVoltage, TELE_DEVICE_VOLTAGE);
  InitTable(tsRXPack, vtRXPack, TELE_DEVICE_RX_MAH);
  InitTable(tsCurrent, vtCurrent, TELE_DEVICE_AMPS);
  InitTable(tsVario, vtVario, TELE_DEVICE_VARIO_S);
  InitTable(tsAlt, vtAlt, TELE_DEVICE_ALTITUDE);
  InitTable(tsAirSpeed, vtAirSpeed, TELE_DEVICE_AIRSPEED);
  InitTable(tsLapTimer, vtLapTimer, TELE_DEVICE_LAPTIMER);
  InitTable(tsTextGen, vtTextGen, TELE_DEVICE_TEXTGEN);
  InitTable(tsESC, vtESC, TELE_DEVICE_ESC);
  InitTable(tsFuel, vtFuel, TELE_DEVICE_FUEL);
  InitTable(tsFlightPack, vtFlightPack, TELE_DEVICE_FP_MAH);
  InitTable(tsTankPressure, vtTankPressure, TELE_DEVICE_DIGITAL_AIR);
  InitTable(tsLipomon, vtLipomon, TELE_DEVICE_LIPOMON);
  InitTable(tsLipomon14, vtLipomon14, TELE_DEVICE_LIPOMON_14);
  InitTable(tsAccel, vtAccel, TELE_DEVICE_GMETER);
  InitTable(tsTurbine, vtTurbine, TELE_DEVICE_JETCAT); // TELE_DEVICE_JETCAT_2
  InitTable(tsGPS, vtGPS, TELE_DEVICE_GPS_STATS);
  InitTable(tsGyro, vtGyro, TELE_DEVICE_GYRO);
  InitTable(tsCompass, vtCompass, TELE_DEVICE_ATTMAG);
  InitTable(tsMultiCylinder, vtMultiCylinder, TELE_DEVICE_MULTICYLINDER);
  InitTable(tsCrossfire, vtCrossfires, TELE_DEVICE_XRF_LINKSTATUS);
  InitTable(tsStandard, vtStandard, TELE_DEVICE_RPM_TM1000); // TELE_DEVICE_RPM_TM1100
  InitTable(tsRX, vtRX, TELE_DEVICE_QOS_TM1000); // TELE_DEVICE_QOS_TM1100
  InitTable(tsTxInput, vtTxInput, TELE_DEVICE_TXINPUTS);
  InitTable(tsSmartBatt1, vtSmartBatt1, TELE_DEVICE_SMARTBATT); // BattNum = 0
  InitTable(tsSmartBatt2, vtSmartBatt2, TELE_DEVICE_SMARTBATT); // BattNum > 0
end;

function TfmMain.IsSwitch(const Name: string; const Multy: Boolean): Boolean;
begin
  if Multy then begin
    Result := (Name = 'A (Input)') or (Name = 'B (Input)') or
      (Name = 'C (Input)') or (Name = 'D (Input)') or (Name = 'E (Input)') or
      (Name = 'F (Input)') or (Name = 'G (Input)') or (Name = 'H (Input)') or
      (Name = 'I (Input)') or (Name = 'J (Input)') or (Name = 'K (Input)') or
      (Name = 'L (Input)') or (Name = 'M (Input)') or (Name = 'N (Input)') or
      (Name = 'O (Input)') or (Name = 'P (Input)') or (Name = 'S (Input)') or
      (Name = 'T (Input)') or (Name = 'LTP (Input)') or
      (Name = 'RTP (Input)') or (Name = 'LST (Input)') or
      (Name = 'RST (Input)') or (Name = 'TRN (Input)') or
      (Name = 'CLR (Input)') or (Name = 'BCK (Input)') or
      (Name = 'ROL (Input)') or (Name = 'FNC (Input)') or
      (Name = 'LLEVER (Input)') or (Name = 'RLEVER (Input)') or
      (Name = 'RFU1 (Input)') or (Name = 'RFU2 (Input)') or
      (Name = 'RFU3 (Input)');
  end else begin
    Result := (Name = 'A') or (Name = 'B') or (Name = 'C') or (Name = 'D') or
      (Name = 'E') or (Name = 'F') or (Name = 'G') or (Name = 'H') or
      (Name = 'I') or (Name = 'J') or (Name = 'K') or (Name = 'L') or
      (Name = 'M') or (Name = 'N') or (Name = 'O') or (Name = 'P') or
      (Name = 'S') or (Name = 'T') or (Name = 'LTP') or (Name = 'RTP') or
      (Name = 'LST') or (Name = 'RST') or (Name = 'TRN') or (Name = 'CLR') or
      (Name = 'BCK') or (Name = 'ROL') or (Name = 'FNC') or (Name = 'LLEVER') or
      (Name = 'RLEVER') or (Name = 'RFU1') or (Name = 'RFU2') or
      (Name = 'RFU3');
  end;
end;

function TfmMain.IsTabAdded(const Ts: TTabSheet): Boolean;
begin
  Result := FTabs.IndexOf(Ts) > -1;
end;

function TfmMain.GetListView(const Index: Integer): TListView;
begin
  Result := nil;

  if (Index < 0) or (Index >= PageControl.PageCount) then
    Exit;

  Result := GetPageListView(PageControl.Pages[Index]);
end;

function TfmMain.GetListViewMark(const ListView: TListView;
  const Column: TListColumn): TListViewSortMark;
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(ListView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column.Index, Item);
  if (Item.fmt and HDF_SORTUP) <> 0 then
    Result := smUp
  else begin
    if (Item.fmt and HDF_SORTDOWN) <> 0 then
      Result := smDown
    else
      Result := smNone;
  end;
end;

function TfmMain.GetMed(Arr: array of Single): Single;
var
  A: Single;
  I: Integer;
begin
  // Very stupid sorting but as array is not too big it should be OK.
  I := Low(Arr);
  while I < High(Arr) do begin
    if Arr[I] > Arr[I + 1] then begin
      A := Arr[I];
      Arr[I] := Arr[I + 1];
      Arr[I + 1] := A;
      I := 0;

    end else
      Inc(I);
  end;

  Result := Arr[(High(Arr) - Low(Arr)) div 2];
end;

function TfmMain.GetPageListView(const Page: TTabSheet): TListView;
var
  I: Integer;
begin
  Result := nil;

  if Page = nil then
    Exit;

  for I := 0 to Page.ControlCount - 1 do begin
    if Page.Controls[I] is TListView then begin
      Result := TListView(Page.Controls[I]);
      Break;
    end;
  end;
end;

function TfmMain.GetPrecision(const Field: TField): Integer;
var
  Str: string;
  P: Integer;
begin
  if Field is TNumericField then begin
    Str := TNumericField(Field).DisplayFormat;
    P := Pos(';', Str);
    if P > 0 then
      Str := Copy(Str, 1, P - 1);
    P := Pos('.', Str);
    if P = 0 then
      Result := 0
    else begin
      Str := Copy(Str, P + 1, Length(Str) - P);
      Result := Length(Str);
    end;

  end else
    Result := -1;
end;

function TfmMain.GetSensorTable(const SensorId: Byte): TVirtualTable;
var
  i: Integer;
  ListView: TListView;
  Table: TVirtualTable;
begin
  Result := nil;
  for i := 0 to PageControl.PageCount - 1 do begin
    ListView := GetPageListView(PageControl.Pages[i]);
    if ListView <> nil then begin
      Table := GetTable(ListView);
      if (Table<> nil) and (Table.Tag = SensorId) then begin
        Result := Table;
        Break;
      end;
    end;
  end;
end;

procedure TfmMain.RefreshSession;
begin
  lvSessionsSelectItem(lvSessions, lvSessions.Selected, False);
  lvSessionsSelectItem(lvSessions, lvSessions.Selected, True);
end;

function TfmMain.GetActiveListView: TListView;
begin
  Result := GetPageListView(PageControl.ActivePage);
end;

function TfmMain.GetFieldByColumn(const Table: TVirtualTable;
  const Column: TListColumn): TField;
var
  I: Integer;
begin
  Result := nil;
  if (Table = nil) or (Column = nil) then
    Exit;

  for I := 0 to Table.Fields.Count - 1 do begin
    if Table.Fields[I].DisplayLabel = Column.Caption then begin
      Result := Table.Fields[I];
      Break;
    end;
  end;
end;

procedure TfmMain.EnableButtons(const Enabled: Boolean);
begin
  btGraphData.Enabled := Enabled;
  cbCombine.Enabled := Enabled;
  cbExportAll.Enabled := lvSessions.Items.Count > 0;
  btExport.Enabled := cbExportAll.Checked or Enabled;
end;

procedure TfmMain.Clear;
var
  I: Integer;
begin
  if lvSessions.Selected <> nil then
    SaveFieldsState(lvSessions.Selected);

  for I := 0 to FSessions.Count - 1 do
    TTelemetrySession(FSessions[I]).Free;
  FSessions.Clear;

  ClearSessionsListView;
  ClearOffsets;

  laFileName.Caption := '';
  FFullFileName := '';
  EnableButtons(False);

  SetImage(IMG_ID_OPEN_FILE);

  ClearTelemetry;
end;

procedure TfmMain.ClearOffsets;
begin
  FAltZeros.Clear;
end;

procedure TfmMain.ClearSessionsListView;
begin
  lvSessions.Items.BeginUpdate;
  try
    lvSessions.Items.Clear;
  finally
    lvSessions.Items.EndUpdate;
  end;

  lvSessions.Groups.BeginUpdate;
  try
    lvSessions.Groups.Clear;
  finally
    lvSessions.Groups.EndUpdate;
  end;
end;

procedure TfmMain.ClearTelemetry;
var
  I: Integer;
  ListView: TListView;
  Page: TTabSheet;
  Table: TVirtualTable;
begin
  LockWindowUpdate(PageControl.Handle);
  try
    for I := 0 to PageControl.PageCount - 1 do begin
      Page := PageControl.Pages[I];
      Page.TabVisible := False;
      if Page.Tag <> 0 then begin
        Table := TVirtualTable(Page.Tag);
        Table.Clear;
        Table.IndexFieldNames := '';
        Table.Close;

        ListView := GetPageListView(Page);
        if ListView <> nil then begin
          ListView.Items.BeginUpdate;
          try
            ListView.Items.Count := 0;
          finally
            ListView.Items.EndUpdate;
          end;
        end;
      end;
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfmMain.CopyDataToTempTable(const Table: TVirtualTable);
var
  X: Integer;
  I: Integer;
begin
  for I := 0 to Table.Fields.Count - 1 do
    vtTemp.Fields[I].DisplayLabel := Table.Fields[I].DisplayLabel;

  Table.First;
  for X := 0 to Table.RecordCount - 1 do begin
    ShowProgress(X);
    vtTemp.Insert;
    try
      for I := 0 to Table.Fields.Count - 1 do
        vtTemp.Fields[I].Value := Table.Fields[I].Value;
    finally
      try
        vtTemp.Post;
      except
        vtTemp.Cancel;
      end;
    end;

    Table.Next;
  end;

  vtTemp.IndexFieldNames := vtTemp.Fields[0].FieldName + ' ASC';
end;

procedure TfmMain.DeleteSessionRecords;
var
  ListView: TListView;
  Table: TVirtualTable;
  Timestamps: array of Cardinal;
  i: Integer;
  Ndx: Integer;
begin
  ListView := GetActiveListView;
  if (ListView <> nil) and (ListView.SelCount > 0) then begin
    Table := GetTable(ListView);
    if Table <> nil then begin
      if MessageDlg('Delete selected records?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        ListView.Items.BeginUpdate;

        SetLength(Timestamps, ListView.SelCount);
        Ndx := 0;
        for i := ListView.Selected.Index to ListView.Items.Count - 1 do begin
          if ListView.Items[i].Selected then begin
            Timestamps[Ndx] := ListView.Items[i].StateIndex;
            Inc(Ndx);
          end;
        end;

        for i := 0 to Length(Timestamps) - 1 do begin
          if Table.Locate('Timestamp', Timestamps[i], []) then
            Table.Delete;
        end;

        ListView.ClearSelection;
        ListView.Items.Count := Table.RecordCount;
        ListView.Items.EndUpdate;

        FSessionChanged := True;
      end;
    end;
  end;
end;

procedure TfmMain.DoExport(const Session: TListItem);
var
  ListView: TListView;
  Table: TVirtualTable;
  Tab: TTabSheet;
  I: Integer;
  Sel: TListItem;
begin
  if Session <> nil then begin
    SaveDialog.Filter := 'Telemetry File (*.tlm)|*.tlm';
    SaveDialog.DefaultExt := '*.tlm';

  end else begin
    if cbCombine.Checked then begin
      SaveDialog.Filter := 'Comma Separated File (*.csv)|*.csv';
      SaveDialog.DefaultExt := '*.csv';

    end else begin
      if cbExportAll.Checked then begin
        SaveDialog.Filter := 'Comma Separated File (*.csv)|*.csv|Telemetry File (*.tlm)|*.tlm';
        SaveDialog.DefaultExt := '*.csv';

      end else begin
        if PageControl.ActivePage <> tsGPS then begin
          SaveDialog.Filter := 'Comma Separated File (*.csv)|*.csv|Telemetry File (*.tlm)|*.tlm';
          SaveDialog.DefaultExt := '*.csv';

        end else begin
          SaveDialog.Filter := 'Comma Separated File (*.csv)|*.csv|' +
            'Telemetry File (*.tlm)|*.tlm|Google Earth File (*.kml)|*.kml';
          SaveDialog.DefaultExt := '*.kml';
        end;
      end;
    end;
  end;

  if SaveDialog.Execute then begin
    if LowerCase(ExtractFileExt(SaveDialog.FileName)) = '.tlm' then
      ExportTlm(Session)

    else begin
      if cbCombine.Checked then
        ExportMixedData

      else begin
        ListView := GetActiveListView;
        if ListView <> nil then begin
          Table := GetTable(ListView);
          if Table <> nil then begin
            if cbExportAll.Checked then begin
              Tab := PageControl.ActivePage;
              Sel := lvSessions.Selected;

              if FileExists(SaveDialog.FileName) then
                DeleteFile(PWideChar(SaveDialog.FileName));

              for I := 0 to lvSessions.Items.Count - 1 do begin
                lvSessions.Selected := lvSessions.Items[I];
                if Tab.TabVisible then
                  ExecuteExport(Table, True)
              end;

              lvSessions.Selected := Sel;
              PageControl.ActivePage := Tab;

            end else
              ExecuteExport(Table, False);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.OpenTLMFile(const FileName: string);
var
  fmSelectParser: TfmSelectParser;
  ProcessOpen: Boolean;
begin
  if FileName = '' then begin
    MessageDlg('Invalid file name', mtError, [mbOK], 0);
    Exit;
  end;

  if LowerCase(ExtractFileExt(FileName)) <> '.tlm' then begin
    MessageDlg('Unsupported file format.', mtError, [mbOK], 0);
    Exit;
  end;

  if not FileExists(FileName) then begin
    MessageDlg('File not found.', mtError, [mbOK], 0);
    Exit;
  end;

  // Select parser
  if not FDoNotAsk then begin
    fmSelectParser := TfmSelectParser.Create(Self);
    fmSelectParser.rbNew.Checked := FUseNewParser;
    fmSelectParser.rbOld.Checked := not FUseNewParser;
    fmSelectParser.laFileName.Caption := ExtractFileName(FileName);

    ProcessOpen := fmSelectParser.ShowModal = mrOk;

    if ProcessOpen then begin
      FUseNewParser := fmSelectParser.rbNew.Checked;
      FDoNotAsk := fmSelectParser.cbDoNotAsk.Checked;
    end;

    fmSelectParser.Free;

  end else
    ProcessOpen := True;

  if not ProcessOpen then
    Exit;

  ProcessTLMFile(FileName, FSessions, FUseNewParser, FFixNameReading);
end;

procedure TfmMain.ProcessTLMFile(const FileName: string; const Sessions: TList;
  const UseNewParser: Boolean; const FixNameReading: Boolean);
var
  ParseResult: Boolean;
begin
  Clear;

  ParseResult := TfmProgressDialog.ParseFile(FileName, FSessions, FUseNewParser,
    FFixNameReading);
  if ParseResult then begin
    laFileName.Caption := ExtractFileName(FileName);
    FFullFileName := FileName;

    ShowSessions;

    if FSessions.Count = 0 then
      SetImage(IMG_ID_OPEN_FILE)
    else
      SetImage(IMG_ID_SELECT_SESSION);
  end;
end;

procedure TfmMain.PageControlChange(Sender: TObject);
begin
  UpdateGraphDataButton;
  UpdateMixDataCheckBox;
end;

procedure TfmMain.PagesMenuItemClick(Sender: TObject);
var
  Cnt: Integer;
  I: Integer;
begin
  Cnt := 0;
  for I := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[I].TabVisible then
      Inc(Cnt);

  if (Cnt > 1) or ((Cnt = 1) and (not TMenuItem(Sender).Checked)) then begin
    TTabSheet(TMenuItem(Sender).Tag).TabVisible := not TTabSheet(TMenuItem(Sender).Tag).TabVisible;
    SavePages;
  end;

  UpdateGraphDataButton;
  UpdateMixDataCheckBox;
end;

procedure TfmMain.pmListViewPopup(Sender: TObject);
var
  ListView: TListView;
  Table: TVirtualTable;
  I: Integer;
  Item: TMenuItem;
  Session: TTelemetrySession;
  Add: Boolean;
  NeedSep: Boolean;
begin
  pmListView.Items.Clear;

  ListView := GetActiveListView;
  if ListView = nil then
    Exit;

  Table := GetTable(ListView);
  if Table = nil then
    Exit;

  SaveListViewColumns(ListView);

  if FUseMenuForColumns then begin
    for I := 1 to Table.Fields.Count - 1 do begin
      // SmartBatt : Build ListView Popup Menu
      if (Table = vtSmartBatt1) or (Table = vtSmartBatt2) then
        Add := (Table.Fields[I].EditMask = '')
      else
        Add := True;

      if Add then begin
        Item := TMenuItem.Create(pmListView);
        Item.Caption := Table.Fields[I].DisplayLabel;
        Item.Checked := Table.Fields[I].Visible;
        Item.Tag := NativeInt(Table.Fields[I]);
        Item.OnClick := ListViewMenuItemClick;

        pmListView.Items.Add(Item);
      end;
    end;
  end else begin
    Item := TMenuItem.Create(pmListView);
    Item.Caption := 'Change visible columns...';
    Item.OnClick := ListViewChangeVisibleColumnsClick;
    pmListView.Items.Add(Item);
  end;

  NeedSep := (ListView = lv16s16u) or (ListView = lv16s16u32u) or
    (ListView = lv16s16u32s) or (ListView = lv16u32s32u) or
    (ListView = lvSmartBatt1) or (ListView = lvSmartBatt2) or
    (ListView = lvTxInput) or (ListView = lvGPS) or (ListView = lvVario) or
    (ListView = lvAlt);

  if NeedSep then begin
    Item := TMenuItem.Create(pmListView);
    Item.Caption := '-';
    pmListView.Items.Add(Item);
  end;

  // Rename menu item.
  if (ListView = lv16s16u) or (ListView = lv16s16u32u) or
     (ListView = lv16s16u32s) or (ListView = lv16u32s32u) or
     (ListView = lvTxInput) then
  begin
    Item := TMenuItem.Create(pmListView);
    Item.Caption := 'Rename...';
    Item.OnClick := ListViewMenuRenameItemClick;
    pmListView.Items.Add(Item);
  end;

  // Add smart battery info item.
  if (ListView = lvSmartBatt1) or (ListView = lvSmartBatt2) then begin
    if lvSessions.Selected = nil then
      Session := nil
    else
      Session := TTelemetrySession(FSessions[lvSessions.Selected.Index]);

    Item := TMenuItem.Create(pmListView);
    Item.Caption := 'Battery information...';
    Item.OnClick := ListViewMenuShowSmartBattInfoClick;
    Item.Enabled := (Session <> nil) and (Length(Session.SmartBatts) > 0);
    pmListView.Items.Add(Item);
  end;

  // Add GPS Track info menu item.
  if ListView = lvGPS then begin
    Item := TMenuItem.Create(pmListView);
    Item.Caption := 'Track info...';
    Item.OnClick := ListViewMenuGpsTrackInfoClick;
    Item.Enabled := lvSessions.Selected <> nil;
    pmListView.Items.Add(Item);
  end;

  // Add SetZero menu item.
  if (ListView = lvGPS) or (ListView = lvVario) or (ListView = lvAlt) then begin
    Item := TMenuItem.Create(pmListView);
    Item.Caption := 'Set altitude zero offset';
    Item.OnClick := ListViewMenuSetAltZeroClick;
    Item.Enabled := (lvSessions.Selected <> nil) and (ListView.SelCount = 1);
    pmListView.Items.Add(Item);
  end;

  // Add copy records item.
  Item := TMenuItem.Create(pmListView);
  Item.Caption := 'Copy selected records';
  Item.ShortCut := TextToShortCut('Ctrl+C');
  Item.OnClick := ListViewMenuCopyRecordsClick;
  Item.Enabled := (lvSessions.Selected <> nil) and (ListView.SelCount > 0);
  pmListView.Items.Add(Item);

  // Add delete records item.
  Item := TMenuItem.Create(pmListView);
  Item.Caption := 'Delete selected records';
  Item.OnClick := ListViewMenuDeleteRecordsClick;
  Item.Enabled := (lvSessions.Selected <> nil) and (ListView.SelCount > 0);
  pmListView.Items.Add(Item);

  // Add file pos item.
  Item := TMenuItem.Create(pmListView);
  Item.Caption := '-';
  pmListView.Items.Add(Item);
  Item := TMenuItem.Create(pmListView);
  Item.Caption := 'File raw data...';
  Item.OnClick := ListViewMenuFileRawDataClick;
  Item.Enabled := (lvSessions.Selected <> nil) and
    (FPostProcessing = ppNone) and (ListView.Selected <> nil);
  pmListView.Items.Add(Item);

  // Add restore column defaults.
  Item := TMenuItem.Create(pmListView);
  Item.Caption := 'Restore colum defaults';
  Item.OnClick := ListViewMenuRestoreColumnDefaultsClick;
  pmListView.Items.Add(Item);
end;

procedure TfmMain.pmPagesPopup(Sender: TObject);
var
  i: Integer;
  Pages: Byte;
  Item: TMenuItem;
  ListView: TListView;
  Table: TVirtualTable;
begin
  pmPages.Items.Clear;

  SavePages;

  Pages := 0;
  for i := 0 to PageControl.PageCount - 1 do begin
    ListView := GetPageListView(PageControl.Pages[i]);
    if ListView = nil then
      Continue;

    Table := GetTable(ListView);
    if Table = nil then
      Continue;

    if Table.RecordCount = 0 then
      Continue;

    Item := TMenuItem.Create(pmPages);
    Item.Caption := PageControl.Pages[i].Caption;
    Item.Checked := PageControl.Pages[i].TabVisible;
    if Item.Checked then
      Inc(Pages);
    Item.Tag := NativeInt(PageControl.Pages[i]);
    Item.OnClick := PagesMenuItemClick;

    pmPages.Items.Add(Item);
  end;

  // If only one page visible - disable the menu item to prevent it from hiding.
  if Pages = 1 then begin
    for i := 0 to pmPages.Items.Count - 1 do begin
      if pmPages.Items[i].Checked then begin
        pmPages.Items[i].Enabled := False;
        Break;
      end;
    end;
  end;
end;

procedure TfmMain.pmSessionsPopup(Sender: TObject);
begin
  miSessionsChangePolesandRatio.Enabled := lvSessions.Items.Count > 0;
  miSessionsDeleteSession.Enabled := lvSessions.Selected <> nil;
  miSessionsExport.Enabled := lvSessions.Selected <> nil;
end;

procedure TfmMain.PrepareSensors;
begin
  FTabs.Clear;

  { TODO -cNew Sensor : Init sensors here }
  AddVoltage(nil);
  AddCurrent(nil);
  AddPowerBox(nil);
  AddLapTimer(nil);
  AddTextGen(nil);
  AddAirSpeed(nil);
  AddAlt(nil);
  AddAccel(nil);
  AddJetCat(nil, nil, 0);
  AddGps(nil);
  AddRxPack(nil);
  AddGyro(nil);
  AddCompass(nil);
  AddEsc(nil);
  AddFuel(nil);
  AddFlightPack(nil);
  AddTankPressure(nil);
  AddLipomon(nil);
  AddLipomon14(nil);
  AddVario(nil);
  AddSmartBatt(nil);
  Add16s16u(nil);
  Add16s16u32u(nil);
  Add16s16u32s(nil);
  Add16u32s32u(nil);
  AddMultiCylinder(nil);
  AddCrossfire(nil);
  AddTxInput(nil);
  AddRpm(nil);
  AddRx(nil);
end;

procedure TfmMain.PrepareTempTable(const SourceTable: TVirtualTable);
var
  I: Integer;
begin
  vtTemp.FieldDefs.Clear;
  vtTemp.FieldDefs.Assign(SourceTable.FieldDefs);
  vtTemp.Tag := NativeInt(SourceTable);
  vtTemp.Open;

  for I := 0 to vtTemp.Fields.Count - 1 do begin
    vtTemp.Fields[I].Visible := SourceTable.Fields[I].Visible;
    if vtTemp.Fields[I] is TNumericField then
      TNumericField(vtTemp.Fields[I]).DisplayFormat := TNumericField(SourceTable.Fields[I]).DisplayFormat;
    if Assigned(SourceTable.Fields[I].OnGetText) then
      vtTemp.Fields[I].OnGetText := SourceTable.Fields[I].OnGetText
    else begin
      // This is timestamp!
      if I = 0 then
        vtTemp.Fields[I].OnGetText := GetTimeStampText;
    end;
  end;
end;

procedure TfmMain.ProcessSensor(const Ndx: Integer; const SrcArr: TSensorArray;
  var DstArr: TSensorArray);
var
  I: Integer;
  TmpArr: array of Single;
  J: Integer;
  Wnd: Byte;
  Start: Byte;
  Stop: Byte;
begin
  if Ndx = 0 then
    DstArr := nil

  else begin
    Wnd := FApperture * 2 + 1;
    Start := (Wnd - 1) div 2;
    Stop := (Wnd + 1) div 2;

    SetLength(TmpArr, Wnd);
    try
      StartOperation('Postprocessing...', Ndx);
      try
        SetLength(DstArr, Ndx);
        for I := 0 to Ndx - 1 do begin
          ShowProgress(I);

          DstArr[I].Timestamp := SrcArr[I].Timestamp;

          if (I < Start) or (I > Ndx - Stop) then
            DstArr[I].Value := SrcArr[I].Value

          else begin
            for J := 0 to Wnd - 1 do
              TmpArr[J] := SrcArr[I - Start + J].Value;

            DstArr[I].Value := GetMed(TmpArr);
          end;
        end;

      finally
        EndOperation;
      end;

    finally
      TmpArr := nil;
    end;
  end;
end;

procedure TfmMain.PushSensor(const Timestamp: Cardinal; const Value: Single;
  var Ndx: Integer; var Arr: TSensorArray);
begin
  if Value = INVALID_DATA_UINT32 then
    Exit;

  if Ndx = Length(Arr) then
    SetLength(Arr, Ndx + 100);

  Arr[Ndx].Timestamp := Timestamp;
  Arr[Ndx].Value := Value;

  Inc(Ndx);
end;

procedure TfmMain.PushTimestamp(const Timestamp: Cardinal; var Ndx: Integer;
  var Arr: TTimestampArray);
begin
  if Ndx = Length(Arr) then
    SetLength(Arr, Ndx + 100);

  Arr[Ndx] := Timestamp;

  Inc(Ndx);
end;

procedure TfmMain.RebuildActiveListView;
begin
  RebuildListView(GetActiveListView);
end;

procedure TfmMain.RebuildListView(const ListView: TListView;
  const Default: Boolean);
var
  Table: TVirtualTable;
  I: Integer;
  Column: TListColumn;
begin
  if ListView = nil then
    Exit;

  Table := GetTable(ListView);
  if Table = nil then
    Exit;

  ListView.Items.BeginUpdate;
  try
    ListView.Columns.BeginUpdate;
    try
      ListView.Columns.Clear;

      for I := 0 to Table.Fields.Count - 1 do begin
        if Table.Fields[I].Visible then begin
          Column := ListView.Columns.Add;
          Column.Caption := Table.Fields[I].DisplayLabel;
          Column.Tag := NativeInt(Table.Fields[I]);

          if I = 0 then
            Column.Alignment := taLeftJustify
          else
            Column.Alignment := taRightJustify;

          if Table.Fields[I] is TNumericField then
            Column.Width := TNumericField(Table.Fields[I]).DisplayWidth
          else
            Column.Width := 100;
        end;
      end;

      RestoreListViewColumns(ListView, Default);

    finally
      ListView.Columns.EndUpdate;
    end;

  finally
    ListView.Items.EndUpdate;
  end;

  ListView.Invalidate;
end;

procedure TfmMain.RefreshSessions;
begin
  ClearSessionsListView;
  ClearTelemetry;
  ShowSessions;
end;

function TfmMain.RegReadInt(const Reg: TRegistry; const Name: string;
  const Def: Integer): Integer;
begin
  if Reg.ValueExists(Name) then
    Result := Reg.ReadInteger(Name)
  else
    Result := Def;
end;

procedure TfmMain.RegWriteStr(const Reg: TRegistry; const Key, Value: string);
begin
  if Reg.OpenKey(Key, True) then begin
    try
      Reg.WriteString('', Value);
    finally
      Reg.CloseKey;
    end;
  end;
end;

procedure TfmMain.ReleaseTempTable;
begin
  vtTemp.Clear;
  vtTemp.Close;
  vtTemp.IndexFieldNames := '';
  vtTemp.FieldDefs.Clear;
end;

procedure TfmMain.ListViewMenuRenameItemClick(Sender: TObject);
var
  I: Integer;
  Reg: TRegistry;
  ListView: TListView;
  Table: TVirtualTable;
  DefName: string;
  DispName: string;
  Form: TfmRenameColumns;
begin
  ListView := GetActiveListView;
  if ListView <> nil then begin
    Table := GetTable(ListView);
    if Table <> nil then begin
      Reg := TRegistry.Create;
      try
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(REG_KEY + '\default\fields\' + Table.Name, False) then begin
          try
            Form := TfmRenameColumns.Create(Self);
            try
              for I := 1 to Table.Fields.Count - 1 do begin
                DefName := Reg.ReadString(Table.Fields[I].FieldName);
                DispName := Table.Fields[I].DisplayLabel;

                Form.veColumns.InsertRow(DefName, DispName, True);
              end;

              if Form.ShowModal = mrOK then begin
                for I := 1 to Table.Fields.Count - 1 do
                  Table.Fields[I].DisplayLabel := Form.veColumns.Cells[1, I];

                RebuildListView(ListView);
              end;

            finally
              Form.Free;
            end;

          finally
            Reg.CloseKey;
          end

        end else
          raise Exception.Create('Something went wrong!!! Default field names not found for table ' + Table.Name);

      finally
        Reg.Free;
      end;
    end;
  end;
end;

procedure TfmMain.ListViewMenuRestoreColumnDefaultsClick(Sender: TObject);
var
  ListView: TListView;
  Table: TVirtualTable;
  i: Integer;
begin
  ListView := GetActiveListView;
  if ListView = nil then
    Exit;

  Table := GetTable(ListView);
  if Table = nil then
    Exit;

  for i := 1 to Table.Fields.Count - 1 do
    Table.Fields[i].Visible := True;

  RebuildListView(ListView, True);;
end;

procedure TfmMain.ListViewMenuShowSmartBattInfoClick(Sender: TObject);
var
  Num: Byte;
begin
  if GetActiveListView = lvSmartBatt1 then
    Num := 0
  else
    Num := 1;
  TfmSmartBattInforDlg.ShowDialog(Num,
    TTelemetrySession(FSessions[lvSessions.Selected.Index]));
end;

procedure TfmMain.RestoreFieldsState(const Item: TListItem;
  const RssiA: Boolean; const RssiB: Boolean; const RssiLemon: Boolean);
var
  I: Integer;
  X: Integer;
  Reg: TRegistry;
  ListView: TListView;
  Table: TVirtualTable;
  Key: string;
begin
  if FNoStore then begin
    SetRssiHeadersSpm4650(RssiA, RssiB);
    SetRssiHeadersLemon(RssiLemon);
    SetSmartBattCells;
    Exit;
  end;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    for I := 0 to PageControl.PageCount - 1 do begin
      ListView := GetListView(I);
      if ListView = nil then
        Continue;

      Table := GetTable(ListView);
      if Table = nil then
       Continue;

      RestoreTableDefaultFields(Table);

      Key := REG_KEY + '\' + TTelemetrySession(FSessions[Item.Index]).ModelName +
        '\fields\' + Table.Name;
      if Reg.OpenKey(Key, False) then begin
        try
          for X := 1 to Table.Fields.Count - 1 do begin
            if Reg.ValueExists(Table.Fields[X].FieldName) then
              Table.Fields[X].Visible := Reg.ReadBool(Table.Fields[X].FieldName)
            else
              Table.Fields[X].Visible := True;

            // Also restore field display name.
            if Reg.ValueExists(Table.Fields[X].FieldName + '_DisplayName') then
              Table.Fields[X].DisplayLabel := Reg.ReadString(Table.Fields[X].FieldName + '_DisplayName');
            // =======
          end;
        finally
          Reg.CloseKey;
        end;
      end;
    end;

  finally
    Reg.Free;
  end;

  SetRssiHeadersSpm4650(RssiA, RssiB);
  SetRssiHeadersLemon(RssiLemon);
  SetSmartBattCells;
  SetTempUnits;
  SetLengthUnits;
end;

procedure TfmMain.RestoreListViewColumns(const ListView: TListView;
  const Default: Boolean);
var
  I: Integer;
  Reg: TRegistry;
  KeyName: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    KeyName := REG_KEY + '\' + ListView.Name;
    if Default then
      KeyName := KeyName + '\Default';

    if Reg.OpenKey(KeyName, False) then begin
      try
        for I := 0 to ListView.Columns.Count - 1 do begin
          ListView.Columns[I].Width := RegReadInt(Reg,
            TField(ListView.Columns[I].Tag).FieldName,
            ListView.Columns[I].Width);
        end;
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.RestorePosition(const Form: TForm);
var
  Reg: TRegistry;
  State: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(REG_KEY + '\' + Form.Name, False) then begin
      try
        Form.Width := RegReadInt(Reg, 'Width', Width);
        Form.Height := RegReadInt(Reg, 'Height', Height);
        Form.Left := RegReadInt(Reg, 'Left', Left);
        Form.Top := RegReadInt(Reg, 'Top', Top);

        State := RegReadInt(Reg, 'State', Ord(wsNormal));
        if (State = Ord(wsMinimized)) and (Form = Self) then begin
          Visible := True;
          Application.Minimize;

        end else begin
          if State <> Ord(wsMinimized) then
            Form.WindowState := TWindowState(State);
        end;

      finally
        Reg.CloseKey;
      end

    end else begin
      if Form = Self then
        Position := poScreenCenter;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.RestoreTableDefaultFields(const Table: TVirtualTable);
var
  Reg: TRegistry;
  X: Integer;
begin
  // Restore default table's fields.
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\default\fields\' + Table.Name, False) then begin
      try
        for X := 1 to Table.Fields.Count - 1 do begin
          if Reg.ValueExists(Table.Fields[X].FieldName) then
            Table.Fields[X].DisplayLabel := Reg.ReadString(Table.Fields[X].FieldName);
          Table.Fields[X].Visible := True;
        end;
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;

  SetTempUnits;
  SetLengthUnits;
end;

procedure TfmMain.RestoreTimeGap(const Item: TListItem);
var
  Reg: TRegistry;
  Key: string;
begin
  FTimeGap.Enabled := False;
  FTimeGap.Gap := 44; // Default 44 ms.

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Key := REG_KEY + '\' + TTelemetrySession(FSessions[Item.Index]).ModelName +
      '\Timegap';
    if Reg.OpenKey(Key, False) then begin
      try
        if Reg.ValueExists('Enabled') then
          FTimeGap.Enabled := Reg.ReadBool('Enabled');
        if Reg.ValueExists('Gap') then
          FTimeGap.Gap := Reg.ReadInteger('Gap');

      finally
        Reg.CloseKey;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.RestoreWarnings(const Item: TListItem);
var
  Reg: TRegistry;
  Key: string;
begin
  // Default values.
  FWarnings.A := 75;
  FWarnings.B := 75;
  FWarnings.R := 75;
  FWarnings.L := 75;
  FWarnings.Fades := 500;
  FWarnings.Frames := 20;
  FWarnings.Holds := 1;
  FWarnings.Use := False;

  FCurrentWarnings.A := 0;
  FCurrentWarnings.B := 0;
  FCurrentWarnings.R := 0;
  FCurrentWarnings.L := 0;
  FCurrentWarnings.Fades := 0;
  FCurrentWarnings.Frames := 0;
  FCurrentWarnings.Holds := 0;
  FCurrentWarnings.Use := False; // Used as telemetry lost indicator.

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Key := REG_KEY + '\' + TTelemetrySession(FSessions[Item.Index]).ModelName +
      '\Warnings';
    if Reg.OpenKey(Key, False) then begin
      try
        if Reg.ValueExists('A') then
          FWarnings.A := Reg.ReadInteger('A');
        if Reg.ValueExists('B') then
          FWarnings.B := Reg.ReadInteger('B');
        if Reg.ValueExists('R') then
          FWarnings.R := Reg.ReadInteger('R');
        if Reg.ValueExists('L') then
          FWarnings.L := Reg.ReadInteger('L');
        if Reg.ValueExists('Fades') then
          FWarnings.Fades := Reg.ReadInteger('Fades');
        if Reg.ValueExists('Frames') then
          FWarnings.Frames := Reg.ReadInteger('Frames');
        if Reg.ValueExists('Holds') then
          FWarnings.Holds := Reg.ReadInteger('Holds');
        if Reg.ValueExists('Use') then
          FWarnings.Use := Reg.ReadBool('Use');

      finally
        Reg.CloseKey;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SaveAllListViewColumns(const Default: Boolean);
var
  I: Integer;
  ListView: TListView;
begin
  // Save columns
  for I := 0 to PageControl.PageCount - 1 do begin
    ListView := GetListView(I);
    if ListView <> nil then
      SaveListViewColumns(ListView, Default);
  end;
end;

procedure TfmMain.SaveColumnDefaults;
begin
  SaveAllListViewColumns(True);
end;

procedure TfmMain.SaveFieldsState(const Item: TListItem);
var
  I: Integer;
  X: Integer;
  Reg: TRegistry;
  ListView: TListView;
  Table: TVirtualTable;
  Key: string;
begin
  if FNoStore then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    for I := 0 to PageControl.PageCount - 1 do begin
      ListView := GetListView(I);
      if ListView = nil then
        Continue;
      Table := GetTable(ListView);
      if Table = nil then
       Continue;

      Key := REG_KEY + '\' + TTelemetrySession(FSessions[Item.Index]).ModelName +
        '\fields\' + Table.Name;
      if Reg.OpenKey(Key, True) then begin
        try
          for X := 1 to Table.Fields.Count - 1 do begin
            Reg.WriteBool(Table.Fields[X].FieldName, Table.Fields[X].Visible);

            // Also store field display name.
            Reg.WriteString(Table.Fields[X].FieldName + '_DisplayName', Table.Fields[X].DisplayLabel);
            // =======
          end;

        finally
          Reg.CloseKey;
        end;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SaveListViewColumns(const ListView: TListView;
  const Default: Boolean);
var
  I: Integer;
  Reg: TRegistry;
  KeyName: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    KeyName :=REG_KEY + '\' + ListView.Name;
    if Default then
      KeyName := KeyName + '\Default';

    if Reg.OpenKey(KeyName, True) then begin
      try
        for I := 0 to ListView.Columns.Count - 1 do begin
          if ListView.Columns[I].Tag <> 0 then begin
            Reg.WriteInteger(TField(ListView.Columns[I].Tag).FieldName,
              ListView.Columns[I].Width);
          end;
        end;
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SavePages;
var
  Reg: TRegistry;
  I: Integer;
  ListView: TListView;
  Key: string;
begin
  if FNoStore then
    Exit;

  if lvSessions.Selected = nil then
    Exit;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Key := REG_KEY + '\' + TTelemetrySession(FSessions[lvSessions.Selected.Index]).ModelName + '\pages';
    if Reg.OpenKey(Key, True) then begin
      try
        for I := 0 to PageControl.PageCount - 1 do begin
          ListView := GetPageListView(PageControl.Pages[I]);
          if ListView = nil then
            Continue;

          if ListView.Items.Count = 0 then
            Continue;

          Reg.WriteBool(PageControl.Pages[I].Caption,
            PageControl.Pages[I].TabVisible);
        end;

      finally
        Reg.CloseKey;
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SavePosition(const Form: TForm);
var
  Reg: TRegistry;
  State: Integer;
  Pl: TWindowPlacement;
  R: TRect;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_KEY + '\' + Form.Name, True) then begin
      try
        Pl.Length := SizeOf(TWindowPlacement);
        GetWindowPlacement(Form.Handle, @Pl);
        R := Pl.rcNormalPosition;
        Reg.WriteInteger('Width', R.Right - R.Left);
        Reg.WriteInteger('Height', R.Bottom - R.Top);
        Reg.WriteInteger('Left', R.Left);
        Reg.WriteInteger('Top', R.Top);

        if Form = Self then begin
          if IsIconic(Application.Handle) then
            State := Ord(wsMinimized)
          else
            State := Ord(WindowState)
        end else
          State := Ord(Form.WindowState);
        Reg.WriteInteger('State', State);

      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SaveSession(const Item: TListItem);
var
  Res: TModalResult;
begin
  if (Item <> nil) and FSessionChanged then begin
    Res := MessageDlg('The session has been changed. Would you like to save it?',
      mtConfirmation, [mbYes, mbNo], 0);
    if Res = mrYes then
      DoExport(Item);

    FSessionChanged := False;
  end;
end;

procedure TfmMain.SaveSettings;
var
  Reg: TRegistry;
begin
  if not FNoStore then begin
    Reg := TRegistry.Create;

    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(REG_KEY, True) then begin
        try
          Reg.WriteBool('MixGraph', cbCombine.Checked);
          Reg.WriteInteger('TempUnits', Integer(FTempUnits));
          Reg.WriteInteger('LengthUnits', Integer(FLengthUnits));
          Reg.WriteInteger('PostProcessing', Integer(FPostProcessing));
          Reg.WriteInteger('Apperture', FApperture);
          Reg.WriteBool('UseNewParser', FUseNewParser);
          Reg.WriteBool('DoNotAsk', FDoNotAsk);
          Reg.WriteBool('EnableRxFiltering', FEnableRxFiltering);
          Reg.WriteBool('UseMenuForColumns', FUseMenuForColumns);
          Reg.WriteInteger('TimeZoneIndex', FTimeZoneIndex);
          Reg.WriteBool('FixNameReading', FFixNameReading);

          Reg.WriteInteger('AltZero', Integer(FAltZeroProcessing));
          Reg.WriteInteger('AltZeroGps', Integer(FGpsAltZeroProcessing));
          Reg.WriteInteger('AltZeroVario', Integer(FVarioAltZeroProcessing));
        finally
          Reg.CloseKey;
        end;
      end;

    finally
      Reg.Free;
    end;
  end;
end;

procedure TfmMain.SaveToCSVFile(const Table: TVirtualTable;
  const Append: Boolean);
var
  Strings: TStringList;
  LatestLine: string;
  I: Integer;
  J: Integer;
begin
  LatestLine := '';

  Strings := TStringList.Create;

  try
    if Append and FileExists(SaveDialog.FileName) then begin
      Strings.LoadFromFile(SaveDialog.FileName, TEncoding.UTF8);
      Strings.Add(FormatSettings.ListSeparator);
      Strings.Add(FormatSettings.ListSeparator);
    end;

    Table.First;
    for I := 0 to Table.Fields.Count - 1 do begin
      if Table.Fields[I].Visible then
        AddTextToLine(Table.Fields[I].DisplayLabel, LatestLine);
    end;
    MoveCompletedLineToList(Strings, LatestLine);

    for I := 0 to Table.RecordCount - 1 do begin
      ShowProgress(I);

      for J := 0 to Table.FieldCount - 1 do begin
        if Table.Fields[J].Visible then begin
          if Table.Fields[J] is TStringField then
            AddTextToLine(Table.Fields[J].DisplayText, LatestLine)
          else begin
            if Table.Fields[J].AsSingle <> INVALID_DATA_UINT32 then
              AddTextToLine(Table.Fields[J].DisplayText, LatestLine)
            else
              AddTextToLine('', LatestLine);
          end;
        end;
      end;

      MoveCompletedLineToList(Strings, LatestLine);

      Table.Next;
    end;

    Strings.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);

  finally
    Strings.Free;
  end;
end;

procedure TfmMain.SaveToKMLFile(const Table: TVirtualTable);
var
  Strings: TStringList;
  I: Integer;
  Str: string;
  Lat: Single;
  Lon: Single;
  Alt: Single;
  LatPrev: Single;
  LonPrev: Single;
  AltPrev: Single;
  CoordSet: Boolean;
begin
  Strings := TStringList.Create;
  try
    Strings.Add('<?xml version="1.0" encoding="UTF-8"?>');
    Strings.Add('<kml xmlns="http://www.opengis.net/kml/2.2">');
    Strings.Add('  <Document>');
    Strings.Add('    <name>' + lvSessions.Selected.SubItems[0] + '</name>');
    Strings.Add('    <description></description>');
    Strings.Add('    <Style id="RedLine">');
    Strings.Add('      <LineStyle>');
    Strings.Add('        <color>7f0000ff</color>');
    Strings.Add('        <width>4</width>');
    Strings.Add('      </LineStyle>');
    Strings.Add('      <PolyStyle>');
    Strings.Add('        <color>7f0000ff</color>');
    Strings.Add('      </PolyStyle>');
    Strings.Add('    </Style>');
    Strings.Add('    <Style id="OrangeLine">');
    Strings.Add('      <LineStyle>');
    Strings.Add('        <color>7f0085ff</color>');
    Strings.Add('        <width>4</width>');
    Strings.Add('      </LineStyle>');
    Strings.Add('      <PolyStyle>');
    Strings.Add('        <color>7f0085ff</color>');
    Strings.Add('      </PolyStyle>');
    Strings.Add('    </Style>');
    Strings.Add('    <Style id="GreenLine">');
    Strings.Add('      <LineStyle>');
    Strings.Add('        <color>7f00ff00</color>');
    Strings.Add('        <width>4</width>');
    Strings.Add('      </LineStyle>');
    Strings.Add('      <PolyStyle>');
    Strings.Add('        <color>7f00ff00</color>');
    Strings.Add('      </PolyStyle>');
    Strings.Add('    </Style>');
    Strings.Add('    <Style id="YellowLine">');
    Strings.Add('      <LineStyle>');
    Strings.Add('        <color>7f00ffff</color>');
    Strings.Add('        <width>4</width>');
    Strings.Add('      </LineStyle>');
    Strings.Add('      <PolyStyle>');
    Strings.Add('        <color>7f00ffFF</color>');
    Strings.Add('      </PolyStyle>');
    Strings.Add('    </Style>');
    Strings.Add('    <Style id="yellowLineGreenPoly">');
    Strings.Add('      <LineStyle>');
    Strings.Add('        <color>7f00ffff</color>');
    Strings.Add('        <width>4</width>');
    Strings.Add('      </LineStyle>');
    Strings.Add('      <PolyStyle>');
    Strings.Add('        <color>7f00ff00</color>');
    Strings.Add('      </PolyStyle>');
    Strings.Add('    </Style>');
    Strings.Add('    <Placemark>');
    Strings.Add('      <name>Absolute</name>');
    Strings.Add('      <description>Flight Path</description>');
    Strings.Add('      <styleUrl>#yellowLineGreenPoly</styleUrl>');
    Strings.Add('      <LineString>');
    Strings.Add('        <extrude>0</extrude>');
    Strings.Add('        <tessellate>0</tessellate>');
    Strings.Add('        <altitudeMode>absolute</altitudeMode>');
    Strings.Add('        <coordinates>');

    CoordSet := False;
    LonPrev := 0;
    LatPrev := 0;
    AltPrev := 0;
    Table.First;
    for I := 0 to Table.RecordCount - 1 do begin
      ShowProgress(I);

      Lon := Table.FieldByName('Longitude').AsSingle;
      Lat := Table.FieldByName('Latitude').AsSingle;
      Alt := Table.FieldByName('Alt').AsSingle;
      if FLengthUnits = luImperial then
        Alt := Alt * 0.3048;

      if (Lon <> 0) and (Lat <> 0) then begin
        if (not CoordSet) or
           (CoordSet and (Lon <> LonPrev) and (Lat <> LatPrev) and (Alt <> AltPrev))
        then begin
          Str := Format('%.8f,%.8f,%.2f', [Lon, Lat, Alt]);
          Strings.Add(Str);

          LonPrev := Lon;
          LatPrev := Lat;
          AltPrev := Alt;
          CoordSet := True;
        end;
      end;

      Table.Next;
    end;

    Strings.Add('        </coordinates>');
    Strings.Add('      </LineString>');
    Strings.Add('    </Placemark>');
    Strings.Add('  </Document>');
    Strings.Add('</kml>');

    Strings.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);

  finally
    Strings.Free;
  end;
end;

procedure TfmMain.SetChannelTag(const Channel: TSLScopeChannel;
  const Str: string);
begin
  if Pos('UTC Time', Str) > 0 then
    Channel.Tag := CHANNEL_TAG_TIME
  else
    Channel.Tag := CHANNEL_TAG_NONE;
end;

procedure TfmMain.SetFirstChannel(const Scope: TSLScope; const Prec: Integer;
  const DisplayLabel: string; const Visible: Boolean);
begin
  Scope.YAxis.AxisLabel.Text := DisplayLabel;
  Scope.YAxis.OnCustomLabel := TfmGraph(Scope.Owner).AxisCustomLable;

  Scope.YAxis.Format.FixedPrecision := True;
  Scope.YAxis.Format.Precision := Prec;

  Scope.Channels[0].Name := DisplayLabel;
  SetChannelTag(Scope.Channels[0], DisplayLabel);

  Scope.Channels[0].Visible := Visible;
  Scope.Channels[0].YAxis.Visible := Visible;
  if FPostProcessing = ppNone then
    Scope.Channels[0].ChannelMode := cmPoint;
end;

procedure TfmMain.SetImage(const ID: Integer);
begin
  Image.Picture := nil;
  if ID >= ImageList.Count then
    ImageList.GetBitmap(0, Image.Picture.Bitmap)
  else
    ImageList.GetBitmap(ID, Image.Picture.Bitmap);
end;

procedure TfmMain.SetLengthUnits;
begin
  { TODO -cUnits : Set length units }
  if FLengthUnits = luMetric then begin
    vtAirSpeed.Fields[1].DisplayLabel := 'Airspeed (km/h)';
    vtAirSpeed.Fields[2].DisplayLabel := 'Max Airspeed (km/h)';

    vtAlt.Fields[1].DisplayLabel := 'Altitude (m)';
    vtAlt.Fields[2].DisplayLabel := 'Max Altitude (m)';

    vtVario.Fields[1].DisplayLabel := 'Altitude (m)';
    vtVario.Fields[2].DisplayLabel := 'Climb Rate (m/s)';

    vtGPS.Fields[2].DisplayLabel := 'Speed (km/h)';
    vtGPS.Fields[3].DisplayLabel := 'Altitude (m)';
    vtGPS.Fields[7].DisplayLabel := 'Distance (m)';

  end else begin
    vtAirSpeed.Fields[1].DisplayLabel := 'Airspeed (MPH)';
    vtAirSpeed.Fields[2].DisplayLabel := 'Max Airspeed (MPH)';

    vtAlt.Fields[1].DisplayLabel := 'Altitude (ft)';
    vtAlt.Fields[2].DisplayLabel := 'Max Altitude (ft)';

    vtVario.Fields[1].DisplayLabel := 'Altitude (ft)';
    vtVario.Fields[2].DisplayLabel := 'Climb Rate (ft/s)';

    vtGPS.Fields[2].DisplayLabel := 'Speed (MPH)';
    vtGPS.Fields[3].DisplayLabel := 'Altitude (ft)';
    vtGPS.Fields[7].DisplayLabel := 'Distance (ft)';
  end;
end;

procedure TfmMain.SetListViewMark(const ListView: TListView;
  const Column: Integer; const Mark: TListViewSortMark);
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(ListView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column, Item);
  Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);

  case Mark of
    smUp:
      Item.fmt := Item.fmt or HDF_SORTUP;

    smDown:
      Item.fmt := Item.fmt or HDF_SORTDOWN;
  end;

  Header_SetItem(Header, Column, Item);
end;

procedure TfmMain.SetNextChannel(const Scope: TSLScope; const Prec: Integer;
  const DisplayLabel: string; const Visible: Boolean);
var
  Axis: TSLScopeYAxesCollectionItem;
  Channel: TSLScopeChannel;
begin
  Axis := Scope.YAxis.AdditionalAxes.Add;
  Axis.Axis.AxisLabel.Text := DisplayLabel;
  Axis.Axis.OnCustomLabel := TfmGraph(Scope.Owner).AxisCustomLable;

  Axis.Axis.Format.FixedPrecision := True;
  Axis.Axis.Format.Precision := Prec;

  Channel := Scope.Channels.Add;
  Channel.Name := DisplayLabel;
  Channel.YAxis  := Axis.Axis;

  SetChannelTag(Channel, DisplayLabel);

  Channel.Visible := Visible;
  Channel.YAxis.Visible := Visible;
  if FPostProcessing = ppNone then
    Channel.ChannelMode := cmPoint;
end;

procedure TfmMain.SetOffsets(const Sensor: STRU_TELE_ALT_ZERO);
begin
  case FAltZeroProcessing of
    azMessage: FAltOffset := Sensor.AltZero[FLengthUnits].Value;
    azVirtual: FAltOffsetUseSensor := True;
  end;

  if FGpsAltZeroProcessing = azVirtual then
    FGpsOffsetUseSensor := True;

  case FVarioAltZeroProcessing of
    azMessage: FVarioOffset := Sensor.AltZero[FLengthUnits].Value;
    azVirtual: FVarioOffsetUseSensor := True;
  end;

  FAltZeros.Add(Sensor);
end;

procedure TfmMain.SetRssiHeadersLemon(const Rssi: Boolean);
begin
  if Rssi then
    vtRXA.DisplayLabel := 'RSSI (%)'
  else
    vtRXA.DisplayLabel := 'A';
end;

procedure TfmMain.SetRssiHeadersSpm4650(const RssiA: Boolean;
  const RssiB: Boolean);
begin
  if RssiA then
    vtStandardA.DisplayLabel := 'RSSI (%)'
  else
    vtStandardA.DisplayLabel := 'A level (dBm)';
  if RssiB then
    vtStandardB.DisplayLabel := 'RSSI (%)'
  else
    vtStandardB.DisplayLabel := 'B level (dBm)';
end;

procedure TfmMain.SetSessionTime(const Item: TListItem;
  const Session: TTelemetrySession);
const
  TIME_ZONES: array [0..37]  of Int64 = (
    -720, -660, -600, -570, -540, -480, -420, -360, -300, -240, -210, -180,
    -120, -60, 0, 60, 120, 180, 210, 240, 270, 300, 330, 345, 360, 390, 420,
    480, 525, 540, 570, 600, 630, 660, 720, 765, 780, 840 );

var
  Str: string;
  SessionTime: TDateTime;
begin
  if Session.RtcSet then begin
    if FTimeZoneIndex > 0 then
      SessionTime := IncMinute(Session.DateTime, TIME_ZONES[FTimeZoneIndex - 1])
    else
      SessionTime := TTimeZone.Local.ToLocalTime(Session.DateTime);
    Str := ' [' + DateTimeToStr(SessionTime) + ']';

  end else
    Str := '';

  Item.SubItems[4] := Session.DurationStr + Str;
end;

procedure TfmMain.SetSmartBattCells;
var
  Session: TTelemetrySession;
  Cells: Byte;
  i: Integer;
  j: Integer;
  ListView: TListView;
  Table: TVirtualTable;
begin
  if lvSessions.Selected <> nil then begin
    Session := FSessions[lvSessions.Selected.Index];

    for i := 0 to Length(Session.SmartBatts) - 1 do begin
      if Session.SmartBatts[i].IdSet then begin
        Cells := Session.SmartBatts[i].Id.Cells;
        if Session.SmartBatts[i].Index = 0 then begin
          ListView := lvSmartBatt1;
          Table := vtSmartBatt1;
        end else begin
          ListView := lvSmartBatt2;
          Table := vtSmartBatt2;
        end;

        for j := 6 to Table.Fields.Count - 1 do begin
          Table.Fields[j].Visible := False;
          Table.Fields[j].EditMask := '-';
        end;

        if Cells > 0 then begin
          for j := 0 to Cells - 1 do begin
            Table.Fields[6 + j].Visible := True;
            Table.Fields[6 + j].EditMask := '';
          end;
        end;

        RebuildListView(ListView);
      end;
    end;
  end;
end;

procedure TfmMain.SetTempUnits;
var
  i: Byte;
begin
  { TODO -cUnits : Set temperature units }
  if FTempUnits = tuCelcius then begin
    vtESC.Fields[4].DisplayLabel := 'BEC Temp (C)';
    vtESC.Fields[8].DisplayLabel := 'FET Temp (C)';

    vtFlightPack.Fields[3].DisplayLabel := 'Temperature A (C)';
    vtFlightPack.Fields[6].DisplayLabel := 'Temperature B (C)';

    vtStandard.Fields[2].DisplayLabel := 'Temperature (C)';

    vtLipomon.Fields[7].DisplayLabel := 'Temperature (C)';

    vtTurbine.Fields[6].DisplayLabel := 'Temperature (C)';

    vtFuel.Fields[3].DisplayLabel := 'Temperature A (C)';
    vtFuel.Fields[6].DisplayLabel := 'Temperature B (C)';

    for i := 1 to 9 do
      vtMultiCylinder.Fields[i].DisplayLabel := 'Cylinder ' + IntToStr(i) + ' (C)';

  end else begin
    vtESC.Fields[4].DisplayLabel := 'BEC Temp (F)';
    vtESC.Fields[8].DisplayLabel := 'FET Temp (F)';

    vtFlightPack.Fields[3].DisplayLabel := 'Temperature A (F)';
    vtFlightPack.Fields[6].DisplayLabel := 'Temperature B (F)';

    vtStandard.Fields[2].DisplayLabel := 'Temperature (F)';

    vtLipomon.Fields[7].DisplayLabel := 'Temperature (F)';

    vtTurbine.Fields[6].DisplayLabel := 'Temperature (F)';

    vtFuel.Fields[3].DisplayLabel := 'Temperature A (F)';
    vtFuel.Fields[6].DisplayLabel := 'Temperature B (F)';

    for i := 1 to 9 do
      vtMultiCylinder.Fields[i].DisplayLabel := 'Cylinder ' + IntToStr(i) + ' (F)';
  end;
end;

procedure TfmMain.SetUpdate(const Start: Boolean);
var
  I: Integer;
  ListView: TListView;
  Page: TTabSheet;
  Table: TVirtualTable;
begin
  for I := 0 to PageControl.PageCount - 1 do begin
    Page := PageControl.Pages[I];
    if Page.Tag = 0 then
      Continue;

    Table := TVirtualTable(Page.Tag);
    if Start then
      Table.Open

    else begin
      Table.First;
      Table.IndexFieldNames := Table.Fields[0].FieldName + ' ASC';

      ListView := GetPageListView(Page);
      if ListView <> nil then
        ListView.Items.Count := Table.RecordCount;
    end;
  end;
end;

procedure TfmMain.SetYAxisColor(const Axis: TSLDisplayAxis; const Color: TColor);
begin
  Axis.Color := Color;
  Axis.Font.Color := Color;
  Axis.AxisLabel.Font.Color := Color;
end;

function TfmMain.SGBuildGraph(const Scope: TSLScope; const SensorName: string): Boolean;
type
  TValue = record
    Val: Single;
    ValSet: Boolean;
  end;

var
  I: Integer;
  X: Integer;
  FirstChannel: Integer;
  Ndx: Integer;
  CylMin: TValue;
  CylMax: TValue;
  PresMin: TValue;
  PresMax: TValue;
  Val: Single;
begin
  vtTemp.First;

  Scope.Channels.BeginUpdate;
  try
    FirstChannel := 0;
    for I := 1 to vtTemp.Fields.Count - 1 do begin
      if vtTemp.Fields[I].Visible then begin
        FirstChannel := I;
        Break;
      end;
    end;

    if FirstChannel = 0 then
      Result := False

    else begin
      SetFirstChannel(Scope, GetPrecision(vtTemp.Fields[FirstChannel]),
        vtTemp.Fields[FirstChannel].DisplayLabel,
        vtTemp.Fields[FirstChannel].Visible);

      for I := FirstChannel + 1 to vtTemp.Fields.Count - 1 do begin
        if vtTemp.Fields[I].Visible then begin
          SetNextChannel(Scope, GetPrecision(vtTemp.Fields[I]),
            vtTemp.Fields[I].DisplayLabel, vtTemp.Fields[I].Visible);
        end;
      end;

      { TODO -cAutoscale : Single graph  init }
      CylMin.Val := 0;
      CylMin.ValSet := False;
      CylMax.Val := 0;
      CylMax.ValSet := False;

      PresMin.Val := 0;
      PresMin.ValSet := False;
      PresMax.Val := 0;
      PresMax.ValSet := False;

      for I := 0 to vtTemp.RecordCount - 1 do begin
        ShowProgress(I);
        Ndx := 0;
        for X := FirstChannel to vtTemp.Fields.Count - 1 do begin
          if vtTemp.Fields[X].Visible then begin
            if (vtTemp.Fields[X].AsSingle <> INVALID_DATA_UINT32) and
               (not vtTemp.Fields[X].IsNull) then
            begin
              Val := vtTemp.Fields[X].AsSingle;

              Scope.Channels[Ndx].Data.AddXYPoint(
                vtTemp.Fields[0].AsLongWord / 100, Val);

              { TODO -cAutoscale : Single graph  calc }
              if Pos('Cylinder ', vtTemp.Fields[X].DisplayLabel) = 1 then begin
                if not CylMin.ValSet then begin
                  CylMin.Val := Val;
                  CylMin.ValSet := True;
                end else begin
                  if CylMin.Val > Val then
                    CylMin.Val := Val;
                end;

                if not CylMax.ValSet then begin
                  CylMax.Val := Val;
                  CylMax.ValSet := True;
                end else begin
                  if CylMax.Val < Val then
                    CylMax.Val := Val;
                end;
              end;

              if Pos('Pressure ', vtTemp.Fields[X].DisplayLabel) = 1 then begin
                if not PresMin.ValSet then begin
                  PresMin.Val := Val;
                  PresMin.ValSet := True;
                end else begin
                  if PresMin.Val > Val then
                    PresMin.Val := Val;
                end;

                if not PresMax.ValSet then begin
                  PresMax.Val := Val;
                  PresMax.ValSet := True;
                end else begin
                  if PresMax.Val < Val then
                    PresMax.Val := Val;
                end;
              end;
            end;

            Inc(Ndx);
          end;
        end;
        vtTemp.Next;
      end;

      Result := True;
    end;

    if Result then begin
      { TODO -cAutoscale : Single graph  setup }
      for I := 0 to Scope.Channels.Count - 1 do begin
        if Pos('Radio Input', Scope.Title.Text) <> 0 then begin
          if IsSwitch(Scope.Channels[I].YAxis.AxisLabel.Text, False) then
            Scope.Channels[I].YAxis.ZoomTo(-4, 4)
          else
            Scope.Channels[I].YAxis.ZoomTo(-2050, 2050);
        end else begin
          if Pos('Cylinder ', Scope.Channels[I].YAxis.AxisLabel.Text) = 1 then
            Scope.Channels[I].YAxis.ZoomTo(CylMin.Val, CylMax.Val);
          if Pos('Pressure ', Scope.Channels[I].YAxis.AxisLabel.Text) = 1 then
            Scope.Channels[I].YAxis.ZoomTo(PresMin.Val, PresMax.Val);
          if Pos('Pressure ', Scope.Channels[I].YAxis.AxisLabel.Text) = 1 then
        end;
      end;
    end;

  finally
    Scope.Channels.EndUpdate;
  end;
end;

procedure TfmMain.SGRestoreGraphSettings(const Form: TForm;
  const Scope: TSLScope; const KeyName: string);
var
  Reg: TRegistry;
  X: Integer;
  Axis: TSLDisplayYAxis;
  Key: string;
begin
  if FNoStore then begin
    Form.Position := poMainFormCenter;
    Exit;
  end;

  RestorePosition(Form);

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    Key := REG_KEY + '\' + lvSessions.Selected.SubItems[0] + '\' +
      KeyName + '\Graph';
    if Reg.OpenKey(Key, False) then begin
      for X := 0 to Scope.Channels.Count - 1 do begin
        if Reg.ValueExists(IntToStr(X)) then begin
          Scope.Channels[X].Visible := Reg.ReadBool(IntToStr(X));
          // Remove this line, uncomment lines below if needed to store axis
          // visability independed.
          Scope.Channels[X].YAxis.Visible := Scope.Channels[X].Visible;
          // ========
        end;

        // May be needed later. Do not delete. That is how it was stored
        // before this line above
        // 'Scope.Channels[X].YAxis.Visible := Scope.Channels[X].Visible;'
        // =========
        {if Reg.ValueExists('yax_' + IntToStr(X)) then
          Scope.Channels[X].YAxis.Visible := Reg.ReadBool('yax_' + IntToStr(X));}
        // ==========

        if Reg.ValueExists('chclr_' + IntToStr(X)) then
          Scope.Channels[X].Color := TColor(Reg.ReadInteger('chclr_' + IntToStr(X)));

        if Reg.ValueExists('chwidth_' + IntToStr(X)) then
          Scope.Channels[X].Width := Reg.ReadInteger('chwidth_' + IntToStr(X));

        // 25.09.2018
        // Precision
        if Reg.ValueExists('chprec_' + IntToStr(X)) then begin
          if X = 0 then
            Axis := Scope.YAxis
          else
            Axis := Scope.Channels[X].YAxis;
          Axis.Format.FixedPrecision := True;
          Axis.Format.Precision := Reg.ReadInteger('chprec_' + IntToStr(X));
        end;
        // ==========

        // Set YAxis color to the same as channel.
        SetYAxisColor(Scope.Channels[X].YAxis, Scope.Channels[X].Color);
      end

    end else begin
      // No settings stored yet.
      for X := 0 to Scope.Channels.Count - 1 do
        SetYAxisColor(Scope.Channels[X].YAxis, Scope.Channels[X].Color);
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.SGSaveGraphSettings(const Form: TForm; const Scope: TSLScope;
  const KeyName: string);
var
  Reg: TRegistry;
  X: Integer;
  Axis: TSLDisplayYAxis;
  Key: string;
begin
  if FNoStore then
    Exit;

  SavePosition(Form);

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    Key := REG_KEY + '\' + lvSessions.Selected.SubItems[0] + '\' +
      KeyName + '\Graph';
    if Reg.OpenKey(Key, True) then begin
      for X := 0 to Scope.Channels.Count - 1 do begin
        Reg.WriteBool(IntToStr(X), Scope.Channels[X].Visible);
        Reg.WriteBool('yax_' + IntToStr(X), Scope.Channels[X].YAxis.Visible);
        Reg.WriteInteger('chclr_' + IntToStr(X), Integer(Scope.Channels[X].Color));
        Reg.WriteInteger('chwidth_' + IntToStr(X), Scope.Channels[X].Width);

        if X = 0 then
          Axis := Scope.YAxis
        else
          Axis := Scope.Channels[X].YAxis;
        Reg.WriteInteger('chprec_' + IntToStr(X), Axis.Format.Precision);
      end;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TfmMain.StartOperation(const Caption: string; Max: Integer);
begin
  if Max = 0 then
    Max := 1;

  ProgressBar.Min := 0;
  ProgressBar.Max := Max;
  ProgressBar.Position := 0;

  laParsing.Caption := Caption;
  laParsing.Visible := True;

  laParsingProgress.Caption := '0%';
  laParsingProgress.Visible := True;
end;

procedure TfmMain.UpdateGraphDataButton;
var
  Pages: Byte;
  i: Integer;
begin
  { TODO -cButtons : Graph button }
  // Calculate visible pages.
  Pages := 0;
  for i := 0 to PageControl.PageCount - 1 do begin
    if PageControl.Pages[i].TabVisible then
      Inc(Pages);
  end;

  btGraphData.Enabled := (Pages > 0) and
    (cbCombine.Checked or
    ((not cbCombine.Checked) and (PageControl.ActivePage <> tsTextGen)));
end;

procedure TfmMain.UpdateMixDataCheckBox;
var
  Cnt: Integer;
  i: Integer;
begin
  Cnt := 0;
  for i := 0 to PageControl.PageCount - 1 do begin
    if PageControl.Pages[i].TabVisible then
      Inc(Cnt);
  end;

  cbCombine.Enabled :=  Cnt > 1;
  if not cbCombine.Enabled then
    cbCombine.Checked := False;
end;

procedure TfmMain.UpdateSessionsTime;
var
  i: Integer;
  Item: TListItem;
  Session: TTelemetrySession;
begin
  if lvSessions.Items.Count > 0 then begin
    for i := 0 to lvSessions.Items.Count - 1 do begin
      Item := lvSessions.Items[i];
      Session := FSessions[i];

      SetSessionTime(Item, Session);
    end;
  end;
end;

procedure TfmMain.vtGPSFixGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  Field: TField;
begin
  Field := TField(Sender);
  if Field = nil then
    Exit;

  case Field.Value of
    STRU_TELE_GPS.GPS_FIX_VALID:
      Text := 'Fix';
    STRU_TELE_GPS.GPS_FIX_3D:
      Text := '3D fix';
    else
      Text := 'None';
  end;
end;

procedure TfmMain.vtGPSUTCTimeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := ConvertTime(Sender.AsLongWord);
end;

procedure TfmMain.vtPowerBoxAlarmsGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := NA
  else begin
    case Sender.AsInteger of
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_1:
        Text := 'VOLTAGE 1';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_VOLTAGE_2:
        Text := 'VOLTAGE 2';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_1:
        Text := 'CAPACITY 1';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_CAPACITY_2:
        Text := 'CAPACITY 2';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RPM:
        Text := 'RPM';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_TEMPERATURE:
        Text := 'TEMPERATURE';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_1:
        Text := 'RESERVED 1';
      STRU_TELE_POWERBOX.TELE_PBOX_ALARM_RESERVED_2:
        Text := 'RESERVED 2';
      else
        Text := '';
    end;
  end;
end;

procedure TfmMain.vtStandardFastbootedGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := NA
  else begin
    if Sender.AsInteger > 0 then
      Text := 'True'
    else
      Text := 'False';
  end;
end;

procedure TfmMain.vtTurbineOffConditionGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := NA
  else begin
    case Sender.AsInteger of
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Shut_down_via_RC:
        Text := 'JETCAT_ECU_OFF_Shut_down_via_RC';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Overtemperature:
        Text := 'JETCAT_ECU_OFF_Overtemperature';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Ignition_timeout:
        Text := 'JETCAT_ECU_OFF_Ignition_timeout';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Acceleration_time_out:
        Text := 'JETCAT_ECU_OFF_Acceleration_time_out';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Acceleration_too_slow:
        Text := 'JETCAT_ECU_OFF_Acceleration_too_slow';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Over_RPM:
        Text := 'JETCAT_ECU_OFF_Over_RPM';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Low_Rpm_Off:
        Text := 'JETCAT_ECU_OFF_Low_Rpm_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Low_Battery:
        Text := 'JETCAT_ECU_OFF_Low_Battery';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Auto_Off:
        Text := 'JETCAT_ECU_OFF_Auto_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Low_temperature_Off:
        Text := 'JETCAT_ECU_OFF_Low_temperature_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Hi_Temp_Off:
        Text := 'JETCAT_ECU_OFF_Hi_Temp_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Glow_Plug_defective:
        Text := 'JETCAT_ECU_OFF_Glow_Plug_defective';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Watch_Dog_Timer:
        Text := 'JETCAT_ECU_OFF_Watch_Dog_Timer';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Fail_Safe_Off:
        Text := 'JETCAT_ECU_OFF_Fail_Safe_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Manual_Off:
        Text := 'JETCAT_ECU_OFF_Manual_Off';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Power_fail:
        Text := 'JETCAT_ECU_OFF_Power_fail';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Temp_Sensor_fail:
        Text := 'JETCAT_ECU_OFF_Temp_Sensor_fail';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Fuel_fail:
        Text := 'JETCAT_ECU_OFF_Fuel_fail';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_Prop_fail:
        Text := 'JETCAT_ECU_OFF_Prop_fail';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_2nd_Engine_fail:
        Text := 'JETCAT_ECU_OFF_2nd_Engine_fail';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_2nd_Engine_Diff_Too_High:
        Text := 'JETCAT_ECU_OFF_2nd_Engine_Diff_Too_High';
      STRU_TELE_JETCAT.JETCAT_ECU_OFF_2nd_Engine_No_Comm:
        Text := 'JETCAT_ECU_OFF_2nd_Engine_No_Comm';
      STRU_TELE_JETCAT.JETCAT_ECU_MAX_OFF_COND:
        Text := 'JETCAT_ECU_MAX_OFF_COND';

      STRU_TELE_JETCAT.JETCENT_ECU_OFF_No_Off_Condition_defined:
        Text := 'JETCENT_ECU_OFF_No_Off_Condition_defined';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_IGNITION_ERROR:
        Text := 'JETCENT_ECU_OFF_IGNITION_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_PREHEAT_ERROR:
        Text := 'JETCENT_ECU_OFF_PREHEAT_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_SWITCHOVER_ERROR:
        Text := 'JETCENT_ECU_OFF_SWITCHOVER_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_STARTER_MOTOR_ERROR:
        Text := 'JETCENT_ECU_OFF_STARTER_MOTOR_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_TO_IDLE_ERROR:
        Text := 'JETCENT_ECU_OFF_TO_IDLE_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_ACCELERATION_ERROR:
        Text := 'JETCENT_ECU_OFF_ACCELERATION_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_IGNITER_BAD:
        Text := 'JETCENT_ECU_OFF_IGNITER_BAD';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_MIN_PUMP_OK:
        Text := 'JETCENT_ECU_OFF_MIN_PUMP_OK';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_MAX_PUMP_OK:
        Text := 'JETCENT_ECU_OFF_MAX_PUMP_OK';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_LOW_RX_BATTERY:
        Text := 'JETCENT_ECU_OFF_LOW_RX_BATTERY';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_LOW_ECU_BATTERY:
        Text := 'JETCENT_ECU_OFF_LOW_ECU_BATTERY';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_NO_RX:
        Text := 'JETCENT_ECU_OFF_NO_RX';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_TRIM_DOWN:
        Text := 'JETCENT_ECU_OFF_TRIM_DOWN';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_TRIM_UP:
        Text := 'JETCENT_ECU_OFF_TRIM_UP';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_FAILSAFE:
        Text := 'JETCENT_ECU_OFF_FAILSAFE';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_FULL:
        Text := 'JETCENT_ECU_OFF_FULL';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_RX_SETUP_ERROR:
        Text := 'JETCENT_ECU_OFF_RX_SETUP_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_TEMP_SENSOR_ERROR:
        Text := 'JETCENT_ECU_OFF_TEMP_SENSOR_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_COM_TURBINE_ERROR:
        Text := 'JETCENT_ECU_OFF_COM_TURBINE_ERROR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_MAX_TEMP:
        Text := 'JETCENT_ECU_OFF_MAX_TEMP';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_MAX_AMPS:
        Text := 'JETCENT_ECU_OFF_MAX_AMPS';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_LOW_RPM:
        Text := 'JETCENT_ECU_OFF_LOW_RPM';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_ERROR_RPM_SENSOR:
        Text := 'JETCENT_ECU_OFF_ERROR_RPM_SENSOR';
      STRU_TELE_JETCAT.JETCENT_ECU_OFF_MAX_PUMP:
        Text := 'JETCENT_ECU_OFF_MAX_PUMP';
      STRU_TELE_JETCAT.JETCENT_ECU_MAX_OFF_COND:
        Text := 'JETCENT_ECU_MAX_OFF_COND';
      else
        Text := '';
    end;
  end;
end;

procedure TfmMain.vtTurbineStatusGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := NA
  else begin
    case Sender.AsInteger of
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_OFF:
        Text := 'JETCAT_ECU_STATE_OFF';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_WAIT_for_RPM:
        Text := 'JETCAT_ECU_STATE_WAIT_for_RPM';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Ignite:
        Text := 'JETCAT_ECU_STATE_Ignite';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Accelerate:
        Text := 'JETCAT_ECU_STATE_Accelerate';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Stabilise:
        Text := 'JETCAT_ECU_STATE_Stabilise';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Learn_HI:
        Text := 'JETCAT_ECU_STATE_Learn_HI';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Learn_LO:
        Text := 'JETCAT_ECU_STATE_Learn_LO';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Slow_Down:
        Text := 'JETCAT_ECU_STATE_Slow_Down';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Manual:
        Text := 'JETCAT_ECU_STATE_Manual';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_AutoOff:
        Text := 'JETCAT_ECU_STATE_AutoOff';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Run:
        Text := 'JETCAT_ECU_STATE_Run';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Accleleration_delay:
        Text := 'JETCAT_ECU_STATE_Accleleration_delay';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_SpeedReg:
        Text := 'JETCAT_ECU_STATE_SpeedReg';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_Two_Shaft_Regulate:
        Text := 'JETCAT_ECU_STATE_Two_Shaft_Regulate';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_PreHeat1:
        Text := 'JETCAT_ECU_STATE_PreHeat1';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_PreHeat2:
        Text := 'JETCAT_ECU_STATE_PreHeat2';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_MainFStart:
        Text := 'JETCAT_ECU_STATE_MainFStart';
      STRU_TELE_JETCAT.JETCAT_ECU_STATE_KeroFullOn:
        Text := 'JETCAT_ECU_STATE_KeroFullOn';

      STRU_TELE_JETCAT.EVOJET_ECU_STATE_off:
        Text := 'EVOJET_ECU_STATE_off';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_ignt:
        Text := 'EVOJET_ECU_STATE_ignt';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_acce:
        Text := 'EVOJET_ECU_STATE_acce';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_run:
        Text := 'EVOJET_ECU_STATE_run';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_cal:
        Text := 'EVOJET_ECU_STATE_cal';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_cool:
        Text := 'EVOJET_ECU_STATE_cool';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_fire:
        Text := 'EVOJET_ECU_STATE_fire';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_glow:
        Text := 'EVOJET_ECU_STATE_glow';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_heat:
        Text := 'EVOJET_ECU_STATE_heat';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_idle:
        Text := 'EVOJET_ECU_STATE_idle';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_lock:
        Text := 'EVOJET_ECU_STATE_lock';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_rel:
        Text := 'EVOJET_ECU_STATE_rel';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_spin:
        Text := 'EVOJET_ECU_STATE_spin';
      STRU_TELE_JETCAT.EVOJET_ECU_STATE_stop:
        Text := 'EVOJET_ECU_STATE_stop';

      STRU_TELE_JETCAT.HORNET_ECU_STATE_OFF:
        Text := 'HORNET_ECU_STATE_OFF';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_SLOWDOWN:
        Text := 'HORNET_ECU_STATE_SLOWDOWN';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_COOL_DOWN:
        text := 'HORNET_ECU_STATE_COOL_DOWN';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_AUTO:
        Text := 'HORNET_ECU_STATE_AUTO';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_AUTO_HC:
        Text := 'HORNET_ECU_STATE_AUTO_HC';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_BURNER_ON:
        Text := 'HORNET_ECU_STATE_BURNER_ON';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_CAL_IDLE:
        Text := 'HORNET_ECU_STATE_CAL_IDLE';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_CALIBRATE:
        Text := 'HORNET_ECU_STATE_CALIBRATE';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_DEV_DELAY:
        Text := 'HORNET_ECU_STATE_DEV_DELAY';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_EMERGENCY:
        Text := 'HORNET_ECU_STATE_EMERGENCY';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_FUEL_HEAT:
        Text := 'HORNET_ECU_STATE_FUEL_HEAT';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_FUEL_IGNITE:
        Text := 'HORNET_ECU_STATE_FUEL_IGNITE';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_GO_IDLE:
        Text := 'HORNET_ECU_STATE_GO_IDLE';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_PROP_IGNITE:
        Text := 'HORNET_ECU_STATE_PROP_IGNITE';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_RAMP_DELAY:
        Text := 'HORNET_ECU_STATE_RAMP_DELAY';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_RAMP_UP:
        Text := 'HORNET_ECU_STATE_RAMP_UP';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_STANDBY:
        Text := 'HORNET_ECU_STATE_STANDBY';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_STEADY:
        Text := 'HORNET_ECU_STATE_STEADY';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_WAIT_ACC:
        Text := 'HORNET_ECU_STATE_WAIT_ACC';
      STRU_TELE_JETCAT.HORNET_ECU_STATE_ERROR:
        Text := 'HORNET_ECU_STATE_ERROR';

      STRU_TELE_JETCAT.XICOY_ECU_STATE_Temp_High:
        Text := 'XICOY_ECU_STATE_Temp_High';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Trim_Low:
        Text := 'XICOY_ECU_STATE_Trim_Low';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Set_Idle:
        Text := 'XICOY_ECU_STATE_Set_Idle';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Ready:
        Text := 'XICOY_ECU_STATE_Ready';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Ignition:
        Text := 'XICOY_ECU_STATE_Ignition';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Fuel_Ramp:
        Text := 'XICOY_ECU_STATE_Fuel_Ramp';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Glow_Test:
        Text := 'XICOY_ECU_STATE_Glow_Test';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Running:
        Text := 'XICOY_ECU_STATE_Running';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Stop:
        Text := 'XICOY_ECU_STATE_Stop';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Flameout:
        Text := 'XICOY_ECU_STATE_Flameout';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Speed_Low:
        Text := 'XICOY_ECU_STATE_Speed_Low';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Cooling:
        Text := 'XICOY_ECU_STATE_Cooling';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Igniter_Bad:
        Text := 'XICOY_ECU_STATE_Igniter_Bad';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Starter_F:
        Text := 'XICOY_ECU_STATE_Starter_F';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Weak_Fuel:
        Text := 'XICOY_ECU_STATE_Weak_Fuel';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Start_On:
        Text := 'XICOY_ECU_STATE_Start_On';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Pre_Heat:
        Text := 'XICOY_ECU_STATE_Pre_Heat';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Battery:
        Text := 'XICOY_ECU_STATE_Battery';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Time_Out:
        Text := 'XICOY_ECU_STATE_Time_Out';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Overload:
        Text := 'XICOY_ECU_STATE_Overload';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Igniter_Fail:
        Text := 'XICOY_ECU_STATE_Igniter_Fail';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Burner_On:
        Text := 'XICOY_ECU_STATE_Burner_On';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Starting:
        Text := 'XICOY_ECU_STATE_Starting';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_SwitchOver:
        Text := 'XICOY_ECU_STATE_SwitchOver';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Cal_Pump:
        Text := 'XICOY_ECU_STATE_Cal_Pump';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Pump_Limit:
        Text := 'XICOY_ECU_STATE_Pump_Limit';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_No_Engine:
        Text := 'XICOY_ECU_STATE_No_Engine';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Pwr_Boost:
        Text := 'XICOY_ECU_STATE_Pwr_Boost';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Run_Idle:
        Text := 'XICOY_ECU_STATE_Run_Idle';
      STRU_TELE_JETCAT.XICOY_ECU_STATE_Run_Max:
        Text := 'XICOY_ECU_STATE_Run_Max';

      STRU_TELE_JETCAT.JETCENT_ECU_STATE_STOP:
        Text := 'JETCENT_ECU_STATE_STOP';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_GLOW_TEST:
        Text := 'JETCENT_ECU_STATE_GLOW_TEST';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_STARTER_TEST:
        Text := 'JETCENT_ECU_STATE_STARTER_TEST';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_PRIME_FUEL:
        Text := 'JETCENT_ECU_STATE_PRIME_FUEL';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_PRIME_BURNER:
        Text := 'JETCENT_ECU_STATE_PRIME_BURNER';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_MAN_COOL:
        Text := 'JETCENT_ECU_STATE_MAN_COOL';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_AUTO_COOL:
        Text := 'JETCENT_ECU_STATE_AUTO_COOL';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_IGN_HEAT:
        Text := 'JETCENT_ECU_STATE_IGN_HEAT';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_IGNITION:
        Text := 'JETCENT_ECU_STATE_IGNITION';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_PREHEAT:
        Text := 'JETCENT_ECU_STATE_PREHEAT';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_SWITCHOVER:
        Text := 'JETCENT_ECU_STATE_SWITCHOVER';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_TO_IDLE:
        Text := 'JETCENT_ECU_STATE_TO_IDLE';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_RUNNING:
        Text := 'JETCENT_ECU_STATE_RUNNING';
      STRU_TELE_JETCAT.JETCENT_ECU_STATE_STOP_ERROR:
        Text := 'JETCENT_ECU_STATE_STOP_ERROR';

      else
        Text := '';
    end;
  end;
end;

procedure TfmMain.EndOperation;
begin
  laParsing.Visible := False;
  laParsing.Caption := 'Parsing session data...';

  laParsingProgress.Visible := False;
  laParsingProgress.Caption := '0%';

  ProgressBar.Position := 0;
end;

procedure TfmMain.ExecuteExport(const Table: TVirtualTable; const Append: Boolean);
begin
  StartOperation('Preparing data...', Table.RecordCount - 1);
  try
    PrepareTempTable(Table);
    try
      CopyDataToTempTable(Table);
      if LowerCase(ExtractFileExt(SaveDialog.FileName)) = '.csv' then
        SaveToCSVFile(vtTemp, Append)
      else
        SaveToKMLFile(vtTemp);

    finally
      ReleaseTempTable;
    end;

  finally
    EndOperation;
  end;
end;

procedure TfmMain.ExportTlmWriteHeader(const F: TByteFile;
  const Session: TTelemetrySession);
var
  C: Cardinal;
  Data: array [0..35] of Byte;
begin
  // Write header.
  C := $FFFFFFFF;
  BlockWrite(F, C, 4);
  BlockWrite(F, Session.Hdr,
    SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER));

  // Poles and ratio
  ZeroMemory(@Data[0], SizeOf(Data));
  Data[0] := $FF;
  Data[1] := $FF;
  Data[2] := $FF;
  Data[3] := $FF;
  Data[4] := TELE_DEVICE_RPM_TM1000;
  Data[5] := TELE_DEVICE_RPM_TM1000;
  Data[6] := Session.Poles;
  Data[10] := Session.RatioRaw and $00FF;
  Data[11] := Session.RatioRaw shr 8;
  BlockWrite(F, Data, SizeOf(Data));

  ZeroMemory(@Data[0], SizeOf(Data));
  Data[0] := $FF;
  Data[1] := $FF;
  Data[2] := $FF;
  Data[3] := $FF;
  Data[4] := TELE_DEVICE_ESC;
  Data[5] := TELE_DEVICE_ESC;
  Data[6] := Session.PolesESC;
  Data[24] := Session.RatioESCRaw and $00FF;
  Data[25] := Session.RatioESCRaw shr 8;
  BlockWrite(F, Data, SizeOf(Data));

  // Dummy sensor header.
  ZeroMemory(@Data[0], SizeOf(Data));
  Data[0] := $FF;
  Data[1] := $FF;
  Data[2] := $FF;
  Data[3] := $FF;
  Data[4] := TELE_DEVICE_GPS_STATS;
  Data[5] := TELE_DEVICE_GPS_STATS;
  BlockWrite(F, Data, SizeOf(Data));

  // Session start time
  ZeroMemory(@Data[0], SizeOf(Data));
  C := Session.Time.Min;
  BlockWrite(F, C, 4);
  BlockWrite(F, Data, 16);
end;

procedure TfmMain.ExportTlmWriteSensor(const F: TByteFile;
  const Sensor: TSensorData);
var
  B: Byte;
begin
  BlockWrite(F, Sensor.TimestampRaw, 4);
  BlockWrite(F, Sensor.SensorID, 1);

  if Sensor.SensorID = TELE_DEVICE_TXINPUTS then
    B := STRU_TELE_TXINPUT(Sensor).CaptureId
  else
    B := 0;
  BlockWrite(F, B, 1);
  BlockWrite(F, Sensor.Data, 14);

  if Sensor.SensorID = TELE_DEVICE_GPS_STATS then begin
    BlockWrite(F, Sensor.TimestampRaw, 4);
    B := TELE_DEVICE_GPS_LOC;
    BlockWrite(F, B, 1);
    B := 0;
    BlockWrite(F, B, 1);
    BlockWrite(F, STRU_TELE_GPS(Sensor).PosData, 14);
  end;
end;

procedure TfmMain.ExportTlmWriteFooter(const F: TByteFile;
  const Session: TTelemetrySession);
var
  C: Cardinal;
  Data: array [0..35] of Byte;
begin
  // Session end time
  ZeroMemory(@Data[0], SizeOf(Data));
  C := Session.Time.Max;
  BlockWrite(F, C, 4);
  BlockWrite(F, Data, 16);
end;

procedure TfmMain.ExportTlmAllSessions;
var
  F: TByteFile;
  Session: TTelemetrySession;
  Sensor: TSensorData;
  I: Integer;
  X: Integer;
begin
  AssignFile(F, SaveDialog.FileName);
  StartOperation('Export to TLM...', FSessions.Count - 1);
  try
    FileMode := fmOpenWrite;
    Rewrite(F);

    for X := 0 to FSessions.Count - 1 do begin
      ShowProgress(X);

      Session := TTelemetrySession(FSessions[X]);
      ExportTlmWriteHeader(F, Session);
      // Write sensors.
      for I := 0 to Session.Data.Count - 1 do begin
        Sensor := TSensorData(Session.Data[I]);
        ExportTlmWriteSensor(F, Sensor);
      end;
      ExportTlmWriteFooter(F, Session);
    end;

  finally
    EndOperation;

    CloseFile(F);
  end;
end;

procedure TfmMain.ExportTlmSingleSession(Item: TListItem);
var
  Session: TTelemetrySession;
  F: TByteFile;
  Sensor: TSensorData;
  I: Integer;
  Table: TVirtualTable;
begin
  Session := TTelemetrySession(FSessions[Item.Index]);
  AssignFile(F, SaveDialog.FileName);
  try
    StartOperation('Export to TLM...', Session.Data.Count - 1);

    try
      FileMode := fmOpenWrite;
      Rewrite(F);

      ExportTlmWriteHeader(F, Session);

      // Write sensors.
      for I := 0 to Session.Data.Count - 1 do begin
        ShowProgress(I);

        Sensor := TSensorData(Session.Data[I]);

        if (Item <> nil) and (Sensor.SensorID <> TELE_DEVICE_ALT_ZERO) then begin
          case Sensor.SensorID of
            TELE_DEVICE_RPM_TM1100:
              Table := GetSensorTable(TELE_DEVICE_RPM_TM1000);
            TELE_DEVICE_QOS_TM1100:
              Table := GetSensorTable(TELE_DEVICE_QOS_TM1000);
            TELE_DEVICE_JETCAT_2:
              Table := GetSensorTable(TELE_DEVICE_JETCAT);
            TELE_DEVICE_SMARTBATT:
              if STRU_SMARTBATT(Sensor).BattNum > 0 then
                Table := vtSmartBatt2
              else
                Table := vtSmartBatt1;
            else
              Table := GetSensorTable(Sensor.SensorID);
          end;

          if Table <> nil then begin
            if not Table.Locate('Timestamp', Sensor.Timestamp, []) then
              Continue;
          end;
        end;

        ExportTlmWriteSensor(F, Sensor);
      end;

      // Session end time
      ExportTlmWriteFooter(F, Session);

    finally
      EndOperation;
    end;

  finally
    CloseFile(F);
  end;
end;

procedure TfmMain.ExportMixedData;
var
  CombineForm: TfmGraphSelect;
  Tables: TList;
  RecCnt: Integer;
  t: Integer; // Table index
  f: Integer; // Table field index
  Table: TVirtualTable;
  Field: TField;
  Strings: TStringList;
  LatestLine: string;
  PrevValues: array of string;
  Value: string;
begin
  CombineForm := TfmGraphSelect.Create(Self);
  try
    MixShowSensors(CombineForm.lvSensors);
    MixRestoreSensorsSettings(CombineForm.lvSensors, True);
    if CombineForm.ShowModal = mrOK then begin
      MixSaveSensorsSettings(CombineForm.lvSensors, True);

      try
        Tables := TList.Create;
        try
          MixBuildTablesList(Tables, CombineForm.lvSensors, RecCnt);
          if Tables.Count = 0 then
            MessageDlg('No data was selected.', mtWarning, [mbOK], 0)

          else begin
            // Build field names array.
            StartOperation('Preparing data...', RecCnt);
            try
              // Prepare graph table
              vtTemp.FieldDefs.Clear;
              // Add timestamp field
              vtTemp.FieldDefs.Add('Timestamp', ftLongWord);
              // Add fileds.
              for t := 0 to Tables.Count - 1 do begin
                Table := TVirtualTable(Tables[t]);
                // Ignore first field which is always timestamp
                for f := 1 to Table.Fields.Count - 1 do begin
                  if Table.Fields[f].Tag = 1 then begin
                    // Add field to temporary table.
                    vtTemp.FieldDefs.Add(Table.Name + '_' + Table.Fields[f].Name,
                      Table.Fields[f].DataType);
                  end;
                end;
              end;

              try
                // Ok, now we can fill the temporary table with data.
                vtTemp.Open;
                // Set timestamp display
                vtTemp.Fields[0].OnGetText := GetTimeStampText;
                // But first we must update field defs.
                for t := 0 to Tables.Count - 1 do begin
                  Table := TVirtualTable(Tables[t]);
                  // Ignore first field which is always timestamp
                  for f := 1 to Table.Fields.Count - 1 do begin
                    if Table.Fields[f].Tag = 1 then begin
                      Field := vtTemp.FieldByName(Table.Name + '_' + Table.Fields[f].Name);
                      Field.DisplayLabel := Table.Fields[f].DisplayLabel + MixGetSensorName(Table);
                      if Field is TNumericField then
                        TNumericField(Field).DisplayFormat := TNumericField(Table.Fields[f]).DisplayFormat;
                      if Assigned(Table.Fields[f].OnGetText) then
                        Field.OnGetText := Table.Fields[f].OnGetText;
                    end;
                  end;
                end;

                for t := 0 to Tables.Count - 1 do begin
                  Table := TVirtualTable(Tables[t]);
                  Table.DisableControls;

                  try
                    Table.First;
                    // Ignore first field which is always timestamp
                    while not Table.Eof do begin
                      vtTemp.Append;
                      // Add timestamp first.
                      vtTemp.FieldByName('Timestamp').Value := Table.Fields[0].Value;

                      try
                        // Now go through all other fields and add them
                        for f := 1 to Table.Fields.Count - 1 do begin
                          if Table.Fields[f].Tag = 1 then
                            vtTemp.FieldByName(Table.Name + '_' + Table.Fields[f].Name).Value := Table.Fields[f].Value;
                        end;

                      finally
                        vtTemp.Post;
                      end;

                      Table.Next;
                    end;

                  finally
                    Table.EnableControls;
                  end;
                end;

                // Now save temporary table to CSV file.
                vtTemp.IndexFieldNames := 'Timestamp ASC';
                vtTemp.First;

                LatestLine := '';
                Strings := TStringList.Create;
                try
                  for f := 0 to vtTemp.Fields.Count - 1 do
                    AddTextToLine(vtTemp.Fields[f].DisplayLabel, LatestLine);
                  MoveCompletedLineToList(Strings, LatestLine);

                  SetLength(PrevValues, vtTemp.FieldCount - 1);
                  for t := 0 to Length(PrevValues) - 1 do
                    PrevValues[t] := '0';

                  try
                    for t := 0 to vtTemp.RecordCount - 1 do begin
                      ShowProgress(t);

                      for f := 0 to vtTemp.FieldCount - 1 do begin
                        if f = 0 then
                          // Timestamp.
                          AddTextToLine(vtTemp.Fields[f].DisplayText, LatestLine)
                        else begin
                          if vtTemp.Fields[f].IsNull then
                            Value := PrevValues[f - 1]
                          else begin
                            if vtTemp.Fields[f].AsSingle <> INVALID_DATA_UINT32 then
                              Value := vtTemp.Fields[f].DisplayText
                            else
                              Value := '';
                            PrevValues[f - 1] := Value;
                          end;

                          AddTextToLine(Value, LatestLine)
                        end;
                      end;

                      MoveCompletedLineToList(Strings, LatestLine);

                      vtTemp.Next;
                    end;

                    Strings.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);

                    MessageDlg('Export completed', mtInformation, [mbOK], 0);

                  finally
                    SetLength(PrevValues, 0);
                    PrevValues := nil;
                  end;

                finally
                  Strings.Free;
                end;

              finally
                ReleaseTempTable
              end;

            finally
              EndOperation;
            end;
          end;

        finally
          Tables.Free;
        end;

      finally
        ReleaseTempTable;
      end;
    end;

  finally
    CombineForm.Free;
  end;
end;

procedure TfmMain.ExportTlm(Session: TListItem);
begin
  if cbExportAll.Checked then begin
    ExportTlmAllSessions;
    FSessionChanged := False;

  end else begin
    if Session = nil then
      Session := lvSessions.Selected;
    if Session = nil then
      MessageDlg('Select session', mtWarning, [mbOK], 0)
    else begin
      ExportTlmSingleSession(Session);
      FSessionChanged := False;
    end;
  end;
end;

procedure TfmMain.ShowGpsTrackInfo;
var
  MinSpeed: Single;
  MaxSpeed: Single;
  AvgSpeed: Single;
  MinAlt: Single;
  MaxAlt: Single;
  AvgAlt: Single;
  MinDist: Single;
  MaxDist: Single;
  AvgDist: Single;
  Len: Single;
  fmGpsTrackInfo: TfmGpsTrackInfo;
  SpeedU: string;
  DistU: string;
  CurLat: Single;
  CurLong: Single;
  Found: Boolean;
  DeltaLat: Single;
  DeltaLon: Single;
  CurLatRad: Single;
  LatRad: Single;
  Alpha: Single;
  Dist: Single;
  c: Single;
  Index: string;
  StartTime: Cardinal;
  CurTime: Cardinal;
  Time: Cardinal;
begin
  Found := False;
  MinSpeed := 0;
  MaxSpeed := 0;
  MinAlt := 0;
  MaxAlt := 0;
  MinDist := 0;
  MaxDist := 0;
  Len := 0;
  CurTime := 0;

  Index := vtGPS.IndexFieldNames;
  vtGPS.IndexFieldNames := 'Timestamp ASC';
  vtGPS.First;
  StartTime := vtGPSTimestamp.Value;
  while not vtGPS.EOF do begin
    CurTime := vtGPSTimestamp.Value;
    // Look for GPS fix.
    if vtGPSSats.Value > 3 then begin
      MinSpeed := vtGPSSpeed.Value;
      MaxSpeed := vtGPSSpeed.Value;
      MinAlt := vtGPSAlt.Value;
      MaxAlt := vtGPSAlt.Value;
      MinDist := vtGPSDistance.Value;
      MaxDist := vtGPSDistance.Value;
      CurLat := vtGPSLatitude.Value;
      CurLong := vtGPSLongitude.Value;
      Len := 0;
      Found := True;
      vtGPS.Next;

      while not vtGPS.EOF do begin
        CurTime := vtGPSTimestamp.Value;

        if vtGPSSats.Value > 3 then begin
          if vtGPSSpeed.Value < MinSpeed then
            MinSpeed := vtGPSSpeed.Value
          else begin
            if vtGPSSpeed.Value > MaxSpeed then
              MaxSpeed := vtGPSSpeed.Value;
          end;
          if vtGPSAlt.Value < MinAlt then
            MinAlt := vtGPSAlt.Value
          else begin
            if vtGPSAlt.Value > MaxAlt then
              MaxAlt := vtGPSAlt.Value;
          end;
          if vtGPSDistance.Value < MinDist then
            MinDist := vtGPSDistance.Value
          else begin
            if vtGPSDistance.Value > MaxDist then
              MaxDist := vtGPSDistance.Value;
          end;

          if (vtGPSLatitude.Value <> 0) and (vtGPSLongitude.Value <> 0) and
             (vtGPSHeading.Value <> 0 ) then
          begin
            DeltaLat := ToRad(vtGPSLatitude.Value - CurLat);
            DeltaLon := ToRad(vtGPSLongitude.Value - CurLong);
            CurLatRad := ToRad(CurLat);
            LatRad := ToRad(vtGPSLatitude.Value);
            Alpha := sin(DeltaLat / 2) * sin(DeltaLat / 2) + sin(DeltaLon / 2) *
              sin(DeltaLon / 2) * cos(CurLatRad) * cos(LatRad);
            c := 2 * arctan2(sqrt(Alpha), sqrt(1 - Alpha));
            Dist:= RADIUS * c;
            Len := Len + Dist;

            CurLat := vtGPSLatitude.Value;
            CurLong := vtGPSLongitude.Value;
          end;
        end;

        vtGPS.Next;
      end;
    end else
      vtGPS.Next;
  end;
  vtGPS.IndexFieldNames := Index;

  if not Found then
    MessageDlg('No sattelite fix in this session', mtWarning, [mbOK], 0)

  else begin
    AvgSpeed := (MinSpeed + MaxSpeed) / 2;
    AvgAlt := (MinAlt + MaxAlt) / 2;
    AvgDist := (MinDist + MaxDist) / 2;
    Time := CurTime - StartTime;

    if FLengthUnits = luMetric then begin
      SpeedU := ' km/h';
      DistU := ' m';

    end else begin
      SpeedU := ' mph';
      DistU := ' ft';
      Len := Len * 3.28084;
    end;

    fmGpsTrackInfo := TfmGpsTrackInfo.Create(Self);
    fmGpsTrackInfo.laMinSpeed.Caption := Format('%.2f' + SpeedU, [MinSpeed]);
    fmGpsTrackInfo.laMaxSpeed.Caption := Format('%.2f' + SpeedU, [MaxSpeed]);
    fmGpsTrackInfo.laAvgSpeed.Caption := Format('%.2f' + SpeedU, [AvgSpeed]);
    fmGpsTrackInfo.laMinAlt.Caption := Format('%.2f' + DistU, [MinAlt]);
    fmGpsTrackInfo.laAvgAlt.Caption := Format('%.2f' + DistU, [AvgAlt]);
    fmGpsTrackInfo.laMaxAlt.Caption := Format('%.2f' + DistU, [MaxAlt]);
    fmGpsTrackInfo.laMinDist.Caption := Format('%.2f' + DistU, [MinDist]);
    fmGpsTrackInfo.laAvgDist.Caption := Format('%.2f' + DistU, [AvgDist]);
    fmGpsTrackInfo.laMaxDist.Caption := Format('%.2f' + DistU, [MaxDist]);
    fmGpsTrackInfo.laTrackTime.Caption := ConvertTime(Time);
    fmGpsTrackInfo.laLength.Caption := Format('%.2f' + DistU, [Len]);
    fmGpsTrackInfo.ShowModal;
    fmGpsTrackInfo.Free;
  end;
end;

procedure TfmMain.ShowProgress(const Pos: Integer);
begin
  ProgressBar.Position := Pos;
  laParsingProgress.Caption := IntToStr(Round(Pos * 100 / ProgressBar.Max)) + ' %';
  Self.Update;
end;

procedure TfmMain.ShowSensorsData(const Session: TTelemetrySession;
  out RssiA: Boolean; out RssiB: Boolean; out RssiLemon: Boolean);
var
  I: Integer;
  Sensor: TSensorData;
  Timestamps: array [0..$FF] of Cardinal;
  JetCat: STRU_TELE_JETCAT;
  JetCat2: STRU_TELE_JETCAT2;
  Id: Byte;
begin
  SetImage(Session.ModelType + IMG_ID_MODEL_START);

  StartOperation('Parsing session data...', Session.Data.Count - 1);
  SetUpdate(True);
  try
    PrepareSensors;

    RssiA := False;
    RssiB := False;
    RssiLemon := False;

    // Reset timestamps
    for I := 0 to $FF do
      Timestamps[I] := 0;
    // ========

    FAltOffset := 0;
    FAltOffsetUseSensor := False;
    FGpsOffset := 0;
    FGpsOffsetUseSensor := False;
    FVarioOffset := 0;
    FVarioOffsetUseSensor := False;
    ClearOffsets;

    JetCat := nil;
    JetCat2 := nil;
    for I := 0 to Session.Data.Count - 1 do begin
      ShowProgress(I);

      Sensor := TSensorData(Session.Data[I]);

      // Remove duplicate records.
      Id := Sensor.SensorID;
      if Id = TELE_DEVICE_JETCAT_2 then
        Id := TELE_DEVICE_JETCAT
      else begin
        if Id = TELE_DEVICE_RPM_TM1100 then
          Id := TELE_DEVICE_RPM_TM1000
        else begin
          if Id = TELE_DEVICE_QOS_TM1100 then
            Id := TELE_DEVICE_QOS_TM1000;
        end;
      end;
      if (I > 0) and (Timestamps[Id] = Sensor.Timestamp) then
        Continue;
      Timestamps[Id] := Sensor.Timestamp;
      // ==========================

      case Sensor.SensorID of
        { TODO -cNew Sensor : Show sensor here }
        TELE_DEVICE_USER_16SU:
          Add16s16u(STRU_TELE_USER_16SU(Sensor));

        TELE_DEVICE_USER_16SU32U:
          Add16s16u32u(STRU_TELE_USER_16SU32U(Sensor));

        TELE_DEVICE_USER_16SU32S:
          Add16s16u32s(STRU_TELE_USER_16SU32S(Sensor));

        TELE_DEVICE_USER_16U32SU:
          Add16u32s32u(STRU_TELE_USER_16U32SU(Sensor));

        TELE_DEVICE_PBOX:
          AddPowerBox(STRU_TELE_POWERBOX(Sensor));

        TELE_DEVICE_VOLTAGE:
          AddVoltage(STRU_TELE_HV(Sensor));

        TELE_DEVICE_RX_MAH:
          AddRxPack(STRU_TELE_RX_MAH(Sensor));

        TELE_DEVICE_AMPS:
          AddCurrent(STRU_TELE_IHIGH(Sensor));

        TELE_DEVICE_VARIO_S:
          AddVario(STRU_TELE_VARIO_S(Sensor));

        TELE_DEVICE_ALTITUDE:
          AddAlt(STRU_TELE_ALT(Sensor));

        TELE_DEVICE_AIRSPEED:
          AddAirSpeed(STRU_TELE_SPEED(Sensor));

        TELE_DEVICE_LAPTIMER:
          AddLapTimer(STRU_TELE_LAPTIMER(Sensor));

        TELE_DEVICE_TEXTGEN:
          AddTextGen(STRU_TELE_TEXTGEN(Sensor));

        TELE_DEVICE_ESC:
          AddEsc(STRU_TELE_ESC(Sensor));

        TELE_DEVICE_FUEL:
          AddFuel(STRU_TELE_FUEL(Sensor));

        TELE_DEVICE_FP_MAH:
          AddFlightPack(STRU_TELE_FP_MAH(Sensor));

        TELE_DEVICE_DIGITAL_AIR:
          AddTankPressure(STRU_TELE_DIGITAL_AIR(Sensor));

        TELE_DEVICE_LIPOMON:
          AddLipomon(STRU_TELE_LIPOMON(Sensor));

        TELE_DEVICE_LIPOMON_14:
          AddLipomon14(STRU_TELE_LIPOMON_14(Sensor));

        TELE_DEVICE_GMETER:
          AddAccel(STRU_TELE_G_METER(Sensor));

        TELE_DEVICE_JETCAT:
          begin
            JetCat := STRU_TELE_JETCAT(Sensor);
            if JetCat2 <> nil then
              AddJetCat(JetCat, JetCat2, JetCat.Timestamp);
          end;

        TELE_DEVICE_JETCAT_2:
          begin
            JetCat2 := STRU_TELE_JETCAT2(Sensor);
            if JetCat <> nil then
              AddJetCat(JetCat, JetCat2, JetCat2.Timestamp);
          end;

        TELE_DEVICE_GPS_STATS:
          AddGps(STRU_TELE_GPS(Sensor));

        TELE_DEVICE_GYRO:
          AddGyro(STRU_TELE_GYRO(Sensor));

        TELE_DEVICE_ATTMAG:
          AddCompass(STRU_TELE_ATTMAG(Sensor));

        TELE_DEVICE_ALT_ZERO:
          SetOffsets(STRU_TELE_ALT_ZERO(Sensor));

        TELE_DEVICE_MULTICYLINDER:
          AddMultiCylinder(STRU_TELE_MULTI_TEMP(Sensor));

        TELE_DEVICE_XRF_LINKSTATUS:
          AddCrossfire(STRU_TELE_XF_QOS(Sensor));

        TELE_DEVICE_RPM_TM1000,
        TELE_DEVICE_RPM_TM1100:
          begin
            AddRpm(STRU_TELE_RPM(Sensor));
            if STRU_TELE_RPM(Sensor).A.Valid and (STRU_TELE_RPM(Sensor).A.Value > 0) then
              RssiA := True;
            if STRU_TELE_RPM(Sensor).B.Valid and (STRU_TELE_RPM(Sensor).B.Value > 0) then
              RssiB := True;
          end;

        TELE_DEVICE_QOS_TM1000,
        TELE_DEVICE_QOS_TM1100:
          begin
            AddRx(STRU_TELE_QOS(Sensor));
            if STRU_TELE_QOS(Sensor).IsLemon.Valid and STRU_TELE_QOS(Sensor).IsLemon.Value then
              RssiLemon := True;
          end;

        TELE_DEVICE_TXINPUTS:
          AddTxInput(STRU_TELE_TXINPUT(Sensor));

        TELE_DEVICE_SMARTBATT:
          AddSmartBatt(STRU_SMARTBATT(Sensor));
      end;
    end;

    if FPostProcessing = ppSmooth then
      PrepareSensors;

  finally
    EndOperation;
    SetUpdate(False);
  end;
end;

procedure TfmMain.ShowSessions;
var
  I: Integer;
  Session: TTelemetrySession;
  GroupHeader: string;
  Group: TListGroup;
begin
  EnableButtons(False);

  if FSessions.Count = 0 then begin
    MessageDlg('No sessions were found.', mtInformation, [mbOK], 0);
    Exit;
  end;

  lvSessions.Items.BeginUpdate;
  try
    lvSessions.Groups.BeginUpdate;
    try
      for I := 0 to FSessions.Count - 1 do begin
        Session := TTelemetrySession(FSessions[I]);
        GroupHeader := Session.ModelName + ' [' + Session.ModelTypeName + ']';
        Group := FindGroup(GroupHeader);
        AddGroupItem(Session, Group.GroupID, IntToStr(I + 1));
      end;

      if lvSessions.Groups.Count > 0 then
        lvSessions.Groups[0].State := lvSessions.Groups[0].State - [lgsCollapsed];

    finally
      lvSessions.Groups.EndUpdate;
    end;

  finally
    lvSessions.Items.EndUpdate;
  end;
end;

procedure TfmMain.ShowTabs;
var
  I: Integer;
  ListView: TListView;
  Page: TTabSheet;
  p: Integer;
begin
  LockWindowUpdate(PageControl.Handle);
  try
    for I := 0 to PageControl.PageCount - 1 do begin
      ListView := GetListView(I);
      if ListView <> nil then begin
        if ListView.Items.Count > 0 then begin
          RebuildListView(ListView);
          ListView.Tag := 0;
          SetListViewMark(ListView, 0, smDown);
          Page := PageControl.Pages[I];
          Page.TabVisible := True;

          p := Pos(' *', Page.Caption);
          if p > 0 then
            Page.Caption := Copy(Page.Caption, 1, p - 1);

          if (FPostProcessing = ppNone) and (FTimeGap.Enabled) and IsTabAdded(Page) then
            Page.Caption := Page.Caption + ' *';
        end;
      end;
    end;

    for I := 0 to PageControl.PageCount - 1 do begin
      if PageControl.Pages[I].TabVisible then begin
        EnableButtons(True);
        Break;
      end;
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfmMain.WMDropFiles(var Msg: TWMDropFiles);
const
  MAXFILENAME = 255;

var
  FileCount: Integer;
  FileName: array [0..MAXFILENAME] of Char;
begin
  FileCount := DragQueryFile(Msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
  try
    if FileCount = 0 then
      Exit;

    if FileCount > 1 then begin
      MessageDlg('Too many files.', mtWarning, [mbOK], 0);
      Exit;
    end;

    DragQueryFile(Msg.Drop, 0, FileName, MAXFILENAME);
    OpenTLMFile(string(FileName));

  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TfmMain.FieldGetText(Sender: TField; var Text: string; DisplayText: Boolean);
var
  Field: TField;
begin
  Field := TField(Sender);
  if Field = nil then
    Exit;

  if Field is TIntegerField then begin
    if Field.AsInteger = INVALID_DATA_INT32 then begin
      Text := NA;
      Exit;
    end;
  end;
  if Field is TSmallintField then begin
    if Field.AsInteger = INVALID_DATA_INT16 then begin
      Text := NA;
      Exit;
    end;
  end;
  if Field is TShortintField then begin
    if Field.AsInteger = INVALID_DATA_INT8 then begin
      Text := NA;
      Exit;
    end;
  end;

  if Field is TLongWordField then begin
    if Field.AsLongWord = INVALID_DATA_UINT32 then begin
      Text := NA;
      Exit;
    end;
  end;
  if Field is TWordField then begin
    if Field.AsLongWord = INVALID_DATA_UINT16 then begin
      Text := NA;
      Exit;
    end;
  end;
  if Field is TByteField then begin
    if Field.AsLongWord = INVALID_DATA_UINT8 then begin
      Text := NA;
      Exit;
    end;
  end;

  if Field is TSingleField then
    Text := Format('%.2f', [Field.AsSingle])
  else
    Text := Format('%d', [Field.AsInteger]);
end;

end.
