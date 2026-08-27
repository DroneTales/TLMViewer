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

unit spektrum;

interface

uses
  Classes;

const
  { Sensor IDs }

  TELE_DEVICE_NODATA          = $00; // No data in packet, but telemetry is alive.
  TELE_DEVICE_VOLTAGE         = $01; // High-voltage sensor message.
  TELE_DEVICE_TEMPERATURE     = $02; // Temperature sensor message. (NOT IMPLEMENTED)
  TELE_DEVICE_AMPS            = $03; // High-current sensor message.
  TELE_DEVICE_RSV_04          = $04; // Reserved
  TELE_DEVICE_FLITECTRL       = $05; // Flight controller status report message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_06          = $06; // Reserved.
  TELE_DEVICE_RSV_07          = $07; // Reserved.
  TELE_DEVICE_RSV_08          = $08; // Reserved.
  TELE_DEVICE_DO_NOT_USE_09   = $09; // DO NOT USE!
  TELE_DEVICE_PBOX            = $0A; // PowerBox message.
  TELE_DEVICE_LAPTIMER        = $0B; // Lap timer message.
  TELE_DEVICE_TEXTGEN         = $0C; // Text generator message.
  TELE_DEVICE_VTX             = $0D; // Video transmitter feedback message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_0E          = $0E; // Reserved.
  TELE_DEVICE_RSV_0F          = $0F; // Reserved.
  TELE_DEVICE_RSV_10          = $10; // Reserved.
  TELE_DEVICE_AIRSPEED        = $11; // Air speed sensor message.
  TELE_DEVICE_ALTITUDE        = $12; // Altitude sensor message.
  TELE_DEVICE_RSV_13          = $13; // Reserved.
  TELE_DEVICE_GMETER          = $14; // G-Force (accelerometer) sensor message.
  TELE_DEVICE_JETCAT          = $15; // Turbine ECU status message.
  TELE_DEVICE_GPS_LOC         = $16; // GPS location data message.
  TELE_DEVICE_GPS_STATS       = $17; // GPS status message.
  TELE_DEVICE_RX_MAH          = $18; // Receiver pack capacity sensor message.
  TELE_DEVICE_JETCAT_2        = $19; // Turbine fuel sensor message.
  TELE_DEVICE_GYRO            = $1A; // 3-axis gyro message.
  TELE_DEVICE_ATTMAG          = $1B; // Attitude and magnetic compass message.
  TELE_DEVICE_TILT            = $1C; // Surface tilt sensor message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_1D          = $1D; // Reserved.
  TELE_DEVICE_AS6X_GAIN       = $1E; // Active AS6X gains message (new mode). (NOT IMPLEMENTED)
  TELE_DEVICE_AS3X_LEGACYGAIN = $1F; // Active AS3X gains message (legacy mode). (NOT IMPLEMENTED)
  TELE_DEVICE_ESC             = $20; // Electronic speed control message.
  TELE_DEVICE_RSV_21          = $21; // Reserved.
  TELE_DEVICE_FUEL            = $22; // Fuel flow sensor message.
  TELE_DEVICE_RSV_23          = $23; // Reserved.
  TELE_DEVICE_ALPHA6          = $24; // Alpha6 stabilizer message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_25          = $25; // Reserved.
  TELE_DEVICE_GPS_BINARY      = $26; // GPS, binary format message. (NOT IMPLEMENTED)
  TELE_DEVICE_REMOTE_ID       = $27; // Remote ID (SkyID) (Sky_RID) (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_28          = $28; // Reserved.
  TELE_DEVICE_RSV_29          = $29; // Reserved.
  TELE_DEVICE_RSV_2A          = $2A; // Reserved.
  TELE_DEVICE_RSV_2B          = $2B; // Reserved.
  TELE_DEVICE_RSV_2C          = $2C; // Reserved.
  TELE_DEVICE_RSV_2D          = $2D; // Reserved.
  TELE_DEVICE_RSV_2E          = $2E; // Reserved.
  TELE_DEVICE_RSV_2F          = $2F; // Reserved.
  TELE_DEVICE_DO_NOT_USE_30   = $30; // Internal ST sensor. (NOT IMPLEMENTED)
  TELE_DEVICE_NOT_DEFINED_31  = $31; // Not defined.
  TELE_DEVICE_DO_NOT_USE_32   = $32; // Internal ST sensor. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_33          = $33; // Reserved.
  TELE_DEVICE_FP_MAH          = $34; // Flight battery capacity sensor message.
  TELE_DEVICE_RSV_35          = $35; // Reserved.
  TELE_DEVICE_DIGITAL_AIR     = $36; // Digital inputs and tank pressure
  TELE_DEVICE_RSV_37          = $37; // Reserved.
  TELE_DEVICE_STRAIN          = $38; // Thrust/Strain gauge message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_39          = $39; // Reserved.
  TELE_DEVICE_LIPOMON         = $3A; // 6S LiPo cell monitor message.
  TELE_DEVICE_RSV_3B          = $3B; // Reserved.
  TELE_DEVICE_RSV_3C          = $3C; // Reserved.
  TELE_DEVICE_RSV_3D          = $3D; // Reserved.
  TELE_DEVICE_RSV_3E          = $3E; // Reserved.
  TELE_DEVICE_LIPOMON_14      = $3F; // 14S LiPo cell monitor message.
  TELE_DEVICE_VARIO_S         = $40; // Vario sensor message.
  TELE_DEVICE_RSV_41          = $41; // Reserved.
  TELE_DEVICE_SMARTBATT       = $42; // Spektrum SMART Battery message.
  TELE_DEVICE_SMART_RX        = $43; // Spektrum Receiver Smart Battery (same structs as 0x42) (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_44          = $44; // Reserved.
  TELE_DEVICE_RSV_45          = $45; // Reserved.
  TELE_DEVICE_RSV_46          = $46; // Reserved.
  TELE_DEVICE_RSV_47          = $47; // Reserved.
  TELE_DEVICE_RSV_48          = $48; // Reserved.
  TELE_DEVICE_RSV_49          = $49; // Reserved.
  TELE_DEVICE_RSV_4A          = $4A; // Reserved.
  TELE_DEVICE_RSV_4B          = $4B; // Reserved.
  TELE_DEVICE_RSV_4C          = $4C; // Reserved.
  TELE_DEVICE_RSV_4D          = $4D; // Reserved.
  TELE_DEVICE_RSV_4E          = $4E; // Reserved.
  TELE_DEVICE_RSV_4F          = $4F; // Reserved.
  TELE_DEVICE_USER_16SU       = $50; // User-defined sensor 16 bit signed/unsigned message.
  TELE_DEVICE_RSV_51          = $51; // Reserved.
  TELE_DEVICE_USER_16SU32U    = $52; // User-defined sensor 16 bit signed/unsigned, 32 bit unsigned message.
  TELE_DEVICE_RSV_53          = $53; // Reserved.
  TELE_DEVICE_USER_16SU32S    = $54; // User-defined sensor 16 bit signed/unsigned, 32 bit signed message.
  TELE_DEVICE_RSV_55          = $55; // Reserved.
  TELE_DEVICE_USER_16U32SU    = $56; // User-defined sensor 16 bit unsigned, 32 bit signed/unsigned message.
  TELE_DEVICE_RSV_57          = $57; // Reserved.
  TELE_DEVICE_RSV_58          = $58; // Reserved.
  TELE_DEVICE_MULTICYLINDER   = $59; // Multi-cylinder temperature sensor message.
  TELE_DEVICE_MULTIENGINE     = $5A; // Multi-engine temp and RPM (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_5B          = $5B; // Reserved.
  TELE_DEVICE_RSV_5C          = $5C; // Reserved.
  TELE_DEVICE_RSV_5D          = $5D; // Reserved.
  TELE_DEVICE_RSV_5E          = $5E; // Reserved.
  TELE_DEVICE_RSV_5F          = $5F; // Reserved.
  TELE_DEVICE_VSPEAK          = $60; // Reserved for V-Speak message. (NOT IMPLEMENTED)
  TELE_DEVICE_SMOKE_EL        = $61; // Reserved for Smoke-EL.de message. (NOT IMPLEMENTED)
  TELE_DEVICE_CROSSFIRE       = $62; // Reserved for Crossfire devices. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_63          = $63; // Reserved.
  TELE_DEVICE_RSV_64          = $64; // Reserved.
  TELE_DEVICE_RSV_65          = $65; // Reserved.
  TELE_DEVICE_EXTRF           = $66; // Reserved for Generic External RF sources message. (NOT IMPLEMENTED)
  TELE_DEVICE_RSV_67          = $67; // Reserved.
  TELE_DEVICE_RSV_68          = $68; // Reserved.
  TELE_DEVICE_RSV_69          = $69; // Reserved.
  TELE_DEVICE_RSV_6A          = $6A; // Reserved.
  TELE_DEVICE_DO_NOT_USE_6B   = $6B; // DO NOT USE!
  TELE_DEVICE_RSV_6C          = $6C; // Reserved.
  TELE_DEVICE_RSV_6D          = $6D; // Reserved.
  TELE_DEVICE_RSV_6E          = $6E; // Reserved.
  TELE_DEVICE_RSV_6F          = $6F; // Reserved.
  TELE_DEVICE_RSV_70          = $70; // Reserved.
  TELE_DEVICE_XRF_LINKSTATUS  = $71; // Crossfire QoS message.
  TELE_DEVICE_RSV_72          = $72; // Reserved.
  TELE_DEVICE_RSV_73          = $73; // Reserved.
  TELE_DEVICE_RSV_74          = $74; // Reserved.
  TELE_DEVICE_RSV_75          = $75; // Reserved.
  TELE_DEVICE_DO_NOT_USE_76   = $76; // DO NOT USE!
  TELE_DEVICE_RSV_77          = $77; // Reserved.
  TELE_DEVICE_RSV_78          = $78; // Reserved.
  TELE_DEVICE_RSX             = $79; // Psuedo-device for RX Volts from QOS packet (NOT IMPLEMENTED)
  TELE_DEVICE_TXINPUTS        = $7A; // Transmitter input data message.
  TELE_DEVICE_ALT_ZERO        = $7B; // Setting altitude "zero" message.
  TELE_DEVICE_RTC             = $7C; // Real time clock message.
  TELE_DEVICE_TX_FRAME_DATA   = $7D; // Transmitter frame data message. (NOT IMPLEMENTED)
  TELE_DEVICE_RPM_TM1000      = $7E; // TM1000 RPM sensor message.
  TELE_DEVICE_QOS_TM1000      = $7F; // TM1000 flight pack sensor and QoS message.
  TELE_DEVICE_RPM_TM1100      = $FE; // TM1100 RPM sensor message.
  TELE_DEVICE_QOS_TM1100      = $FF; // TM1100 flight pack sensor and QoS message.

