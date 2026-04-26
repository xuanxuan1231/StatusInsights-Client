import 'dart:io';

import 'package:flutter/foundation.dart';

class DeviceTypeService {
  /// Returns the device type string for the current platform.
  static String getDeviceType() {
    if (kIsWeb) return 'web';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  /// Returns the default device name based on the platform hostname.
  static Future<String> getDeviceName() async {
    try {
      return Platform.localHostname;
    } catch (_) {
      return 'Unknown Device';
    }
  }
}
