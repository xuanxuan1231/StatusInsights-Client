import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _personStatusController = TextEditingController();
  bool _isSubmittingStatus = false;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      _personStatusController.text = appState.personStatus;
    });
  }

  @override
  void dispose() {
    _personStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          if (appState.status == AppStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context, appState, l10n, colorScheme);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Notification banners
        if (appState.lastError != null) _buildErrorBanner(context, appState, l10n),
        if (appState.lastSuccessMessage != null)
          _buildSuccessBanner(context, appState, l10n),

        // Server warning if not configured
        if (appState.serverUrl.isEmpty) _buildServerWarningCard(context, l10n, colorScheme),

        // Device Info Card
        _buildDeviceInfoCard(context, appState, l10n, colorScheme),

        const SizedBox(height: 12),

        // Registration Card
        _buildRegistrationCard(context, appState, l10n, colorScheme),

        const SizedBox(height: 12),

        // Auto Reporting Card
        _buildAutoReportingCard(context, appState, l10n, colorScheme),

        const SizedBox(height: 12),

        // Custom Status Card
        _buildCustomStatusCard(context, appState, l10n, colorScheme),

        const SizedBox(height: 12),

        // Status History Card (if any)
        if (appState.statusHistory.isNotEmpty)
          _buildStatusHistoryCard(context, appState, l10n, colorScheme),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildErrorBanner(BuildContext context, AppState appState, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialBanner(
        padding: const EdgeInsets.all(12),
        content: Text(l10n.errorFailed(appState.lastError ?? '')),
        leading: const Icon(Icons.error_outline, color: Colors.red),
        actions: [
          TextButton(
            onPressed: () => appState.clearMessages(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner(BuildContext context, AppState appState, AppLocalizations l10n) {
    String message;
    final key = appState.lastSuccessMessage;
    if (key == 'registered') {
      message = l10n.successRegistered;
    } else if (key == 'unregistered') {
      message = l10n.successUnregistered;
    } else if (key == 'status_submitted') {
      message = l10n.successStatusSubmitted;
    } else {
      message = key ?? '';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialBanner(
        padding: const EdgeInsets.all(12),
        content: Text(message),
        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        actions: [
          TextButton(
            onPressed: () => appState.clearMessages(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildServerWarningCard(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: colorScheme.errorContainer,
        child: ListTile(
          leading: Icon(Icons.cloud_off_outlined, color: colorScheme.onErrorContainer),
          title: Text(
            l10n.errorServerNotSet,
            style: TextStyle(color: colorScheme.onErrorContainer),
          ),
          trailing: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            child: Text(l10n.settings),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.devices_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.deviceInfo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(l10n.deviceName, appState.deviceName),
            const SizedBox(height: 6),
            _buildInfoRow(l10n.deviceType, _getDeviceTypeIcon(appState.deviceType)),
            const SizedBox(height: 6),
            _buildGuidRow(context, appState.guid, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidRow(BuildContext context, String guid, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            l10n.deviceGuid,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: guid));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.copied),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    guid,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.copy_outlined,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getDeviceTypeIcon(String deviceType) {
    switch (deviceType) {
      case 'windows':
        return '🪟 Windows';
      case 'macos':
        return '🍎 macOS';
      case 'linux':
        return '🐧 Linux';
      case 'android':
        return '🤖 Android';
      case 'ios':
        return '📱 iOS';
      case 'web':
        return '🌐 Web';
      default:
        return deviceType;
    }
  }

  Widget _buildRegistrationCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.how_to_reg_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.deviceStatus,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                _buildStatusBadge(appState.isRegistered, l10n, colorScheme),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!appState.isRegistered)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: appState.serverUrl.isEmpty || _isRegistering
                          ? null
                          : () => _registerDevice(appState, l10n),
                      icon: _isRegistering
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_circle_outline),
                      label: Text(l10n.registerDevice),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isRegistering
                          ? null
                          : () => _confirmUnregister(context, appState, l10n),
                      icon: const Icon(Icons.remove_circle_outline),
                      label: Text(l10n.unregisterDevice),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isRegistered, AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isRegistered ? Colors.green.withValues(alpha: 0.15) : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRegistered ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isRegistered ? Colors.green : colorScheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            isRegistered ? l10n.registered : l10n.notRegistered,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isRegistered ? Colors.green : colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoReportingCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sync_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.autoReporting,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportingInterval,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
            if (appState.currentWindowTitle != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.window_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appState.currentWindowTitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Last reported time
            if (appState.lastReportedAt != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${l10n.lastReported}: ${_formatDateTime(appState.lastReportedAt!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.isReporting ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  appState.isReporting ? l10n.autoReportingOn : l10n.autoReportingOff,
                  style: TextStyle(
                    fontSize: 13,
                    color: appState.isReporting ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Start/stop button
            Row(
              children: [
                Expanded(
                  child: appState.isReporting
                      ? OutlinedButton.icon(
                          onPressed: () => appState.stopReporting(),
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: Text(l10n.stopReporting),
                        )
                      : FilledButton.icon(
                          onPressed: !appState.isRegistered || appState.serverUrl.isEmpty
                              ? null
                              : () => appState.startReporting(),
                          icon: const Icon(Icons.play_circle_outlined),
                          label: Text(l10n.startReporting),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomStatusCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mood_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.customStatus,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _personStatusController,
              decoration: InputDecoration(
                labelText: l10n.personStatus,
                hintText: l10n.personStatusHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              maxLength: 100,
              textInputAction: TextInputAction.done,
              onChanged: (value) => appState.setPersonStatus(value),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmittingStatus || !appState.isRegistered || appState.serverUrl.isEmpty
                    ? null
                    : () => _submitCustomStatus(appState, l10n),
                icon: _isSubmittingStatus
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(l10n.submitStatus),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHistoryCard(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.statusHistory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...appState.statusHistory.take(5).map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(report.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (report.windowTitle != null)
                                Text(
                                  report.windowTitle!,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (report.personStatus != null)
                                Text(
                                  '👤 ${report.personStatus}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  Future<void> _registerDevice(AppState appState, AppLocalizations l10n) async {
    setState(() => _isRegistering = true);
    await appState.registerDevice();
    if (mounted) setState(() => _isRegistering = false);
  }

  Future<void> _confirmUnregister(
      BuildContext context, AppState appState, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmUnregister),
        content: Text(l10n.confirmUnregisterMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isRegistering = true);
      await appState.unregisterDevice();
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  Future<void> _submitCustomStatus(AppState appState, AppLocalizations l10n) async {
    setState(() => _isSubmittingStatus = true);
    await appState.submitCustomStatus(_personStatusController.text);
    if (mounted) setState(() => _isSubmittingStatus = false);
  }
}
