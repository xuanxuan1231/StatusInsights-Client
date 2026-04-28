import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'home_page.dart';
import 'main.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedLanguageCode = preferencesService.getLanguageCode();
    if (savedLanguageCode != null) {
      setState(() {
        _locale = Locale(savedLanguageCode);
      });
    }
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
