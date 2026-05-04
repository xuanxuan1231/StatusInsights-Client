import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/active_window_service.dart';
import '../services/android_report_service.dart';
import '../services/status_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
    required this.serverAddress,
    required this.apiKey,
    required this.deviceId,
    required this.deviceName,
    required this.deviceDescription,
    required this.deviceType,
    required this.windowTitleBackend,
    required this.windowTitleCommand,
    required this.reportIntervalSeconds,
  });

  final String serverAddress;
  final String apiKey;
  final String deviceId;
  final String deviceName;
  final String deviceDescription;
  final String deviceType;
  final String windowTitleBackend;
  final String windowTitleCommand;
  final int reportIntervalSeconds;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  static const double _desktopBreakpoint = 900;

  final TextEditingController _personStatusController = TextEditingController();
  final TextEditingController _personDescriptionController =
      TextEditingController();
  late ActiveWindowService _activeWindowService;

  late StatusService _statusService;
  Timer? _autoReportTimer;
  bool _isPersonReporting = false;
  bool _isDeviceReporting = false;
  bool _isRegistering = false;
  bool _isUnregistering = false;
  String _personResult = '';
  String _deviceResult = '';
  String _lastReportedDeviceStatus = '';
  bool get _useAndroidForegroundService =>
      defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _statusService = StatusService(
      baseUrl: widget.serverAddress,
      apiKey: widget.apiKey,
    );
    _activeWindowService = ActiveWindowService(
      backend: ActiveWindowService.backendFromValue(widget.windowTitleBackend),
      customCommand: widget.windowTitleCommand,
    );
    _startAutoDeviceReporting();
  }

  @override
  void didUpdateWidget(covariant ReportsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serverAddress != widget.serverAddress ||
        oldWidget.apiKey != widget.apiKey) {
      _statusService = StatusService(
        baseUrl: widget.serverAddress,
        apiKey: widget.apiKey,
      );
    }
    if (oldWidget.windowTitleBackend != widget.windowTitleBackend ||
        oldWidget.windowTitleCommand != widget.windowTitleCommand) {
      _activeWindowService = ActiveWindowService(
        backend: ActiveWindowService.backendFromValue(widget.windowTitleBackend),
        customCommand: widget.windowTitleCommand,
      );
    }

    final androidReportingConfigChanged =
        oldWidget.serverAddress != widget.serverAddress ||
        oldWidget.apiKey != widget.apiKey ||
        oldWidget.deviceId != widget.deviceId ||
        oldWidget.reportIntervalSeconds != widget.reportIntervalSeconds;

    if (_useAndroidForegroundService && androidReportingConfigChanged) {
      unawaited(_startAndroidForegroundReporting());
    } else if (!_useAndroidForegroundService &&
        oldWidget.reportIntervalSeconds != widget.reportIntervalSeconds) {
      _startFlutterAutoReportTimer();
    }
  }

  @override
  void dispose() {
    _stopAutoDeviceReporting();
    _personStatusController.dispose();
    _personDescriptionController.dispose();
    super.dispose();
  }

  void _startAutoDeviceReporting() {
    if (_useAndroidForegroundService) {
      unawaited(_startAndroidForegroundReporting());
      return;
    }
    _startFlutterAutoReportTimer();
  }

  void _stopAutoDeviceReporting() {
    _autoReportTimer?.cancel();
    _autoReportTimer = null;
    if (_useAndroidForegroundService) {
      unawaited(AndroidReportService.stop());
    }
  }

  void _startFlutterAutoReportTimer() {
    _autoReportTimer?.cancel();
    final interval = widget.reportIntervalSeconds <= 0
        ? 20
        : widget.reportIntervalSeconds;
    _autoReportTimer = Timer.periodic(
      Duration(seconds: interval),
      (_) => _reportDevice(isManual: false),
    );
  }

  Future<void> _startAndroidForegroundReporting() async {
    if (widget.serverAddress.trim().isEmpty || widget.deviceId.trim().isEmpty) {
      return;
    }
    try {
      await AndroidReportService.start(
        serverAddress: widget.serverAddress,
        apiKey: widget.apiKey,
        deviceId: widget.deviceId,
        intervalSeconds:
            widget.reportIntervalSeconds <= 0 ? 20 : widget.reportIntervalSeconds,
      );
    } catch (error) {
      debugPrint('Failed to start Android foreground reporting: $error');
    }
  }

  Future<void> _reportPerson() async {
    if (_isPersonReporting) {
      return;
    }
    setState(() {
      _isPersonReporting = true;
      _personResult = '';
    });
    final result = await _statusService.setPersonStatus(
      status: _personStatusController.text.trim(),
      description: _personDescriptionController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isPersonReporting = false;
      _personResult = result.message;
    });
  }

  Future<void> _registerDevice() async {
    if (_isRegistering || _isUnregistering) {
      return;
    }
    setState(() {
      _isRegistering = true;
      _deviceResult = '';
    });
    final result = await _statusService.registerDevice(
      deviceId: widget.deviceId,
      name: widget.deviceName,
      description: widget.deviceDescription,
      deviceType: widget.deviceType,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isRegistering = false;
      _deviceResult = result.message;
    });
  }

  Future<void> _unregisterDevice() async {
    if (_isRegistering || _isUnregistering) {
      return;
    }
    setState(() {
      _isUnregistering = true;
      _deviceResult = '';
    });
    final result = await _statusService.unregisterDevice(
      deviceId: widget.deviceId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isUnregistering = false;
      _deviceResult = result.message;
    });
  }

  Future<void> _reportDevice({required bool isManual}) async {
    if (_isDeviceReporting || _isRegistering || _isUnregistering) {
      return;
    }

    setState(() {
      _isDeviceReporting = true;
      if (isManual) {
        _deviceResult = '';
      }
    });
    final currentWindowTitle = await _activeWindowService
        .getForegroundWindowTitle();
    final result = await _statusService.setDeviceStatus(
      deviceId: widget.deviceId,
      status: currentWindowTitle,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isDeviceReporting = false;
      _lastReportedDeviceStatus = currentWindowTitle;
      _deviceResult = result.message;
    });
  }

  Widget _buildPersonSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsPersonSectionTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _personStatusController,
          decoration: InputDecoration(
            labelText: l10n.reportsStatusLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _personDescriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: l10n.reportsDescriptionLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _isPersonReporting ? null : _reportPerson,
          icon: _isPersonReporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
          label: Text(l10n.reportsManualReportButton),
        ),
        if (_personResult.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _personResult,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeviceSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final registerDisabled =
        _isRegistering || _isUnregistering || _isDeviceReporting;
    final unregisterDisabled =
        _isRegistering || _isUnregistering || _isDeviceReporting;
    final reportDeviceDisabled =
        _isDeviceReporting || _isRegistering || _isUnregistering;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsDeviceSectionTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.reportsDeviceId(widget.deviceId),
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.reportsRegistrationIndependentHint,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: registerDisabled ? null : _registerDevice,
              icon: _isRegistering
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.link),
              label: Text(l10n.reportsRegisterButton),
            ),
            OutlinedButton.icon(
              onPressed: unregisterDisabled ? null : _unregisterDevice,
              icon: _isUnregistering
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.link_off),
              label: Text(l10n.reportsUnregisterButton),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: reportDeviceDisabled ? null : () => _reportDevice(isManual: true),
          icon: _isDeviceReporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
          label: Text(l10n.reportsManualReportButton),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.reportsActualStatusLabel,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _lastReportedDeviceStatus.isEmpty
              ? l10n.reportsStatusEmpty
              : _lastReportedDeviceStatus,
          style: textTheme.bodyMedium,
        ),
        if (_deviceResult.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _deviceResult,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= _desktopBreakpoint;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isDesktop
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildPersonSection(
                        context,
                        textTheme,
                        colorScheme,
                        l10n,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const VerticalDivider(width: 1),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDeviceSection(
                        context,
                        textTheme,
                        colorScheme,
                        l10n,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPersonSection(context, textTheme, colorScheme, l10n),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildDeviceSection(context, textTheme, colorScheme, l10n),
                ],
              ),
      ),
    );
  }
}
