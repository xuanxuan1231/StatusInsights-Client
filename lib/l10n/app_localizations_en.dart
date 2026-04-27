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
      'Review trends, incidents, and historical reports.';

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
  String get aboutTitle => 'About';

  @override
  String get aboutDescription =>
      'StatusInsights version 1.0.0. Built with Flutter.';
}
