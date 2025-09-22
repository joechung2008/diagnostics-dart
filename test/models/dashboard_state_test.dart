import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_flutter/models.dart';

void main() {
  test('DashboardState allows setting and clearing selectedExtension', () {
    // Create a dummy ExtensionInfo
    final extension = ExtensionInfo(extensionName: 'test-extension');

    // Start with default state (don't assume it's null in test environment)
    final initial = const DashboardState();

    // Set the selectedExtension
    final withSelection = initial.copyWith(selectedExtension: extension);
    expect(withSelection.selectedExtension, equals(extension));

    // Clear the selection (should be null after copying with null)
    final cleared = withSelection.copyWith(selectedExtension: null);
    expect(cleared.selectedExtension, isNull);
  });
}
