program spmtlmviewer;

uses
  Windows,
  Vcl.Forms,
  main in 'main.pas' {fmMain},
  spektrum in 'spektrum.pas',
  progressdialog in 'progressdialog.pas' {fmProgressDialog},
  about in 'about.pas' {fmAbout},
  graph in 'graph.pas' {fmGraph},
  graphselect in 'graphselect.pas' {fmGraphSelect},
  settings in 'settings.pas' {fmSettings},
  graphsettings in 'graphsettings.pas' {fmGraphSettings},
  splash in 'splash.pas' {fmSplash},
  channelsettings in 'channelsettings.pas' {fmChannelSettings},
  renamecolumns in 'renamecolumns.pas' {fmRenameColumns},
  changepolesandratio in 'changepolesandratio.pas' {fmChangePolesAndRatio},
  selectparser in 'selectparser.pas' {fmSelectParser},
  smartbattinfodlg in 'smartbattinfodlg.pas' {fmSmartBattInforDlg},
  gpstrackinfo in 'gpstrackinfo.pas' {fmGpsTrackInfo},
  rawdata in 'rawdata.pas' {fmRawData},
  columnseditor in 'columnseditor.pas' {fmColumnsEditor},
  gpssettingsinfo in 'gpssettingsinfo.pas' {fmGpsSettingsInfo},
  offsets in 'offsets.pas' {fmOffsets};

{$R *.res}

procedure SleepGood;
var
  Cnt: Byte;
begin
  // Stupid loop but it allows to not block the app on long sleep.
  // And as it's just a 2 seconds does not matter that it is so stupid.
  Cnt := 255;
  while Cnt > 0 do begin
    Sleep(10);
    Dec(Cnt);
    Application.ProcessMessages;
  end;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Spektrum Telemetry Log Viewer';
  fmSplash := TfmSplash.Create(nil);
  fmSplash.Show;
  fmSplash.Update;

  Application.CreateForm(TfmMain, fmMain);
  if not fmMain.OpeningFile then begin
    SleepGood;

    fmSplash.Free;
    fmSplash := nil;
  end;

  Application.Run;
end.
