import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/device_info.dart';
import '../models/status_report.dart';

class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;

  const ApiResult.success(this.data)
      : success = true,
        error = null;

  const ApiResult.failure(this.error)
      : success = false,
        data = null;
}

class ApiService {
  final String baseUrl;

  ApiService(String baseUrl)
      : baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Register a device with the StatusInsights server.
  Future<ApiResult<void>> registerDevice(DeviceInfo device) async {
    try {
      final uri = Uri.parse('$baseUrl/api/register');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode(device.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const ApiResult.success(null);
      }
      return ApiResult.failure(_parseError(response));
    } on SocketException {
      return const ApiResult.failure('Network error: cannot reach server');
    } on HttpException catch (e) {
      return ApiResult.failure('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  /// Unregister a device from the StatusInsights server.
  Future<ApiResult<void>> unregisterDevice(String guid) async {
    try {
      final uri = Uri.parse('$baseUrl/api/unregister');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({'guid': guid}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const ApiResult.success(null);
      }
      return ApiResult.failure(_parseError(response));
    } on SocketException {
      return const ApiResult.failure('Network error: cannot reach server');
    } on HttpException catch (e) {
      return ApiResult.failure('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  /// Upload a status report to the StatusInsights server.
  Future<ApiResult<void>> uploadStatus(StatusReport report) async {
    try {
      final uri = Uri.parse('$baseUrl/api/status');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode(report.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const ApiResult.success(null);
      }
      return ApiResult.failure(_parseError(response));
    } on SocketException {
      return const ApiResult.failure('Network error: cannot reach server');
    } on HttpException catch (e) {
      return ApiResult.failure('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  String _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ??
          body['error'] as String? ??
          'HTTP ${response.statusCode}';
    } catch (_) {
      return 'HTTP ${response.statusCode}';
    }
  }
}
