import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _serverUrlKey = 'server_url';
  static const String _isRegisteredKey = 'is_registered';
  static const String _personStatusKey = 'person_status';

  static Future<String> getServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverUrlKey) ?? '';
  }

  static Future<void> setServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverUrlKey, url.trim());
  }

  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isRegisteredKey) ?? false;
  }

  static Future<void> setRegistered(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRegisteredKey, value);
  }

  static Future<String> getPersonStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_personStatusKey) ?? '';
  }

  static Future<void> setPersonStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_personStatusKey, status);
  }
}
