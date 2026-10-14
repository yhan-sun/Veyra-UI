import 'package:flutter/widgets.dart';

/// Semantic color tokens for the Soflume UI design system (Soft Lumen).
///
/// Designed with high contrast, accessibility (WCAG AA), and luminous depth in mind.
@immutable
class SoflumeColors {
  const SoflumeColors({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceMuted,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.outlineSubtle,
    required this.outlineFocus,
    required this.accent,
    required this.onAccent,
    required this.accentSubtle,
    required this.success,
    required this.warning,
    required this.danger,
    required this.overlay,
    required this.isDark,
  });

  /// Computes the WCAG 2.1 relative luminance contrast ratio between two colors.
  ///
  /// The returned value ranges from 1.0 (identical luminance) to 21.0 (pure black on pure white).
  /// - WCAG AA requires at least 4.5:1 for normal text and 3.0:1 for large text.
  /// - WCAG AAA requires at least 7.0:1 for normal text and 4.5:1 for large text.
  static double contrastRatio(Color foreground, Color background) {
    final lum1 = foreground.computeLuminance();
    final lum2 = background.computeLuminance();
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Computes an accessible, high-contrast foreground color (WCAG AA/AAA compliant)
  /// for the given [background] color.
  ///
  /// Evaluates the true WCAG contrast ratio between candidate foreground colors and
  /// [background]. By default, tests against standard dark text ([darkCandidate], default #11162C)
  /// and light text ([lightCandidate], default #FFFFFF).
  ///
  /// If one candidate meets or exceeds [minContrast] (default 4.5 for WCAG AA normal text),
  /// and the other does not, the compliant candidate is chosen. Otherwise, the candidate
  /// with the higher contrast ratio is selected.
  static Color computeContrastColor(
    Color background, {
    Color darkCandidate = const Color(0xFF11162C),
    Color lightCandidate = const Color(0xFFFFFFFF),
    double minContrast = 4.5,
  }) {
    final darkRatio = contrastRatio(darkCandidate, background);
    final lightRatio = contrastRatio(lightCandidate, background);

    if (lightRatio >= minContrast && darkRatio < minContrast) {
      return lightCandidate;
    }
    if (darkRatio >= minContrast && lightRatio < minContrast) {
      return darkCandidate;
    }
    return lightRatio >= darkRatio ? lightCandidate : darkCandidate;
  }

  /// Factory for Soflume Light theme colors.
  factory SoflumeColors.light({Color? customAccent, Color? customOnAccent}) {
    final accent = customAccent ?? const Color(0xFF5362E8);
    final onAccent = customOnAccent ?? computeContrastColor(accent);
    return SoflumeColors(
      canvas: const Color(0xFFF6F7FB),
      surface: const Color(0xFFFFFFFF),
      surfaceRaised: const Color(0xFFFFFFFF),
      surfaceMuted: const Color(0xFFEDF0F7),
      contentPrimary: const Color(0xFF1B2030),
      contentSecondary: const Color(0xFF697184),
      contentTertiary: const Color(0xFF9DA5B4),
      outlineSubtle: const Color(0xFFE3E7F0),
      outlineFocus: accent.withValues(alpha: 0.45),
      accent: accent,
      onAccent: onAccent,
      accentSubtle: accent.withValues(alpha: 0.12),
      success: const Color(0xFF258867),
      warning: const Color(0xFF9F6A1C),
      danger: const Color(0xFFC94459),
      overlay: const Color(0x52000000),
      isDark: false,
    );
  }

  /// Factory for Soflume Dark theme colors.
  factory SoflumeColors.dark({Color? customAccent, Color? customOnAccent}) {
    final accent = customAccent ?? const Color(0xFF9EA8FF);
    final onAccent = customOnAccent ?? computeContrastColor(accent);
    return SoflumeColors(
      canvas: const Color(0xFF101218),
      surface: const Color(0xFF1A1D25),
      surfaceRaised: const Color(0xFF232735),
      surfaceMuted: const Color(0xFF282C39),
      contentPrimary: const Color(0xFFF1F3FA),
      contentSecondary: const Color(0xFFADB4C4),
      contentTertiary: const Color(0xFF6A7387),
      outlineSubtle: const Color(0xFF353A48),
      outlineFocus: accent.withValues(alpha: 0.55),
      accent: accent,
      onAccent: onAccent,
      accentSubtle: accent.withValues(alpha: 0.16),
      success: const Color(0xFF75D6AD),
      warning: const Color(0xFFF4C47B),
      danger: const Color(0xFFFF8B9A),
      overlay: const Color(0x80000000),
      isDark: true,
    );
  }

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceMuted;
  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color outlineSubtle;
  final Color outlineFocus;
  final Color accent;
  final Color onAccent;
  final Color accentSubtle;
  final Color success;
  final Color warning;
  final Color danger;
  final Color overlay;
  final bool isDark;

  /// Returns a copy of [SoflumeColors] with updated values.
  SoflumeColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceMuted,
    Color? contentPrimary,
    Color? contentSecondary,
    Color? contentTertiary,
    Color? outlineSubtle,
    Color? outlineFocus,
    Color? accent,
    Color? onAccent,
    Color? accentSubtle,
    Color? success,
    Color? warning,
    Color? danger,
    Color? overlay,
    bool? isDark,
  }) {
    return SoflumeColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      contentPrimary: contentPrimary ?? this.contentPrimary,
      contentSecondary: contentSecondary ?? this.contentSecondary,
      contentTertiary: contentTertiary ?? this.contentTertiary,
      outlineSubtle: outlineSubtle ?? this.outlineSubtle,
      outlineFocus: outlineFocus ?? this.outlineFocus,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      overlay: overlay ?? this.overlay,
      isDark: isDark ?? this.isDark,
    );
  }

  /// Linearly interpolates between two [SoflumeColors] sets.
  static SoflumeColors lerp(SoflumeColors a, SoflumeColors b, double t) {
    return SoflumeColors(
      canvas: Color.lerp(a.canvas, b.canvas, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      surfaceRaised: Color.lerp(a.surfaceRaised, b.surfaceRaised, t)!,
      surfaceMuted: Color.lerp(a.surfaceMuted, b.surfaceMuted, t)!,
      contentPrimary: Color.lerp(a.contentPrimary, b.contentPrimary, t)!,
      contentSecondary: Color.lerp(a.contentSecondary, b.contentSecondary, t)!,
      contentTertiary: Color.lerp(a.contentTertiary, b.contentTertiary, t)!,
      outlineSubtle: Color.lerp(a.outlineSubtle, b.outlineSubtle, t)!,
      outlineFocus: Color.lerp(a.outlineFocus, b.outlineFocus, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      onAccent: Color.lerp(a.onAccent, b.onAccent, t)!,
      accentSubtle: Color.lerp(a.accentSubtle, b.accentSubtle, t)!,
      success: Color.lerp(a.success, b.success, t)!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      danger: Color.lerp(a.danger, b.danger, t)!,
      overlay: Color.lerp(a.overlay, b.overlay, t)!,
      isDark: t < 0.5 ? a.isDark : b.isDark,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeColors &&
          runtimeType == other.runtimeType &&
          canvas == other.canvas &&
          surface == other.surface &&
          surfaceRaised == other.surfaceRaised &&
          surfaceMuted == other.surfaceMuted &&
          contentPrimary == other.contentPrimary &&
          contentSecondary == other.contentSecondary &&
          contentTertiary == other.contentTertiary &&
          outlineSubtle == other.outlineSubtle &&
          outlineFocus == other.outlineFocus &&
          accent == other.accent &&
          onAccent == other.onAccent &&
          accentSubtle == other.accentSubtle &&
          success == other.success &&
          warning == other.warning &&
          danger == other.danger &&
          overlay == other.overlay &&
          isDark == other.isDark;

  @override
  int get hashCode => Object.hashAll([
        canvas,
        surface,
        surfaceRaised,
        surfaceMuted,
        contentPrimary,
        contentSecondary,
        contentTertiary,
        outlineSubtle,
        outlineFocus,
        accent,
        onAccent,
        accentSubtle,
        success,
        warning,
        danger,
        overlay,
        isDark,
      ]);
}
