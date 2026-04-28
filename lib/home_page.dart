import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'l10n/app_localizations.dart';
import 'main.dart';
import 'models/status_summary.dart';
import 'pages/about.dart';
import 'pages/settings.dart';
import 'services/status_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double _desktopBreakpoint = 800;
  static const String _defaultServerAddress = 'https://api.example.com';
  static const int _defaultReportIntervalSeconds = 60;
  static const String _defaultDeviceName = '我的设备';
  static const String _defaultDeviceDescription = '用于监控应用和系统状态。';

  int _selectedIndex = 0;
  String _serverAddress = _defaultServerAddress;
  int _reportIntervalSeconds = _defaultReportIntervalSeconds;
  String _deviceName = _defaultDeviceName;
  String _deviceDescription = _defaultDeviceDescription;

  final GlobalKey<_OverviewPageState> _overviewPageKey =
      GlobalKey<_OverviewPageState>();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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
        serviceSectionTitle: l10n.settingsServiceSection,
        serverAddressLabel: l10n.settingsServerAddressLabel,
        serverAddressHelper: l10n.settingsServerAddressHelper,
        serverAddressValue: _serverAddress,
        reportIntervalLabel: l10n.settingsReportIntervalLabel,
        reportIntervalHelper: l10n.settingsReportIntervalHelper,
        reportIntervalSeconds: _reportIntervalSeconds,
        secondsUnit: l10n.settingsSecondsUnit,
        editServerAddressTitle: l10n.settingsEditServerAddressTitle,
        serverAddressInputHint: l10n.settingsServerAddressInputHint,
        invalidUrlErrorText: l10n.settingsValidationInvalidUrl,
        editReportIntervalTitle: l10n.settingsEditReportIntervalTitle,
        reportIntervalInputHint: l10n.settingsReportIntervalInputHint,
        invalidNumberErrorText: l10n.settingsValidationInvalidNumber,
        chineseLabel: l10n.languageChinese,
        englishLabel: l10n.languageEnglish,
        currentLocale: widget.currentLocale,
        onLocaleChanged: widget.onLocaleChanged,
        onServerAddressChanged: _setServerAddress,
        onReportIntervalChanged: _setReportIntervalSeconds,
      ),
    );
  }

  Future<void> _loadPreferences() async {
    final savedAddress = preferencesService.getServerAddress();
    final savedInterval = preferencesService.getReportInterval();
    final savedName = preferencesService.getDeviceName();
    final savedDescription = preferencesService.getDeviceDescription();

    setState(() {
      _serverAddress = savedAddress ?? _defaultServerAddress;
      _reportIntervalSeconds = savedInterval ?? _defaultReportIntervalSeconds;
      _deviceName = savedName ?? _defaultDeviceName;
      _deviceDescription = savedDescription ?? _defaultDeviceDescription;
    });
  }

  void _setServerAddress(String value) {
    setState(() => _serverAddress = value);
    preferencesService.setServerAddress(value);
    _overviewPageKey.currentState?.refresh();
  }

  void _setReportIntervalSeconds(int value) {
    setState(() => _reportIntervalSeconds = value);
    preferencesService.setReportInterval(value);
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
        content: const _PageContent(),
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
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: items.map((item) => item.content).toList(),
                        ),
                        onRefresh: _selectedIndex == 0
                            ? () => _overviewPageKey.currentState?.refresh()
                            : null,
                      ),
                    ),
                  ],
                )
              : _BodyContent(
                  pageTitle: items[_selectedIndex].label,
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: items.map((item) => item.content).toList(),
                  ),
                  onRefresh: _selectedIndex == 0
                      ? () => _overviewPageKey.currentState?.refresh()
                      : null,
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
    required this.deviceName,
    required this.deviceDescription,
    required this.onDeviceInfoChanged,
  });

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
  late StatusService _statusService;

  @override
  void initState() {
    super.initState();
    final serverAddress =
        preferencesService.getServerAddress() ?? 'https://api.example.com';
    _statusService = StatusService(baseUrl: serverAddress);
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
    final result = await _statusService.fetchStatusSummary();
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
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.editDeviceInfo),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.deviceNameLabel,
                    helperText: l10n.deviceNameHelper,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: tempName),
                  onChanged: (value) => tempName = value,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.deviceDescriptionLabel,
                    helperText: l10n.deviceDescriptionHelper,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: tempDescription),
                  onChanged: (value) => tempDescription = value,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () {
                widget.onDeviceInfoChanged(tempName, tempDescription);
                Navigator.pop(context);
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
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
                )
                .toList(),
          ],
        ],
      ),
    ];
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(child: Center(child: SizedBox.shrink()));
  }
}
