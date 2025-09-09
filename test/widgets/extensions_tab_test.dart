import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_dart/widgets/extensions_tab.dart';
import 'package:diagnostics_dart/models.dart';

void main() {
  testWidgets('ExtensionsTab displays extension list', (
    WidgetTester tester,
  ) async {
    final extensions = <String, Extension>{
      'testExtension': Extension(
        info: ExtensionInfo(extensionName: 'testExtension'),
      ),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExtensionsTab(
            extensions: extensions,
            selectedExtension: null,
            onExtensionSelected: (ext) {},
          ),
        ),
      ),
    );

    // Verify the extension name is displayed in the list
    expect(find.text('testExtension'), findsOneWidget);

    // Verify ListView is present
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('ExtensionsTab shows toggle button on small screens', (
    WidgetTester tester,
  ) async {
    final extensions = <String, Extension>{
      'testExtension': Extension(
        info: ExtensionInfo(extensionName: 'testExtension'),
      ),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400, // Simulate small screen
            height: 600,
            child: ExtensionsTab(
              extensions: extensions,
              selectedExtension: null,
              onExtensionSelected: (ext) {},
            ),
          ),
        ),
      ),
    );

    // Verify the toggle button is present
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Verify the list icon is shown initially
    expect(find.byIcon(Icons.list), findsOneWidget);
  });

  testWidgets('ExtensionsTab shows extension details when selected', (
    WidgetTester tester,
  ) async {
    final selectedExtension = ExtensionInfo(
      extensionName: 'selectedExtension',
      config: Configuration(config: {'testKey': 'testValue'}),
      stageDefinition: StageDefinition(
        stageDefinition: {
          'testStage': ['testDefinition'],
        },
      ),
    );

    final extensions = <String, Extension>{
      'selectedExtension': Extension(info: selectedExtension),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExtensionsTab(
            extensions: extensions,
            selectedExtension: selectedExtension,
            onExtensionSelected: (ext) {},
          ),
        ),
      ),
    );

    // Verify the selected extension name is displayed in details
    expect(
      find.text('selectedExtension'),
      findsNWidgets(2),
    ); // Once in list, once in details

    // Verify configuration and stage definition are shown
    expect(find.text('testKey'), findsOneWidget);
    expect(find.text('testValue'), findsOneWidget);
    expect(find.text('testStage'), findsOneWidget);
    expect(find.text('testDefinition'), findsOneWidget);
  });

  testWidgets('ExtensionsTab shows select message when no extension selected', (
    WidgetTester tester,
  ) async {
    final extensions = <String, Extension>{
      'testExtension': Extension(
        info: ExtensionInfo(extensionName: 'testExtension'),
      ),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExtensionsTab(
            extensions: extensions,
            selectedExtension: null,
            onExtensionSelected: (ext) {},
          ),
        ),
      ),
    );

    // Verify the select message is shown
    expect(find.text('Select an extension'), findsOneWidget);
  });

  testWidgets('ExtensionsTab sorts extensions alphabetically', (
    WidgetTester tester,
  ) async {
    final extensions = <String, Extension>{
      'zExtension': Extension(info: ExtensionInfo(extensionName: 'zExtension')),
      'aExtension': Extension(info: ExtensionInfo(extensionName: 'aExtension')),
      'mExtension': Extension(info: ExtensionInfo(extensionName: 'mExtension')),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExtensionsTab(
            extensions: extensions,
            selectedExtension: null,
            onExtensionSelected: (ext) {},
          ),
        ),
      ),
    );

    // Find all ListTile widgets
    final listTiles = find.byType(ListTile);
    expect(listTiles, findsNWidgets(3));

    // Verify the order is alphabetical
    final firstTile = tester.widget<ListTile>(listTiles.at(0));
    final secondTile = tester.widget<ListTile>(listTiles.at(1));
    final thirdTile = tester.widget<ListTile>(listTiles.at(2));

    expect((firstTile.title as Text).data, 'aExtension');
    expect((secondTile.title as Text).data, 'mExtension');
    expect((thirdTile.title as Text).data, 'zExtension');
  });

  testWidgets(
    'ExtensionsTab toggle switches between list and details on small screen',
    (WidgetTester tester) async {
      final selectedExtension = ExtensionInfo(
        extensionName: 'selectedExtension',
      );

      final extensions = <String, Extension>{
        'selectedExtension': Extension(info: selectedExtension),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: ExtensionsTab(
                extensions: extensions,
                selectedExtension: selectedExtension,
                onExtensionSelected: (ext) {},
              ),
            ),
          ),
        ),
      );

      // Initially shows list (since _showList starts as true)
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.text('selectedExtension'), findsOneWidget); // In list

      // Tap the toggle button to switch to details
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Now shows details icon and details view
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('selectedExtension'), findsOneWidget); // In details
    },
  );

  testWidgets('ExtensionsTab can switch between list and details views', (
    WidgetTester tester,
  ) async {
    final selectedExtension = ExtensionInfo(extensionName: 'selectedExtension');

    final extensions = <String, Extension>{
      'selectedExtension': Extension(info: selectedExtension),
    };

    // Test on small screen with selected extension
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400, // Small screen
            height: 600,
            child: ExtensionsTab(
              extensions: extensions,
              selectedExtension: selectedExtension,
              onExtensionSelected: (ext) {},
            ),
          ),
        ),
      ),
    );

    // Should have toggle button
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Initially shows list icon (since _showList starts as true)
    expect(find.byIcon(Icons.list), findsOneWidget);

    // Tap the toggle button to switch to details
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Now should show details icon
    expect(find.byIcon(Icons.info), findsOneWidget);
    expect(
      find.text('selectedExtension'),
      findsOneWidget,
    ); // Only in details view
  });

  testWidgets(
    'ExtensionsTab stays in list view when extension selected on large screen',
    (WidgetTester tester) async {
      final selectedExtension = ExtensionInfo(
        extensionName: 'selectedExtension',
      );

      final extensions = <String, Extension>{
        'selectedExtension': Extension(info: selectedExtension),
      };

      // First, create the widget with no selection on large screen
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800, // Large screen
              height: 600,
              child: ExtensionsTab(
                extensions: extensions,
                selectedExtension: null, // No selection initially
                onExtensionSelected: (ext) {},
              ),
            ),
          ),
        ),
      );

      // Initially should show list view
      expect(find.text('Select an extension'), findsOneWidget);

      // Now rebuild the widget with a selected extension
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800, // Large screen
              height: 600,
              child: ExtensionsTab(
                extensions: extensions,
                selectedExtension: selectedExtension, // Now has selection
                onExtensionSelected: (ext) {},
              ),
            ),
          ),
        ),
      );

      // On large screen, should still show both list and details side by side
      expect(
        find.text('selectedExtension'),
        findsNWidgets(2),
      ); // Once in list, once in details
      // No toggle button should be present on large screens
      expect(find.byType(ElevatedButton), findsNothing);
    },
  );
}
