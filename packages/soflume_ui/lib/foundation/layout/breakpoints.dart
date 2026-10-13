import 'package:flutter/widgets.dart';

/// Screen class based on width.
enum SofScreenClass {
  /// Width < 600: Phones, compact multi-window split
  compact,

  /// 600 <= Width < 1024: Foldables, tablets, medium windows
  medium,

  /// Width >= 1024: Desktop, large tablets, widescreen monitors
  expanded;

  bool get isCompact => this == SofScreenClass.compact;
  bool get isMedium => this == SofScreenClass.medium;
  bool get isExpanded => this == SofScreenClass.expanded;
}

/// Breakpoint boundaries for responsive and adaptive layout.
class SofBreakpoints {
  const SofBreakpoints._();

  static const double compactMax = 599.0;
  static const double mediumMax = 1023.0;
  static const double expandedMin = 1024.0;

  /// Determines the [SofScreenClass] from a given width.
  static SofScreenClass ofWidth(double width) {
    if (width < expandedMin && width > compactMax) {
      return SofScreenClass.medium;
    } else if (width >= expandedMin) {
      return SofScreenClass.expanded;
    }
    return SofScreenClass.compact;
  }

  /// Determines the [SofScreenClass] from the current [BuildContext].
  static SofScreenClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ofWidth(width);
  }
}
