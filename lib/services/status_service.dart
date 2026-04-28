import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/status_summary.dart';

class StatusService {
  final String baseUrl;

  StatusService({required this.baseUrl});

  Future<StatusSummary?> fetchStatusSummary() async {
    try {
      final url = Uri.parse('$baseUrl/status/summary');
      final response = await http
          .get(url)
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
      print('Error fetching status summary: $e');
      return null;
    }
  }
}
