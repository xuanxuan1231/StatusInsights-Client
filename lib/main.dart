import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.initialize();

  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: const StatusInsightsApp(),
    ),
  );
}
