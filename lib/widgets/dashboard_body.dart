import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import '../pages/dashboard_page.dart'; // For DashboardState

class DashboardBody extends StatelessWidget {
  final DashboardState state;
  final TabController tabController;
  final ValueChanged<Environment?> onEnvironmentChanged;
  final ValueChanged<ExtensionInfo> onExtensionSelected;
  final ValueChanged<String> onShortcutPressed;

  const DashboardBody({
    super.key,
    required this.state,
    required this.tabController,
    required this.onEnvironmentChanged,
    required this.onExtensionSelected,
    required this.onShortcutPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }
    if (state.diagnostics == null) {
      return const Center(child: Text('No data'));
    }
    return Column(
      children: [
        DashboardToolbar(
          selectedEnvironment: state.selectedEnvironment,
          onEnvironmentChanged: onEnvironmentChanged,
          extensions: state.diagnostics!.extensions,
          onShortcutPressed: onShortcutPressed,
        ),
        // Tabs
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 600;
            return TabBar(
              controller: tabController,
              isScrollable: isDesktop,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: isDesktop
                  ? TabAlignment.start
                  : TabAlignment.center,
              tabs: [
                Tab(child: Text('Extensions', overflow: TextOverflow.ellipsis)),
                Tab(
                  child: Text(
                    'Build Information',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'Server Information',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ExtensionsTab(
                extensions: state.diagnostics!.extensions,
                selectedExtension: state.selectedExtension,
                onExtensionSelected: onExtensionSelected,
              ),
              BuildInfoTab(buildInfo: state.diagnostics!.buildInfo),
              ServerInfoTab(serverInfo: state.diagnostics!.serverInfo),
            ],
          ),
        ),
      ],
    );
  }
}
