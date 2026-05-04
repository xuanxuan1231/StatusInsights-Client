import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AndroidReportService {
  static const MethodChannel _channel = MethodChannel(
    'statusinsights/device_report_service',
  );

  static Future<void> start({
    required String serverAddress,
    required String apiKey,
    required String deviceId,
    int intervalSeconds = 20,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    await _channel.invokeMethod<void>('startForegroundReporting', {
      'serverAddress': serverAddress,
      'apiKey': apiKey,
      'deviceId': deviceId,
      'intervalSeconds': intervalSeconds,
    });
  }

  static Future<void> stop() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    await _channel.invokeMethod<void>('stopForegroundReporting');
  }
}
