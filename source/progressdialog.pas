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

unit progressdialog;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls, System.Classes,
  Vcl.ExtCtrls, spektrum;

type
  TfmProgressDialog = class(TForm)
    ProgressBar: TProgressBar;
    btCancel: TButton;
    Timer: TTimer;
    laFileNameCaption: TLabel;
    laFileName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);

  private
    FFileName: string;
    FSessions: TList;
    FShown: Boolean;
    FTeminate: Boolean;
    FUseNewParser: Boolean;
    FFixNameReading: Boolean;

    function UpdateProgress(const Pos: Integer): Boolean;
    function GetModelName(
      const Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER): string;

    function ParseSmartBatteryInfo(const Data: TTelemetryData;
      const Session: TTelemetrySession): Boolean;
    procedure ParseOldWay;
    procedure ParseNewWay;
    procedure Parse;
    procedure SetSession(const Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
      var Session: TTelemetrySession; var Time: TSessionTime);

  public
    class function ParseFile(const FileName: string; const Sessions: TList;
      const UseNewParser: Boolean; const FixNameReading: Boolean): Boolean;
  end;


implementation

{$R *.dfm}

uses
  SysUtils, Dialogs, Windows, splash;

procedure TfmProgressDialog.btCancelClick(Sender: TObject);
begin
  FTeminate := True;
end;

procedure TfmProgressDialog.FormCreate(Sender: TObject);
begin
  FFileName := '';
  FSessions := nil;
  FShown := False;
  FTeminate := False;

  ProgressBar.Min := 0;
end;

procedure TfmProgressDialog.FormShow(Sender: TObject);
begin
  if not FShown then begin
    FShown := True;
    Timer.Enabled := True;
  end;
end;

function TfmProgressDialog.GetModelName(
  const Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER): string;
begin
  // 1.10 moved name 2 bytes left
  Result := '';

  if (Byte(Hdr.ModelName[0]) >= $20) and (Byte(Hdr.ModelName[1]) >= $20) then
    Result := string(AnsiString(Hdr.ModelName))
  else
    Result := string(AnsiString(PAnsiChar(@Hdr.ModelName[2])));
end;

procedure TfmProgressDialog.ParseOldWay;
type
  TParseMethod = (pmStandard, pmWithBadTime);
  TDataArray = array [0..39] of Byte;

var
  F: File of Byte;
  Size: Integer;
  SensorInfoSize: Byte;
  Data: TDataArray;
  Timestamp: Cardinal;
  Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
  Session: TTelemetrySession;
  Time: TSessionTime;
  SensorData: TSensorData;
  Poles: Byte;
  Ratio: Word;
  Tmp: DWORD;
  ParseMethod: TParseMethod;
  GPSData: TTelemetryData;
  GPSDataValid: Boolean;
  PrevHDR: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
  PolesESC: Byte;
  RatioESC: Word;
  Offset: UInt64;
  GpsStatsOffset: UInt64;
  GpsAltByte: Byte;
  GpsDist: Word;
  GpsAlarm: Byte;
