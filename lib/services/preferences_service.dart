import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyServerAddress = 'server_address';
  static const String _keyReportInterval = 'report_interval';
  static const String _keyDeviceName = 'device_name';
  static const String _keyDeviceDescription = 'device_description';
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

  // Language Code
  Future<bool> setLanguageCode(String value) async {
    return _prefs.setString(_keyLanguageCode, value);
  }

  String? getLanguageCode() {
    return _prefs.getString(_keyLanguageCode);
  }
}
