import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GuidService {
  static const String _guidKey = 'device_guid';
  static const _uuid = Uuid();

  static Future<String> getOrCreateGuid() async {
    final prefs = await SharedPreferences.getInstance();
    String? guid = prefs.getString(_guidKey);
    if (guid == null || guid.isEmpty) {
      guid = _uuid.v4();
      await prefs.setString(_guidKey, guid);
    }
    return guid;
  }
}
