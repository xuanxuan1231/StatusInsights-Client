import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'l10n/app_localizations.dart';
import 'main.dart';
import 'models/status_summary.dart';
import 'pages/about.dart';
import 'pages/reports.dart';
import 'pages/settings.dart';
import 'services/active_window_service.dart';
import 'services/status_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.currentLocale,
    required this.currentThemeModeValue,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final Locale currentLocale;
  final String currentThemeModeValue;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<String> onThemeModeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double _desktopBreakpoint = 800;
  static const String _defaultServerAddress = 'https://api.example.com';
  static const int _defaultReportIntervalSeconds = 60;
  static const String _defaultDeviceName = '我的设备';
  static const String _defaultDeviceDescription = '用于监控应用和系统状态。';
  static const String _defaultApiKey = '';
  static const String _defaultWindowTitleBackend = 'auto';
  static const String _defaultWindowTitleCommand = '';
  static const bool _defaultCloseToTray = true;
  static const bool _defaultSilentStartup = false;

  int _selectedIndex = 0;
  String _serverAddress = _defaultServerAddress;
  String _apiKey = _defaultApiKey;
  String _windowTitleBackend = _defaultWindowTitleBackend;
  String _windowTitleCommand = _defaultWindowTitleCommand;
  int _reportIntervalSeconds = _defaultReportIntervalSeconds;
  String _deviceName = _defaultDeviceName;
  String _deviceDescription = _defaultDeviceDescription;
  String _deviceId = '';
  bool _closeToTray = _defaultCloseToTray;
  bool _silentStartup = _defaultSilentStartup;

  final GlobalKey<_OverviewPageState> _overviewPageKey =
      GlobalKey<_OverviewPageState>();
  bool _androidUsageAccessPromptShown = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkAndroidUsageAccessPermission();
  }

  Future<void> _checkAndroidUsageAccessPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android ||
        _androidUsageAccessPromptShown) {
      return;
    }
    final hasPermission =
        await ActiveWindowService.hasAndroidUsageStatsPermission();
    if (hasPermission || !mounted) {
      return;
    }
    _androidUsageAccessPromptShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _showAndroidUsageAccessDialog();
    });
  }

  Future<void> _showAndroidUsageAccessDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.androidUsagePermissionTitle),
          content: Text(l10n.androidUsagePermissionMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () async {
                await ActiveWindowService.openAndroidUsageAccessSettings();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.androidUsagePermissionAction),
            ),
          ],
        );
      },
    );
  }

  _NavItem _buildSettingsNavItem(AppLocalizations l10n) {
    return _NavItem(
      label: l10n.navSettings,
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      content: SettingsPage(
        description: l10n.settingsDescription,
        generalSectionTitle: l10n.settingsGeneralSection,
        languageLabel: l10n.settingsLanguageLabel,
        languageHelper: l10n.settingsLanguageHelper,
        themeModeLabel: l10n.settingsThemeModeLabel,
        themeModeHelper: l10n.settingsThemeModeHelper,
        themeModeValue: widget.currentThemeModeValue,
        closeToTrayLabel: l10n.settingsCloseToTrayLabel,
        closeToTrayHelper: l10n.settingsCloseToTrayHelper,
        closeToTrayValue: _closeToTray,
        silentStartupLabel: l10n.settingsSilentStartupLabel,
        silentStartupHelper: l10n.settingsSilentStartupHelper,
        silentStartupValue: _silentStartup,
        serviceSectionTitle: l10n.settingsServiceSection,
        serverAddressLabel: l10n.settingsServerAddressLabel,
        serverAddressHelper: l10n.settingsServerAddressHelper,
        serverAddressValue: _serverAddress,
        apiKeyLabel: l10n.settingsApiKeyLabel,
        apiKeyHelper: l10n.settingsApiKeyHelper,
        apiKeyValue: _apiKey,
        windowTitleBackendLabel: l10n.settingsWindowTitleBackendLabel,
        windowTitleBackendHelper: l10n.settingsWindowTitleBackendHelper,
        windowTitleBackendValue: _windowTitleBackend,
        windowTitleCommandLabel: l10n.settingsWindowTitleCommandLabel,
        windowTitleCommandHelper: l10n.settingsWindowTitleCommandHelper,
        windowTitleCommandValue: _windowTitleCommand,
        reportIntervalLabel: l10n.settingsReportIntervalLabel,
        reportIntervalHelper: l10n.settingsReportIntervalHelper,
        reportIntervalSeconds: _reportIntervalSeconds,
        secondsUnit: l10n.settingsSecondsUnit,
        editServerAddressTitle: l10n.settingsEditServerAddressTitle,
        editApiKeyTitle: l10n.settingsEditApiKeyTitle,
        editThemeModeTitle: l10n.settingsEditThemeModeTitle,
        editWindowTitleBackendTitle: l10n.settingsEditWindowTitleBackendTitle,
        editWindowTitleCommandTitle: l10n.settingsEditWindowTitleCommandTitle,
        serverAddressInputHint: l10n.settingsServerAddressInputHint,
        apiKeyInputHint: l10n.settingsApiKeyInputHint,
        windowTitleCommandInputHint: l10n.settingsWindowTitleCommandInputHint,
        invalidUrlErrorText: l10n.settingsValidationInvalidUrl,
        invalidApiKeyErrorText: l10n.settingsValidationInvalidApiKey,
        invalidCommandErrorText: l10n.settingsValidationInvalidCommand,
        editReportIntervalTitle: l10n.settingsEditReportIntervalTitle,
        reportIntervalInputHint: l10n.settingsReportIntervalInputHint,
        invalidNumberErrorText: l10n.settingsValidationInvalidNumber,
        chineseLabel: l10n.languageChinese,
        englishLabel: l10n.languageEnglish,
        themeModeSystemLabel: l10n.settingsThemeModeSystemLabel,
        themeModeLightLabel: l10n.settingsThemeModeLightLabel,
        themeModeDarkLabel: l10n.settingsThemeModeDarkLabel,
        windowTitleBackendAutoLabel: l10n.settingsWindowTitleBackendAutoLabel,
        windowTitleBackendNiriLabel: l10n.settingsWindowTitleBackendNiriLabel,
        windowTitleBackendHyprlandLabel:
            l10n.settingsWindowTitleBackendHyprlandLabel,
        windowTitleBackendSwayLabel: l10n.settingsWindowTitleBackendSwayLabel,
        windowTitleBackendX11Label: l10n.settingsWindowTitleBackendX11Label,
        windowTitleBackendCustomLabel:
            l10n.settingsWindowTitleBackendCustomLabel,
        showTraySettings: !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS),
        showWindowTitleSettings:
            !kIsWeb && defaultTargetPlatform == TargetPlatform.linux,
        currentLocale: widget.currentLocale,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: widget.onThemeModeChanged,
        onCloseToTrayChanged: _setCloseToTray,
        onSilentStartupChanged: _setSilentStartup,
        onServerAddressChanged: _setServerAddress,
        onApiKeyChanged: _setApiKey,
        onWindowTitleBackendChanged: _setWindowTitleBackend,
        onWindowTitleCommandChanged: _setWindowTitleCommand,
        onReportIntervalChanged: _setReportIntervalSeconds,
      ),
    );
  }

  Future<void> _loadPreferences() async {
    final savedAddress = preferencesService.getServerAddress();
    final savedApiKey = preferencesService.getApiKey();
    final savedInterval = preferencesService.getReportInterval();
    final savedName = preferencesService.getDeviceName();
    final savedDescription = preferencesService.getDeviceDescription();
    final savedWindowTitleBackend = preferencesService.getWindowTitleBackend();
    final savedWindowTitleCommand = preferencesService.getWindowTitleCommand();
    final savedCloseToTray = preferencesService.getCloseToTray();
    final savedSilentStartup = preferencesService.getSilentStartup();
    var savedDeviceId = preferencesService.getDeviceId();
    if (savedDeviceId == null || savedDeviceId.isEmpty) {
      savedDeviceId = _generateDeviceId();
      preferencesService.setDeviceId(savedDeviceId);
    }

    setState(() {
      _serverAddress = savedAddress ?? _defaultServerAddress;
      _apiKey = savedApiKey ?? _defaultApiKey;
      _windowTitleBackend =
          savedWindowTitleBackend ?? _defaultWindowTitleBackend;
      _windowTitleCommand =
          savedWindowTitleCommand ?? _defaultWindowTitleCommand;
      _reportIntervalSeconds = savedInterval ?? _defaultReportIntervalSeconds;
      _deviceName = savedName ?? _defaultDeviceName;
      _deviceDescription = savedDescription ?? _defaultDeviceDescription;
      _deviceId = savedDeviceId!;
      _closeToTray = savedCloseToTray ?? _defaultCloseToTray;
      _silentStartup = savedSilentStartup ?? _defaultSilentStartup;
    });
  }

  void _setServerAddress(String value) {
    setState(() => _serverAddress = value);
    preferencesService.setServerAddress(value);
    _overviewPageKey.currentState?.refresh();
  }

  void _setApiKey(String value) {
    setState(() => _apiKey = value);
    preferencesService.setApiKey(value);
    _overviewPageKey.currentState?.refresh();
  }

  void _setWindowTitleBackend(String value) {
    setState(() => _windowTitleBackend = value);
    preferencesService.setWindowTitleBackend(value);
  }

  void _setWindowTitleCommand(String value) {
    setState(() => _windowTitleCommand = value);
    preferencesService.setWindowTitleCommand(value);
  }

  void _setReportIntervalSeconds(int value) {
    setState(() => _reportIntervalSeconds = value);
    preferencesService.setReportInterval(value);
  }

  void _setCloseToTray(bool value) {
    setState(() => _closeToTray = value);
    preferencesService.setCloseToTray(value);
  }

  void _setSilentStartup(bool value) {
    setState(() => _silentStartup = value);
    preferencesService.setSilentStartup(value);
  }

  void _setDeviceName(String value) {
    setState(() => _deviceName = value);
    preferencesService.setDeviceName(value);
  }

  void _setDeviceDescription(String value) {
    setState(() => _deviceDescription = value);
    preferencesService.setDeviceDescription(value);
  }

  List<_NavItem> _buildNavItems(AppLocalizations l10n) {
    return [
      _NavItem(
        label: l10n.navOverview,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        content: OverviewPage(
          key: _overviewPageKey,
          deviceId: _deviceId,
          deviceName: _deviceName,
          deviceDescription: _deviceDescription,
          onDeviceInfoChanged: (name, description) {
            _setDeviceName(name);
            _setDeviceDescription(description);
          },
        ),
      ),
      _NavItem(
        label: l10n.navReports,
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
        content: ReportsPage(
          serverAddress: _serverAddress,
          apiKey: _apiKey,
          deviceId: _deviceId,
          deviceName: _deviceName,
          deviceDescription: _deviceDescription,
          deviceType: _getDeviceTypeForApi(),
          windowTitleBackend: _windowTitleBackend,
          windowTitleCommand: _windowTitleCommand,
          reportIntervalSeconds: _reportIntervalSeconds,
        ),
      ),
      _buildSettingsNavItem(l10n),
      _NavItem(
        label: l10n.navAbout,
        icon: Icons.info_outline,
        selectedIcon: Icons.info,
        content: AboutPage(
          appName: l10n.appName,
          author: 'HelloSWX',
          version: '1.0.0',
          notes: [
            l10n.aboutDescription,
            l10n.aboutNoteProject,
            l10n.aboutNoteFuture,
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _buildNavItems(l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= _desktopBreakpoint;

        return Scaffold(
          body: isDesktop
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: items
                          .map(
                            (item) => NavigationRailDestination(
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                              label: Text(item.label),
                            ),
                          )
                          .toList(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _BodyContent(
                        pageTitle: items[_selectedIndex].label,
                        onRefresh: _selectedIndex == 0
                            ? () => _overviewPageKey.currentState?.refresh()
                            : null,
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: items.map((item) => item.content).toList(),
                        ),
                      ),
                    ),
                  ],
                )
              : _BodyContent(
                  pageTitle: items[_selectedIndex].label,
                  onRefresh: _selectedIndex == 0
                      ? () => _overviewPageKey.currentState?.refresh()
                      : null,
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: items.map((item) => item.content).toList(),
                  ),
                ),
          bottomNavigationBar: isDesktop
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  destinations: items
                      .map(
                        (item) => NavigationDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: item.label,
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }

  String _getDeviceTypeForApi() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'unknown';
    }
  }

  String _generateDeviceId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String twoDigits(int value) => value.toRadixString(16).padLeft(2, '0');
    final hex = bytes.map(twoDigits).toList();
    return '${hex[0]}${hex[1]}${hex[2]}${hex[3]}-'
        '${hex[4]}${hex[5]}-'
        '${hex[6]}${hex[7]}-'
        '${hex[8]}${hex[9]}-'
        '${hex[10]}${hex[11]}${hex[12]}${hex[13]}${hex[14]}${hex[15]}';
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.content,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget content;
}

