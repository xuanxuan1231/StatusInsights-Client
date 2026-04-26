import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
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
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you'll need to edit this
/// file.
///
/// First, open your project's ios/Runner directory and locate the Info.plist
/// file. Next, select the Information Property List item, select Add Item from
/// the Editor menu, then select Localizations from the pop-up menu.
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
  /// Returns a list of localizations delegates containing this delegate along
  /// with GlobalMaterialLocalizations.delegate,
  /// GlobalCupertinoLocalizations.delegate, and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or additional initialization is needed.
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
    Locale('ja'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'StatusInsights Client'**
  String get appTitle;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for server address input
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// Hint text for server address input
  ///
  /// In en, this message translates to:
  /// **'https://your-server.example.com'**
  String get serverAddressHint;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Section title for device info
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// Label for device GUID
  ///
  /// In en, this message translates to:
  /// **'Device GUID'**
  String get deviceGuid;

  /// Label for device name
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// Label for device type
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceType;

  /// Section title for device status
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatus;

  /// Status when device is not registered
  ///
  /// In en, this message translates to:
  /// **'Not Registered'**
  String get notRegistered;

  /// Status when device is registered
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// Register device button label
  ///
  /// In en, this message translates to:
  /// **'Register Device'**
  String get registerDevice;

  /// Unregister device button label
  ///
  /// In en, this message translates to:
  /// **'Unregister Device'**
  String get unregisterDevice;

  /// Section title for auto reporting
  ///
  /// In en, this message translates to:
  /// **'Auto Reporting'**
  String get autoReporting;

  /// Status when auto reporting is on
  ///
  /// In en, this message translates to:
  /// **'Auto reporting is active'**
  String get autoReportingOn;

  /// Status when auto reporting is off
  ///
  /// In en, this message translates to:
  /// **'Auto reporting is stopped'**
  String get autoReportingOff;

  /// Start reporting button label
  ///
  /// In en, this message translates to:
  /// **'Start Reporting'**
  String get startReporting;

  /// Stop reporting button label
  ///
  /// In en, this message translates to:
  /// **'Stop Reporting'**
  String get stopReporting;

  /// Label for current window title
  ///
  /// In en, this message translates to:
  /// **'Current Window'**
  String get currentWindowTitle;

  /// Text shown when no window title detected
  ///
  /// In en, this message translates to:
  /// **'None detected'**
  String get noneDetected;

  /// Section title for custom status
  ///
  /// In en, this message translates to:
  /// **'Custom Status'**
  String get customStatus;

  /// Label for person status input
  ///
  /// In en, this message translates to:
  /// **'Personal Status'**
  String get personStatus;

  /// Hint text for person status input
  ///
  /// In en, this message translates to:
  /// **'e.g. Working, In a meeting, On break...'**
  String get personStatusHint;

  /// Button to submit custom status
  ///
  /// In en, this message translates to:
  /// **'Submit Status'**
  String get submitStatus;

  /// Label for last reported time
  ///
  /// In en, this message translates to:
  /// **'Last reported'**
  String get lastReported;

  /// Text for never
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// Error when server is not configured
  ///
  /// In en, this message translates to:
  /// **'Server address is not configured'**
  String get errorServerNotSet;

  /// Error when device is not registered
  ///
  /// In en, this message translates to:
  /// **'Device is not registered'**
  String get errorNotRegistered;

  /// Success message for registration
  ///
  /// In en, this message translates to:
  /// **'Device registered successfully'**
  String get successRegistered;

  /// Success message for unregistration
  ///
  /// In en, this message translates to:
  /// **'Device unregistered successfully'**
  String get successUnregistered;

  /// Success message for status submission
  ///
  /// In en, this message translates to:
  /// **'Status submitted successfully'**
  String get successStatusSubmitted;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Operation failed: {message}'**
  String errorFailed(String message);

  /// Message when text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// Title for server settings section
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutApp;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Info about reporting interval
  ///
  /// In en, this message translates to:
  /// **'Reporting interval: every 20 seconds'**
  String get reportingInterval;

  /// Text when no window title available
  ///
  /// In en, this message translates to:
  /// **'No window detected'**
  String get noWindowTitle;

  /// Hint to tap to copy
  ///
  /// In en, this message translates to:
  /// **'Tap to copy'**
  String get tapToCopy;

  /// Message when server address is updated
  ///
  /// In en, this message translates to:
  /// **'Server address updated'**
  String get serverAddressUpdated;

  /// Title for unregister confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Unregister'**
  String get confirmUnregister;

  /// Message for unregister confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unregister this device? You can register again later.'**
  String get confirmUnregisterMessage;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Status history section title
  ///
  /// In en, this message translates to:
  /// **'Status History'**
  String get statusHistory;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
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
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