begin
  GpsStatsOffset := 0;

  ParseMethod := pmStandard;
  if LowerCase(ExtractFileName(FFileName)) = 'parseme.tlm' then
    ParseMethod := pmWithBadTime;

  FSessions.Clear;
  AssignFile(F, FFileName);
  try
    FileMode := fmOpenRead;
    Reset(F);
    Size := FileSize(F);
    if fmSplash = nil then
      ProgressBar.Max := Size
    else
      fmSplash.ProgressBar.Max := Size;
    SensorInfoSize := 36;
    Poles := 0;
    Ratio := 0;
    PolesESC := 0;
    RatioESC := 0;
    GpsAltByte := 0;
    GpsDist := 0;
    GpsAlarm := 0;
    FillChar(PrevHdr, SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER), 0);

    try
      laFileName.Caption := ExtractFileName(FFileName);

      while not Eof(F) do begin
        if UpdateProgress(FilePos(F)) then
          Exit;

        // Header
        BlockRead(F, Data, 36);

        // Added 16.11.2015 to check 40 bytes block
        BlockRead(F, Tmp, 4);
        if Tmp = $FFFFFFFF then
          Seek(F, FilePos(F) - 4)

        else begin
          BlockRead(F, Tmp, 4);
          if Tmp = $FFFFFFFF then
            SensorInfoSize := 40;
          Seek(F, FilePos(F) - 4);
        end;
        // ===================

        // Is it header or corrupter info block?
        if PDWORD(@Data[20])^ <> $FFFFFFFF then begin
          // Header
          Timestamp := PDWORD(@Data[0])^;
          Hdr := TTelemetrySession.PSPRM_TLM_SESSION_HEADER(@Data[4])^;
          // 21.01.2024: Check name starting. It can be 2 bytes left or
          // 2 bytes right. We need to check first 2 characters.
          if FFixNameReading then begin
            if (Hdr.ModelName[0] <= #$1F) or (Hdr.ModelName[0] >= #$7F) then
            begin
              CopyMemory(@Hdr.ModelName[0], @Hdr.ModelName[2], 24);
              Hdr.ModelName[24] := #$00;
              Hdr.ModelName[25] := #$00;
            end;
          end;

        end else begin
          // Corrupter info block.
          SensorInfoSize := 20;
          Seek(F, FilePos(F) - 36);
        end;

        // Looking for first info entry.
        while not Eof(F) do begin
          if UpdateProgress(FilePos(F)) then
            Exit;

          BlockRead(F, Timestamp, 4);
          if Timestamp = $FFFFFFFF then begin
            Seek(F, FilePos(F) - 4);
            Break;
          end;
        end;

        // Sensor info.
        while not Eof(F) do begin
          if UpdateProgress(FilePos(F)) then
            Exit;

          BlockRead(F, Data, SensorInfoSize);
          if Data[4] = Data[5] then begin
            case Data[4] of
              // Standard RPM info
              TELE_DEVICE_RPM_TM1000,
              TELE_DEVICE_RPM_TM1100:
                begin
                  Poles := Data[6];
                  Ratio := (Data[11] shl 8) or Data[10];
                end;

              // ESC RPM info
              TELE_DEVICE_ESC:
                begin
                  PolesESC := Data[6];
                  RatioESC := (Data[25] shl 8) or Data[24];
                end;

              // Looking for end.
              TELE_DEVICE_GPS_STATS:
                Break;

              TELE_DEVICE_GPS_LOC:
                begin
                  GpsAltByte := Data[6];
                  GpsDist := Data[14] + (Data[15] shl 8);
                  GpsAlarm := Data[9];
                end;
            end;
          end;

          while not Eof(F) do begin
            if UpdateProgress(FilePos(F)) then
              Exit;

            BlockRead(F, Timestamp, 4);
            if Timestamp <> $FFFFFFFF then begin
              if (Timestamp <> $00000000) then begin
                BlockRead(F, Data, 4);
                if (Data[0] <> $00) and (Data[1] = $00) then begin
                  Seek(F, FilePos(F) - 8);
                    Break;
                end;
              end;

            end else begin
              Seek(F, FilePos(F) - 4);
              Break;
            end;
          end;

          if (Data[0] <> $00) and (Data[1] = $00) then
            Break;
        end;

        // Create new session.
        if PrevHdr.UpdateRate = 0 then
          PrevHdr := Hdr;
        if Hdr.UpdateRate = 0 then
          Hdr := PrevHDR;
        Session := TTelemetrySession.Create(Hdr, Hdr.BindType, Hdr.ModelNumber,
          GetModelName(Hdr), Hdr.ModelType, Hdr.UpdateRate);
        PrevHdr := Hdr;

        Session.SetEscPolesAndRatio(PolesESC, RatioESC);
        Session.SetPolesAndRatio(Poles, Ratio);
        Session.SetGpsSettings(GpsAltByte, GpsDist, GpsAlarm);

        FSessions.Add(Session);

        // Read sensor data.
        Time.Min := 0;
        Time.Max := 0;
        GPSDataValid := False;

        while not Eof(F) do begin
          if UpdateProgress(FilePos(F)) then
            Exit;

          BlockRead(F, Timestamp, 4);
          if Timestamp = 0 then begin
            // Telemetry lost. New session.
            SetSession(Hdr, Session, Time);
            Continue;
          end;

          Seek(F, FilePos(F) - 4);

          if (Timestamp <> 0) and (Timestamp <> $FFFFFFFF) and
             (HiByte(HiWord(Timestamp)) <> 0)
          then begin
            if ParseMethod = pmStandard then
              // Telemetry lost. New session. Stamp INVALID. Same header.
              // Remove previouse record.
              SetSession(Hdr, Session, Time);
          end;

          if Timestamp = $FFFFFFFF then begin
            Session.Time := Time; // Set time for previous session.
            Break;
          end;

          // Set session's min and max times.
          if Time.Min = 0 then
            Time.Min := Timestamp;
          if Time.Max = 0 then
            Time.Max := Timestamp;
          if Time.Min > Timestamp then
            Time.Min := Timestamp;
          if Time.Max < Timestamp then
            Time.Max := Timestamp;
          Session.Time := Time;

          // Read sensor data and parse.
          Offset := FilePos(F);
          BlockRead(F, Data, 20);

          SensorData := nil;
          if Data[4] = TELE_DEVICE_GPS_STATS then begin
            Move(Data[0], GPSData[0], SizeOf(TTelemetryData));
            GpsStatsOffset := Offset;
            GPSDataValid := True;

          end else begin
            if (Data[4] = TELE_DEVICE_GPS_LOC) and GPSDataValid then begin
              SensorData := TSensorData.CreateSensor(Session, GpsStatsOffset, TTelemetryData((@GPSData[0])^));
              STRU_TELE_GPS(SensorData).SetPosData(TTelemetryData((@Data[0])^), Offset);
              GpsStatsOffset := 0;
              GPSDataValid := False;

            end else begin
              if not ParseSmartBatteryInfo(TTelemetryData((@Data[0])^), Session) then
                SensorData := TSensorData.CreateSensor(Session, Offset, TTelemetryData((@Data[0])^));
            end;
          end;

          if SensorData <> nil then begin
            if SensorData.Validate then
              Session.Data.Add(SensorData)
            else
              SensorData.Free;
          end;
        end;
      end;

    except
    end;

  finally
    CloseFile(F);
  end;
end;

function TfmProgressDialog.ParseSmartBatteryInfo(const Data: TTelemetryData;
  const Session: TTelemetrySession): Boolean;
var
  Id: Byte;
  MsgId: Byte;
  Index: Byte;
  BattId: STRU_SMARTBATT.TSmartBatteryId;
  BattLimits: STRU_SMARTBATT.TSmartBatteryLimits;
begin
  Id := TSensorData.GetId(Data);

  if Id = TELE_DEVICE_SMARTBATT then begin
    Index := Data[6] and STRU_SMARTBATT.SMARTBATT_MSG_TYPE_MASK_BATTNUMBER;
    MsgId := Data[6] and STRU_SMARTBATT.SMARTBATT_MSG_TYPE_MASK_MSGTYPE;
    if (Index = INVALID_DATA_UINT8) or (MsgId = INVALID_DATA_UINT8) then
      Result := False

    else begin
      if MsgId = STRU_SMARTBATT.SMARTBATT_MSG_TYPE_ID then begin
        BattId.Chemistry := Data[7];
        BattId.Cells := Data[8];
        BattId.Manufacturer := Data[9];
        BattId.Cycles := (Data[11] shl 8) or Data[10];
        CopyMemory(@BattId.Id[0], @Data[12], 8);
        Session.AddSmartBattInfo(Index, BattId);
        Result := False;

      end else begin
        if MsgId = STRU_SMARTBATT.SMARTBATT_MSG_TYPE_LIMITS then begin
          BattLimits.Rfu := Data[7];
          BattLimits.FullCapacity := (Data[9] shl 8) or Data[10];
          BattLimits.DischargeCurrentRating := ((Data[11] shl 8) or Data[12]) * 0.1;
          BattLimits.OverDischarge := (Data[13] shl 8) or Data[12];
          BattLimits.ZeroCapacity := (Data[15] shl 8) or Data[14];
          BattLimits.FullyCharged := (Data[17] shl 8) or Data[16];
          BattLimits.MinWorkingTemp := Data[18];
          BattLimits.MaxWorkingTemp := Data[19];
          Session.AddSmartBattInfo(Index, BattLimits);
          Result := False;

        end else
          Result := False;
      end;
    end;

  end else
    Result := False;
end;

procedure TfmProgressDialog.ParseNewWay;
var
  F: File of Byte;
  Size: Integer;
  Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
  Timestamp: Cardinal;
  Poles: Byte;
  Ratio: Word;
  PolesESC: Byte;
  RatioESC: Word;
  SensorsSettings: array [0..SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER) - 1] of Byte;
  Data: TTelemetryData;
  Session: TTelemetrySession;
  Time: TSessionTime;
  SensorData: TSensorData;
  GpsDataValid: Boolean;
  GPSData: TTelemetryData;
  Id: Byte;
  Id2: Byte;
  PrevHdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
  Offset: UInt64;
  GpsStatsOffset: UInt64;
  GpsAltByte: Byte;
  GpsDist: Word;
  GpsAlarm: Byte;

  function BytesLeft: Integer;
  begin
    Result := Size - FilePos(F);
  end;

