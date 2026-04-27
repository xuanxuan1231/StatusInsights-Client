import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh');

  void _setLocale(Locale locale) {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: MyHomePage(currentLocale: _locale, onLocaleChanged: _setLocale),
    );
  }
}

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

  int _selectedIndex = 0;
  String _serverAddress = _defaultServerAddress;
  int _reportIntervalSeconds = _defaultReportIntervalSeconds;

  void _setServerAddress(String value) {
    setState(() => _serverAddress = value);
  }

  void _setReportIntervalSeconds(int value) {
    setState(() => _reportIntervalSeconds = value);
  }

  List<_NavItem> _buildNavItems(AppLocalizations l10n) {
    return [
      _NavItem(
        label: l10n.navOverview,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        content: _PageContent(
          title: l10n.overviewTitle,
          description: l10n.overviewDescription,
        ),
      ),
      _NavItem(
        label: l10n.navReports,
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
        content: _PageContent(
          title: l10n.reportsTitle,
          description: l10n.reportsDescription,
        ),
      ),
      _NavItem(
        label: l10n.navSettings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        content: _SettingsContent(
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
      ),
      _NavItem(
        label: l10n.navAbout,
        icon: Icons.info_outline,
        selectedIcon: Icons.info,
        content: _AboutContent(
          appName: l10n.appName,
          author: 'HelloSWX',
          version: '1.0.0',
          notes: [
            l10n.aboutDescription,
            '本项目用于状态洞察与信息展示。',
            '后续将持续补充更多设置项与功能模块。',
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
                        child: items[_selectedIndex].content,
                      ),
                    ),
                  ],
                )
              : _BodyContent(
                  pageTitle: items[_selectedIndex].label,
                  child: items[_selectedIndex].content,
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

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({
    required this.description,
    required this.generalSectionTitle,
    required this.languageLabel,
    required this.languageHelper,
    required this.serviceSectionTitle,
    required this.serverAddressLabel,
    required this.serverAddressHelper,
    required this.serverAddressValue,
    required this.reportIntervalLabel,
    required this.reportIntervalHelper,
    required this.reportIntervalSeconds,
    required this.secondsUnit,
    required this.editServerAddressTitle,
    required this.serverAddressInputHint,
    required this.invalidUrlErrorText,
    required this.editReportIntervalTitle,
    required this.reportIntervalInputHint,
    required this.invalidNumberErrorText,
    required this.chineseLabel,
    required this.englishLabel,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onServerAddressChanged,
    required this.onReportIntervalChanged,
  });

  final String description;
  final String generalSectionTitle;
  final String languageLabel;
  final String languageHelper;
  final String serviceSectionTitle;
  final String serverAddressLabel;
  final String serverAddressHelper;
  final String serverAddressValue;
  final String reportIntervalLabel;
  final String reportIntervalHelper;
  final int reportIntervalSeconds;
  final String secondsUnit;
  final String editServerAddressTitle;
  final String serverAddressInputHint;
  final String invalidUrlErrorText;
  final String editReportIntervalTitle;
  final String reportIntervalInputHint;
  final String invalidNumberErrorText;
  final String chineseLabel;
  final String englishLabel;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<String> onServerAddressChanged;
  final ValueChanged<int> onReportIntervalChanged;

  Future<void> _showLanguageDialog(BuildContext context) async {
    String selectedCode = currentLocale.languageCode;
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(languageLabel),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'zh',
                    groupValue: selectedCode,
                    title: Text(chineseLabel),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedCode = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'en',
                    groupValue: selectedCode,
                    title: Text(englishLabel),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedCode = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selectedCode),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != currentLocale.languageCode) {
      onLocaleChanged(Locale(result));
    }
  }

  Future<void> _showServerAddressDialog(BuildContext context) async {
    final controller = TextEditingController(text: serverAddressValue);
    String? errorText;

    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editServerAddressTitle),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: serverAddressInputHint,
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final input = controller.text.trim();
                    final uri = Uri.tryParse(input);
                    final isValid =
                        uri != null &&
                        uri.hasScheme &&
                        (uri.scheme == 'http' || uri.scheme == 'https') &&
                        uri.hasAuthority;

                    if (!isValid) {
                      setDialogState(() => errorText = invalidUrlErrorText);
                      return;
                    }

                    Navigator.of(context).pop(input);
                  },
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (result != null && result != serverAddressValue) {
      onServerAddressChanged(result);
    }
  }

  Future<void> _showReportIntervalDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: reportIntervalSeconds.toString(),
    );
    String? errorText;

    final int? result = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editReportIntervalTitle),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: reportIntervalInputHint,
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final value = int.tryParse(controller.text.trim());
                    if (value == null || value <= 0) {
                      setDialogState(() => errorText = invalidNumberErrorText);
                      return;
                    }

                    Navigator.of(context).pop(value);
                  },
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (result != null && result != reportIntervalSeconds) {
      onReportIntervalChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final currentLanguageLabel = currentLocale.languageCode == 'zh'
        ? chineseLabel
        : englishLabel;

    return Align(
      alignment: Alignment.topCenter,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(description, style: textTheme.bodyLarge),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      generalSectionTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: () => _showLanguageDialog(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(languageLabel, style: textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                languageHelper,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLanguageLabel,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      serviceSectionTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _SettingsInfoRow(
                  label: serverAddressLabel,
                  helper: serverAddressHelper,
                  value: serverAddressValue,
                  onTap: () => _showServerAddressDialog(context),
                ),
                const Divider(height: 1),
                _SettingsInfoRow(
                  label: reportIntervalLabel,
                  helper: reportIntervalHelper,
                  value: '$reportIntervalSeconds $secondsUnit',
                  onTap: () => _showReportIntervalDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoRow extends StatelessWidget {
  const _SettingsInfoRow({
    required this.label,
    required this.helper,
    required this.value,
    this.onTap,
  });

  final String label;
  final String helper;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final row = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  helper,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right),
              ],
            ],
          ),
        ],
      ),
    );

    if (onTap == null) {
      return row;
    }

    return InkWell(onTap: onTap, child: row);
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({
    required this.appName,
    required this.author,
    required this.version,
    required this.notes,
  });

  final String appName;
  final String author;
  final String version;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.apps_rounded, size: 32),
                  // TODO: Replace with your own app icon widget.
                  // Example: child: Image.asset('assets/icon/app_icon.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appName, style: textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      _AboutInfoLine(label: '作者', value: author),
                      const SizedBox(height: 6),
                      _AboutInfoLine(label: '版本', value: version),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notes
                .map(
                  (note) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $note', style: textTheme.bodyMedium),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _AboutInfoLine extends StatelessWidget {
  const _AboutInfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          '$label: ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }
}

class _BodyContent extends StatelessWidget {
  const _BodyContent({required this.pageTitle, required this.child});

  final String pageTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(pageTitle, style: textTheme.headlineSmall),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
