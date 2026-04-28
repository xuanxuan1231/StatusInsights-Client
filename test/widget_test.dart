// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:statusinsights/app.dart';

void main() {
  testWidgets('Home page shows overview title', (WidgetTester tester) async {
    // Build the app and wait for localization/widgets to settle.
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Expect the default page title (Chinese locale) to be shown.
    expect(find.text('概览'), findsWidgets);
  });
}
