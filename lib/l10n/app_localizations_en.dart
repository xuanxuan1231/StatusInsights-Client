// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StatusInsights';

  @override
  String get navOverview => 'Overview';

  @override
  String get navReports => 'Report';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get overviewDescription =>
      'Track overall service status and key indicators.';

  @override
  String get reportsTitle => 'Report';

  @override
  String get reportsDescription =>
      'Report person and device status manually or automatically.';

  @override
  String get reportsPersonSectionTitle => 'Person Status Report';

  @override
  String get reportsDeviceSectionTitle => 'Device Status Report';

  @override
  String get reportsStatusLabel => 'Status';

  @override
  String get reportsDescriptionLabel => 'Description';

  @override
  String get reportsManualReportButton => 'Manual Report';

  @override
  String get reportsRegisterButton => 'Register';

  @override
  String get reportsUnregisterButton => 'Unregister';

  @override
  String get reportsRegisteredStatus => 'Registered';

  @override
  String get reportsUnregisteredStatus => 'Unregistered';

  @override
  String get reportsDeviceNotRegistered =>
      'Device is not registered. Register first.';

  @override
  String get reportsRegistrationIndependentHint =>
      'Device reporting does not depend on local registration state checks.';

  @override
  String get reportsActualStatusLabel =>
      'Actual reported status (foreground window title)';

  @override
  String get reportsStatusEmpty => '-';

  @override
  String reportsDeviceId(Object value) {
    return 'device_id: $value';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDescription =>
      'Manage alert preferences and integrations.';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageHelper => 'Choose the app display language.';

  @override
  String get settingsThemeModeLabel => 'Theme Mode';

  @override
  String get settingsThemeModeHelper =>
      'Follow system automatically, or switch to light/dark manually.';

  @override
  String get settingsEditThemeModeTitle => 'Choose Theme Mode';

  @override
  String get settingsThemeModeSystemLabel => 'Auto';

  @override
  String get settingsThemeModeLightLabel => 'Light';

  @override
  String get settingsThemeModeDarkLabel => 'Dark';

  @override
  String get settingsServiceSection => 'Service';

  @override
  String get settingsServerAddressLabel => 'Server Address';

  @override
  String get settingsServerAddressHelper =>
      'Used for uploading and pulling status data.';

  @override
  String get settingsServerAddressValue => 'https://api.example.com';

  @override
  String get settingsEditServerAddressTitle => 'Edit Server Address';

  @override
  String get settingsServerAddressInputHint =>
      'Enter a full URL, for example https://api.example.com';

  @override
  String get settingsApiKeyLabel => 'API Key';

  @override
  String get settingsApiKeyHelper =>
      'Value used for the X-API-Key request header.';

  @override
  String get settingsEditApiKeyTitle => 'Edit API Key';

  @override
  String get settingsApiKeyInputHint => 'Enter API Key';

  @override
  String get settingsWindowTitleBackendLabel => 'Window Title Source';

  @override
  String get settingsWindowTitleBackendHelper =>
      'Choose how to get foreground window title.';

  @override
  String get settingsWindowTitleCommandLabel => 'Custom Title Command';

  @override
  String get settingsWindowTitleCommandHelper =>
      'Used only when source is Custom Command.';

  @override
  String get settingsEditWindowTitleBackendTitle =>
      'Choose Window Title Source';

  @override
  String get settingsEditWindowTitleCommandTitle => 'Edit Custom Title Command';

  @override
  String get settingsWindowTitleCommandInputHint =>
      'Enter command that outputs title text';

  @override
  String get settingsWindowTitleBackendAutoLabel => 'Auto Detect';

  @override
  String get settingsWindowTitleBackendNiriLabel => 'niri';

  @override
  String get settingsWindowTitleBackendHyprlandLabel => 'Hyprland';

  @override
  String get settingsWindowTitleBackendSwayLabel => 'sway';

  @override
  String get settingsWindowTitleBackendX11Label => 'X11 (xprop)';

  @override
  String get settingsWindowTitleBackendCustomLabel => 'Custom Command';

  @override
  String get settingsValidationInvalidUrl => 'Please enter a valid URL.';

  @override
  String get settingsReportIntervalLabel => 'Auto Report Interval';

  @override
  String get settingsReportIntervalHelper =>
      'How often the app reports status automatically.';

  @override
  String get settingsReportIntervalValue => '60 s';

  @override
  String get settingsEditReportIntervalTitle => 'Edit Auto Report Interval';

  @override
  String get settingsReportIntervalInputHint => 'Enter seconds, for example 60';

  @override
  String get settingsValidationInvalidNumber =>
      'Please enter a valid positive integer.';

  @override
  String get settingsSecondsUnit => 's';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get deviceName => 'My Device';

  @override
  String get deviceNameLabel => 'Device Name';

  @override
  String get deviceNameHelper => 'Give this device a memorable name.';

  @override
  String get deviceDescription => 'For monitoring app and system status.';

  @override
  String get deviceDescriptionLabel => 'Device Description';

  @override
  String get deviceDescriptionHelper =>
      'Brief description of this device\'s purpose.';

  @override
  String get deviceTypeDesktop => 'Desktop';

  @override
  String get deviceTypeMobile => 'Mobile';

  @override
  String get deviceTypeUnknown => 'Unknown';

  @override
  String get devicesTitle => 'Devices';

  @override
  String get statusLoading => 'Loading status...';

  @override
  String get statusFetchFailed => 'Failed to fetch status';

  @override
  String get statusNoData => 'No status data available';

  @override
  String statusTitle(Object name) {
    return '$name\'s status';
  }

  @override
  String get editDeviceInfo => 'Edit Device Info';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutDescription =>
      'StatusInsights version 1.0.0. Built with Flutter.';

  @override
  String get aboutNoteProject =>
      'This project is for status insights and information display.';

  @override
  String get aboutNoteFuture =>
      'More settings and feature modules will be added continuously.';

  @override
  String get androidUsagePermissionTitle => 'Permission Required';

  @override
  String get androidUsagePermissionMessage =>
      'Please grant Usage Access permission, or the app cannot get foreground app names from other apps.';

  @override
  String get androidUsagePermissionAction => 'Open Settings';
}
