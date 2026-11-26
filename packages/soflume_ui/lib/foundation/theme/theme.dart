import 'package:flutter/widgets.dart';
import 'theme_data.dart';
import 'material_adapter.dart';
import '../tokens/colors.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../tokens/motion.dart';
import '../layout/density.dart';

export 'theme_data.dart';
export '../tokens/colors.dart';
export '../tokens/radii.dart';
export '../tokens/spacing.dart';
export '../tokens/typography.dart';
export '../tokens/motion.dart';
export '../layout/density.dart';

/// Applies Soflume theme styling to child widgets.
class SoflumeTheme extends InheritedTheme {
  const SoflumeTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final SoflumeThemeData data;

  /// Retrieves the nearest [SoflumeThemeData] from [SoflumeTheme] or [SoflumeThemeExtension],
  /// returning null if neither is present.
  static SoflumeThemeData? maybeOf(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<SoflumeTheme>();
    if (theme != null) return theme.data;
    return SoflumeThemeExtension.maybeOf(context);
  }

  /// Retrieves the nearest [SoflumeThemeData], or falls back to a default light theme.
  static SoflumeThemeData of(BuildContext context) {
    return maybeOf(context) ?? SoflumeThemeData.light();
  }

  /// Convenience accessor for colors.
  static SoflumeColors colorsOf(BuildContext context) => of(context).colors;

  /// Convenience accessor for radii.
  static SoflumeRadii radiiOf(BuildContext context) => of(context).radii;

  /// Convenience accessor for spacing.
  static SoflumeSpacing spacingOf(BuildContext context) => of(context).spacing;

  /// Convenience accessor for typography.
  static SoflumeTypography typographyOf(BuildContext context) => of(context).typography;

  /// Convenience accessor for motion.
  static SoflumeMotion motionOf(BuildContext context) => of(context).motion;

  /// Convenience accessor for density.
  static SoflumeDensity densityOf(BuildContext context) => of(context).density;

  @override
  bool updateShouldNotify(SoflumeTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return SoflumeTheme(data: data, child: child);
  }
}