class _BodyContent extends StatelessWidget {
  const _BodyContent({
    required this.pageTitle,
    required this.child,
    this.onRefresh,
  });

  final String pageTitle;
  final Widget child;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(pageTitle, style: textTheme.headlineSmall),
                  ),
                ),
                if (onRefresh != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onRefresh,
                  ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class OverviewPage extends StatefulWidget {
  const OverviewPage({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.deviceDescription,
    required this.onDeviceInfoChanged,
  });

  final String deviceId;
  final String deviceName;
  final String deviceDescription;
  final Function(String, String) onDeviceInfoChanged;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Timer? _timer;
  StatusSummary? _statusData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _fetchStatus();
    });
  }

  Future<void> _fetchStatus() async {
    final serverAddress =
        preferencesService.getServerAddress() ?? 'https://api.example.com';
    final apiKey = preferencesService.getApiKey() ?? '';
    final statusService = StatusService(baseUrl: serverAddress, apiKey: apiKey);
    final result = await statusService.fetchStatusSummary();
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _statusData = result;
        _isLoading = false;
        _errorMessage = result == null ? l10n.statusFetchFailed : null;
      });
    }
  }

  Future<void> refresh() async {
    setState(() => _isLoading = true);
    await _fetchStatus();
  }

  String _getDeviceType() {
    final l10n = AppLocalizations.of(context)!;
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return l10n.deviceTypeDesktop;
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return l10n.deviceTypeMobile;
    }
    return l10n.deviceTypeUnknown;
  }

  IconData _getDeviceIcon() {
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return Icons.desktop_mac;
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return Icons.phone_android;
    }
    return Icons.devices;
  }

  void _showEditDeviceInfoDialog(BuildContext context) {
    String tempName = widget.deviceName;
    String tempDescription = widget.deviceDescription;
    final messenger = ScaffoldMessenger.of(context);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController(text: tempName);
        final descriptionController = TextEditingController(text: tempDescription);
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final l10n = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(l10n.editDeviceInfo),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    TextField(
                      controller: nameController,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: l10n.deviceNameLabel,
                        helperText: l10n.deviceNameHelper,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => tempName = value,
                    ),
                    TextField(
                      controller: descriptionController,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: l10n.deviceDescriptionLabel,
                        helperText: l10n.deviceDescriptionHelper,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => tempDescription = value,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    MaterialLocalizations.of(dialogContext).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final newName = nameController.text.trim();
                          final newDescription = descriptionController.text.trim();
                          final oldName = widget.deviceName.trim();
                          final oldDescription = widget.deviceDescription.trim();

                          if (newName == oldName &&
                              newDescription == oldDescription) {
                            Navigator.pop(dialogContext);
                            return;
                          }

                          setDialogState(() => isSubmitting = true);

                          final serverAddress =
                              preferencesService.getServerAddress() ??
                              'https://api.example.com';
                          final apiKey = preferencesService.getApiKey() ?? '';
                          final statusService = StatusService(
                            baseUrl: serverAddress,
                            apiKey: apiKey,
                          );
                          final result = await statusService.editDevice(
                            deviceId: widget.deviceId,
                            name: newName != oldName ? newName : null,
                            description: newDescription != oldDescription
                                ? newDescription
                                : null,
                          );

                          if (!mounted) {
                            return;
                          }

                          if (result.success) {
                            widget.onDeviceInfoChanged(newName, newDescription);
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.deviceInfoUpdateSuccess)),
                            );
                            return;
                          }

                          if (dialogContext.mounted) {
                            setDialogState(() => isSubmitting = false);
                          }
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                '${l10n.deviceInfoUpdateFailed} ${result.message}',
                              ),
                            ),
                          );
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          MaterialLocalizations.of(dialogContext).okButtonLabel,
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            // Device info card
            Card(
              child: InkWell(
                onTap: () => _showEditDeviceInfoDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Device icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primaryContainer,
                        ),
                        child: Icon(
                          _getDeviceIcon(),
                          color: colorScheme.onPrimaryContainer,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Device info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            Text(
                              widget.deviceName,
                              style: textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.deviceDescription,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getDeviceType(),
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Edit icon
                      Icon(
                        Icons.edit_outlined,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            // Status summary section
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.statusLoading, style: textTheme.bodyMedium),
                  ],
                ),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              )
            else if (_statusData != null)
              ..._buildStatusContent(textTheme, colorScheme, l10n)
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.statusNoData, style: textTheme.bodyMedium),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatusContent(
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final data = _statusData!;
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.statusTitle(data.name), style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Text(
                      data.person.status,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data.person.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (data.devices.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.devicesTitle, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            ...data.devices
                .map(
                  (device) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.secondaryContainer,
                              ),
                              child: Icon(
                                device.deviceType.toLowerCase() == 'linux' ||
                                        device.deviceType.toLowerCase() ==
                                            'windows' ||
                                        device.deviceType.toLowerCase() ==
                                            'macos'
                                    ? Icons.desktop_mac
                                    : Icons.phone_android,
                                color: colorScheme.onSecondaryContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 2,
                                children: [
                                  Text(
                                    device.name,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    device.description,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    device.status,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    ];
  }
}
