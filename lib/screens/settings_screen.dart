import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _serverUrlController = TextEditingController();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _serverUrlController.text = appState.serverUrl;
    _serverUrlController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final appState = context.read<AppState>();
    setState(() {
      _hasChanges = _serverUrlController.text.trim() != appState.serverUrl;
    });
  }

  @override
  void dispose() {
    _serverUrlController.removeListener(_onTextChanged);
    _serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: () => _saveSettings(context, l10n),
              child: Text(l10n.save),
            ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Server Settings Section
              _buildSectionHeader(context, l10n.serverSettings, Icons.cloud_outlined),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _serverUrlController,
                        decoration: InputDecoration(
                          labelText: l10n.serverAddress,
                          hintText: l10n.serverAddressHint,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.link_outlined),
                          suffixIcon: _serverUrlController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _serverUrlController.clear();
                                  },
                                )
                              : null,
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _saveSettings(context, l10n),
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'e.g. https://statusinsights.example.com',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _hasChanges ? () => _saveSettings(context, l10n) : null,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(l10n.save),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Device Info Section
              _buildSectionHeader(context, l10n.deviceInfo, Icons.devices_outlined),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        context,
                        icon: Icons.perm_device_information_outlined,
                        label: l10n.deviceName,
                        value: appState.deviceName,
                        colorScheme: colorScheme,
                      ),
                      const Divider(height: 24),
                      _buildInfoTile(
                        context,
                        icon: Icons.computer_outlined,
                        label: l10n.deviceType,
                        value: appState.deviceType,
                        colorScheme: colorScheme,
                      ),
                      const Divider(height: 24),
                      _buildInfoTile(
                        context,
                        icon: Icons.fingerprint_outlined,
                        label: l10n.deviceGuid,
                        value: appState.guid,
                        isMonospace: true,
                        colorScheme: colorScheme,
                        subtitle: Text(
                          l10n.tapToCopy,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        onTap: () => _copyGuid(context, appState.guid, l10n),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader(context, l10n.aboutApp, Icons.info_outline),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.monitoring,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          l10n.appTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          l10n.reportingInterval,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
    bool isMonospace = false,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isMonospace ? 12 : 14,
                      fontFamily: isMonospace ? 'monospace' : null,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    subtitle,
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.copy_outlined,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings(BuildContext context, AppLocalizations l10n) async {
    final appState = context.read<AppState>();
    final url = _serverUrlController.text.trim();
    await appState.updateServerUrl(url);
    setState(() => _hasChanges = false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.serverAddressUpdated),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyGuid(BuildContext context, String guid, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: guid));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copied),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _doCopy(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
