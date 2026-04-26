import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StatusInsights Client';

  @override
  String get settings => 'Settings';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get serverAddressHint => 'https://your-server.example.com';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get deviceGuid => 'Device GUID';

  @override
  String get deviceName => 'Device Name';

  @override
  String get deviceType => 'Device Type';

  @override
  String get deviceStatus => 'Device Status';

  @override
  String get notRegistered => 'Not Registered';

  @override
  String get registered => 'Registered';

  @override
  String get registerDevice => 'Register Device';

  @override
  String get unregisterDevice => 'Unregister Device';

  @override
  String get autoReporting => 'Auto Reporting';

  @override
  String get autoReportingOn => 'Auto reporting is active';

  @override
  String get autoReportingOff => 'Auto reporting is stopped';

  @override
  String get startReporting => 'Start Reporting';

  @override
  String get stopReporting => 'Stop Reporting';

  @override
  String get currentWindowTitle => 'Current Window';

  @override
  String get noneDetected => 'None detected';

  @override
  String get customStatus => 'Custom Status';

  @override
  String get personStatus => 'Personal Status';

  @override
  String get personStatusHint => 'e.g. Working, In a meeting, On break...';

  @override
  String get submitStatus => 'Submit Status';

  @override
  String get lastReported => 'Last reported';

  @override
  String get never => 'Never';

  @override
  String get errorServerNotSet => 'Server address is not configured';

  @override
  String get errorNotRegistered => 'Device is not registered';

  @override
  String get successRegistered => 'Device registered successfully';

  @override
  String get successUnregistered => 'Device unregistered successfully';

  @override
  String get successStatusSubmitted => 'Status submitted successfully';

  @override
  String errorFailed(String message) => 'Operation failed: $message';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get aboutApp => 'About';

  @override
  String get version => 'Version';

  @override
  String get reportingInterval => 'Reporting interval: every 20 seconds';

  @override
  String get noWindowTitle => 'No window detected';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get serverAddressUpdated => 'Server address updated';

  @override
  String get confirmUnregister => 'Confirm Unregister';

  @override
  String get confirmUnregisterMessage =>
      'Are you sure you want to unregister this device? You can register again later.';

  @override
  String get confirm => 'Confirm';

  @override
  String get statusHistory => 'Status History';

  @override
  String get language => 'Language';
}
