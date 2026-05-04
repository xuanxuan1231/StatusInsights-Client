import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/status_summary.dart';

class StatusService {
  final String baseUrl;
  final String apiKey;

  StatusService({required this.baseUrl, required this.apiKey});

  Uri _buildUri(String path) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse(normalizedBase).resolve(normalizedPath);
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-API-Key': apiKey,
  };

  Future<StatusSummary?> fetchStatusSummary() async {
    try {
      final url = _buildUri('/status/summary');
      final response = await http
          .get(url, headers: _headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('timeout', 408),
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StatusSummary.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching status summary: $e');
      return null;
    }
  }

  Future<ApiCallResult> setPersonStatus({
    required String status,
    required String description,
  }) async {
    final bool shouldUnset = status.trim().isEmpty && description.trim().isEmpty;
    if (shouldUnset) {
      return _post('/status/person/unset', '{}');
    }
    final body = jsonEncode({
      'status': status,
      'description': description,
    });
    return _post('/status/person/set', body);
  }

  Future<ApiCallResult> registerDevice({
    required String deviceId,
    required String name,
    required String description,
    required String deviceType,
  }) {
    final body = jsonEncode({
      'device_id': deviceId,
      'name': name,
      'description': description,
      'device_type': deviceType,
    });
    return _post('/device/register', body);
  }

  Future<ApiCallResult> unregisterDevice({required String deviceId}) {
    return _delete('/device/unregister/$deviceId');
  }

  Future<ApiCallResult> editDevice({
    required String deviceId,
    String? name,
    String? description,
  }) {
    final nameValue = name?.trim();
    final descriptionValue = description?.trim();
    final payload = <String, dynamic>{'device_id': deviceId};
    if (nameValue != null) {
      payload['name'] = nameValue;
    }
    if (descriptionValue != null) {
      payload['description'] = descriptionValue;
    }
    final body = jsonEncode(payload);
    return _post('/device/edit', body);
  }

  Future<ApiCallResult> setDeviceStatus({
    required String deviceId,
    required String status,
  }) {
    final body = jsonEncode({
      'device_id': deviceId,
      'status': status,
    });
    return _post('/status/device/set', body);
  }

  Future<ApiCallResult> _post(String path, String body) async {
    try {
      final response = await http
          .post(_buildUri(path), headers: _headers, body: body)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('timeout', 408),
          );
      return ApiCallResult.fromResponse(response);
    } catch (e) {
      return ApiCallResult(
        success: false,
        statusCode: null,
        message: 'Request failed: $e',
      );
    }
  }

  Future<ApiCallResult> _delete(String path) async {
    try {
      final response = await http
          .delete(_buildUri(path), headers: _headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('timeout', 408),
          );
      return ApiCallResult.fromResponse(response);
    } catch (e) {
      return ApiCallResult(
        success: false,
        statusCode: null,
        message: 'Request failed: $e',
      );
    }
  }
}

class ApiCallResult {
  const ApiCallResult({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  final bool success;
  final int? statusCode;
  final String message;

  factory ApiCallResult.fromResponse(http.Response response) {
    final success = response.statusCode >= 200 && response.statusCode < 300;
    final body = response.body.trim();
    final message = body.isEmpty ? 'HTTP ${response.statusCode}' : body;
    return ApiCallResult(
      success: success,
      statusCode: response.statusCode,
      message: message,
    );
  }
}
