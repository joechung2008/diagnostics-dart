import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_dart/widgets/dashboard_body.dart';
import 'package:diagnostics_dart/models.dart';
import 'package:diagnostics_dart/pages/dashboard_page.dart';

void main() {
  testWidgets('DashboardBody displays tabs correctly', (
    WidgetTester tester,
  ) async {
    final diagnostics = Diagnostics(
      extensions: {},
      buildInfo: BuildInfo(buildVersion: '1.0.0'),
      serverInfo: ServerInfo(
        deploymentId: 'test',
        extensionSync: ExtensionSync(totalSyncAllCount: 0),
        hostname: 'test',
        nodeVersions: 'test',
        serverId: 'test',
        uptime: 0,
      ),
    );

    final tabController = TabController(length: 3, vsync: tester);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardBody(
            state: DashboardState(diagnostics: diagnostics),
            tabController: tabController,
            onEnvironmentChanged: (env) {},
            onExtensionSelected: (ext) {},
            onShortcutPressed: (name) {},
          ),
        ),
      ),
    );

    // Wait for the widget to build
    await tester.pumpAndSettle();

    // Verify TabBar is present
    expect(find.byType(TabBar), findsOneWidget);

    // Verify tab texts
    expect(find.text('Extensions'), findsOneWidget);
    expect(find.text('Build Information'), findsOneWidget);
    expect(find.text('Server Information'), findsOneWidget);

    // Verify TabBarView is present
    expect(find.byType(TabBarView), findsOneWidget);
  });
}
