import 'package:flutter/foundation.dart';

import 'environment.dart';
import 'diagnostics.dart';
import 'extension_info.dart';

// Sentinel used to detect when selectedExtension was omitted vs passed null
const _DashboardStateNoValue = Object();

@immutable
class DashboardState {
  const DashboardState({
    this.selectedEnvironment = Environment.public,
    this.diagnostics,
    this.isLoading = false,
    this.error,
    this.selectedExtension,
  });

  final Environment selectedEnvironment;
  final Diagnostics? diagnostics;
  final bool isLoading;
  final String? error;
  final ExtensionInfo? selectedExtension;

  DashboardState copyWith({
    Environment? selectedEnvironment,
    Object? diagnostics = _DashboardStateNoValue,
    bool? isLoading,
    Object? error = _DashboardStateNoValue,
    Object? selectedExtension = _DashboardStateNoValue,
  }) {
    return DashboardState(
      selectedEnvironment: selectedEnvironment ?? this.selectedEnvironment,
      diagnostics: identical(diagnostics, _DashboardStateNoValue)
          ? this.diagnostics
          : diagnostics as Diagnostics?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _DashboardStateNoValue)
          ? this.error
          : error as String?,
      selectedExtension: identical(selectedExtension, _DashboardStateNoValue)
          ? this.selectedExtension
          : selectedExtension as ExtensionInfo?,
    );
  }
}