begin
  GpsStatsOffset := 0;

  FSessions.Clear;
  AssignFile(F, FFileName);
  try
    FileMode := fmOpenRead;
    Reset(F);
    Size := FileSize(F);

    if fmSplash = nil then
      ProgressBar.Max := Size
    else
      fmSplash.ProgressBar.Max := Size;

    laFileName.Caption := ExtractFileName(FFileName);

    ZeroMemory(@PrevHdr, SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER));
    while not Eof(F) do begin
      if UpdateProgress(FilePos(F)) then
        Exit;

      // Look for the header or data.
      if BytesLeft < 20 then
        Break; // Not enough data. stop parsing.

      // Read timestamp.
      BlockRead(F, Timestamp, 4);
      // Is it header or data block (with empty header).
      if Timestamp = $FFFFFFFF then begin
        if BytesLeft < SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER) then
          Break; // Incomplete header. stop parsing.

        // It is header. Read it.
        BlockRead(F, Hdr, SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER));
        // 21.01.2024: Check name starting. It can be 2 bytes left or
        // 2 bytes right. We need to check first 2 characters.
        if FFixNameReading then begin
          if (Hdr.ModelName[0] <= #$1F) or (Hdr.ModelName[0] >= #$7F) then begin
            CopyMemory(@Hdr.ModelName[0], @Hdr.ModelName[2], 24);
            Hdr.ModelName[24] := #$00;
            Hdr.ModelName[25] := #$00;
          end;
        end;

      end else begin
        // It is data block and we have empty header. Use default update rates.
        ZeroMemory(@Hdr, SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER));
        Hdr.UpdateRate := $2710;
        // We have to seek back to 4 bytes because we need to read data block together
        // with timestamp then.
        Seek(F, FilePos(F) - 4);
      end;

      // Reset sensors settings.
      Poles := 0;
      Ratio := 0;
      PolesESC := 0;
      RatioESC := 0;
      GpsAltByte := 0;
      GpsDist := 0;
      GpsAlarm := 0;

      // If we just read header we can try to find sensors settings.
      while Timestamp = $FFFFFFFF do begin
        if UpdateProgress(FilePos(F)) then
          Exit;

        // Make sure there is enough bytes in the file.
        if BytesLeft < 20 then
          Break;

        BlockRead(F, Timestamp, 4);
        // More header (Sensors settings)?
        if Timestamp <> $FFFFFFFF then begin
          // We have to seek back to 4 bytes to be able to read data block completly.
          Seek(F, FilePos(F) - 4);
          Break;
        end;

        // Read sensors settings.
        BlockRead(F, SensorsSettings, SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER));

        // Get sensor ID.
        Id := SensorsSettings[0];
        Id2 := SensorsSettings[1];

        // We are interested in Poles and Ratio settings only. The valid sensor info block
        // has sensor ID in first and second bytes (we read 4 bytes as timestamp!).
        if Id = Id2 then begin
          case Id of
            TELE_DEVICE_RPM_TM1000,
            TELE_DEVICE_RPM_TM1100:
              begin
                Poles := SensorsSettings[2];
                Ratio := (SensorsSettings[7] shl 8) or SensorsSettings[6];
              end;

            TELE_DEVICE_ESC:
              begin
                PolesESC := SensorsSettings[2];
                RatioESC := (SensorsSettings[21] shl 8) or SensorsSettings[20];
              end;

            TELE_DEVICE_GPS_LOC:
              begin
                GpsAltByte := SensorsSettings[2];
                GpsDist := SensorsSettings[10] + (SensorsSettings[11] shl 8);
                GpsAlarm := SensorsSettings[5];
              end;
          end;

          Continue;
        end;

        if Id2 = TELE_DEVICE_RPM_TM1100 then begin
          if Id = TELE_DEVICE_RPM_TM1000 then begin
            Poles := SensorsSettings[2];
            Ratio := (SensorsSettings[7] shl 8) or SensorsSettings[6];
          end;

          Continue;
        end;

        if (Id <> Id2) and (SensorsSettings[2] = $FF) and (Timestamp = $FFFFFFFF) then
          Continue;

        // Ok, we have differen bytes for model ID. Make sure if we should ignore this
        // header or it is another header and this one was without data?
        if (Id < $FA) and (Id2 <> $7E) and (SensorsSettings[2] <> $00) then begin
          // 18.09.2025: Fix with incorrect name reading from strange sensor header.
          // We must process new header only if ID1 <> $16 and ID2 <> $27
          // ===========
          if (Id <> $16) and (Id2 <> $27) then begin
          // =============
            // it appeared as we have empty data block and found new header. We have
            // seek to the header beginning and stop looking for the infor.
            Seek(F, FilePos(F) - SizeOf(TTelemetrySession.SPRM_TLM_SESSION_HEADER) - 4);
            Break;
          end;
        end;
      end;

      // Still enough bytes?
      if BytesLeft < 20 then
        Break;

      // If we have timestamp as for header we have to start parsing new header.
      if Timestamp = $FFFFFFFF then
        Continue;

      if UpdateProgress(FilePos(F)) then
        Exit;

      // Ok, we are here because have all the session information and next 20 bytes are
      // data block.
      // So we are ready to create session.
      Session := TTelemetrySession.Create(Hdr, Hdr.BindType, Hdr.ModelNumber,
        GetModelName(Hdr), Hdr.ModelType, Hdr.UpdateRate);

      Session.SetEscPolesAndRatio(PolesESC, RatioESC);
      Session.SetGpsSettings(GpsAltByte, GpsDist, GpsAlarm);
      Session.SetPolesAndRatio(Poles, Ratio);

      FSessions.Add(Session);

      Time.Min := 0;
      Time.Max := 0;
      GpsDataValid := False;
      Session.Time := Time; // Reset session time.

      // All is done, parse sensors in the session.
      while not Eof(F) do begin
        if UpdateProgress(FilePos(F)) then
          Exit;

        // Do we have enough data in the file.
        if BytesLeft < 20 then
          Break;

        // First, read timestamp.
        BlockRead(F, Timestamp, 4);
        // And seek back to be able to read full sensor data block.
        Seek(F, FilePos(F) - 4);

        // Do we still have sensor data block or it is new session?
        if Timestamp = $FFFFFFFF then begin
          Session.Time := Time; // Set time for previous session.
          Break;
        end;

        // Set session's min and max timestamps
        if Timestamp > 0 then begin
          if Time.Min = 0 then
            Time.Min := Timestamp;
          if Time.Max = 0 then
            Time.Max := Timestamp;
          if Time.Min > Timestamp then
            Time.Min := Timestamp;
          if Time.Max < Timestamp then
            Time.Max := Timestamp;
          Session.Time := Time;
        end;

        // Read sensor's data now!
        Offset := FilePos(F);
        BlockRead(F, Data, SizeOf(TTelemetryData));

        // And parse it.
        Id := TSensorData.GetId(Data);
        SensorData := nil;
        if Id = TELE_DEVICE_GPS_STATS then begin
          Move(Data[0], GPSData[0], SizeOf(TTelemetryData));
          GpsStatsOffset := Offset;
          GPSDataValid := True;

        end else begin
          if (Id = TELE_DEVICE_GPS_LOC) and GPSDataValid then begin
            SensorData := TSensorData.CreateSensor(Session, GpsStatsOffset, TTelemetryData((@GPSData[0])^));
            STRU_TELE_GPS(SensorData).SetPosData(TTelemetryData((@Data[0])^), Offset);
            GPSDataValid := False;
            GpsStatsOffset := 0;

          end else begin
            if not ParseSmartBatteryInfo(Data, Session) then
              SensorData := TSensorData.CreateSensor(Session, Offset, TTelemetryData((@Data[0])^));
          end;
        end;

        if SensorData <> nil then begin
          if SensorData.Validate then
            Session.Data.Add(SensorData)
          else
            SensorData.Free;
        end;
      end;
    end;

    UpdateProgress(Size);

  finally
    CloseFile(F);
  end;
