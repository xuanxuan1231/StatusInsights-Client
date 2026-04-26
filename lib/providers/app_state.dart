import 'dart:async';

import 'package:flutter/material.dart';

import '../models/device_info.dart';
import '../models/status_report.dart';
import '../services/api_service.dart';
import '../services/device_type_service.dart';
import '../services/guid_service.dart';
import '../services/settings_service.dart';
import '../services/window_title_service.dart';

enum AppStatus { loading, ready }

class AppState extends ChangeNotifier {
  static const Duration _reportingInterval = Duration(seconds: 20);

  // App state
  AppStatus _status = AppStatus.loading;
  AppStatus get status => _status;

  // Device info
  String _guid = '';
  String get guid => _guid;

  String _deviceName = '';
  String get deviceName => _deviceName;

  String _deviceType = '';
  String get deviceType => _deviceType;

  // Server settings
  String _serverUrl = '';
  String get serverUrl => _serverUrl;

  // Registration state
  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;

  // Auto-reporting state
  bool _isReporting = false;
  bool get isReporting => _isReporting;

  Timer? _reportingTimer;

  // Current window title
  String? _currentWindowTitle;
  String? get currentWindowTitle => _currentWindowTitle;

  // Person status (custom)
  String _personStatus = '';
  String get personStatus => _personStatus;

  // Last report time
  DateTime? _lastReportedAt;
  DateTime? get lastReportedAt => _lastReportedAt;

  // Last operation result
  String? _lastError;
  String? get lastError => _lastError;

  bool _lastOperationSuccess = false;
  bool get lastOperationSuccess => _lastOperationSuccess;

  String? _lastSuccessMessage;
  String? get lastSuccessMessage => _lastSuccessMessage;

  // Status history (last 10 entries)
  final List<StatusReport> _statusHistory = [];
  List<StatusReport> get statusHistory => List.unmodifiable(_statusHistory);

  // Initialize the app state
  Future<void> initialize() async {
    _status = AppStatus.loading;
    notifyListeners();

    _guid = await GuidService.getOrCreateGuid();
    _deviceName = await DeviceTypeService.getDeviceName();
    _deviceType = DeviceTypeService.getDeviceType();
    _serverUrl = await SettingsService.getServerUrl();
    _isRegistered = await SettingsService.isRegistered();
    _personStatus = await SettingsService.getPersonStatus();

    _status = AppStatus.ready;
    notifyListeners();
  }

  // --- Server settings ---

  Future<void> updateServerUrl(String url) async {
    _serverUrl = url;
    await SettingsService.setServerUrl(url);
    notifyListeners();
  }

  // --- Device registration ---

  Future<bool> registerDevice() async {
    if (_serverUrl.isEmpty) {
      _setError('Server URL is not configured');
      return false;
    }

    final api = ApiService(_serverUrl);
    final deviceInfo = DeviceInfo(
      guid: _guid,
      name: _deviceName,
      deviceType: _deviceType,
    );

    final result = await api.registerDevice(deviceInfo);
    if (result.success) {
      _isRegistered = true;
      await SettingsService.setRegistered(true);
      _setSuccess('registered');
      notifyListeners();
      return true;
    } else {
      _setError(result.error ?? 'Registration failed');
      return false;
    }
  }

  Future<bool> unregisterDevice() async {
    if (_serverUrl.isEmpty) {
      _setError('Server URL is not configured');
      return false;
    }

    // Stop reporting if active
    if (_isReporting) {
      stopReporting();
    }

    final api = ApiService(_serverUrl);
    final result = await api.unregisterDevice(_guid);

    if (result.success) {
      _isRegistered = false;
      await SettingsService.setRegistered(false);
      _setSuccess('unregistered');
      notifyListeners();
      return true;
    } else {
      _setError(result.error ?? 'Unregistration failed');
      return false;
    }
  }

  // --- Auto-reporting ---

  void startReporting() {
    if (_isReporting) return;
    _isReporting = true;
    notifyListeners();

    // Report immediately, then on interval
    _doReport();
    _reportingTimer = Timer.periodic(_reportingInterval, (_) => _doReport());
  }

  void stopReporting() {
    _reportingTimer?.cancel();
    _reportingTimer = null;
    _isReporting = false;
    notifyListeners();
  }

  Future<void> _doReport() async {
    if (_serverUrl.isEmpty || !_isRegistered) return;

    final title = await WindowTitleService.getActiveWindowTitle();
    _currentWindowTitle = title;

    final report = StatusReport(
      guid: _guid,
      windowTitle: title,
      personStatus: _personStatus.isNotEmpty ? _personStatus : null,
    );

    final api = ApiService(_serverUrl);
    final result = await api.uploadStatus(report);

    if (result.success) {
      _lastReportedAt = DateTime.now();
      _addToHistory(report);
    }

    notifyListeners();
  }

  // --- Custom status ---

  void setPersonStatus(String status) {
    _personStatus = status;
    SettingsService.setPersonStatus(status);
    notifyListeners();
  }

  Future<bool> submitCustomStatus(String personStatus) async {
    if (_serverUrl.isEmpty) {
      _setError('Server URL is not configured');
      return false;
    }
    if (!_isRegistered) {
      _setError('Device is not registered');
      return false;
    }

    setPersonStatus(personStatus);

    final title = await WindowTitleService.getActiveWindowTitle();
    _currentWindowTitle = title;

    final report = StatusReport(
      guid: _guid,
      windowTitle: title,
      personStatus: personStatus.isNotEmpty ? personStatus : null,
    );

    final api = ApiService(_serverUrl);
    final result = await api.uploadStatus(report);

    if (result.success) {
      _lastReportedAt = DateTime.now();
      _addToHistory(report);
      _setSuccess('status_submitted');
      notifyListeners();
      return true;
    } else {
      _setError(result.error ?? 'Status submission failed');
      return false;
    }
  }

  // --- Helpers ---

  void _addToHistory(StatusReport report) {
    _statusHistory.insert(0, report);
    if (_statusHistory.length > 10) {
      _statusHistory.removeLast();
    }
  }

  void _setError(String error) {
    _lastError = error;
    _lastOperationSuccess = false;
    _lastSuccessMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _lastSuccessMessage = message;
    _lastOperationSuccess = true;
    _lastError = null;
    notifyListeners();
  }

  void clearMessages() {
    _lastError = null;
    _lastSuccessMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _reportingTimer?.cancel();
    super.dispose();
  }
}
