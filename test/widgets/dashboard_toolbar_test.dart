import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_flutter/widgets/dashboard_toolbar.dart';
import 'package:diagnostics_flutter/models.dart';

void main() {
  testWidgets(
    'DashboardToolbar renders with environment dropdown and shortcuts',
    (WidgetTester tester) async {
      // Mock extensions
      final extensions = <String, Extension>{
        'websites': Extension(),
        'paasserverless': Extension(),
      };

      Environment selectedEnvironment = Environment.public;
      String? shortcutPressed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardToolbar(
              selectedEnvironment: selectedEnvironment,
              onEnvironmentChanged: (env) {
                selectedEnvironment = env ?? Environment.public;
              },
              extensions: extensions,
              onShortcutPressed: (name) {
                shortcutPressed = name;
              },
            ),
          ),
        ),
      );

      // Verify dropdown is present
      expect(find.byType(DropdownButton<Environment>), findsOneWidget);
      expect(
        find.text('Public Cloud'),
        findsOneWidget,
      ); // Environment.public.displayName

      // Verify shortcut buttons
      expect(find.text('websites'), findsOneWidget);
      expect(find.text('paasserverless'), findsOneWidget);

      // Test shortcut button press
      await tester.tap(find.text('websites'));
      expect(shortcutPressed, 'websites');
    },
  );
}
