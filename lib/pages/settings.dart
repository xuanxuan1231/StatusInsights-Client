import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.description,
    required this.generalSectionTitle,
    required this.languageLabel,
    required this.languageHelper,
    required this.themeModeLabel,
    required this.themeModeHelper,
    required this.themeModeValue,
    required this.closeToTrayLabel,
    required this.closeToTrayHelper,
    required this.closeToTrayValue,
    required this.silentStartupLabel,
    required this.silentStartupHelper,
    required this.silentStartupValue,
    required this.serviceSectionTitle,
    required this.serverAddressLabel,
    required this.serverAddressHelper,
    required this.serverAddressValue,
    required this.apiKeyLabel,
    required this.apiKeyHelper,
    required this.apiKeyValue,
    required this.windowTitleBackendLabel,
    required this.windowTitleBackendHelper,
    required this.windowTitleBackendValue,
    required this.windowTitleCommandLabel,
    required this.windowTitleCommandHelper,
    required this.windowTitleCommandValue,
    required this.reportIntervalLabel,
    required this.reportIntervalHelper,
    required this.reportIntervalSeconds,
    required this.secondsUnit,
    required this.editServerAddressTitle,
    required this.editApiKeyTitle,
    required this.editThemeModeTitle,
    required this.editWindowTitleBackendTitle,
    required this.editWindowTitleCommandTitle,
    required this.serverAddressInputHint,
    required this.apiKeyInputHint,
    required this.windowTitleCommandInputHint,
    required this.invalidUrlErrorText,
    required this.invalidApiKeyErrorText,
    required this.invalidCommandErrorText,
    required this.editReportIntervalTitle,
    required this.reportIntervalInputHint,
    required this.invalidNumberErrorText,
    required this.chineseLabel,
    required this.englishLabel,
    required this.themeModeSystemLabel,
    required this.themeModeLightLabel,
    required this.themeModeDarkLabel,
    required this.windowTitleBackendAutoLabel,
    required this.windowTitleBackendNiriLabel,
    required this.windowTitleBackendHyprlandLabel,
    required this.windowTitleBackendSwayLabel,
    required this.windowTitleBackendX11Label,
    required this.windowTitleBackendCustomLabel,
    required this.showTraySettings,
    required this.showWindowTitleSettings,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    required this.onCloseToTrayChanged,
    required this.onSilentStartupChanged,
    required this.onServerAddressChanged,
    required this.onApiKeyChanged,
    required this.onWindowTitleBackendChanged,
    required this.onWindowTitleCommandChanged,
    required this.onReportIntervalChanged,
  });

  final String description;
  final String generalSectionTitle;
  final String languageLabel;
  final String languageHelper;
  final String themeModeLabel;
  final String themeModeHelper;
  final String themeModeValue;
  final String closeToTrayLabel;
  final String closeToTrayHelper;
  final bool closeToTrayValue;
  final String silentStartupLabel;
  final String silentStartupHelper;
  final bool silentStartupValue;
  final String serviceSectionTitle;
  final String serverAddressLabel;
  final String serverAddressHelper;
  final String serverAddressValue;
  final String apiKeyLabel;
  final String apiKeyHelper;
  final String apiKeyValue;
  final String windowTitleBackendLabel;
  final String windowTitleBackendHelper;
  final String windowTitleBackendValue;
  final String windowTitleCommandLabel;
  final String windowTitleCommandHelper;
  final String windowTitleCommandValue;
  final String reportIntervalLabel;
  final String reportIntervalHelper;
  final int reportIntervalSeconds;
  final String secondsUnit;
  final String editServerAddressTitle;
  final String editApiKeyTitle;
  final String editThemeModeTitle;
  final String editWindowTitleBackendTitle;
  final String editWindowTitleCommandTitle;
  final String serverAddressInputHint;
  final String apiKeyInputHint;
  final String windowTitleCommandInputHint;
  final String invalidUrlErrorText;
  final String invalidApiKeyErrorText;
  final String invalidCommandErrorText;
  final String editReportIntervalTitle;
  final String reportIntervalInputHint;
  final String invalidNumberErrorText;
  final String chineseLabel;
  final String englishLabel;
  final String themeModeSystemLabel;
  final String themeModeLightLabel;
  final String themeModeDarkLabel;
  final String windowTitleBackendAutoLabel;
  final String windowTitleBackendNiriLabel;
  final String windowTitleBackendHyprlandLabel;
  final String windowTitleBackendSwayLabel;
  final String windowTitleBackendX11Label;
  final String windowTitleBackendCustomLabel;
  final bool showTraySettings;
  final bool showWindowTitleSettings;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<String> onThemeModeChanged;
  final ValueChanged<bool> onCloseToTrayChanged;
  final ValueChanged<bool> onSilentStartupChanged;
  final ValueChanged<String> onServerAddressChanged;
  final ValueChanged<String> onApiKeyChanged;
  final ValueChanged<String> onWindowTitleBackendChanged;
  final ValueChanged<String> onWindowTitleCommandChanged;
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
                    // ignore: deprecated_member_use
                    groupValue: selectedCode,
                    title: Text(chineseLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedCode = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'en',
                    // ignore: deprecated_member_use
                    groupValue: selectedCode,
                    title: Text(englishLabel),
                    // ignore: deprecated_member_use
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

  Future<void> _showThemeModeDialog(BuildContext context) async {
    String selectedValue = themeModeValue;
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editThemeModeTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'system',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(themeModeSystemLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'light',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(themeModeLightLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'dark',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(themeModeDarkLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selectedValue),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != themeModeValue) {
      onThemeModeChanged(result);
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

  Future<void> _showApiKeyDialog(BuildContext context) async {
    final controller = TextEditingController(text: apiKeyValue);
    String? errorText;
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editApiKeyTitle),
              content: TextField(
                controller: controller,
                autofocus: true,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: apiKeyInputHint,
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
                    final value = controller.text.trim();
                    if (value.isEmpty) {
                      setDialogState(
                        () => errorText = invalidApiKeyErrorText,
                      );
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

    if (result != null && result != apiKeyValue) {
      onApiKeyChanged(result);
    }
  }

  Future<void> _showWindowTitleBackendDialog(BuildContext context) async {
    String selectedValue = windowTitleBackendValue;
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editWindowTitleBackendTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'auto',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendAutoLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'niri',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendNiriLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'hyprland',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendHyprlandLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'sway',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendSwayLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'x11',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendX11Label),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'custom',
                    // ignore: deprecated_member_use
                    groupValue: selectedValue,
                    title: Text(windowTitleBackendCustomLabel),
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => selectedValue = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selectedValue),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != windowTitleBackendValue) {
      onWindowTitleBackendChanged(result);
    }
  }

  Future<void> _showWindowTitleCommandDialog(BuildContext context) async {
    final controller = TextEditingController(text: windowTitleCommandValue);
    String? errorText;
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editWindowTitleCommandTitle),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: windowTitleCommandInputHint,
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
                    final value = controller.text.trim();
                    if (value.isEmpty && windowTitleBackendValue == 'custom') {
                      setDialogState(
                        () => errorText = invalidCommandErrorText,
                      );
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

    if (result != null && result != windowTitleCommandValue) {
      onWindowTitleCommandChanged(result);
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
                const Divider(height: 1),
                _SettingsInfoRow(
                  label: themeModeLabel,
                  helper: themeModeHelper,
                  value: _themeModeLabel(themeModeValue),
                  onTap: () => _showThemeModeDialog(context),
                ),
                if (showTraySettings) ...[
                  const Divider(height: 1),
                  _SettingsSwitchRow(
                    label: closeToTrayLabel,
                    helper: closeToTrayHelper,
                    value: closeToTrayValue,
                    onChanged: onCloseToTrayChanged,
                  ),
                  const Divider(height: 1),
                  _SettingsSwitchRow(
                    label: silentStartupLabel,
                    helper: silentStartupHelper,
                    value: silentStartupValue,
                    onChanged: onSilentStartupChanged,
                  ),
                ],
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
                  label: apiKeyLabel,
                  helper: apiKeyHelper,
                  value: _maskApiKey(apiKeyValue),
                  onTap: () => _showApiKeyDialog(context),
                ),
                if (showWindowTitleSettings) ...[
                  const Divider(height: 1),
                  _SettingsInfoRow(
                    label: windowTitleBackendLabel,
                    helper: windowTitleBackendHelper,
                    value: _backendLabel(windowTitleBackendValue),
                    onTap: () => _showWindowTitleBackendDialog(context),
                  ),
                  const Divider(height: 1),
                  _SettingsInfoRow(
                    label: windowTitleCommandLabel,
                    helper: windowTitleCommandHelper,
                    value: windowTitleCommandValue.isEmpty
                        ? '-'
                        : windowTitleCommandValue,
                    onTap: () => _showWindowTitleCommandDialog(context),
                  ),
                ],
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

  String _maskApiKey(String value) {
    if (value.isEmpty) {
      return '-';
    }
    return '********';
  }

  String _backendLabel(String value) {
    switch (value) {
      case 'niri':
        return windowTitleBackendNiriLabel;
      case 'hyprland':
        return windowTitleBackendHyprlandLabel;
      case 'sway':
        return windowTitleBackendSwayLabel;
      case 'x11':
        return windowTitleBackendX11Label;
      case 'custom':
        return windowTitleBackendCustomLabel;
      case 'auto':
      default:
        return windowTitleBackendAutoLabel;
    }
  }

  String _themeModeLabel(String value) {
    switch (value) {
      case 'light':
        return themeModeLightLabel;
      case 'dark':
        return themeModeDarkLabel;
      case 'system':
      default:
        return themeModeSystemLabel;
    }
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.label,
    required this.helper,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String helper;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxValueWidth = screenWidth * 0.38;

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
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxValueWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ],
            ),
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
