// This is a basic Flutter widget test for LeafCompass.
// Updated to use the correct app widget name.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_compass_app/main.dart';

void main() {
  testWidgets('LeafCompass app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LeafCompassApp());

    // The app should load without throwing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