type
  { Common data types. }

  TTelemetryData = array [0..19] of Byte;

  TTempUnits = ( tuCelcius, tuFahrenheit );
  TLengthUnits = ( luMetric, luImperial );

  TSessionTime = record
    Min: Cardinal;
    Max: Cardinal;
  end;

  TSingleSensorValue = record
    Value: Single;
    Valid: Boolean;
  end;

  TByteSensorValue = record
    Value: Byte;
    Valid: Boolean;
  end;

  TWordSensorValue = record
    Value: Word;
    Valid: Boolean;
  end;

  TCardinalSensorValue = record
    Value: Cardinal;
    Valid: Boolean;
  end;

  TShortIntSensorValue = record
    Value: ShortInt;
    Valid: Boolean;
  end;

  TBooleanSensorValue = record
    Value: Boolean;
    Valid: Boolean;
  end;

  TSmallIntSensorValue = record
    Value: SmallInt;
    Valid: Boolean;
  end;

  TIntegerSensorValue = record
    Value: Integer;
    Valid: Boolean;
  end;

  TInt64SensorValue = record
    Value: Int64;
    Valid: Boolean;
  end;

  TUInt64SensorValue = record
    Value: UInt64;
    Valid: Boolean;
  end;

  TStringSensorValue = record
    Value: string;
    Valid: Boolean;
  end;

  TAltZeroProcessing = ( azIgnore, azVirtual, azMessage );

  { Base sensor's class }

  TTelemetrySession = class;

  TSensorData = class
  private
    FData: TTelemetryData;
    FOffset: UInt64;
    FRawData: TTelemetryData;
    FSensorID: Byte;
    FSession: TTelemetrySession;
    FTimestamp: Cardinal;

    function GetTimestamp: Cardinal;

  public
    constructor Create(const Session: TTelemetrySession; const Offset: UInt64;
      const AData: TTelemetryData); virtual;

    class function GetId(const Data: TTelemetryData): Byte;
    class function CreateSensor(const Session: TTelemetrySession;
      const Offset: UInt64; const Data: TTelemetryData): TSensorData;

    function Validate: Boolean; virtual;

    procedure Update; virtual; abstract;

    property Data: TTelemetryData read FData;
    property Offset: UInt64 read FOffset;
    property RawData: TTelemetryData read FRawData;
    property SensorID: Byte read FSensorID;
    property Session: TTelemetrySession read FSession;
    property Timestamp: Cardinal read GetTimestamp;
    property TimestampRaw: Cardinal read FTimestamp;
  end;

  { SENSORS }

  STRU_TELE_USER_16SU = class(TSensorData)
  private
    FSignedField1: TSmallIntSensorValue;
    FSignedField2: TSmallIntSensorValue;
    FSignedField3: TSmallIntSensorValue;
    FUnsignedField1: TWordSensorValue;
    FUnsignedField2: TWordSensorValue;
    FUnsignedField3: TWordSensorValue;
    FUnsignedField4: TWordSensorValue;

  public
    procedure Update; override;

    property SignedField1: TSmallIntSensorValue read FSignedField1;
    property SignedField2: TSmallIntSensorValue read FSignedField2;
    property SignedField3: TSmallIntSensorValue read FSignedField3;
    property UnsignedField1: TWordSensorValue read FUnsignedField1;
    property UnsignedField2: TWordSensorValue read FUnsignedField2;
    property UnsignedField3: TWordSensorValue read FUnsignedField3;
    property UnsignedField4: TWordSensorValue read FUnsignedField4;
  end;

  STRU_TELE_USER_16SU32U = class(TSensorData)
  private
    FSignedField1: TSmallIntSensorValue;
    FSignedField2: TSmallIntSensorValue;
    FUnsignedField1: TWordSensorValue;
    FUnsignedField2: TWordSensorValue;
    FUnsignedField3: TWordSensorValue;
    FUnsignedField4: TCardinalSensorValue;

  public
    procedure Update; override;

    property SignedField1: TSmallIntSensorValue read FSignedField1;
    property SignedField2: TSmallIntSensorValue read FSignedField2;
    property UnsignedField1: TWordSensorValue read FUnsignedField1;
    property UnsignedField2: TWordSensorValue read FUnsignedField2;
    property UnsignedField3: TWordSensorValue read FUnsignedField3;
    property UnsignedField4: TCardinalSensorValue read FUnsignedField4;
  end;

  STRU_TELE_USER_16SU32S = class(TSensorData)
  private
    FSignedField1: TSmallIntSensorValue;
    FSignedField2: TSmallIntSensorValue;
    FUnsignedField1: TWordSensorValue;
    FUnsignedField2: TWordSensorValue;
    FUnsignedField3: TWordSensorValue;
    FSignedField3: TIntegerSensorValue;

  public
    procedure Update; override;

    property SignedField1: TSmallIntSensorValue read FSignedField1;
    property SignedField2: TSmallIntSensorValue read FSignedField2;
    property UnsignedField1: TWordSensorValue read FUnsignedField1;
    property UnsignedField2: TWordSensorValue read FUnsignedField2;
    property UnsignedField3: TWordSensorValue read FUnsignedField3;
    property SignedField3: TIntegerSensorValue read FSignedField3;
  end;

  STRU_TELE_USER_16U32SU = class(TSensorData)
  private
    FUnsignedField1: TWordSensorValue;
    FSignedField1: TIntegerSensorValue;
    FUnsignedField2: TCardinalSensorValue;
    FUnsignedField3: TCardinalSensorValue;

  public
    procedure Update; override;

    property UnsignedField1: TWordSensorValue read FUnsignedField1;
    property SignedField1: TIntegerSensorValue read FSignedField1;
    property UnsignedField2: TCardinalSensorValue read FUnsignedField2;
    property UnsignedField3: TCardinalSensorValue read FUnsignedField3;
  end;

  STRU_TELE_POWERBOX = class(TSensorData)
  public const
    TELE_PBOX_ALARM_VOLTAGE_1 = $01;
    TELE_PBOX_ALARM_VOLTAGE_2 = $02;
    TELE_PBOX_ALARM_CAPACITY_1 = $04;
    TELE_PBOX_ALARM_CAPACITY_2 = $08;
    TELE_PBOX_ALARM_RPM = $10;
    TELE_PBOX_ALARM_TEMPERATURE = $20;
    TELE_PBOX_ALARM_RESERVED_1 = $40;
    TELE_PBOX_ALARM_RESERVED_2 = $80;

  public type
    TCaps = array [0..1] of TWordSensorValue;
    TVolts = array [0..1] of TSingleSensorValue;

  private
    FAlarms: TByteSensorValue;
    FCaps: TCaps;
    FVolts: TVolts;

  public
    procedure Update; override;

    property Alarms: TByteSensorValue read FAlarms;
    property Caps: TCaps read FCaps;
    property Volts: TVolts read FVolts;
  end;

  STRU_TELE_HV = class(TSensorData)
  private const
    SCALE = 0.01;

  private
    FVoltage: TSingleSensorValue;

  public
    procedure Update; override;

    property Voltage: TSingleSensorValue read FVoltage;
  end;

  { TODO -cUPDATE : Update Required }
  STRU_TELE_RX_MAH = class(TSensorData)
  public type
    TValueArray = array [0..1] of TSingleSensorValue;

  public const
    RXMAH_PS_ALERT_NONE       = 0;       // No alarms
    RXMAH_PS_ALERT_RF_INT     = 1 shl 0; // A or internal Remote failure
    RXMAH_PS_ALERT_RF_ANT1    = 1 shl 1; // B remote power fault
    RXMAH_PS_ALERT_RF_ANT2    = 1 shl 2; // L remote power fault
    RXMAH_PS_ALERT_RF_ANT3    = 1 shl 3; // R remote power fault
    RXMAH_PS_ALERT_OVERVOLT_A = 1 shl 4; // Battery A is over voltage
    RXMAH_PS_ALERT_OVERVOLT_B = 1 shl 5; // Battery A is over voltage
    RXMAH_PS_ALERT_RFU1       = 1 shl 6;
    RXMAH_PS_ALERT_RFU2       = 1 shl 7;

  private
    FCapacity: TValueArray;
    FCurrent: TValueArray;
    FVolt: TValueArray;
    FPower: TValueArray;

  public
    procedure Update; override;

    property Capacity: TValueArray read FCapacity;
    property Current: TValueArray read FCurrent;
    property Volt: TValueArray read FVolt;
    property Power: TValueArray read FPower;
  end;

  STRU_TELE_IHIGH = class(TSensorData)
  private const
    IHIGH_RESOLUTION_FACTOR = 0.196791;

  private
    FCurrent: TSingleSensorValue;

  public
    procedure Update; override;

    property Current: TSingleSensorValue read FCurrent;
  end;

  { TODO -cUPDATE : Update Required }
  STRU_TELE_VARIO_S = class(TSensorData)
  private
    FClimbM: TSingleSensorValue;
    FClimbI: TSingleSensorValue;
    FAltM: TSingleSensorValue;
    FAltI: TSingleSensorValue;

    function GetClimb(const Units: TLengthUnits): TSingleSensorValue;
    function GetAlt(const Units: TLengthUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property Climb[const Units: TLengthUnits]: TSingleSensorValue read GetClimb;
    property Alt[const Units: TLengthUnits]: TSingleSensorValue read GetAlt;
  end;

  STRU_TELE_ALT = class(TSensorData)
  private
    FAltM: TSingleSensorValue;
    FAltI: TSingleSensorValue;
    FAltMaxM: TSingleSensorValue;
    FAltMaxI: TSingleSensorValue;

    function GetAlt(const Units: TLengthUnits): TSingleSensorValue;
    function GetAltMax(const Units: TLengthUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property Alt[const Units: TLengthUnits]: TSingleSensorValue read GetAlt;
    property AltMax[const Units: TLengthUnits]: TSingleSensorValue
      read GetAltMax;
  end;

  STRU_TELE_SPEED = class(TSensorData)
  private
    FSpeedM: TWordSensorValue;
    FSpeedI: TWordSensorValue;
    FSpeedMaxM: TWordSensorValue;
    FSpeedMaxI: TWordSensorValue;

    function GetSpeed(const Units: TLengthUnits): TWordSensorValue;
    function GetSpeedMax(const Units: TLengthUnits): TWordSensorValue;

  public
    procedure Update; override;

    property Speed[const Units: TLengthUnits]: TWordSensorValue
      read GetSpeed;
    property SpeedMax[const Units: TLengthUnits]: TWordSensorValue
      read GetSpeedMax;
  end;

  STRU_TELE_LAPTIMER = class(TSensorData)
  private
    FLapNumber: TByteSensorValue;
    FGateNumber: TByteSensorValue;
    FLastLapTime: TCardinalSensorValue;
    FGateTime: TCardinalSensorValue;

  public
    procedure Update; override;

    property LapNumber: TByteSensorValue read FLapNumber;
    property GateNumber: TByteSensorValue read FGateNumber;
    property LastLapTime: TCardinalSensorValue read FLastLapTime;
    property GateTime: TCardinalSensorValue read FGateTime;
  end;

  STRU_TELE_TEXTGEN = class(TSensorData)
  private
    FLineNum: Byte;
    FText: string;

  public
    procedure Update; override;

    property LineNum: Byte read FLineNum;
    property Text: string read FText;
  end;

  STRU_TELE_ESC = class(TSensorData)
  private
    FBECCurrent: TSingleSensorValue;
    FBECVolt: TSingleSensorValue;
    FBECPower: TSingleSensorValue;
    FBECTempM: TSingleSensorValue;
    FBECTempI: TSingleSensorValue;
    FCurrent: TSingleSensorValue;
    FFETTempM: TSingleSensorValue;
    FFETTempI: TSingleSensorValue;
    FOutput: TSingleSensorValue;
    FRPM: TSingleSensorValue;
    FThrottle: TSingleSensorValue;
    FVolt: TSingleSensorValue;
    FPower: TSingleSensorValue;

    function GetBECTemp(const Units: TTempUnits): TSingleSensorValue;
    function GetFETTemp(const Units: TTempUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property BECCurrent: TSingleSensorValue read FBECCurrent;
    property BECVolt: TSingleSensorValue read FBECVolt;
    property BECPower: TSingleSensorValue read FBECPower;
    property BECTemp[const Units: TTempUnits]: TSingleSensorValue read GetBECTemp;
    property Current: TSingleSensorValue read FCurrent;
    property FETTemp[const Units: TTempUnits]: TSingleSensorValue read GetFETTemp;
    property Output: TSingleSensorValue read FOutput;
    property RPM: TSingleSensorValue read FRPM;
    property Throttle: TSingleSensorValue read FThrottle;
    property Volt: TSingleSensorValue read FVolt;
    property Power: TSingleSensorValue read FPower;
  end;

  STRU_TELE_FUEL = class(TSensorData)
  private
    FConsumedA: TSingleSensorValue;
    FFlowRateA: TSingleSensorValue;
    FTempAM: TSingleSensorValue;
    FTempAI: TSingleSensorValue;
    FConsumedB: TSingleSensorValue;
    FFlowRateB: TSingleSensorValue;
    FTempBM: TSingleSensorValue;
    FTempBI: TSingleSensorValue;

    function GetTempA(const Units: TTempUnits): TSingleSensorValue;
    function GetTempB(const Units: TTempUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property ConsumedA: TSingleSensorValue read FConsumedA;
    property FlowRateA: TSingleSensorValue read FFlowRateA;
    property TempA[const Units: TTempUnits]: TSingleSensorValue read GetTempA;
    property ConsumedB: TSingleSensorValue read FConsumedB;
    property FlowRateB: TSingleSensorValue read FFlowRateB;
    property TempB[const Units: TTempUnits]: TSingleSensorValue read GetTempB;
  end;

  STRU_TELE_FP_MAH = class(TSensorData)
  public type
    TValueArray = array [0..1] of TSingleSensorValue;

  private
    FCapacity: TValueArray;
    FCurrent: TValueArray;
    FTempM: TValueArray;
    FTempI: TValueArray;

    function GetTemp(const Units: TTempUnits): TValueArray;

  public
    procedure Update; override;

    property Capacity: TValueArray read FCapacity;
    property Current: TValueArray read FCurrent;
    property Temp[const Units: TTempUnits]: TValueArray read GetTemp;
  end;

  { TODO -cUPDATE : Update Required }
  STRU_TELE_DIGITAL_AIR = class(TSensorData)
  public type
    TValueArray = array [0..3] of TSingleSensorValue;

  private
    FPressure: TValueArray;

  public
    procedure Update; override;

    property Pressure: TValueArray read FPressure;
  end;

  STRU_TELE_LIPOMON = class(TSensorData)
  public type
    T6SLiPoCells = array [0..5] of TSingleSensorValue;

  private
    FCells: T6SLiPoCells;
    FTempM: TSingleSensorValue;
    FTempI: TSingleSensorValue;

    function GetTemp(const Units: TTempUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property Cells: T6SLiPoCells read FCells;
    property Temp[const Ubits: TTempUnits]: TSingleSensorValue read GetTemp;
  end;

  STRU_TELE_LIPOMON_14 = class(TSensorData)
  public type
    T14SLiPoCells = array [0..13] of TSingleSensorValue;

  private
    FCells: T14SLiPoCells;

  public
    procedure Update; override;

    property Cells: T14SLiPoCells read FCells;
  end;

  STRU_TELE_G_METER = class(TSensorData)
  public type
    TAxisArray = array [0..2] of TSingleSensorValue;

  private
    FAxis: TAxisArray;
    FAxisMax: TAxisArray;
    FZMin: TSingleSensorValue;

  public
    procedure Update; override;

    property Axis: TAxisArray read FAxis;
    property AxisMax: TAxisArray read FAxisMax;
    property ZMin: TSingleSensorValue read FZMin;
  end;

  STRU_TELE_JETCAT = class(TSensorData)
  public const
    JETCAT_ECU_STATE_OFF = $00;
    JETCAT_ECU_STATE_WAIT_for_RPM = $01;
    JETCAT_ECU_STATE_Ignite = $02;
    JETCAT_ECU_STATE_Accelerate = $03;
    JETCAT_ECU_STATE_Stabilise = $04;
    JETCAT_ECU_STATE_Learn_HI = $05;
    JETCAT_ECU_STATE_Learn_LO = $06;
    JETCAT_ECU_STATE_UNDEFINED = $07;
    JETCAT_ECU_STATE_Slow_Down = $08;
    JETCAT_ECU_STATE_Manual = $09;
    JETCAT_ECU_STATE_AutoOff = $0A;
    JETCAT_ECU_STATE_Run = $0B;
    JETCAT_ECU_STATE_Accleleration_delay = $0C;
    JETCAT_ECU_STATE_SpeedReg = $0D;
    JETCAT_ECU_STATE_Two_Shaft_Regulate = $0E;
    JETCAT_ECU_STATE_PreHeat1 = $0F;
    JETCAT_ECU_STATE_PreHeat2 = $10;
    JETCAT_ECU_STATE_MainFStart = $11;
    JETCAT_ECU_STATE_NotUsed = $12;
    JETCAT_ECU_STATE_KeroFullOn = $13;

    EVOJET_ECU_STATE_off = $20;
    EVOJET_ECU_STATE_ignt = $21;
    EVOJET_ECU_STATE_acce = $22;
    EVOJET_ECU_STATE_run = $23;
    EVOJET_ECU_STATE_cal = $24;
    EVOJET_ECU_STATE_cool = $25;
    EVOJET_ECU_STATE_fire = $26;
    EVOJET_ECU_STATE_glow = $27;
    EVOJET_ECU_STATE_heat = $28;
    EVOJET_ECU_STATE_idle = $29;
    EVOJET_ECU_STATE_lock = $2A;
    EVOJET_ECU_STATE_rel = $2B;
    EVOJET_ECU_STATE_spin = $2C;
    EVOJET_ECU_STATE_stop = $2D;

    HORNET_ECU_STATE_OFF = $30;
    HORNET_ECU_STATE_SLOWDOWN = $31;
    HORNET_ECU_STATE_COOL_DOWN = $32;
    HORNET_ECU_STATE_AUTO = $33;
    HORNET_ECU_STATE_AUTO_HC = $34;
    HORNET_ECU_STATE_BURNER_ON = $35;
    HORNET_ECU_STATE_CAL_IDLE = $36;
    HORNET_ECU_STATE_CALIBRATE = $37;
    HORNET_ECU_STATE_DEV_DELAY = $38;
    HORNET_ECU_STATE_EMERGENCY = $39;
    HORNET_ECU_STATE_FUEL_HEAT = $3A;
    HORNET_ECU_STATE_FUEL_IGNITE = $3B;
    HORNET_ECU_STATE_GO_IDLE = $3C;
    HORNET_ECU_STATE_PROP_IGNITE = $3D;
    HORNET_ECU_STATE_RAMP_DELAY = $3E;
    HORNET_ECU_STATE_RAMP_UP = $3F;
    HORNET_ECU_STATE_STANDBY = $40;
    HORNET_ECU_STATE_STEADY = $41;
    HORNET_ECU_STATE_WAIT_ACC = $42;
    HORNET_ECU_STATE_ERROR = $43;

    XICOY_ECU_STATE_Temp_High = $50;
    XICOY_ECU_STATE_Trim_Low = $51;
    XICOY_ECU_STATE_Set_Idle = $52;
    XICOY_ECU_STATE_Ready = $53;
    XICOY_ECU_STATE_Ignition = $54;
    XICOY_ECU_STATE_Fuel_Ramp = $55;
    XICOY_ECU_STATE_Glow_Test = $56;
    XICOY_ECU_STATE_Running = $57;
    XICOY_ECU_STATE_Stop = $58;
    XICOY_ECU_STATE_Flameout = $59;
    XICOY_ECU_STATE_Speed_Low = $5A;
    XICOY_ECU_STATE_Cooling = $5B;
    XICOY_ECU_STATE_Igniter_Bad = $5C;
    XICOY_ECU_STATE_Starter_F = $5D;
    XICOY_ECU_STATE_Weak_Fuel = $5E;
    XICOY_ECU_STATE_Start_On = $5F;
    XICOY_ECU_STATE_Pre_Heat = $60;
    XICOY_ECU_STATE_Battery = $61;
    XICOY_ECU_STATE_Time_Out = $62;
    XICOY_ECU_STATE_Overload = $63;
    XICOY_ECU_STATE_Igniter_Fail = $64;
    XICOY_ECU_STATE_Burner_On = $65;
    XICOY_ECU_STATE_Starting = $66;
    XICOY_ECU_STATE_SwitchOver = $67;
    XICOY_ECU_STATE_Cal_Pump = $68;
    XICOY_ECU_STATE_Pump_Limit = $69;
    XICOY_ECU_STATE_No_Engine = $6A;
    XICOY_ECU_STATE_Pwr_Boost = $6B;
    XICOY_ECU_STATE_Run_Idle = $6C;
    XICOY_ECU_STATE_Run_Max = $6D;

    JETCENT_ECU_STATE_STOP = $74;
    JETCENT_ECU_STATE_GLOW_TEST = $75;
    JETCENT_ECU_STATE_STARTER_TEST = $76;
    JETCENT_ECU_STATE_PRIME_FUEL = $77;
    JETCENT_ECU_STATE_PRIME_BURNER = $78;
    JETCENT_ECU_STATE_MAN_COOL = $79;
    JETCENT_ECU_STATE_AUTO_COOL = $7A;
    JETCENT_ECU_STATE_IGN_HEAT = $7B;
    JETCENT_ECU_STATE_IGNITION = $7C;
    JETCENT_ECU_STATE_PREHEAT = $7D;
    JETCENT_ECU_STATE_SWITCHOVER = $7E;
    JETCENT_ECU_STATE_TO_IDLE = $7F;
    JETCENT_ECU_STATE_RUNNING = $80;
    JETCENT_ECU_STATE_STOP_ERROR = $81;

    SWIWIN_ECU_STATE_STOP = $90;
    SWIWIN_ECU_STATE_READY = $91;
    SWIWIN_ECU_STATE_IGNITION = $92;
    SWIWIN_ECU_STATE_PREHEAT = $93;
    SWIWIN_ECU_STATE_FUEL_RAMP = $94;
    SWIWIN_ECU_STATE_RUNNING = $95;
    SWIWIN_ECU_STATE_COOLING = $96;
    SWIWIN_ECU_STATE_RESTART_SWOVER = $97;
    SWIWIN_ECU_STATE_NOTUSED = $98;

    TURBINE_ECU_MAX_STATE = $9F;

    JETCAT_ECU_OFF_No_Off_Condition_defined = 0;
    JETCAT_ECU_OFF_Shut_down_via_RC = 1;
    JETCAT_ECU_OFF_Overtemperature = 2;
    JETCAT_ECU_OFF_Ignition_timeout = 3;
    JETCAT_ECU_OFF_Acceleration_time_out = 4;
    JETCAT_ECU_OFF_Acceleration_too_slow = 5;
    JETCAT_ECU_OFF_Over_RPM = 6;
    JETCAT_ECU_OFF_Low_Rpm_Off = 7;
    JETCAT_ECU_OFF_Low_Battery = 8;
    JETCAT_ECU_OFF_Auto_Off = 9;
    JETCAT_ECU_OFF_Low_temperature_Off = 10;
    JETCAT_ECU_OFF_Hi_Temp_Off = 11;
    JETCAT_ECU_OFF_Glow_Plug_defective = 12;
    JETCAT_ECU_OFF_Watch_Dog_Timer = 13;
    JETCAT_ECU_OFF_Fail_Safe_Off = 14;
    JETCAT_ECU_OFF_Manual_Off = 15;
    JETCAT_ECU_OFF_Power_fail = 16;
    JETCAT_ECU_OFF_Temp_Sensor_fail = 17;
    JETCAT_ECU_OFF_Fuel_fail = 18;
    JETCAT_ECU_OFF_Prop_fail = 19;
    JETCAT_ECU_OFF_2nd_Engine_fail = 20;
    JETCAT_ECU_OFF_2nd_Engine_Diff_Too_High = 21;
    JETCAT_ECU_OFF_2nd_Engine_No_Comm = 22;
    JETCAT_ECU_MAX_OFF_COND = 23;

    JETCENT_ECU_OFF_No_Off_Condition_defined = 24;
    JETCENT_ECU_OFF_IGNITION_ERROR = 25;
    JETCENT_ECU_OFF_PREHEAT_ERROR = 26;
    JETCENT_ECU_OFF_SWITCHOVER_ERROR = 27;
    JETCENT_ECU_OFF_STARTER_MOTOR_ERROR = 28;
    JETCENT_ECU_OFF_TO_IDLE_ERROR = 29;
    JETCENT_ECU_OFF_ACCELERATION_ERROR = 30;
    JETCENT_ECU_OFF_IGNITER_BAD = 31;
    JETCENT_ECU_OFF_MIN_PUMP_OK = 32;
    JETCENT_ECU_OFF_MAX_PUMP_OK = 33;
    JETCENT_ECU_OFF_LOW_RX_BATTERY = 34;
    JETCENT_ECU_OFF_LOW_ECU_BATTERY = 35;
    JETCENT_ECU_OFF_NO_RX = 36;
    JETCENT_ECU_OFF_TRIM_DOWN = 37;
    JETCENT_ECU_OFF_TRIM_UP = 38;
    JETCENT_ECU_OFF_FAILSAFE = 39;
    JETCENT_ECU_OFF_FULL = 40;
    JETCENT_ECU_OFF_RX_SETUP_ERROR = 41;
    JETCENT_ECU_OFF_TEMP_SENSOR_ERROR = 42;
    JETCENT_ECU_OFF_COM_TURBINE_ERROR = 43;
    JETCENT_ECU_OFF_MAX_TEMP = 44;
    JETCENT_ECU_OFF_MAX_AMPS = 45;
    JETCENT_ECU_OFF_LOW_RPM = 46;
    JETCENT_ECU_OFF_ERROR_RPM_SENSOR = 47;
    JETCENT_ECU_OFF_MAX_PUMP = 48;
    JETCENT_ECU_MAX_OFF_COND = 49;

  private
    FStatus: TByteSensorValue;
    FThrottle: TByteSensorValue;
    FPackVoltage: TSingleSensorValue;
    FPumpVoltage: TSingleSensorValue;
    FRPM: TCardinalSensorValue;
    FTemperatureM: TSingleSensorValue;
    FTemperatureI: TSingleSensorValue;
    FOffCondition: TByteSensorValue;

    function GetTemperature(const Units: TTempUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property Status: TByteSensorValue read FStatus;
    property Throttle: TByteSensorValue read FThrottle;
    property PackVoltage: TSingleSensorValue read FPackVoltage;
    property PumpVoltage: TSingleSensorValue read FPumpVoltage;
    property RPM: TCardinalSensorValue read FRPM;
    property Temperature[const Units: TTempUnits]: TSingleSensorValue
      read GetTemperature;
    property OffCondition: TByteSensorValue read FOffCondition;
  end;

  STRU_TELE_JETCAT2 = class(TSensorData)
  private
    FFuelFlow: TWordSensorValue;
    FRestFuel: TCardinalSensorValue;

  public
    procedure Update; override;

    property FuelFlow: TWordSensorValue read FFuelFlow;
    property RestFuel: TCardinalSensorValue read FRestFuel;
  end;

  // Combines both:
  //   STRU_TELE_GPS_LOC
  //   STRU_TELE_GPS_STAT
  STRU_TELE_GPS = class(TSensorData)
  public type
    TGPSAltitudeKind = (
      akMSL,
      akAGL
    );

    TGPSSettings = record
      AltitudeKind: TGPSAltitudeKind;
      Distance: Word;
      Alarm: Byte;
    end;

  public const
    GPS_ALARM_NONE = $00;
    GPS_ALARM_TONE = $01;
    GPS_ALARM_VIBE = $02;
    GPS_ALARM_VOICE = $04;
    GPS_ALARM_TONE_VIBE = GPS_ALARM_TONE or GPS_ALARM_VIBE;
    GPS_ALARM_TONE_VOICE = GPS_ALARM_TONE or GPS_ALARM_VOICE;
    GPS_ALARM_VIBE_VOICE = GPS_ALARM_VIBE or GPS_ALARM_VOICE;
    GPS_ALARM_TONE_VIBE_VOICE = GPS_ALARM_TONE_VIBE or GPS_ALARM_VOICE;

    GPS_FIX_NONE = 0;
    GPS_FIX_VALID = 1;
    GPS_FIX_3D = 2;

  private const
    GPS_INFO_FLAGS_IS_NORTH_BIT = 0;
    GPS_INFO_FLAGS_IS_NORTH = 1 shl GPS_INFO_FLAGS_IS_NORTH_BIT;
    GPS_INFO_FLAGS_IS_EAST_BIT = 1;
    GPS_INFO_FLAGS_IS_EAST = 1 shl GPS_INFO_FLAGS_IS_EAST_BIT;
    GPS_INFO_FLAGS_LONG_GREATER_99_BIT = 2;
    GPS_INFO_FLAGS_LONG_GREATER_99 = 1 shl GPS_INFO_FLAGS_LONG_GREATER_99_BIT;
    GPS_INFO_FLAGS_FIX_VALID_BIT = 3;
    GPS_INFO_FLAGS_FIX_VALID = 1 shl GPS_INFO_FLAGS_FIX_VALID_BIT;
    GPS_INFO_FLAGS_DATA_RECEIVED_BIT = 4;
    GPS_INFO_FLAGS_DATA_RECEIVED = 1 shl GPS_INFO_FLAGS_DATA_RECEIVED_BIT;
    GPS_INFO_FLAGS_3D_FIX_BIT = 5;
    GPS_INFO_FLAGS_3D_FIX = 1 shl GPS_INFO_FLAGS_3D_FIX_BIT;
    GPS_INFO_FLAGS_NEGATIVE_ALT_BIT = 7;
    GPS_INFO_FLAGS_NEGATIVE_ALT = 1 shl GPS_INFO_FLAGS_NEGATIVE_ALT_BIT;

    GPS_INFO_FLAGS_FIX = GPS_INFO_FLAGS_FIX_VALID or GPS_INFO_FLAGS_3D_FIX;

  private
    FPosData: TTelemetryData;
    FPosRawData: TTelemetryData;
    FPosOffset: UInt64;
    FPosSensorID: Byte;
    FPosTimestamp: Cardinal;

    function GetAlt(const Units: TLengthUnits): Single;
    function GetAltRaw: Word;
    function GetFix: Byte;
    function GetFixRaw: Byte;
    function GetHeading: Single;
    function GetHeadingRaw: Word;
    function GetLatitude: Single;
    function GetLatitudeRaw: Single;
    function GetLongitude: Single;
    function GetLongitudeRaw: Single;
    function GetSpeed(const Units: TLengthUnits): Single;
    function GetSpeedRaw: Word;
    function GetTime: Cardinal;
    function GetTimeRaw: Cardinal;
    function GetVisibleSats: Byte;
    function GetVisibleSatsRaw: Byte;
    function GetPosTimestamp: Cardinal;
    function GetDataReceived: Boolean;
    function GetDataReceivedRaw: Byte;

    property AltRaw: Word read GetAltRaw;
    property FixRaw: Byte read GetFixRaw;
    property HeadingRaw: Word read GetHeadingRaw;
    property LatitudeRaw: Single read GetLatitudeRaw;
    property LongitudeRaw: Single read GetLongitudeRaw;
    property SpeedRaw: Word read GetSpeedRaw;
    property TimeRaw: Cardinal read GetTimeRaw;
    property VisibleSatsRaw: Byte read GetVisibleSatsRaw;
    property DataReceivedRaw: Byte read GetDataReceivedRaw;

  public
    constructor Create(const Session: TTelemetrySession; const Offset: UInt64;
      const AData: TTelemetryData); override;

    procedure Update; override;

    procedure SetPosData(const Pos: TTelemetryData; const Offset: UInt64);

    function Validate: Boolean; override;

    property Alt[const Units: TLengthUnits]: Single read GetAlt;
    property Fix: Byte read GetFix;
    property Heading: Single read GetHeading;
    property Latitude: Single read GetLatitude;
    property Longitude: Single read GetLongitude;
    property Speed[const Units: TLengthUnits]: Single read GetSpeed;
    property Time: Cardinal read GetTime;
    property VisibleSats: Byte read GetVisibleSats;
    property DataReceived: Boolean read GetDataReceived;

    property PosData: TTelemetryData read FPosData;
    property PosRawData: TTelemetryData read FPosRawData;
    property PosOffset: UInt64 read FPosOffset;
    property PosSensorID: Byte read FPosSensorID;
    property PosTimestampRaw: Cardinal read FPosTimestamp;
    property PosTimestamp: Cardinal read GetPosTimestamp;
  end;

  STRU_TELE_GYRO = class(TSensorData)
  public type
    TAxisArray = array [0..2] of TSingleSensorValue;

  private
    FAxis: TAxisArray;
    FAxisMax: TAxisArray;

  public
    procedure Update; override;

    property Axis: TAxisArray read FAxis;
    property AxisMax: TAxisArray read FAxisMax;
  end;

  STRU_TELE_ATTMAG = class(TSensorData)
  public type
    TSensorAxisValues = array [0..2] of TSingleSensorValue;
    TSensorMagValues = array [0..2] of TSmallIntSensorValue;

  private
    FAxis: TSensorAxisValues;
    FMag: TSensorMagValues;
    FHeading: TSingleSensorValue;

  public
    procedure Update; override;

    property Axis: TSensorAxisValues read FAxis;
    property Mag: TSensorMagValues read FMag;
    property Heading: TSingleSensorValue read FHeading;
  end;

  STRU_TELE_ALT_ZERO = class(TSensorData)
  public const
    USER_DEFINED_FILE_OFFSET = $FFFFFFFFFFFFFFFF;

  private
    FAltZeroM: TSingleSensorValue;
    FAltZeroI: TSingleSensorValue;

    function GetAltZero(const Units: TLengthUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property AltZero[const Units: TLengthUnits]: TSingleSensorValue
      read GetAltZero;
  end;

  STRU_TELE_RTC = class(TSensorData)
  private
    FTime: UInt64;

  public
    procedure Update; override;

    property Time: UInt64 read FTime;
  end;

  STRU_TELE_MULTI_TEMP = class(TSensorData)
  public type
    TTempArray = array [0..8] of TWordSensorValue;

  private
    FTempM: TTempArray;
    FTempI: TTempArray;
    FThrottle: TByteSensorValue;
    FRpm: TWordSensorValue;
    FBatt: TSingleSensorValue;

    function GetTemperature(const Units: TTempUnits): TTempArray;

  public
    procedure Update; override;

    property Temp[const Units: TTempUnits]: TTempArray read GetTemperature;
    property Throttle: TByteSensorValue read FThrottle;
    property Rpm: TWordSensorValue read FRpm;
    property Batt: TSingleSensorValue read FBatt;
  end;

  STRU_TELE_XF_QOS = class(TSensorData)
  private
    FAnt1: TByteSensorValue;
    FAnt2: TByteSensorValue;
    FQuality: TByteSensorValue;
    FSNR: TShortIntSensorValue;
    FActiveAnt: TByteSensorValue;
    FRFMode: TByteSensorValue;
    FUpPower: TByteSensorValue;
    FDownLink: TByteSensorValue;
    FQualityDown: TByteSensorValue;
    FSNRDown: TShortIntSensorValue;

    function GetAnt1: TSmallIntSensorValue;
    function GetAnt2: TSmallIntSensorValue;
    function GetActiveAnt: TByteSensorValue;
    function GetRFMode: TByteSensorValue;
    function GetUpPower: TWordSensorValue;
    function GetDownLink: TSmallIntSensorValue;

  public
    procedure Update; override;

    property Ant1: TSmallIntSensorValue read GetAnt1;
    property Ant2: TSmallIntSensorValue read GetAnt2;
    property Quality: TByteSensorValue read FQuality;
    property SNR: TShortIntSensorValue read FSNR;
    property ActiveAnt: TByteSensorValue read GetActiveAnt;
    property RFMode: TByteSensorValue read GetRFMode;
    property UpPower: TWordSensorValue read GetUpPower;
    property DownLink: TSmallIntSensorValue read GetDownLink;
    property QualityDown: TByteSensorValue read FQualityDown;
    property SNRDown: TShortIntSensorValue read FSNRDown;
  end;

  STRU_TELE_RPM = class(TSensorData)
  private
    FRPM: TSingleSensorValue;
    FTempM: TSingleSensorValue;
    FTempI: TSingleSensorValue;
    FVolt: TSingleSensorValue;
    FA: TShortIntSensorValue;
    FB: TShortIntSensorValue;
    FFastBooted: TByteSensorValue;
    FUptime: TWordSensorValue;

    function GetTemp(const Units: TTempUnits): TSingleSensorValue;

  public
    procedure Update; override;

    property A: TShortIntSensorValue read FA;
    property B: TShortIntSensorValue read FB;
    property RPM: TSingleSensorValue read FRPM;
    property Temp[const Units: TTempUnits]: TSingleSensorValue read GetTemp;
    property Volt: TSingleSensorValue read FVolt;
    property FastBoot: TByteSensorValue read FFastBooted;
    property Uptime: TWordSensorValue read FUptime;
  end;

  STRU_TELE_QOS = class(TSensorData)
  private
    FA: TWordSensorValue;
    FB: TWordSensorValue;
    FL: TWordSensorValue;
    FR: TWordSensorValue;
    FFrameLoss: TWordSensorValue;
    FHolds: TWordSensorValue;
    FVolt: TSingleSensorValue;
    FIsLemon: TBooleanSensorValue;

  public
    procedure Update; override;

    property A: TWordSensorValue read FA;
    property B: TWordSensorValue read FB;
    property L: TWordSensorValue read FL;
    property R: TWordSensorValue read FR;
    property FrameLoss: TWordSensorValue read FFrameLoss;
    property Holds: TWordSensorValue read FHolds;
    property Volt: TSingleSensorValue read FVolt;
    property IsLemon: TBooleanSensorValue read FIsLemon;
  end;

  STRU_TELE_TXINPUT = class(TSensorData)
  protected const
    TELE_MASK_SW_A_SHIFT = 0;
    TELE_MASK_SW_B_SHIFT = 2;
    TELE_MASK_SW_C_SHIFT = 4;
    TELE_MASK_SW_D_SHIFT = 6;
    TELE_MASK_SW_E_SHIFT = 8;
    TELE_MASK_SW_F_SHIFT = 10;
    TELE_MASK_SW_G_SHIFT = 12;
    TELE_MASK_SW_H_SHIFT = 14;
    TELE_MASK_SW_I_SHIFT = 16;
    TELE_MASK_SW_J_SHIFT = 18;
    TELE_MASK_SW_K_SHIFT = 20;
    TELE_MASK_SW_L_SHIFT = 22;
    TELE_MASK_SW_M_SHIFT = 24;
    TELE_MASK_SW_N_SHIFT = 26;
    TELE_MASK_SW_O_SHIFT = 28;
    TELE_MASK_SW_P_SHIFT = 30;
    TELE_MASK_SW_S_SHIFT = 32;
    TELE_MASK_SW_T_SHIFT = 34;
    TELE_MASK_SW_LTP_SHIFT = 36;
    TELE_MASK_SW_RTP_SHIFT = 38;
    TELE_MASK_SW_LST_SHIFT = 40;
    TELE_MASK_SW_RST_SHIFT = 42;
    TELE_MASK_SW_TRN_SHIFT = 44;
    TELE_MASK_SW_CLR_SHIFT = 46;
    TELE_MASK_SW_BCK_SHIFT = 48;
    TELE_MASK_SW_ROL_SHIFT = 50;
    TELE_MASK_SW_FNC_SHIFT = 52;
    TELE_MASK_SW_LL_SHIFT = 54;
    TELE_MASK_SW_RL_SHIFT = 56;
    TELE_MASK_SW_RFU1_SHIFT = 58;
    TELE_MASK_SW_RFU2_SHIFT = 60;
    TELE_MASK_SW_RFU3_SHIFT = 62;

    TELE_MASK_SW_A = $03 shl TELE_MASK_SW_A_SHIFT;
    TELE_MASK_SW_B = $03 shl TELE_MASK_SW_B_SHIFT;
    TELE_MASK_SW_C = $03 shl TELE_MASK_SW_C_SHIFT;
    TELE_MASK_SW_D = $03 shl TELE_MASK_SW_D_SHIFT;
    TELE_MASK_SW_E = $03 shl TELE_MASK_SW_E_SHIFT;
    TELE_MASK_SW_F = $03 shl TELE_MASK_SW_F_SHIFT;
    TELE_MASK_SW_G = $03 shl TELE_MASK_SW_G_SHIFT;
    TELE_MASK_SW_H = $03 shl TELE_MASK_SW_H_SHIFT;
    TELE_MASK_SW_I = $03 shl TELE_MASK_SW_I_SHIFT;
    TELE_MASK_SW_J = $03 shl TELE_MASK_SW_J_SHIFT;
    TELE_MASK_SW_K = $03 shl TELE_MASK_SW_K_SHIFT;
    TELE_MASK_SW_L = $03 shl TELE_MASK_SW_L_SHIFT;
    TELE_MASK_SW_M = $03 shl TELE_MASK_SW_M_SHIFT;
    TELE_MASK_SW_N = $03 shl TELE_MASK_SW_N_SHIFT;
    TELE_MASK_SW_O = $03 shl TELE_MASK_SW_O_SHIFT;
    TELE_MASK_SW_P = $03 shl TELE_MASK_SW_P_SHIFT;
    TELE_MASK_SW_S = $03 shl TELE_MASK_SW_S_SHIFT;
    TELE_MASK_SW_T = $03 shl TELE_MASK_SW_T_SHIFT;
    TELE_MASK_SW_LTP = $03 shl TELE_MASK_SW_LTP_SHIFT;
    TELE_MASK_SW_RTP = $03 shl TELE_MASK_SW_RTP_SHIFT;
    TELE_MASK_SW_LST = $03 shl TELE_MASK_SW_LST_SHIFT;
    TELE_MASK_SW_RST = $03 shl TELE_MASK_SW_RST_SHIFT;
    TELE_MASK_SW_TRN = $03 shl TELE_MASK_SW_TRN_SHIFT;
    TELE_MASK_SW_CLR = $03 shl TELE_MASK_SW_CLR_SHIFT;
    TELE_MASK_SW_BCK = $03 shl TELE_MASK_SW_BCK_SHIFT;
    TELE_MASK_SW_ROL = $03 shl TELE_MASK_SW_ROL_SHIFT;
    TELE_MASK_SW_FNC = $03 shl TELE_MASK_SW_FNC_SHIFT;
    TELE_MASK_SW_LLEVER = $03 shl TELE_MASK_SW_LL_SHIFT;
    TELE_MASK_SW_RLEVER = $03 shl TELE_MASK_SW_RL_SHIFT;
    TELE_MASK_SW_RFU1 = $03 shl TELE_MASK_SW_RFU1_SHIFT;
    TELE_MASK_SW_RFU2 = $03 shl TELE_MASK_SW_RFU2_SHIFT;
    TELE_MASK_SW_RFU3 = $03 shl TELE_MASK_SW_RFU3_SHIFT;

  public const
    TELE_CAPTURE_DIGITAL = 0;
    TELE_CAPTURE_ANALOG_BASE = 1;
    TELE_CAPTURE_ANALOG_EXT = 2;
    TELE_CAPTURE_TOUCH = 3;

  public type
    STRU_TX_DIGITAL = packed record
      A: Byte;
      B: Byte;
      C: Byte;
      D: Byte;
      E: Byte;
      F: Byte;
      G: Byte;
      H: Byte;
      I: Byte;
      J: Byte;
      K: Byte;
      L: Byte;
      M: Byte;
      N: Byte;
      O: Byte;
      P: Byte;
      S: Byte;
      T: Byte;
      LTP: Byte;
      RTP: Byte;
      LST: Byte;
      RST: Byte;
      TRN: Byte;
      CLR: Byte;
      BCK: Byte;
      ROL: Byte;
      FNC: Byte;
      LLEVER: Byte;
      RLEVER: Byte;
      RFU1: Byte;
      RFU2: Byte;
      RFU3: Byte;
    end;

    STRU_TX_ANALOG_B = packed record
      knob_R: SmallInt;
			stick_Thr: SmallInt;
			stick_Ele: SmallInt;
			stick_Ail: SmallInt;
			stick_Rud: SmallInt;
			slider_L: SmallInt;
			slider_R: SmallInt;
    end;

    STRU_TX_ANALOG_X = packed record
      pot_3: SmallInt;
			pot_4: SmallInt;
			pot_5: SmallInt;
			pot_6: SmallInt;
			knob_L: SmallInt;
			tbd_1: SmallInt;
			tbd_2: SmallInt;
    end;

  private
    FCaptureId: Byte;
    FSwitches: STRU_TX_DIGITAL;
    FSticks: STRU_TX_ANALOG_B;
    FPots: STRU_TX_ANALOG_X;
    FTouch: STRU_TX_DIGITAL;

    procedure ParseSwitches(var Val: STRU_TX_DIGITAL);
    procedure ParseSticks;
    procedure ParsePots;

  public
    constructor Create(const Session: TTelemetrySession; const Offset: UInt64;
      const AData: TTelemetryData); override;

    procedure Update; override;

    property CaptureId: Byte read FCaptureId;
    property Switches: STRU_TX_DIGITAL read FSwitches;
    property Sticks: STRU_TX_ANALOG_B read FSticks;
    property Pots: STRU_TX_ANALOG_X read FPots;
    property Touch: STRU_TX_DIGITAL read FTouch;
  end;

  // Combines:
  //   STRU_SMARTBATT_HEADER
  //   STRU_SMARTBATT_REALTIME
  //   STRU_SMARTBATT_CELLS
  STRU_SMARTBATT = class(TSensorData)
  public const
    SMARTBATT_MSG_TYPE_REALTIME = $00;
    SMARTBATT_MSG_TYPE_CELLS_1_6 = $10;
    SMARTBATT_MSG_TYPE_CELLS_7_12 = $20;
    SMARTBATT_MSG_TYPE_CELLS_13_18 = $30;

  public const
    SMARTBATT_MSG_TYPE_MASK_BATTNUMBER = $0F;
    SMARTBATT_MSG_TYPE_MASK_MSGTYPE = $F0;

    SMARTBATT_MSG_TYPE_ID = $80;
    SMARTBATT_MSG_TYPE_LIMITS = $90;

  public type
    STRU_SMARTBATT_REALTIME = record
      Temperature: TShortIntSensorValue;
      DischargeCurrent: TCardinalSensorValue;
      CapacityUsage: TWordSensorValue;
      MinCellVoltage: TWordSensorValue;
      MaxCellVoltage: TWordSensorValue;
      Rfu: array [0..1] of TByteSensorValue;
    end;

    STRU_SMARTBATT_CELLS = record
      Temperature: TShortIntSensorValue;
      Cells: array [0..5] of TWordSensorValue;
    end;

    TSmartBatteryId = record
      Chemistry: Byte;
      Cells: Byte;
      Manufacturer: Byte;
      Cycles: Word;
      Id: array [0..7] of Byte;
    end;

    TSmartBatteryLimits = record
      Rfu: Byte;
      FullCapacity: Word;
      DischargeCurrentRating: Single;
      OverDischarge: Word;
      ZeroCapacity: Word;
      FullyCharged: Word;
      MinWorkingTemp: ShortInt;
      MaxWorkingTemp: ShortInt;
    end;

    TSmartBatteryInfo = record
      Index: Byte;
      Id: TSmartBatteryId;
      IdSet: Boolean;
      Limits: TSmartBatteryLimits;
      LimitsSet: Boolean;
    end;

    TSmartBatteryInfos = array of TSmartBatteryInfo;

  private
    FBattNum: Byte;
    FRealTime: STRU_SMARTBATT_REALTIME;
    FRealTimeSet: Boolean;
    FCells1: STRU_SMARTBATT_CELLS;
    FCells1Set: Boolean;
    FCells2: STRU_SMARTBATT_CELLS;
    FCells2Set: Boolean;
    FCells3: STRU_SMARTBATT_CELLS;
    FCells3Set: Boolean;

    procedure UpdateRealTime;
    procedure UpdateCells(const Ndx: Byte);

  public
    procedure Update; override;

    property BattNum: Byte read FBattNum;
    property RealTime: STRU_SMARTBATT_REALTIME read FRealTime;
    property RealTimeSet: Boolean read FRealTimeSet;
    property Cells1: STRU_SMARTBATT_CELLS read FCells1;
    property Cells1Set: Boolean read FCells1Set;
    property Cells2: STRU_SMARTBATT_CELLS read FCells2;
    property Cells2Set: Boolean read FCells2Set;
    property Cells3: STRU_SMARTBATT_CELLS read FCells3;
    property Cells3Set: Boolean read FCells3Set;
  end;

  TTelemetrySession = class
  public const
    SPRM_MODEL_FIXED_WING = $00;
    SPRM_MODEL_HELICOPTER = $01;
    SPRM_MODEL_GLIDER = $02;
    SPRM_MODEL_MULTIROTOR = $03;

    SPRM_COMMON_BIND_NOBINDINFO = $00;
    SPRM_COMMON_BIND_DSM2_1024_22 = $01;
    SPRM_COMMON_BIND_DSM2_2048_11_1 = $02;
    SPRM_COMMON_BIND_DSM2_2048_11_2 = $12;
    SPRM_COMMON_BIND_DSMX_11_1 = $03;
    SPRM_COMMON_BIND_DSMX_11_2 = $A2;
    SPRM_COMMON_BIND_DSMX_22_1 = $04;
    SPRM_COMMON_BIND_DSMX_22_2 = $B2;
    SPRM_COMMON_BIND_DSMJ = $05;
    SPRM_COMMON_BIND_DSM_MARINE = $06;

    SURFACE_TYPE_MASK = $40;
    SURFACE_DSM1 = $00 or SURFACE_TYPE_MASK;
    SURFACE_DSM2_16_5 = $23 or SURFACE_TYPE_MASK;
    SURFACE_DSMR_11 = $A2 or SURFACE_TYPE_MASK;
    SURFACE_DSMR_5 = $A4 or SURFACE_TYPE_MASK;

  public type
    PSPRM_TLM_SESSION_HEADER = ^SPRM_TLM_SESSION_HEADER;
    SPRM_TLM_SESSION_HEADER = packed record
      ModelNumber: Byte;
      ModelType: Byte;
      BindType: Byte;
      Unknown1: Byte;
      UpdateRate: Word;
      // Unused: Word; // In v. 1.10 model name moved to 2 bytes left).
      // Changed 08.04.2018. Now model name can be 26 characters long
      // (including termination 0).
      //ModelName: array [0..17] of AnsiChar;
      //Unused: array [0..7] of Byte;
      ModelName: array[0..25] of AnsiChar;
    end;

  private
    FBindType: Byte;
    FData: TList;
    FGpsSettings: STRU_TELE_GPS.TGPSSettings;
    FModelID: Byte;
    FModelName: string;
    FModelType: Byte;
    FPoles: Byte;
    FRatioRaw: Word;
    FTime: TSessionTime;
    FUpdateRate: Word;
    FPolesESC: Byte;
    FRatioESCRaw: Word;
    FHdr: SPRM_TLM_SESSION_HEADER;
    FRtc: UInt64;
    FRtcSet: Boolean;
    FRtcTimestamp: Cardinal;
    FSmartBatts: STRU_SMARTBATT.TSmartBatteryInfos;

    function GetBindTypeName: string;
    function GetDuration: Cardinal;
    function GetDurationStr: string;
    function GetModelTypeName: string;
    function GetRatio: Single;
    function GetRatioESC: Single;
    function GetDateTime: TDateTime;

  public
    constructor Create(const Hdr: SPRM_TLM_SESSION_HEADER; const BindType: Byte;
      const ModelID: Byte; const ModelName: string; const ModelType: Byte;
      const UpdateRate: Word);
    destructor Destroy; override;

    procedure UpdateSensors;

    procedure AddSmartBattInfo(const Index: Byte;
      const Id: STRU_SMARTBATT.TSmartBatteryId); overload;
    procedure AddSmartBattInfo(const Index: Byte;
      const Limits: STRU_SMARTBATT.TSmartBatteryLimits); overload;

    procedure SetEscPolesAndRatio(const Poles: Byte; const RatioRaw: Word);
    procedure SetGpsSettings(const AltByte: Byte; const Distance: Word;
      const Alarm: Byte);
    procedure SetPolesAndRatio(const Poles: Byte; const RatioRaw: Word);
    procedure SetRtc(const Rtc: UInt64; const Timestamp: Cardinal);

    property Hdr: SPRM_TLM_SESSION_HEADER read FHdr;
    property BindType: Byte read FBindType;
    property BindTypeName: string read GetBindTypeName;
    property GpsSettings: STRU_TELE_GPS.TGPSSettings read FGpsSettings;
    property Data: TList read FData;
    property Duration: Cardinal read GetDuration;
    property DurationStr: string read GetDurationStr;
    property ModelID: Byte read FModelID;
    property ModelName: string read FModelName;
    property ModelType: Byte read FModelType;
    property ModelTypeName: string read GetModelTypeName;
    property Poles: Byte read FPoles;
    property RatioRaw: Word read FRatioRaw;
    property Ratio: Single read GetRatio;
    property Time: TSessionTime read FTime write FTime;
    property UpdateRate: Word read FUpdateRate;
    property PolesESC: Byte read FPolesESC;
    property RatioESCRaw: Word read FRatioESCRaw;
    property RatioESC: Single read GetRatioESC;
    property Rtc: UInt64 read FRtc;
    property RtcSet: Boolean read FRtcSet;
    property RtcTimestamp: Cardinal read FRtcTimestamp;
    property DateTime: TDateTime read GetDateTime;
    property SmartBatts: STRU_SMARTBATT.TSmartBatteryInfos read FSmartBatts;
  end;

  TFieldDef = record
    DataType: string;
    Name: string;
    Len: Byte;
  end;

  TFieldDefs = array of TFieldDef;

  TStruct = record
    Id: Byte;
    Name: string;
    Fields: TFieldDefs;
  end;

  TStructs = array of TStruct;

const
  REG_KEY = 'SOFTWARE\Mike Petrichenko\Spektrum Telemetry Log View';

  INVALID_DATA_INT8: ShortInt = $7F;
  INVALID_DATA_INT16: SmallInt = $7FFF;
  INVALID_DATA_INT32: Integer = $7FFFFFFF;
  INVALID_DATA_INT64: Int64 = $7FFFFFFFFFFFFFFF;

  INVALID_DATA_UINT8: Byte = $FF;
  INVALID_DATA_UINT16: Word = $FFFF;
  INVALID_DATA_UINT32: Cardinal = $FFFFFFFF;
  INVALID_DATA_UINT64: UInt64 = $FFFFFFFFFFFFFFFF;

  INVALID_DATA_SINT8: Byte = $7F;
  INVALID_DATA_SINT16: Word = $7FFF;
  INVALID_DATA_SINT32: Cardinal = $7FFFFFFF;
  INVALID_DATA_SINT64: UInt64 = $7FFFFFFFFFFFFFFF;

function ConvertTime(const Timestamp: Cardinal): string; overload;

implementation

uses
  SysUtils, Windows;

{ Time convertion }

function ConvertTime(const Timestamp: Cardinal): string;
var
  TimeSecs: Currency;
  TimeSec: Cardinal;
  Milli: Byte;
begin
  TimeSecs := Timestamp / 100;
  TimeSec := Trunc(TimeSecs);
  Milli := Trunc((TimeSecs - TimeSec) * 100);
  Result := Format('%d:%2.2d:%2.2d.%2.2d', [TimeSec div 3600, TimeSec mod 3600 div 60, TimeSec mod 60, Milli]);
end;

{ BCD convertion}

function BCDToByte(const BCD: Byte): Byte;
begin
  Result := ((BCD and $F0) shr 4) * 10 + (BCD and $0F);
end;

function BCDValid(const BCD: Byte): Boolean;
begin
  Result := (((BCD and $F0) shr 4) <= 9) and ((BCD and $0F) <= 9);
end;

{ TSensorData }

constructor TSensorData.Create(const Session: TTelemetrySession;
  const Offset: UInt64; const AData: TTelemetryData);
begin
  FOffset := Offset;
  FRawData := AData;
  FSensorID := GetId(AData);
  FSession := Session;
  FTimestamp := PCardinal(@AData[0])^;

  Move(AData[6], FData[0], SizeOf(TTelemetryData) - 6);

  Update;
end;

class function TSensorData.GetId(const Data: TTelemetryData): Byte;
begin
  Result := Data[4];
  if (Result <> TELE_DEVICE_TXINPUTS) and (Data[5] <> 0) then
    Result := Data[5];
end;

class function TSensorData.CreateSensor(const Session: TTelemetrySession;
  const Offset: UInt64; const Data: TTelemetryData): TSensorData;
var
  Id: Byte;
begin
  { TODO -cNew Sensor : Create sensor here }
  Id := GetId(Data);

  case Id of
    TELE_DEVICE_VOLTAGE:
      Result := STRU_TELE_HV.Create(Session, Offset, Data);

    TELE_DEVICE_AMPS:
      Result := STRU_TELE_IHIGH.Create(Session, Offset, Data);

    TELE_DEVICE_PBOX:
      Result := STRU_TELE_POWERBOX.Create(Session, Offset, Data);

    TELE_DEVICE_LAPTIMER:
      Result := STRU_TELE_LAPTIMER.Create(Session, Offset, Data);

    TELE_DEVICE_TEXTGEN:
      Result := STRU_TELE_TEXTGEN.Create(Session, Offset, Data);

    TELE_DEVICE_AIRSPEED:
      Result := STRU_TELE_SPEED.Create(Session, Offset, Data);

    TELE_DEVICE_ALTITUDE:
      Result := STRU_TELE_ALT.Create(Session, Offset, Data);

    TELE_DEVICE_GMETER:
      Result := STRU_TELE_G_METER.Create(Session, Offset, Data);

    TELE_DEVICE_JETCAT:
      Result := STRU_TELE_JETCAT.Create(Session, Offset, Data);

    TELE_DEVICE_GPS_STATS:
      Result := STRU_TELE_GPS.Create(Session, Offset, Data);

    TELE_DEVICE_RX_MAH:
      Result := STRU_TELE_RX_MAH.Create(Session, Offset, Data);

    TELE_DEVICE_JETCAT_2:
      Result := STRU_TELE_JETCAT2.Create(Session, Offset, Data);

    TELE_DEVICE_GYRO:
      Result := STRU_TELE_GYRO.Create(Session, Offset, Data);

    TELE_DEVICE_ATTMAG:
      Result := STRU_TELE_ATTMAG.Create(Session, Offset, Data);

    TELE_DEVICE_ESC:
      Result := STRU_TELE_ESC.Create(Session, Offset, Data);

    TELE_DEVICE_FUEL:
      Result := STRU_TELE_FUEL.Create(Session, Offset, Data);

    TELE_DEVICE_FP_MAH:
      Result := STRU_TELE_FP_MAH.Create(Session, Offset, Data);

    TELE_DEVICE_DIGITAL_AIR:
      Result := STRU_TELE_DIGITAL_AIR.Create(Session, Offset, Data);

    TELE_DEVICE_LIPOMON:
      Result := STRU_TELE_LIPOMON.Create(Session, Offset, Data);

    TELE_DEVICE_LIPOMON_14:
      Result := STRU_TELE_LIPOMON_14.Create(Session, Offset, Data);

    TELE_DEVICE_VARIO_S:
      Result := STRU_TELE_VARIO_S.Create(Session, Offset, Data);

    TELE_DEVICE_SMARTBATT:
      Result := STRU_SMARTBATT.Create(Session, Offset, Data);

    TELE_DEVICE_USER_16SU:
      Result := STRU_TELE_USER_16SU.Create(Session, Offset, Data);

    TELE_DEVICE_USER_16SU32U:
      Result := STRU_TELE_USER_16SU32U.Create(Session, Offset, Data);

    TELE_DEVICE_USER_16SU32S:
      Result := STRU_TELE_USER_16SU32S.Create(Session, Offset, Data);

    TELE_DEVICE_USER_16U32SU:
      Result := STRU_TELE_USER_16U32SU.Create(Session, Offset, Data);

    TELE_DEVICE_MULTICYLINDER:
      Result := STRU_TELE_MULTI_TEMP.Create(Session, Offset, Data);

    TELE_DEVICE_XRF_LINKSTATUS:
      Result := STRU_TELE_XF_QOS.Create(Session, Offset, Data);

    TELE_DEVICE_TXINPUTS:
      Result := STRU_TELE_TXINPUT.Create(Session, Offset, Data);

    TELE_DEVICE_ALT_ZERO:
      Result := STRU_TELE_ALT_ZERO.Create(Session, Offset, Data);

    TELE_DEVICE_RTC:
      Result := STRU_TELE_RTC.Create(Session, Offset, Data);

    TELE_DEVICE_RPM_TM1000,
    TELE_DEVICE_RPM_TM1100:
      Result := STRU_TELE_RPM.Create(Session, Offset, Data);

    TELE_DEVICE_QOS_TM1000,
    TELE_DEVICE_QOS_TM1100:
      Result := STRU_TELE_QOS.Create(Session, Offset, Data);

    else
      Result := nil;
  end;
end;

function TSensorData.GetTimestamp: Cardinal;
begin
  if FTimestamp < FSession.Time.Min then
    Result := 0
  else begin
    Result := Round((FTimestamp - FSession.Time.Min) /
      (10000 / FSession.UpdateRate));
  end;
end;

function TSensorData.Validate: Boolean;
begin
  Result := True;
end;

{ STRU_TELE_USER_16SU }

procedure STRU_TELE_USER_16SU.Update;
begin
  FSignedField1.Value := (Data[1] shl 8) or Data[0];
  FSignedField1.Valid := FSignedField1.Value <> INVALID_DATA_INT16;

  FSignedField2.Value := (Data[3] shl 8) or Data[2];
  FSignedField2.Valid := FSignedField2.Value <> INVALID_DATA_INT16;

  FSignedField3.Value := (Data[5] shl 8) or Data[4];
  FSignedField3.Valid := FSignedField3.Value <> INVALID_DATA_INT16;

  FUnsignedField1.Value := (Data[7] shl 8) or Data[6];
  FUnsignedField1.Valid := FUnsignedField1.Value <> INVALID_DATA_UINT16;

  FUnsignedField2.Value := (Data[9] shl 8) or Data[8];
  FUnsignedField2.Valid := FUnsignedField2.Value <> INVALID_DATA_UINT16;

  FUnsignedField3.Value := (Data[11] shl 8) or Data[10];
  FUnsignedField3.Valid := FUnsignedField3.Value <> INVALID_DATA_UINT16;

  FUnsignedField4.Value := (Data[13] shl 8) or Data[12];
  FUnsignedField4.Valid := FUnsignedField4.Value <> INVALID_DATA_UINT16;
end;

{ STRU_TELE_USER_16SU32U }

procedure STRU_TELE_USER_16SU32U.Update;
begin
  FSignedField1.Value := (Data[1] shl 8) or Data[0];
  FSignedField1.Valid := FSignedField1.Value <> INVALID_DATA_INT16;

  FSignedField2.Value := (Data[3] shl 8) or Data[2];
  FSignedField2.Valid := FSignedField2.Value <> INVALID_DATA_INT16;

  FUnsignedField1.Value := (Data[5] shl 8) or Data[4];
  FUnsignedField1.Valid := FUnsignedField1.Value <> INVALID_DATA_UINT16;

  FUnsignedField2.Value := (Data[7] shl 8) or Data[6];
  FUnsignedField2.Valid := FUnsignedField2.Value <> INVALID_DATA_UINT16;

  FUnsignedField3.Value := (Data[9] shl 8) or Data[8];
  FUnsignedField3.Valid := FUnsignedField3.Value <> INVALID_DATA_UINT16;

  FUnsignedField4.Value := (Data[13] shl 24) or (Data[12] shl 16) or (Data[11] shl 8) or Data[10];
  FUnsignedField4.Valid := FUnsignedField4.Value <> INVALID_DATA_UINT32;
end;

{ STRU_TELE_USER_16SU32S }

procedure STRU_TELE_USER_16SU32S.Update;
begin
  FSignedField1.Value := (Data[1] shl 8) or Data[0];
  FSignedField1.Valid := FSignedField1.Value <> INVALID_DATA_INT16;

  FSignedField2.Value := (Data[3] shl 8) or Data[2];
  FSignedField2.Valid := FSignedField2.Value <> INVALID_DATA_INT16;

  FUnsignedField1.Value := (Data[5] shl 8) or Data[4];
  FUnsignedField1.Valid := FUnsignedField1.Value <> INVALID_DATA_UINT16;

  FUnsignedField2.Value := (Data[7] shl 8) or Data[6];
  FUnsignedField2.Valid := FUnsignedField2.Value <> INVALID_DATA_UINT16;

  FUnsignedField3.Value := (Data[9] shl 8) or Data[8];
  FUnsignedField3.Valid := FUnsignedField3.Value <> INVALID_DATA_UINT16;

  FSignedField3.Value := (Data[13] shl 24) or (Data[12] shl 16) or (Data[11] shl 8) or Data[10];
  FSignedField3.Valid := FSignedField3.Value <> INVALID_DATA_INT32;
end;

{ STRU_TELE_USER_16U32SU }

procedure STRU_TELE_USER_16U32SU.Update;
begin
  FUnsignedField1.Value := (Data[1] shl 8) or Data[0];
  FUnsignedField1.Valid := FUnsignedField1.Value <> INVALID_DATA_UINT16;

  FSignedField1.Value := (Data[5] shl 24) or (Data[4] shl 16) or (Data[3] shl 8) or Data[2];
  FSignedField1.Valid := FSignedField1.Value <> INVALID_DATA_INT32;

  FUnsignedField2.Value := (Data[9] shl 24) or (Data[8] shl 16) or (Data[7] shl 8) or Data[6];
  FUnsignedField2.Valid := FUnsignedField2.Value <> INVALID_DATA_UINT32;

  FUnsignedField3.Value := (Data[13] shl 24) or (Data[12] shl 16) or (Data[11] shl 8) or Data[10];
  FUnsignedField3.Valid := FUnsignedField3.Value <> INVALID_DATA_UINT32;
end;

{ STRU_TELE_POWERBOX }

procedure STRU_TELE_POWERBOX.Update;
var
  Tmp: Word;
  J: Byte;
begin
  for J := 0 to 1 do begin
    Tmp := (Data[J * 2] shl 8) or Data[J * 2 + 1];
    FVolts[J].Valid := Tmp <> INVALID_DATA_UINT16;
    if FVolts[J].Valid then
      FVolts[J].Value := Tmp * 0.01;

    Tmp := (Data[J * 2 + 4] shl 8) or Data[J * 2 + 5];
    FCaps[J].Valid := Tmp <> INVALID_DATA_UINT16;
    if FCaps[J].Valid then
      FCaps[J].Value := Tmp;
  end;

  FAlarms.Valid := Data[13] <> INVALID_DATA_UINT8;
  if FAlarms.Valid then
    FAlarms.Value := Data[13];
end;

{ STRU_TELE_HV }

procedure STRU_TELE_HV.Update;
var
  Tmp: Word;
begin
  Tmp := (Data[0] shl 8) or Data[1];
  FVoltage.Valid := (Tmp <> INVALID_DATA_UINT16);
  if FVoltage.Valid then
    FVoltage.Value := Tmp * SCALE;
end;

{ STRU_TELE_RX_MAH }

procedure STRU_TELE_RX_MAH.Update;
var
  Tmp: SmallInt;
  TmpUnsigned: Word;
  J: Byte;
begin
  for J := 0 to 1 do begin
    Tmp := Data[J * 6] or (Data[J * 6 + 1] shl 8);
    FCurrent[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FCurrent[J].Valid then
      FCurrent[J].Value := Tmp * 0.01;

    Tmp := Data[J * 6 + 2] or (Data[J * 6 + 3] shl 8);
    FCapacity[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FCapacity[J].Valid then
      FCapacity[J].Value := Tmp * 0.1;

    TmpUnsigned := Data[J * 6 + 4] or (Data[J * 6 + 5] shl 8);
    FVolt[J].Valid := TmpUnsigned <> INVALID_DATA_UINT16;
    if FVolt[J].Valid then
      FVolt[J].Value := TmpUnsigned * 0.01;

    FPower[J].Valid := FCurrent[J].Valid and FVolt[J].Valid;
    if FPower[J].Valid then
      FPower[J].Value := FCurrent[J].Value * FVolt[J].Value * 0.001;
  end;
end;

{ STRU_TELE_IHIGH }

procedure STRU_TELE_IHIGH.Update;
var
  Tmp: SmallInt;
begin
  inherited;

  Tmp := (Data[0] shl 8) or Data[1];
  FCurrent.Valid := (Tmp <> INVALID_DATA_INT16);
  if FCurrent.Valid then
    FCurrent.Value := Tmp * IHIGH_RESOLUTION_FACTOR;
end;

{ STRU_TELE_VARIO_S }

procedure STRU_TELE_VARIO_S.Update;
var
  Tmp: SmallInt;
begin
  Tmp := (Data[0] shl 8) or Data[1];
  FAltM.Valid := Tmp <> INVALID_DATA_INT16;
  FAltI.Valid := FAltM.Valid;
  if FAltM.Valid then begin
    FAltM.Value := Tmp * 0.1;
    FAltI.Value := FAltM.Value * 3.28084;
  end;

  Tmp := (Data[2] shl 8) or Data[3];
  FClimbM.Valid := Tmp <> INVALID_DATA_INT16;
  FClimbI.Valid := FClimbM.Valid;
  if FClimbM.Valid then begin
    FClimbM.Value := Tmp * 0.1;
    FClimbI.Value := FClimbM.Value * 3.28084;
  end;
end;

function STRU_TELE_VARIO_S.GetAlt(const Units: TLengthUnits): TSingleSensorValue;
begin
  if Units = luImperial then
    Result := FAltI
  else
    Result := FAltM;
end;

function STRU_TELE_VARIO_S.GetClimb(const Units: TLengthUnits): TSingleSensorValue;
begin
  if Units = luImperial then
    Result := FClimbI
  else
    Result := FClimbM;
end;

{ STRU_TELE_ALT }

procedure STRU_TELE_ALT.Update;
var
  Tmp: SmallInt;
begin
  Tmp := (Data[0] shl 8) or Data[1];
  FAltM.Valid := Tmp <> INVALID_DATA_INT16;
  FAltI.Valid := FAltM.Valid;
  if FAltM.Valid then begin
    FAltM.Value := Tmp * 0.1;
    FAltI.Value := FAltM.Value * 3.28084;
  end;

  Tmp := (Data[2] shl 8) or Data[3];
  FAltMaxM.Valid := Tmp <> INVALID_DATA_INT16;
  FAltMaxI.Valid := FAltMaxM.Valid;
  if FAltMaxM.Valid then begin
    FAltMaxM.Value := Tmp * 0.1;
    FAltMaxI.Value := FAltMaxM.Value * 3.28084;
  end;
end;

function STRU_TELE_ALT.GetAlt(const Units: TLengthUnits): TSingleSensorValue;
begin
  if Units = luImperial then
    Result := FAltI
  else
    Result := FAltM;
end;

function STRU_TELE_ALT.GetAltMax(const Units: TLengthUnits): TSingleSensorValue;
begin
  if Units = luImperial then
    Result := FAltMaxI
  else
    Result := FAltMaxM;
end;

{ STRU_TELE_SPEED }

procedure STRU_TELE_SPEED.Update;
begin
  FSpeedM.Value := (Data[0] shl 8) or Data[1];
  FSpeedM.Valid := FSpeedM.Value <> INVALID_DATA_UINT16;
  FSpeedI.Valid := FSpeedM.Valid;
  if FSpeedI.Valid then
    FSpeedI.Value := Round(FSpeedM.Value * 0.621371);

  FSpeedMaxM.Value := (Data[2] shl 8) or Data[3];
  FSpeedMaxM.Valid := FSpeedMaxM.Value <> INVALID_DATA_UINT16;
  FSpeedMaxI.Valid := FSpeedMaxM.Valid;
  if FSpeedMaxI.Valid then
    FSpeedMaxI.Value := Round(FSpeedMaxM.Value * 0.621371);
end;

function STRU_TELE_SPEED.GetSpeed(const Units: TLengthUnits): TWordSensorValue;
begin
  if Units = luMetric then
    Result := FSpeedM
  else
    Result := FSpeedI;
end;

function STRU_TELE_SPEED.GetSpeedMax(const Units: TLengthUnits): TWordSensorValue;
begin
  if Units = luMetric then
    Result := FSpeedMaxM
  else
    Result := FSpeedMaxI;
end;

{ STRU_TELE_LAPTIMER }

procedure STRU_TELE_LAPTIMER.Update;
var
  Tmp: Cardinal;
begin
  FLapNumber.Valid := Data[0] <> INVALID_DATA_UINT8;
  if FLapNumber.Valid then
    FLapNumber.Value := Data[0];

  FGateNumber.Valid := Data[1] <> INVALID_DATA_UINT8;
  if FGateNumber.Valid then
    FGateNumber.Value := Data[1];

  Tmp := (Data[2] shl 24) or (Data[3] shl 16) or (Data[4] shl 8) or Data[5];
  FLastLapTime.Valid := Tmp <> INVALID_DATA_UINT32;
  if FLastLapTime.Valid then
    FLastLapTime.Value := Tmp;

  Tmp := (Data[6] shl 24) or (Data[7] shl 16) or (Data[8] shl 8) or Data[9];
  FGateTime.Valid := Tmp <> INVALID_DATA_UINT32;
  if FGateTime.Valid then
    FGateTime.Value := Tmp;
end;

{ STRU_TELE_TEXTGEN }

procedure STRU_TELE_TEXTGEN.Update;
begin
  FLineNum := Data[0];
  if FLineNum = $FF then
    FText := ''
  else
    FText := string(AnsiString(PAnsiChar(@Data[1])));
end;

{ STRU_TELE_ESC }

procedure STRU_TELE_ESC.Update;
var
  TmpByte: Byte;
  TmpWord: Word;
begin
  TmpWord := (Data[0] shl 8) or Data[1];
  FRPM.Valid := (TmpWord < INVALID_DATA_UINT16);
  if FRPM.Valid then begin
    if Session.RatioESC = 0 then
      FRPM.Value := TmpWord * 10
    else
      FRPM.Value := TmpWord * 10 / Session.RatioESC;
    if Session.PolesESC <> 0 then
      FRPM.Value := FRPM.Value * 2 / Session.PolesESC;
  end;

  TmpWord := (Data[2] shl 8) or (Data[3]);
  FVolt.Valid := (TmpWord < INVALID_DATA_UINT16);
  if FVolt.Valid then
    FVolt.Value := TmpWord * 0.01;

  TmpWord := (Data[4]  shl 8) or Data[5];
  FFETTempM.Valid := TmpWord <> INVALID_DATA_UINT16;
  FFETTempI.Valid := FFETTempM.Valid;
  if FFETTempM.Valid then begin
    FFETTempM.Value := TmpWord * 0.1;
    FFETTempI.Value := FFETTempM.Value * 9 / 5 + 32;
  end;

  TmpWord := (Data[6] shl 8) or Data[7];
  FCurrent.Valid := TmpWord < INVALID_DATA_UINT16;
  if FCurrent.Valid then
    FCurrent.Value := TmpWord * 0.01;

  TmpWord := (Data[8] shl 8) or Data[9];
  FBECTempM.Valid := TmpWord < INVALID_DATA_UINT16;
  FBECTempI.Valid := FBECTempM.Valid;
  if FBECTempM.Valid then begin
    FBECTempM.Value := TmpWord * 0.1;
    FBECTempI.Value := FBECTempM.Value * 9 / 5 + 32;
  end;

  TmpByte := Data[10];
  FBECCurrent.Valid := TmpByte < INVALID_DATA_UINT8;
  if FBECCurrent.Valid then
    FBECCurrent.Value := TmpByte * 0.1;

  TmpByte := Data[11];
  FBECVolt.Valid := TmpByte < INVALID_DATA_UINT8;
  if FBECVolt.Valid then
    FBECVolt.Value := TmpByte * 0.05;

  TmpByte := Data[12];
  FThrottle.Valid := TmpByte < INVALID_DATA_UINT8;
  if FThrottle.Valid then
    FThrottle.Value := TmpByte * 0.5;

  TmpByte := Data[13];
  FOutput.Valid := TmpByte < INVALID_DATA_UINT8;
  if FOutput.Valid then
    FOutput.Value := TmpByte * 0.5;

  FBECPower.Valid := FBECCurrent.Valid and FBECVolt.Valid;
  if FBECPower.Valid then
    FBECPower.Value := FBECCurrent.Value * FBECVolt.Value;

  FPower.Valid := FCurrent.Valid and FVolt.Valid;
  if FPower.Valid then
    FPower.Value := FCurrent.Value * FVolt.Value;
end;

function STRU_TELE_ESC.GetBECTemp(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FBECTempM
  else
    Result := FBECTempI;
end;

function STRU_TELE_ESC.GetFETTemp(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FFETTempM
  else
    Result := FFETTempI;
end;

{ STRU_TELE_FUEL }

function STRU_TELE_FUEL.GetTempA(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FTempAM
  else
    Result := FTempAI;
end;

function STRU_TELE_FUEL.GetTempB(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FTempBM
  else
    Result := FTempBI;
end;

procedure STRU_TELE_FUEL.Update;
var
  TmpWord: Word;
begin
  TmpWord := (Data[1] shl 8) or Data[0];
  FConsumedA.Valid := TmpWord < INVALID_DATA_UINT16;
  if FConsumedA.Valid then
    FConsumedA.Value := TmpWord * 0.1;

  TmpWord := (Data[3] shl 8) or Data[2];
  FFlowRateA.Valid := TmpWord < INVALID_DATA_UINT16;
  if FFlowRateA.Valid then
    FFlowRateA.Value := TmpWord * 0.01;

  TmpWord := (Data[5]  shl 8) or Data[4];
  FTempAM.Valid := TmpWord <> INVALID_DATA_UINT16;
  FTempAI.Valid := FTempAM.Valid;
  if FTempAM.Valid then begin
    FTempAM.Value := TmpWord * 0.01;
    FTempAI.Value := FTempAM.Value * 9 / 5 + 32;
  end;

  TmpWord := (Data[7] shl 8) or Data[6];
  FConsumedB.Valid := TmpWord < INVALID_DATA_UINT16;
  if FConsumedB.Valid then
    FConsumedB.Value := TmpWord * 0.1;

  TmpWord := (Data[9] shl 8) or Data[8];
  FFlowRateB.Valid := TmpWord < INVALID_DATA_UINT16;
  if FFlowRateB.Valid then
    FFlowRateB.Value := TmpWord * 0.01;

  TmpWord := (Data[11]  shl 8) or Data[10];
  FTempBM.Valid := TmpWord <> INVALID_DATA_UINT16;
  FTempBI.Valid := FTempBM.Valid;
  if FTempBM.Valid then begin
    FTempBM.Value := TmpWord * 0.01;
    FTempBI.Value := FTempBM.Value * 9 / 5 + 32;
  end;
end;

{ STRU_TELE_FP_MAH }

procedure STRU_TELE_FP_MAH.Update;
var
  TmpSigned: SmallInt;
  TmpUnsigned: Word;
  J: Byte;
begin
  for J := 0 to 1 do begin
    TmpSigned := Data[J * 6] or (Data[J * 6 + 1] shl 8);
    FCurrent[J].Valid := TmpSigned <> INVALID_DATA_INT16;
    if FCurrent[J].Valid then
      FCurrent[J].Value := TmpSigned * 0.1;

    TmpSigned := Data[J * 6 + 2] or (Data[J * 6 + 3] shl 8);
    FCapacity[J].Valid := TmpSigned <> INVALID_DATA_INT16;
    if FCapacity[J].Valid then
      FCapacity[J].Value := TmpSigned;

    TmpUnsigned := Data[J * 6 + 4] or (Data[J * 6 + 5] shl 8);
    // It must be compared with INVALID_DATA_INT16!!!!
    FTempM[J].Valid := TmpUnsigned <> INVALID_DATA_SINT16;
    FTempI[J].Valid := FTempM[J].Valid;
    if FTempM[J].Valid then begin
      FTempM[J].Value := TmpUnsigned * 0.1;
      FTempI[J].Value := FTempM[J].Value * 9 / 5 + 32;
    end;
  end;
end;

function STRU_TELE_FP_MAH.GetTemp(const Units: TTempUnits): TValueArray;
begin
  if Units = tuCelcius then
    Result := FTempM
  else
    Result := FTempI;
end;

{ STRU_TELE_DIGITAL_AIR }

procedure STRU_TELE_DIGITAL_AIR.Update;
var
  Dig: Word;
  i: Integer;
begin
  for i := 0 to 3 do begin
    Dig := (Data[5 + i * 2] shl 8) or Data[4 + i * 2];
    FPressure[i].Valid := Dig <> INVALID_DATA_UINT16;
    if FPressure[i].Valid then
      FPressure[i].Value := Dig / 10;
  end;
end;

{ STRU_TELE_LIPOMON }

procedure STRU_TELE_LIPOMON.Update;
var
  Tmp: Word;
  J: Byte;
begin
  for J := 0 to 5 do begin
    Tmp := (Data[J * 2 + 1] shl 8) or Data[J * 2];
    FCells[J].Valid := Tmp <> INVALID_DATA_SINT16;
    if FCells[J].Valid then
      FCells[J].Value := Tmp * 0.01;
  end;

  Tmp := (Data[12]  shl 8) or Data[13];
  FTempM.Valid := Tmp <> INVALID_DATA_UINT16;
  FTempI.Valid := FTempM.Valid;
  if FTempM.Valid then begin
    FTempM.Value := Tmp * 0.01;
    FTempI.Value := FTempM.Value * 9 / 5 + 32;
  end;
end;

function STRU_TELE_LIPOMON.GetTemp(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FTempM
  else
    Result := FTempI;
end;

{ STRU_TELE_LIPOMON_14 }

procedure STRU_TELE_LIPOMON_14.Update;
var
  J: Byte;
begin
  for J := 0 to 13 do begin
    FCells[J].Valid := Data[J] <> INVALID_DATA_UINT8;
    if FCells[J].Valid then
      FCells[J].Value := (Data[J] + 256) * 0.01;
  end;
end;

{ STRU_TELE_G_METER }

procedure STRU_TELE_G_METER.Update;
var
  Tmp: SmallInt;
  J: Byte;
begin
  for J := 0 to 2 do begin
    Tmp := (Data[J * 2] shl 8) or Data[J * 2 + 1];
    FAxis[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FAxis[J].Valid then
      FAxis[J].Value := Tmp * 0.01;

    Tmp := (Data[J * 2 + 6] shl 8) or Data[J * 2 + 7];
    FAxisMax[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FAxisMax[J].Valid then
      FAxisMax[J].Value := Tmp * 0.01;
  end;

  Tmp := (Data[12] shl 8) or Data[13];
  FZMin.Valid := Tmp <> INVALID_DATA_INT16;
  if FZMin.Valid then
    FZMin.Value := Tmp * 0.01;
end;

{ STRU_TELE_JETCAT }

procedure STRU_TELE_JETCAT.Update;
begin
  FStatus.Valid := Data[0] <> INVALID_DATA_UINT8;
  if FStatus.Valid then
    FStatus.Value := Data[0];

  FThrottle.Valid := BCDValid(Data[1]);
  if FThrottle.Valid then
    FThrottle.Value := BCDToByte(Data[1]);

  FPackVoltage.Valid := BCDValid(Data[2]) and BCDValid(Data[3]);
  if FPackVoltage.Valid then
    FPackVoltage.Value := BCDToByte(Data[3]) + BCDToByte(Data[2]) * 0.01;

  FPumpVoltage.Valid := BCDValid(Data[4]) and BCDValid(Data[5]);
  if FPumpVoltage.Valid then
    FPumpVoltage.Value := BCDToByte(Data[5]) + BCDToByte(Data[4]) * 0.01;

  FRPM.Valid := BCDValid(Data[6]) and BCDValid(Data[7]) and
    BCDValid(Data[8]) and BCDValid(Data[9]);
  if FRPM.Valid then begin
    FRPM.Value := BCDToByte(Data[9]) * 1000000 + BCDToByte(Data[8]) * 10000 +
      BCDToByte(Data[7]) * 100 + BCDToByte(Data[6]);
  end;

  FTemperatureM.Valid := BCDValid(Data[10]) and BCDValid(Data[11]);
  FTemperatureI.Valid := FTemperatureM.Valid;
  if FTemperatureM.Valid then begin
    FTemperatureM.Value := BCDToByte(Data[11]) * 100 + BCDToByte(Data[10]);
    FTemperatureI.Value := FTemperatureM.Value * 9 / 5 + 32;
  end;

  FOffCondition.Valid := BCDValid(Data[12]);
  if FOffCondition.Valid then begin
    if FStatus.Valid and (FStatus.Value <> JETCAT_ECU_STATE_OFF) then
      FOffCondition.Value := 0
    else
      FOffCondition.Value := BCDToByte(Data[12]);
  end;
end;

function STRU_TELE_JETCAT.GetTemperature(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FTemperatureM
  else
    Result := FTemperatureI;
end;

{ STRU_TELE_JETCAT2 }

procedure STRU_TELE_JETCAT2.Update;
begin
  FFuelFlow.Valid := BCDValid(Data[0]) and BCDValid(Data[1]);
  if FFuelFlow.Valid then
    FFuelFlow.Value := BCDToByte(Data[1]) * 100 + BCDToByte(Data[0]);

  FRestFuel.Valid := BCDValid(Data[2]) and BCDValid(Data[3]) and
    BCDValid(Data[4]) and BCDValid(Data[5]);
  if FRestFuel.Valid then begin
    FRestFuel.Value := BCDToByte(Data[5]) * 1000000 +
      BCDToByte(Data[4]) * 10000 + BCDToByte(Data[3]) * 100 +
      BCDToByte(Data[2]);
  end;
end;

{ STRU_TELE_GPS }

constructor STRU_TELE_GPS.Create(const Session: TTelemetrySession;
  const Offset: UInt64; const AData: TTelemetryData);
begin
  inherited;

  FillChar(FPosData[0], SizeOf(TTelemetryData), 0);
  FillChar(FPosRawData[0], SizeOf(TTelemetryData), 0);

  FPosOffset := 0;
  FPosSensorID := 0;
  FPosTimestamp := 0;
end;

procedure STRU_TELE_GPS.Update;
begin
  // Do nothing for this sensor!
end;

function STRU_TELE_GPS.GetAlt(const Units: TLengthUnits): Single;
begin
  Result := AltRaw * 0.1;
  if (FPosData[13] and GPS_INFO_FLAGS_NEGATIVE_ALT) <> 0 then
    Result := -Result;
  if Units = luImperial then
    Result := Result * 3.28084;
end;

function STRU_TELE_GPS.GetAltRaw: Word;
begin
  Result := BCDToByte(FPosData[0]) + BCDToByte(FPosData[1]) * 100 +
    BCDToByte(Data[7]) * 10000;
end;

function STRU_TELE_GPS.GetDataReceived: Boolean;
begin
  Result := DataReceivedRaw <> 0;
end;

function STRU_TELE_GPS.GetDataReceivedRaw: Byte;
begin
  Result := FPosData[13] and GPS_INFO_FLAGS_DATA_RECEIVED;
end;

function STRU_TELE_GPS.GetFix: Byte;
begin
  if (FixRaw and GPS_INFO_FLAGS_3D_FIX) <> 0 then
    Result := GPS_FIX_3D
  else begin
    if (FixRaw and GPS_INFO_FLAGS_FIX_VALID) <> 0 then
      Result := GPS_FIX_VALID
    else
      Result := GPS_FIX_NONE;
  end;
end;

function STRU_TELE_GPS.GetFixRaw: Byte;
begin
  Result := FPosData[13] and GPS_INFO_FLAGS_FIX;
end;

function STRU_TELE_GPS.GetHeading: Single;
begin
  Result := HeadingRaw * 0.1;
end;

function STRU_TELE_GPS.GetHeadingRaw: Word;
begin
  Result := BCDToByte(FPosData[10]) + BCDToByte(FPosData[11]) * 100;
end;

function STRU_TELE_GPS.GetLatitude: Single;
begin
  Result := LatitudeRaw;
end;

function STRU_TELE_GPS.GetLatitudeRaw: Single;
begin
  Result := BCDToByte(FPosData[4]) + BCDToByte(FPosData[3]) / 100 +
    BCDToByte(FPosData[2]) / 10000;
  Result := BCDToByte(FPosData[5]) + Result / 60;
  if (FPosData[13] and GPS_INFO_FLAGS_IS_NORTH) = 0 then
    Result := (-1) * Result;
end;

function STRU_TELE_GPS.GetLongitude: Single;
begin
  Result := LongitudeRaw;
end;

function STRU_TELE_GPS.GetLongitudeRaw: Single;
begin
  Result := BCDToByte(FPosData[8]) + BCDToByte(FPosData[7]) / 100 +
    BCDToByte(FPosData[6]) / 10000;
  Result := BCDToByte(FPosData[9]) + Result / 60;
  if (FPosData[13] and GPS_INFO_FLAGS_LONG_GREATER_99) = 4 then
    Result := Result + 100;
  if (FPosData[13] and GPS_INFO_FLAGS_IS_EAST) = 0 then
    Result := (-1) * Result;
end;

function STRU_TELE_GPS.GetPosTimestamp: Cardinal;
begin
  if FPosTimestamp < FSession.Time.Min then
    Result := 0
  else begin
    Result := Round((FPosTimestamp - FSession.Time.Min) /
      (10000 / FSession.UpdateRate));
  end;
end;

function STRU_TELE_GPS.GetSpeed(const Units: TLengthUnits): Single;
begin
  if Units = luMetric then
    Result := SpeedRaw * 0.185
  else
    Result := SpeedRaw * 0.115;
end;

function STRU_TELE_GPS.GetSpeedRaw: Word;
begin
  Result := BCDToByte(Data[0]) + BCDToByte(Data[1]) * 100;
end;

function STRU_TELE_GPS.GetTime: Cardinal;
begin
  Result := TimeRaw;
end;

function STRU_TELE_GPS.GetTimeRaw: Cardinal;
begin
  Result := BCDToByte(Data[2]) + (BCDToByte(Data[3]) + BCDToByte(Data[4]) * 60 +
    BCDToByte(Data[5]) * 3600) * 100;
end;

function STRU_TELE_GPS.GetVisibleSats: Byte;
begin
  Result := VisibleSatsRaw;
end;

function STRU_TELE_GPS.GetVisibleSatsRaw: Byte;
begin
  Result := BCDToByte(Data[6]);
end;

procedure STRU_TELE_GPS.SetPosData(const Pos: TTelemetryData;
  const Offset: UInt64);
begin
  Move(Pos[6], FPosData[0], SizeOf(TTelemetryData)- 6);
  Move(Pos[0], FPosRawData[0], SizeOf(TTelemetryData));

  FPosOffset := Offset;
  FPosSensorID := GetId(Pos);
  FPosTimestamp := PCardinal(@Pos[0])^;
end;

function STRU_TELE_GPS.Validate: Boolean;
begin
  Result := (VisibleSats > 0) and (Heading <= 360) and (Latitude >= -90) and
    (Latitude <= 90) and (Longitude >= -180) and (Longitude <= 180);
end;

{ STRU_TELE_GYRO }

procedure STRU_TELE_GYRO.Update;
var
  Tmp: SmallInt;
  J: Byte;
begin
  for J := 0 to 2 do begin
    //Tmp := Data[J * 2] or (Data[J * 2 + 1] shl 8);
    Tmp := Data[J * 2 + 1] or (Data[J * 2] shl 8); // Updated 10.11.2022
    FAxis[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FAxis[J].Valid then
      FAxis[J].Value := Tmp * 0.1;

    //Tmp := Data[J * 2 + 6] or (Data[J * 2 + 7] shl 8);
    Tmp := Data[J * 2 + 7] or (Data[J * 2 + 6] shl 8); // Updated 10.11.2022
    FAxisMax[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FAxisMax[J].Valid then
      FAxisMax[J].Value := Tmp * 0.1;
  end;
end;

{ STRU_TELE_ATTMAG }

procedure STRU_TELE_ATTMAG.Update;
var
  Tmp: SmallInt;
  TmpUint: Word;
  J: Byte;
begin
  for J := 0 to 2 do begin
    Tmp := (Data[J * 2] shl 8) or Data[J * 2 + 1];
    FAxis[J].Valid := (Tmp <> INVALID_DATA_INT16) and (Tmp >= -180) and
      (Tmp <= 180);
    if FAxis[J].Valid then
      FAxis[J].Value := Tmp * 0.1;

    Tmp := (Data[J * 2 + 6] shl 8) or Data[J * 2 + 7];
    FMag[J].Valid := Tmp <> INVALID_DATA_INT16;
    if FMag[J].Valid then
      FMag[J].Value := Tmp;
  end;

  TmpUint := (Data[12] shl 8) or Data[13];
  FHeading.Valid := (TmpUint <> INVALID_DATA_UINT16) and (TmpUint <= 3999);
  if FHeading.Valid then
    FHeading.Value := TmpUint * 0.1;
end;

{ STRU_TELE_ALT_ZERO }

procedure STRU_TELE_ALT_ZERO.Update;
var
  Tmp: Integer;
begin
  Tmp := (Data[5] shl 24) or (Data[4] shl 16) or (Data[3] shl 8) or Data[2];

  // Always valid.
  FAltZeroM.Valid := True;
  FAltZeroI.Valid := FAltZeroM.Valid;

  FAltZeroM.Value := Tmp * 0.1;
  FAltZeroI.Value := FAltZeroM.Value * 3.28084;
end;

function STRU_TELE_ALT_ZERO.GetAltZero(
  const Units: TLengthUnits): TSingleSensorValue;
begin
  if Units = luImperial then
    Result := FAltZeroI
  else
    Result := FAltZeroM;
end;

{ STRU_TELE_RTC }

procedure STRU_TELE_RTC.Update;
begin
  FTime := PUint64(@Data[6])^;
  Session.SetRtc(FTime, TimestampRaw);
end;

{ STRU_TELE_MULTI_TEMP }

function STRU_TELE_MULTI_TEMP.GetTemperature(const Units: TTempUnits): TTempArray;
begin
  if Units = tuCelcius then
    Result := FTempM
  else
    Result := FTempI;
end;

procedure STRU_TELE_MULTI_TEMP.Update;
var
  i: Byte;
  ByteVal: Byte;
  WordVal: Word;
begin
  for i := 0 to 8 do begin
    ByteVal := Data[i];
    FTempM[i].Valid := ByteVal <> INVALID_DATA_UINT8;
    FTempI[i].Valid := FTempM[i].Valid;
    if FTempM[i].Valid then begin
      FTempM[i].Value := ByteVal + 30;
      FTempI[i].Value := Round(FTempM[i].Value * 9 / 5 + 32);
    end;
  end;

  ByteVal := Data[9];
  FThrottle.Valid := ByteVal <> INVALID_DATA_UINT8;
  if FThrottle.Valid then
    FThrottle.Value := ByteVal;

  WordVal := ((Data[11] shl 8) or Data[10]) and $0FFF;
  FRpm.Valid := WordVal <> $0FFF;
  if FRpm.Valid then
    FRpm.Value := WordVal * 4 + 400;

  ByteVal := Data[12];
  FBatt.Valid := ByteVal <> INVALID_DATA_UINT8;
  if FBatt.Valid then
    FBatt.Value := ByteVal * 0.1 + 3.5;
end;

{ STRU_TELE_XF_QOS }

function STRU_TELE_XF_QOS.GetActiveAnt: TByteSensorValue;
begin
  Result.Valid := FActiveAnt.Valid;
  if FActiveAnt.Valid then
    Result.Value := FActiveAnt.Value + 1
  else
    Result.Value := INVALID_DATA_UINT8;
end;

function STRU_TELE_XF_QOS.GetAnt1: TSmallIntSensorValue;
begin
  Result.Valid := FAnt1.Valid;
  if FAnt1.Valid then
    Result.Value := FAnt1.Value * -1
  else
    Result.Value := INVALID_DATA_INT16;
end;

function STRU_TELE_XF_QOS.GetAnt2: TSmallIntSensorValue;
begin
  Result.Valid := FAnt2.Valid;
  if FAnt2.Valid then
    Result.Value := FAnt2.Value * -1
  else
    Result.Value := INVALID_DATA_INT16;
end;

function STRU_TELE_XF_QOS.GetDownLink: TSmallIntSensorValue;
begin
  Result.Valid := FDownLink.Valid;
  if FDownLink.Valid then
    Result.Value := FDownLink.Value * -1
  else
    Result.Value := INVALID_DATA_INT16;
end;

function STRU_TELE_XF_QOS.GetRFMode: TByteSensorValue;
begin
  Result.Valid := FRFMode.Valid;
  if FRFMode.Valid then begin
    case FRFMode.Value of
      0: Result.Value := 4;
      1: Result.Value := 50;
      2: Result.Value := 150;
      else Result.Valid := False;
    end;
  end;

  if not FRFMode.Valid then
    FRFMode.Value := INVALID_DATA_UINT8;
end;

function STRU_TELE_XF_QOS.GetUpPower: TWordSensorValue;
begin
  Result.Valid := FUpPower.Valid;
  if FUpPower.Valid then begin
    case FUpPower.Value of
      0: Result.Value := 0;
      1: Result.Value := 10;
      2: Result.Value := 25;
      3: Result.Value := 100;
      4: Result.Value := 500;
      5: Result.Value := 1000;
      6: Result.Value := 2000;
      else Result.Valid := False;
    end;
  end;

  if not Result.Valid then
    Result.Value := INVALID_DATA_UINT16;
end;

procedure STRU_TELE_XF_QOS.Update;
begin
  FAnt1.Valid := Data[0] <> INVALID_DATA_UINT8;
  if FAnt1.Valid then
    FAnt1.Value := Data[0];
  FAnt1.Valid := Data[1] <> INVALID_DATA_UINT8;
  if FAnt1.Valid then
    FAnt1.Value := Data[1];
  FQuality.Valid := (Data[2] <> INVALID_DATA_UINT8) and (Data[2] <= 100);
  if FQuality.Valid then
    FQuality.Value := Data[2];
  FSNR.Valid := Data[3] <> INVALID_DATA_SINT8;
  if FSNR.Valid then
    FSNR.Value := Data[3];
  FActiveAnt.Valid := (Data[4] <> INVALID_DATA_UINT8) and (Data[4] in [0..1]);
  if FActiveAnt.Valid then
    FActiveAnt.Value := Data[4];
  FRFMode.Valid := (Data[5] <> INVALID_DATA_UINT8) and (Data[5] in [0..2]);
  if FRFMode.Valid then
    FRFMode.Value := Data[5];
  FUpPower.Valid := (Data[6] <> INVALID_DATA_UINT8) and (Data[6] in [0..6]);
  if FUpPower.Valid then
    FUpPower.Value := Data[6];
  FDownLink.Valid := Data[7] <> INVALID_DATA_UINT8;
  if FDownLink.Valid then
    FDownLink.Value := Data[7];
  FQualityDown.Valid := (Data[8] <> INVALID_DATA_UINT8) and (Data[8] <= 100);
  if FQualityDown.Valid then
    FQualityDown.Value := Data[8];
  FSNRDown.Valid := Data[9] <> INVALID_DATA_SINT8;
  if FSNRDown.Valid then
    FSNRDown.Value := Data[9];
end;

{ STRU_TELE_RPM }

procedure STRU_TELE_RPM.Update;
var
  Tmp: Word;
  Ratio: Single;
  Poles: Byte;
  TmpInt: SmallInt;
  Uptime: Word;
begin
  Tmp := (Data[0] shl 8) or Data[1];
  FRPM.Valid := (Tmp <> INVALID_DATA_UINT16) and (Tmp >= 200);
  if FRPM.Valid then begin
    Ratio := Session.Ratio;
    if Ratio = 0 then
      Ratio := 1; // Default ratio is 1.
    Poles := Session.Poles;
    if Poles = 0 then
      Poles := 2; // Try to use 2 poles as default value.
    if Tmp = 0 then
      FRPM.Value := 0
    else
      FRPM.Value := 120000000 / Poles / Tmp / Ratio;
  end;

  Tmp := (Data[2] shl 8) or Data[3];
  FVolt.Valid := Tmp <> INVALID_DATA_UINT16;
  if FVolt.Valid then
    FVolt.Value := Tmp * 0.01;

  TmpInt := (Data[4] shl 8) or Data[5];
  FTempI.Valid := TmpInt <> INVALID_DATA_INT16;
  FTempM.Valid := FTempI.Valid;
  if FTempI.Valid then begin
    FTempI.Value := TmpInt;
    FTempM.Value := (FTempI.Value - 32) * 5 / 9;
  end;

  FA.Valid := Data[6] <> INVALID_DATA_SINT8;
  if FA.Valid then
    FA.Value := Data[6];

  FB.Valid := Data[7] <> INVALID_DATA_SINT8;
  if FB.Valid then
    FB.Value := Data[7];

  Uptime := (Data[12] shl 8) or Data[13];
  FFastBooted.Valid := Uptime <> INVALID_DATA_UINT16;
  FUptime.Valid := Uptime <> INVALID_DATA_UINT16;
  if FFastBooted.Valid then begin
    FFastBooted.Value := Uptime and $8000;
    FUptime.Value := Uptime and $7FFF;
  end;
end;

function STRU_TELE_RPM.GetTemp(const Units: TTempUnits): TSingleSensorValue;
begin
  if Units = tuCelcius then
    Result := FTempM
  else
    Result := FTempI;
end;

{ STRU_TELE_QOS }

procedure STRU_TELE_QOS.Update;
var
  Tmp: Word;
begin
  Tmp := (Data[0] shl 8) or Data[1];
  FA.Valid := Tmp <> INVALID_DATA_UINT16;
  if FA.Valid then
    FA.Value := Tmp;

  Tmp := (Data[2] shl 8) or Data[3];
  FB.Valid := Tmp <> INVALID_DATA_UINT16;
  if FB.Valid then
    FB.Value := Tmp;

  Tmp := (Data[4] shl 8) or Data[5];
  FL.Valid := Tmp <> INVALID_DATA_UINT16;
  if FL.Valid then
    FL.Value := Tmp;

  Tmp := (Data[6] shl 8) or Data[7];
  FR.Valid := Tmp <> INVALID_DATA_UINT16;
  if FR.Valid then
    FR.Value := Tmp;

  Tmp := (Data[8] shl 8) or Data[9];
  FFrameLoss.Valid := Tmp <> INVALID_DATA_UINT16;
  if FFrameLoss.Valid then
    FFrameLoss.Value := Tmp;

  Tmp := (Data[10] shl 8) or Data[11];
  FHolds.Valid := Tmp <> INVALID_DATA_UINT16;
  if FHolds.Valid then
    FHolds.Value := Tmp;

  Tmp := (Data[12] shl 8) or Data[13];
  FVolt.Valid := Tmp <> INVALID_DATA_UINT16;
  if FVolt.Valid then
    FVolt.Value := Tmp * 0.01;

  FIsLemon.Valid := FA.Valid and FB.Valid and FL.Valid and FR.Valid and
    FHolds.Valid and FFrameLoss.Valid;
  if FIsLemon.Valid then begin
    FIsLemon.Value := (FA.Value <> 32768) and (FB.Value = 32768) and
      (FL.Value = 32768) and (FR.Value = 32768) and (FHolds.Value = 32768) and
      (FFrameLoss.Value = 32768);
    if FIsLemon.Value then begin
      FB.Valid := False;
      FL.Valid := False;
      FR.Valid := False;
      FHolds.Valid := False;
      FFrameLoss.Valid := False;
    end;
  end;
end;

{ STRU_TELE_TXINPUT }

constructor STRU_TELE_TXINPUT.Create(const Session: TTelemetrySession;
  const Offset: UInt64; const AData: TTelemetryData);
begin
  inherited;

  FCaptureId := AData[5];

  ZeroMemory(@FSwitches, SizeOf(STRU_TX_DIGITAL));
  ZeroMemory(@FSticks, SizeOf(STRU_TX_ANALOG_B));
  ZeroMemory(@FPots, SizeOf(STRU_TX_ANALOG_X));

  Update;
end;

procedure STRU_TELE_TXINPUT.ParsePots;
begin
  FPots.pot_3 := PSmallInt(@Data[0])^;
  FPots.pot_4 := PSmallInt(@Data[2])^;
	FPots.pot_5 := PSmallInt(@Data[4])^;
  FPots.pot_6 := PSmallInt(@Data[6])^;
  FPots.knob_L := PSmallInt(@Data[8])^;
  FPots.tbd_1 := PSmallInt(@Data[10])^;
  FPots.tbd_2 := PSmallInt(@Data[12])^;
end;

procedure STRU_TELE_TXINPUT.ParseSticks;
begin
  FSticks.knob_R := PSmallInt(@Data[0])^;
  FSticks.stick_Thr := PSmallInt(@Data[2])^;
  FSticks.stick_Ele := PSmallInt(@Data[4])^;
  FSticks.stick_Ail := PSmallInt(@Data[6])^;
  FSticks.stick_Rud := PSmallInt(@Data[8])^;
  FSticks.slider_L := PSmallInt(@Data[10])^;
  FSticks.slider_R := PSmallInt(@Data[12])^;
end;

procedure STRU_TELE_TXINPUT.ParseSwitches(var Val: STRU_TX_DIGITAL);
var
  Tmp1: Cardinal;
  Tmp2: Cardinal;
  Tmp: UInt64;
begin
  Tmp1 := Data[0] + (Data[1] shl 8) + (Data[2] shl 16) + (Data[3] shl 24);
  Tmp2 := Data[4] + (Data[5] shl 8) + (Data[6] shl 16) + (Data[7] shl 24);
  Tmp := (Tmp2 shl 32) + Tmp1;

  FSwitches.A := (Tmp and TELE_MASK_SW_A) shr TELE_MASK_SW_A_SHIFT;
  FSwitches.B := (Tmp and TELE_MASK_SW_B) shr TELE_MASK_SW_B_SHIFT;
  FSwitches.C := (Tmp and TELE_MASK_SW_C) shr TELE_MASK_SW_C_SHIFT;
  FSwitches.D := (Tmp and TELE_MASK_SW_D) shr TELE_MASK_SW_D_SHIFT;
  FSwitches.E := (Tmp and TELE_MASK_SW_E) shr TELE_MASK_SW_E_SHIFT;
  FSwitches.F := (Tmp and TELE_MASK_SW_F) shr TELE_MASK_SW_F_SHIFT;
  FSwitches.G := (Tmp and TELE_MASK_SW_G) shr TELE_MASK_SW_G_SHIFT;
  FSwitches.H := (Tmp and TELE_MASK_SW_H) shr TELE_MASK_SW_H_SHIFT;
  FSwitches.I := (Tmp and TELE_MASK_SW_I) shr TELE_MASK_SW_I_SHIFT;
  FSwitches.J := (Tmp and TELE_MASK_SW_J) shr TELE_MASK_SW_J_SHIFT;
  FSwitches.K := (Tmp and TELE_MASK_SW_K) shr TELE_MASK_SW_K_SHIFT;
  FSwitches.L := (Tmp and TELE_MASK_SW_L) shr TELE_MASK_SW_L_SHIFT;
  FSwitches.M := (Tmp and TELE_MASK_SW_M) shr TELE_MASK_SW_M_SHIFT;
  FSwitches.N := (Tmp and TELE_MASK_SW_N) shr TELE_MASK_SW_N_SHIFT;
  FSwitches.O := (Tmp and TELE_MASK_SW_O) shr TELE_MASK_SW_O_SHIFT;
  FSwitches.P := (Tmp and TELE_MASK_SW_P) shr TELE_MASK_SW_P_SHIFT;
  FSwitches.S := (Tmp and TELE_MASK_SW_S) shr TELE_MASK_SW_S_SHIFT;
  FSwitches.T := (Tmp and TELE_MASK_SW_T) shr TELE_MASK_SW_T_SHIFT;
  FSwitches.LTP := (Tmp and TELE_MASK_SW_LTP) shr TELE_MASK_SW_LTP_SHIFT;
  FSwitches.RTP := (Tmp and TELE_MASK_SW_RTP) shr TELE_MASK_SW_RTP_SHIFT;
  FSwitches.LST := (Tmp and TELE_MASK_SW_LST) shr TELE_MASK_SW_LST_SHIFT;
  FSwitches.RST := (Tmp and TELE_MASK_SW_RST) shr TELE_MASK_SW_RST_SHIFT;
  FSwitches.TRN := (Tmp and TELE_MASK_SW_TRN) shr TELE_MASK_SW_TRN_SHIFT;
  FSwitches.CLR := (Tmp and TELE_MASK_SW_CLR) shr TELE_MASK_SW_CLR_SHIFT;
  FSwitches.BCK := (Tmp and TELE_MASK_SW_BCK) shr TELE_MASK_SW_BCK_SHIFT;
  FSwitches.ROL := (Tmp and TELE_MASK_SW_ROL) shr TELE_MASK_SW_ROL_SHIFT;
  FSwitches.FNC := (Tmp and TELE_MASK_SW_FNC) shr TELE_MASK_SW_FNC_SHIFT;
  FSwitches.LLEVER := (Tmp and TELE_MASK_SW_LLEVER) shr TELE_MASK_SW_LL_SHIFT;
  FSwitches.RLEVER := (Tmp and TELE_MASK_SW_RLEVER) shr TELE_MASK_SW_RL_SHIFT;
  FSwitches.RFU1 := (Tmp and TELE_MASK_SW_RFU1) shr TELE_MASK_SW_RFU1_SHIFT;
  FSwitches.RFU2 := (Tmp and TELE_MASK_SW_RFU2) shr TELE_MASK_SW_RFU2_SHIFT;
  FSwitches.RFU3 := (Tmp and TELE_MASK_SW_RFU3) shr TELE_MASK_SW_RFU3_SHIFT;
end;

procedure STRU_TELE_TXINPUT.Update;
begin
  case FCaptureId of
    TELE_CAPTURE_DIGITAL:
      ParseSwitches(FSwitches);
    TELE_CAPTURE_ANALOG_BASE:
      ParseSticks;
    TELE_CAPTURE_ANALOG_EXT:
      ParsePots;
    TELE_CAPTURE_TOUCH:
      ParseSwitches(FTouch);
  end;
end;

{ STRU_SMARTBATT }

procedure STRU_SMARTBATT.UpdateCells(const Ndx: Byte);
var
  Temp: TShortIntSensorValue;
  Cell1: TWordSensorValue;
  Cell2: TWordSensorValue;
  Cell3: TWordSensorValue;
  Cell4: TWordSensorValue;
  Cell5: TWordSensorValue;
  Cell6: TWordSensorValue;
begin
  Temp.Value := Data[1];
  Temp.Valid := Temp.Value <> INVALID_DATA_INT8;

  Cell1.Value := Data[2] or (Data[3] shl 8);
  Cell1.Valid := Cell1.Value <> INVALID_DATA_UINT16;

  Cell2.Value := Data[4] or (Data[5] shl 8);
  Cell2.Valid := Cell2.Value <> INVALID_DATA_UINT16;

  Cell3.Value := Data[6] or (Data[7] shl 8);
  Cell3.Valid := Cell3.Value <> INVALID_DATA_UINT16;

  Cell4.Value := Data[8] or (Data[9] shl 8);
  Cell4.Valid := Cell4.Value <> INVALID_DATA_UINT16;

  Cell5.Value := Data[10] or (Data[11] shl 8);
  Cell5.Valid := Cell5.Value <> INVALID_DATA_UINT16;

  Cell6.Value := Data[12] or (Data[13] shl 8);
  Cell6.Valid := Cell6.Value <> INVALID_DATA_UINT16;

  case Ndx of
    1: begin
         FCells1.Temperature := Temp;
         FCells1.Cells[0] := Cell1;
         FCells1.Cells[1] := Cell2;
         FCells1.Cells[2] := Cell3;
         FCells1.Cells[3] := Cell4;
         FCells1.Cells[4] := Cell5;
         FCells1.Cells[5] := Cell6;
         FCells1Set := True;
       end;

    2: begin
         FCells2.Temperature := Temp;
         FCells2.Cells[0] := Cell1;
         FCells2.Cells[1] := Cell2;
         FCells2.Cells[2] := Cell3;
         FCells2.Cells[3] := Cell4;
         FCells2.Cells[4] := Cell5;
         FCells2.Cells[5] := Cell6;
         FCells2Set := True;
       end;

    3: begin
         FCells3.Temperature := Temp;
         FCells3.Cells[0] := Cell1;
         FCells3.Cells[1] := Cell2;
         FCells3.Cells[2] := Cell3;
         FCells3.Cells[3] := Cell4;
         FCells3.Cells[4] := Cell5;
         FCells3.Cells[5] := Cell6;
         FCells3Set := True;
       end;
  end;
end;

procedure STRU_SMARTBATT.UpdateRealTime;
begin
  FRealTime.Temperature.Value := Data[1];
  FRealTime.Temperature.Valid := FRealTime.Temperature.Value <> INVALID_DATA_INT8;

  FRealTime.DischargeCurrent.Value := Data[2] or (Data[3] shl 8) or
    (Data[4] shl 16) or (Data[5] shl 24);
  FRealTime.DischargeCurrent.Valid := FRealTime.DischargeCurrent.Value <> INVALID_DATA_UINT32;

  FRealTime.CapacityUsage.Value := Data[6] or (Data[7] shl 8);
  FRealTime.CapacityUsage.Valid := FRealTime.CapacityUsage.Value <> INVALID_DATA_UINT16;

  FRealTime.MinCellVoltage.Value := Data[8] or (Data[9] shl 8);
  FRealTime.MinCellVoltage.Valid := FRealTime.MinCellVoltage.Value <> INVALID_DATA_UINT16;

  FRealTime.MaxCellVoltage.Value := Data[10] or (Data[11] shl 8);
  FRealTime.MAxCellVoltage.Valid := FRealTime.MaxCellVoltage.Value <> INVALID_DATA_UINT16;

  FRealTime.Rfu[0].Valid := False;
  FRealTime.Rfu[1].Valid := False;

  FRealTimeSet := True;
end;

procedure STRU_SMARTBATT.Update;
var
  MsgId: Byte;
begin
  FBattNum := Data[0] and SMARTBATT_MSG_TYPE_MASK_BATTNUMBER;
  MsgId := Data[0] and SMARTBATT_MSG_TYPE_MASK_MSGTYPE;

  FRealTimeSet := False;
  FCells1Set := False;
  FCells2Set := False;
  FCells3Set := False;

  case MsgId of
    SMARTBATT_MSG_TYPE_REALTIME:
      UpdateRealTime;

    SMARTBATT_MSG_TYPE_CELLS_1_6:
      UpdateCells(1);

    SMARTBATT_MSG_TYPE_CELLS_7_12:
      UpdateCells(2);

    SMARTBATT_MSG_TYPE_CELLS_13_18:
      UpdateCells(3);
  end;
end;

{ TTelemetrySession }

procedure TTelemetrySession.AddSmartBattInfo(const Index: Byte;
  const Id: STRU_SMARTBATT.TSmartBatteryId);
var
  i: Integer;
  Ndx: Integer;
begin
  Ndx := -1;

  for i := 0 to Length(FSmartBatts) - 1 do begin
    if FSmartBatts[i].Index = Index then begin
      Ndx := i;
      Break;
    end;
  end;

  if Ndx = -1 then begin
    Ndx := Length(FSmartBatts);
    SetLength(FSmartBatts, Ndx + 1);
    FSmartBatts[Ndx].IdSet := False;
    FSmartBatts[Ndx].LimitsSet := False;
  end;

  if not FSmartBatts[Ndx].IdSet then begin
    FSmartBatts[Ndx].Index := Index;
    FSmartBatts[Ndx].Id := Id;
    FSmartBatts[Ndx].IdSet := True;
  end;
end;

procedure TTelemetrySession.AddSmartBattInfo(const Index: Byte;
  const Limits: STRU_SMARTBATT.TSmartBatteryLimits);
var
  i: Integer;
  Ndx: Integer;
begin
  Ndx := -1;

  for i := 0 to Length(FSmartBatts) - 1 do begin
    if FSmartBatts[i].Index = Index then begin
      Ndx := i;
      Break;
    end;
  end;

  // We are here if the batt was not found.
  if Ndx = -1 then begin
    Ndx := Length(FSmartBatts);
    SetLength(FSmartBatts, Ndx + 1);
    FSmartBatts[Ndx].IdSet := False;
    FSmartBatts[Ndx].LimitsSet := False;
  end;

  if not FSmartBatts[Ndx].LimitsSet then begin
    FSmartBatts[Ndx].Index := Index;
    FSmartBatts[Ndx].Limits := Limits;
    FSmartBatts[Ndx].LimitsSet := True;
  end;
end;

constructor TTelemetrySession.Create(const Hdr: SPRM_TLM_SESSION_HEADER;
  const BindType: Byte; const ModelID: Byte; const ModelName: string;
  const ModelType: Byte; const UpdateRate: Word);
begin
  FHdr := Hdr;
  FBindType := BindType;
  FData := TList.Create;
  FModelID := ModelID;
  FModelName := ModelName;
  FModelType := ModelType;
  FTime.Min := 0;
  FTime.Max := 0;
  FPoles := 0;
  FRatioRaw := 0;
  FPolesESC := 0;
  FRatioESCRaw := 0;
  FRtc := 0;
  FRtcSet := False;
  FRtcTimestamp := 0;

  FUpdateRate := UpdateRate;
  if FUpdateRate = 0 then
    FUpdateRate := 10000;

  FSmartBatts := nil;
end;

destructor TTelemetrySession.Destroy;
var
  I: Integer;
begin
  for I := 0 to FData.Count - 1 do
    TSensorData(FData[I]).Free;
  FData.Clear;

  inherited;
end;

procedure TTelemetrySession.UpdateSensors;
var
  i: Integer;
begin
  for I := 0 to FData.Count - 1 do
    TSensorData(FData[I]).Update;
end;

function TTelemetrySession.GetBindTypeName: string;
begin
  case FBindType of
    SPRM_COMMON_BIND_NOBINDINFO:
      Result := 'No info';
    SPRM_COMMON_BIND_DSM2_1024_22:
      Result := 'DSM2 22ms';
    SPRM_COMMON_BIND_DSM2_2048_11_1:
      Result := 'DSM2 11ms';
    SPRM_COMMON_BIND_DSM2_2048_11_2:
      Result := 'DSM2 11ms';
    SPRM_COMMON_BIND_DSMX_11_1:
      Result := 'DSMX 11ms';
    SPRM_COMMON_BIND_DSMX_11_2:
      Result := 'DSMX 11ms';
    SPRM_COMMON_BIND_DSMX_22_1:
      Result := 'DSMX 22ms';
    SPRM_COMMON_BIND_DSMX_22_2:
      Result := 'DSMX 22ms';
    SPRM_COMMON_BIND_DSMJ:
      Result := 'DSMJ';
    SPRM_COMMON_BIND_DSM_MARINE:
      Result := 'DSM Marine';

    SURFACE_DSM1:
      Result := 'DSMR1';
    SURFACE_DSM2_16_5:
      Result := 'DSMR2';
    SURFACE_DSMR_11:
      Result := 'DSMR 11ms';
    SURFACE_DSMR_5:
      Result := 'DSMR 22ms';
    else
      Result := 'Unknown';
  end;
end;

function TTelemetrySession.GetDateTime: TDateTime;
begin
  if not RtcSet then
    Result := 0
  else
    Result := (FRtc / 86400) + 25569;
end;

function TTelemetrySession.GetDuration: Cardinal;
var
  Devider: Single;
begin
  Result := FTime.Max - FTime.Min;
  Devider := 10000 / UpdateRate;
  Result := Round(Result / Devider)
end;

function TTelemetrySession.GetDurationStr: string;
var
  TimeSecs: Real48;
  TimeSec: Cardinal;
  Milli: Byte;
begin
  TimeSecs := Duration / 100;
  TimeSec := Trunc(TimeSecs);
  Milli := Trunc((TimeSecs - TimeSec) * 100);
  Result := Format('%d:%2.2d:%2.2d.%2.2d', [TimeSec div 3600,
    TimeSec mod 3600 div 60, TimeSec mod 60, Milli]);
end;

function TTelemetrySession.GetModelTypeName: string;
begin
  case FModelType of
    SPRM_MODEL_FIXED_WING:
      Result := 'Fixed wing';

    SPRM_MODEL_HELICOPTER:
      Result := 'Helicopter';

    SPRM_MODEL_GLIDER:
      Result := 'Glider';

    SPRM_MODEL_MULTIROTOR:
      Result := 'Multirotor';

    else
      Result := 'Unknown [' + IntToStr(FModelType) + ']';
  end;
end;

function TTelemetrySession.GetRatio: Single;
begin
  Result := FRatioRaw * 0.01;
end;

function TTelemetrySession.GetRatioESC: Single;
begin
  Result := FRatioESCRaw * 0.01;
end;

procedure TTelemetrySession.SetEscPolesAndRatio(const Poles: Byte;
  const RatioRaw: Word);
begin
  FPolesESC := Poles;
  FRatioESCRaw := RatioRaw;
end;

procedure TTelemetrySession.SetGpsSettings(const AltByte: Byte;
  const Distance: Word; const Alarm: Byte);
begin
  if AltByte = 0 then
    FGpsSettings.AltitudeKind := akMSL
  else
    FGpsSettings.AltitudeKind := akAGL;
  FGpsSettings.Distance := Distance;
  FGpsSettings.Alarm := Alarm;
end;

procedure TTelemetrySession.SetPolesAndRatio(const Poles: Byte;
  const RatioRaw: Word);
begin
  FPoles := Poles;
  FRatioRaw := RatioRaw;
end;

procedure TTelemetrySession.SetRtc(const Rtc: UInt64; const Timestamp: Cardinal);
begin
  if not FRtcSet then begin
    FRtc := Rtc;
    FRtcTimestamp := Timestamp;
    FRtcSet := True;
  end;
end;

end.
