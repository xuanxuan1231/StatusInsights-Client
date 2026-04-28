import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'pages/about.dart';
import 'pages/settings.dart';

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
      ),
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
