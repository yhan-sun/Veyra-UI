import 'package:flutter/widgets.dart';
import '../tokens/colors.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../tokens/motion.dart';
import '../layout/density.dart';

/// Complete configuration data for the Soflume UI design system.
@immutable
class SoflumeThemeData {
  const SoflumeThemeData({
    required this.brightness,
    required this.colors,
    required this.radii,
    required this.spacing,
    required this.typography,
    required this.motion,
    required this.density,
    this.reducedTransparency = false,
  });

  /// Factory for the default light theme.
  factory SoflumeThemeData.light({
    Color? customAccent,
    SoflumeDensity density = SoflumeDensity.comfortable,
    SoflumeMotion motion = SoflumeMotion.standard,
    bool reducedTransparency = false,
  }) {
    final colors = SoflumeColors.light(customAccent: customAccent);
    final typography = SoflumeTypography.standard().applyColors(colors);
    return SoflumeThemeData(
      brightness: Brightness.light,
      colors: colors,
      radii: const SoflumeRadii(),
      spacing: const SoflumeSpacing(),
      typography: typography,
      motion: motion,
      density: density,
      reducedTransparency: reducedTransparency,
    );
  }

  /// Factory for the default dark theme.
  factory SoflumeThemeData.dark({
    Color? customAccent,
    SoflumeDensity density = SoflumeDensity.comfortable,
    SoflumeMotion motion = SoflumeMotion.standard,
    bool reducedTransparency = false,
  }) {
    final colors = SoflumeColors.dark(customAccent: customAccent);
    final typography = SoflumeTypography.standard().applyColors(colors);
    return SoflumeThemeData(
      brightness: Brightness.dark,
      colors: colors,
      radii: const SoflumeRadii(),
      spacing: const SoflumeSpacing(),
      typography: typography,
      motion: motion,
      density: density,
      reducedTransparency: reducedTransparency,
    );
  }

  final Brightness brightness;
  final SoflumeColors colors;
  final SoflumeRadii radii;
  final SoflumeSpacing spacing;
  final SoflumeTypography typography;
  final SoflumeMotion motion;
  final SoflumeDensity density;
  final bool reducedTransparency;

  bool get isDark => brightness == Brightness.dark;

  SoflumeThemeData copyWith({
    Brightness? brightness,
    SoflumeColors? colors,
    SoflumeRadii? radii,
    SoflumeSpacing? spacing,
    SoflumeTypography? typography,
    SoflumeMotion? motion,
    SoflumeDensity? density,
    bool? reducedTransparency,
  }) {
    return SoflumeThemeData(
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
      radii: radii ?? this.radii,
      spacing: spacing ?? this.spacing,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      density: density ?? this.density,
      reducedTransparency: reducedTransparency ?? this.reducedTransparency,
    );
  }

  static SoflumeThemeData lerp(SoflumeThemeData a, SoflumeThemeData b, double t) {
    return SoflumeThemeData(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      colors: SoflumeColors.lerp(a.colors, b.colors, t),
      radii: SoflumeRadii.lerp(a.radii, b.radii, t),
      spacing: SoflumeSpacing.lerp(a.spacing, b.spacing, t),
      typography: SoflumeTypography.lerp(a.typography, b.typography, t),
      motion: t < 0.5 ? a.motion : b.motion,
      density: t < 0.5 ? a.density : b.density,
      reducedTransparency: t < 0.5 ? a.reducedTransparency : b.reducedTransparency,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeThemeData &&
          runtimeType == other.runtimeType &&
          brightness == other.brightness &&
          colors == other.colors &&
          radii == other.radii &&
          spacing == other.spacing &&
          typography == other.typography &&
          motion == other.motion &&
          density == other.density &&
          reducedTransparency == other.reducedTransparency;

  @override
  int get hashCode => Object.hash(
        brightness,
        colors,
        radii,
        spacing,
        typography,
        motion,
        density,
        reducedTransparency,
      );
}
