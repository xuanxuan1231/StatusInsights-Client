import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyServerAddress = 'server_address';
  static const String _keyApiKey = 'api_key';
  static const String _keyReportInterval = 'report_interval';
  static const String _keyDeviceName = 'device_name';
  static const String _keyDeviceDescription = 'device_description';
  static const String _keyDeviceId = 'device_id';
  static const String _keyWindowTitleBackend = 'window_title_backend';
  static const String _keyWindowTitleCommand = 'window_title_command';
  static const String _keyLanguageCode = 'language_code';

  late final SharedPreferences _prefs;

  PreferencesService();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Server Address
  Future<bool> setServerAddress(String value) async {
    return _prefs.setString(_keyServerAddress, value);
  }

  String? getServerAddress() {
    return _prefs.getString(_keyServerAddress);
  }

  // API Key
  Future<bool> setApiKey(String value) async {
    return _prefs.setString(_keyApiKey, value);
  }

  String? getApiKey() {
    return _prefs.getString(_keyApiKey);
  }

  // Report Interval
  Future<bool> setReportInterval(int value) async {
    return _prefs.setInt(_keyReportInterval, value);
  }

  int? getReportInterval() {
    return _prefs.getInt(_keyReportInterval);
  }

  // Device Name
  Future<bool> setDeviceName(String value) async {
    return _prefs.setString(_keyDeviceName, value);
  }

  String? getDeviceName() {
    return _prefs.getString(_keyDeviceName);
  }

  // Device Description
  Future<bool> setDeviceDescription(String value) async {
    return _prefs.setString(_keyDeviceDescription, value);
  }

  String? getDeviceDescription() {
    return _prefs.getString(_keyDeviceDescription);
  }

  // Device ID
  Future<bool> setDeviceId(String value) async {
    return _prefs.setString(_keyDeviceId, value);
  }

  String? getDeviceId() {
    return _prefs.getString(_keyDeviceId);
  }

  // Window Title Backend
  Future<bool> setWindowTitleBackend(String value) async {
    return _prefs.setString(_keyWindowTitleBackend, value);
  }

  String? getWindowTitleBackend() {
    return _prefs.getString(_keyWindowTitleBackend);
  }

  // Window Title Command
  Future<bool> setWindowTitleCommand(String value) async {
    return _prefs.setString(_keyWindowTitleCommand, value);
  }

  String? getWindowTitleCommand() {
    return _prefs.getString(_keyWindowTitleCommand);
  }

  // Language Code
  Future<bool> setLanguageCode(String value) async {
    return _prefs.setString(_keyLanguageCode, value);
  }

  String? getLanguageCode() {
    return _prefs.getString(_keyLanguageCode);
  }
}
