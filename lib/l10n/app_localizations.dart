import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'StatusInsights'**
  String get appName;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @overviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Track overall service status and key indicators.'**
  String get overviewDescription;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportsTitle;

  /// No description provided for @reportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Report person and device status manually or automatically.'**
  String get reportsDescription;

  /// No description provided for @reportsPersonSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Person Status Report'**
  String get reportsPersonSectionTitle;

  /// No description provided for @reportsDeviceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Status Report'**
  String get reportsDeviceSectionTitle;

  /// No description provided for @reportsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get reportsStatusLabel;

  /// No description provided for @reportsDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get reportsDescriptionLabel;

  /// No description provided for @reportsManualReportButton.
  ///
  /// In en, this message translates to:
  /// **'Manual Report'**
  String get reportsManualReportButton;

  /// No description provided for @reportsRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get reportsRegisterButton;

  /// No description provided for @reportsUnregisterButton.
  ///
  /// In en, this message translates to:
  /// **'Unregister'**
  String get reportsUnregisterButton;

  /// No description provided for @reportsRegisteredStatus.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get reportsRegisteredStatus;

  /// No description provided for @reportsUnregisteredStatus.
  ///
  /// In en, this message translates to:
  /// **'Unregistered'**
  String get reportsUnregisteredStatus;

  /// No description provided for @reportsDeviceNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device is not registered. Register first.'**
  String get reportsDeviceNotRegistered;

  /// No description provided for @reportsRegistrationIndependentHint.
  ///
  /// In en, this message translates to:
  /// **'Device reporting does not depend on local registration state checks.'**
  String get reportsRegistrationIndependentHint;

  /// No description provided for @reportsActualStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Actual reported status (foreground window title)'**
  String get reportsActualStatusLabel;

  /// No description provided for @reportsStatusEmpty.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get reportsStatusEmpty;

  /// No description provided for @reportsDeviceId.
  ///
  /// In en, this message translates to:
  /// **'device_id: {value}'**
  String reportsDeviceId(Object value);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage alert preferences and integrations.'**
  String get settingsDescription;

  /// No description provided for @settingsGeneralSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralSection;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose the app display language.'**
  String get settingsLanguageHelper;

  /// No description provided for @settingsThemeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeModeLabel;

  /// No description provided for @settingsThemeModeHelper.
  ///
  /// In en, this message translates to:
  /// **'Follow system automatically, or switch to light/dark manually.'**
  String get settingsThemeModeHelper;

  /// No description provided for @settingsEditThemeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme Mode'**
  String get settingsEditThemeModeTitle;

  /// No description provided for @settingsThemeModeSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingsThemeModeSystemLabel;

  /// No description provided for @settingsThemeModeLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLightLabel;

  /// No description provided for @settingsThemeModeDarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDarkLabel;

  /// No description provided for @settingsCloseToTrayLabel.
  ///
  /// In en, this message translates to:
  /// **'Close To Tray'**
  String get settingsCloseToTrayLabel;

  /// No description provided for @settingsCloseToTrayHelper.
  ///
  /// In en, this message translates to:
  /// **'When clicking window close, hide to tray instead of exiting.'**
  String get settingsCloseToTrayHelper;

  /// No description provided for @settingsSilentStartupLabel.
  ///
  /// In en, this message translates to:
  /// **'Silent Startup'**
  String get settingsSilentStartupLabel;

  /// No description provided for @settingsSilentStartupHelper.
  ///
  /// In en, this message translates to:
  /// **'Start with the main window hidden and only show the tray icon.'**
  String get settingsSilentStartupHelper;

  /// No description provided for @settingsServiceSection.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get settingsServiceSection;

  /// No description provided for @settingsServerAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get settingsServerAddressLabel;

  /// No description provided for @settingsServerAddressHelper.
  ///
  /// In en, this message translates to:
  /// **'Used for uploading and pulling status data.'**
  String get settingsServerAddressHelper;

  /// No description provided for @settingsServerAddressValue.
  ///
  /// In en, this message translates to:
  /// **'https://api.example.com'**
  String get settingsServerAddressValue;

  /// No description provided for @settingsEditServerAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Server Address'**
  String get settingsEditServerAddressTitle;

  /// No description provided for @settingsServerAddressInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a full URL, for example https://api.example.com'**
  String get settingsServerAddressInputHint;

  /// No description provided for @settingsApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get settingsApiKeyLabel;

  /// No description provided for @settingsApiKeyHelper.
  ///
  /// In en, this message translates to:
  /// **'Value used for the X-API-Key request header.'**
  String get settingsApiKeyHelper;

  /// No description provided for @settingsEditApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit API Key'**
  String get settingsEditApiKeyTitle;

  /// No description provided for @settingsApiKeyInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter API Key'**
  String get settingsApiKeyInputHint;

  /// No description provided for @settingsWindowTitleBackendLabel.
  ///
  /// In en, this message translates to:
  /// **'Window Title Source'**
  String get settingsWindowTitleBackendLabel;

  /// No description provided for @settingsWindowTitleBackendHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose how to get foreground window title.'**
  String get settingsWindowTitleBackendHelper;

  /// No description provided for @settingsWindowTitleCommandLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Title Command'**
  String get settingsWindowTitleCommandLabel;

  /// No description provided for @settingsWindowTitleCommandHelper.
  ///
  /// In en, this message translates to:
  /// **'Used only when source is Custom Command.'**
  String get settingsWindowTitleCommandHelper;

  /// No description provided for @settingsEditWindowTitleBackendTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Window Title Source'**
  String get settingsEditWindowTitleBackendTitle;

  /// No description provided for @settingsEditWindowTitleCommandTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Custom Title Command'**
  String get settingsEditWindowTitleCommandTitle;

  /// No description provided for @settingsWindowTitleCommandInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter command that outputs title text'**
  String get settingsWindowTitleCommandInputHint;

  /// No description provided for @settingsWindowTitleBackendAutoLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto Detect'**
  String get settingsWindowTitleBackendAutoLabel;

  /// No description provided for @settingsWindowTitleBackendNiriLabel.
  ///
  /// In en, this message translates to:
  /// **'niri'**
  String get settingsWindowTitleBackendNiriLabel;

  /// No description provided for @settingsWindowTitleBackendHyprlandLabel.
  ///
  /// In en, this message translates to:
  /// **'Hyprland'**
  String get settingsWindowTitleBackendHyprlandLabel;

  /// No description provided for @settingsWindowTitleBackendSwayLabel.
  ///
  /// In en, this message translates to:
  /// **'sway'**
  String get settingsWindowTitleBackendSwayLabel;

  /// No description provided for @settingsWindowTitleBackendX11Label.
  ///
  /// In en, this message translates to:
  /// **'X11 (xprop)'**
  String get settingsWindowTitleBackendX11Label;

  /// No description provided for @settingsWindowTitleBackendCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Command'**
  String get settingsWindowTitleBackendCustomLabel;

  /// No description provided for @settingsValidationInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL.'**
  String get settingsValidationInvalidUrl;

  /// No description provided for @settingsValidationInvalidApiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key cannot be empty.'**
  String get settingsValidationInvalidApiKey;

  /// No description provided for @settingsValidationInvalidCommand.
  ///
  /// In en, this message translates to:
  /// **'Command cannot be empty.'**
  String get settingsValidationInvalidCommand;

  /// No description provided for @settingsReportIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto Report Interval'**
  String get settingsReportIntervalLabel;

  /// No description provided for @settingsReportIntervalHelper.
  ///
  /// In en, this message translates to:
  /// **'How often the app reports status automatically.'**
  String get settingsReportIntervalHelper;

  /// No description provided for @settingsReportIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'60 s'**
  String get settingsReportIntervalValue;

  /// No description provided for @settingsEditReportIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Auto Report Interval'**
  String get settingsEditReportIntervalTitle;

  /// No description provided for @settingsReportIntervalInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter seconds, for example 60'**
  String get settingsReportIntervalInputHint;

  /// No description provided for @settingsValidationInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive integer.'**
  String get settingsValidationInvalidNumber;

  /// No description provided for @settingsSecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get settingsSecondsUnit;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'My Device'**
  String get deviceName;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceNameLabel;

  /// No description provided for @deviceNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Give this device a memorable name.'**
  String get deviceNameHelper;

  /// No description provided for @deviceDescription.
  ///
  /// In en, this message translates to:
  /// **'For monitoring app and system status.'**
  String get deviceDescription;

  /// No description provided for @deviceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Description'**
  String get deviceDescriptionLabel;

  /// No description provided for @deviceDescriptionHelper.
  ///
  /// In en, this message translates to:
  /// **'Brief description of this device\'s purpose.'**
  String get deviceDescriptionHelper;

  /// No description provided for @deviceTypeDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get deviceTypeDesktop;

  /// No description provided for @deviceTypeMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get deviceTypeMobile;

  /// No description provided for @deviceTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get deviceTypeUnknown;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// No description provided for @statusLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading status...'**
  String get statusLoading;

  /// No description provided for @statusFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch status'**
  String get statusFetchFailed;

  /// No description provided for @statusNoData.
  ///
  /// In en, this message translates to:
  /// **'No status data available'**
  String get statusNoData;

  /// No description provided for @statusTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s status'**
  String statusTitle(Object name);

  /// No description provided for @editDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Device Info'**
  String get editDeviceInfo;

  /// No description provided for @deviceInfoUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device info updated.'**
  String get deviceInfoUpdateSuccess;

  /// No description provided for @deviceInfoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update device info.'**
  String get deviceInfoUpdateFailed;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'StatusInsights version 1.0.0. Built with Flutter.'**
  String get aboutDescription;

  /// No description provided for @aboutNoteProject.
  ///
  /// In en, this message translates to:
  /// **'This project is for status insights and information display.'**
  String get aboutNoteProject;

  /// No description provided for @aboutNoteFuture.
  ///
  /// In en, this message translates to:
  /// **'More settings and feature modules will be added continuously.'**
  String get aboutNoteFuture;

  /// No description provided for @androidUsagePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get androidUsagePermissionTitle;

  /// No description provided for @androidUsagePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please grant Usage Access permission, or the app cannot get foreground app names from other apps.'**
  String get androidUsagePermissionMessage;

  /// No description provided for @androidUsagePermissionAction.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get androidUsagePermissionAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
