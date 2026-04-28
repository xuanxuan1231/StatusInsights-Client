import 'package:flutter/material.dart';

import 'app.dart';
import 'services/preferences_service.dart';

final preferencesService = PreferencesService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferencesService.init();
  runApp(const MyApp());
}