end;

procedure TfmProgressDialog.Parse;
var
  Session: TTelemetrySession;
  I: Integer;
begin
  try
    if FUseNewParser then
      ParseNewWay
    else
      ParseOldWay;

    // Remove empty sessions.
    I := 0;
    while I < FSessions.Count do begin
      Session := TTelemetrySession(FSessions[I]);
      if (Session.Time.Min = Session.Time.Max) then begin
        Session.Free;
        FSessions.Delete(I);

      end else
        Inc(I);
    end;

  finally
    ModalResult := mrOK;
  end;
end;

class function TfmProgressDialog.ParseFile(const FileName: string;
  const Sessions: TList; const UseNewParser: Boolean;
  const FixNameReading: Boolean): Boolean;
var
  Form: TfmProgressDialog;
begin
  if FileName = '' then
    raise Exception.Create('Invalid file name.');

  if Sessions = nil then
    raise Exception.Create('Sessions list not inititalized.');

  Form := TfmProgressDialog.Create(nil);
  try
    Form.FFileName := FileName;
    Form.FSessions := Sessions;
    Form.FUseNewParser := UseNewParser;
    Form.FFixNameReading := FixNameReading;

    if fmSplash = nil then
      Result := Form.ShowModal = mrOK

    else begin
      fmSplash.ProgressBar.Min := 0;
      fmSplash.ProgressBar.Visible := True;

      fmSplash.laFileNameCaption.Visible := True;
      fmSplash.laFileName.Caption := ExtractFileName(FileName);
      fmSplash.laFileName.Visible := True;

      Form.Parse;

      Result := True;
    end;

  finally
    Form.Free;
  end;
end;

procedure TfmProgressDialog.SetSession(
  const Hdr: TTelemetrySession.SPRM_TLM_SESSION_HEADER;
  var Session: TTelemetrySession; var Time: TSessionTime);
begin
  Session.Time := Time; // Set time for previous session.
  // Reset time.
  Time.Min := 0;
  Time.Max := 0;
  // Create new session.
  Session := TTelemetrySession.Create(Hdr, Hdr.BindType, Hdr.ModelNumber,
    GetModelName(Hdr), Hdr.ModelType, Hdr.UpdateRate);

  FSessions.Add(Session);
end;

procedure TfmProgressDialog.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  Parse;
end;

function TfmProgressDialog.UpdateProgress(const Pos: Integer): Boolean;
begin
  if fmSplash = nil then begin
    ProgressBar.Position := Pos;
    //laPrecent.Caption := IntToStr(Round(Pos * 100 / ProgressBar.Max)) + ' %';

    Application.ProcessMessages;

    if FTeminate then
      ModalResult := mrCancel;

    Result := ModalResult = mrCancel;

  end else begin
    fmSplash.ProgressBar.Position := Pos;

    Application.ProcessMessages;

    Result := False;
  end;
end;

end.
