import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/app_localizations.dart';
import 'home_page.dart';
import 'main.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const MethodChannel _linuxThemeChannel = MethodChannel(
    'statusinsights/theme',
  );

  Locale _locale = const Locale('zh');
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final savedLanguageCode = preferencesService.getLanguageCode();
    final savedThemeMode = preferencesService.getThemeMode();
    if (savedLanguageCode != null) {
      setState(() {
        _locale = Locale(savedLanguageCode);
      });
    }
    if (savedThemeMode != null) {
      setState(() {
        _themeMode = _themeModeFromValue(savedThemeMode);
      });
    }
    _syncLinuxTitlebarTheme();
  }

  void _setLocale(Locale locale) {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }

    setState(() {
      _locale = locale;
    });
    preferencesService.setLanguageCode(locale.languageCode);
  }

  void _setThemeMode(String value) {
    final nextMode = _themeModeFromValue(value);
    if (_themeMode == nextMode) {
      return;
    }
    setState(() {
      _themeMode = nextMode;
    });
    preferencesService.setThemeMode(_themeModeToValue(nextMode));
    _syncLinuxTitlebarTheme();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == ThemeMode.system) {
      _syncLinuxTitlebarTheme();
    }
  }

  Future<void> _syncLinuxTitlebarTheme() async {
    if (defaultTargetPlatform != TargetPlatform.linux) {
      return;
    }
    final brightness = _effectiveBrightnessForLinux();
    final mode = brightness == Brightness.dark ? 'dark' : 'light';
    try {
      await _linuxThemeChannel.invokeMethod<void>('setGtkThemeMode', {
        'mode': mode,
      });
    } catch (_) {
      return;
    }
  }

  Brightness _effectiveBrightnessForLinux() {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  ThemeMode _themeModeFromValue(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
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
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        currentLocale: _locale,
        currentThemeModeValue: _themeModeToValue(_themeMode),
        onLocaleChanged: _setLocale,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}
