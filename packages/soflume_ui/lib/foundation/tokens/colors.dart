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
  /// Selection logic:
  /// 1. If one candidate satisfies [minContrast] (default 4.5 for WCAG AA) while the other
  ///    does not, the compliant candidate is chosen.
  /// 2. If both candidates satisfy [minContrast], the candidate providing superior contrast is chosen.
  /// 3. If neither candidate meets [minContrast] (e.g., boundary mid-grays such as #7B7B7B or restricted custom candidates):
  ///    - When [enforceMinContrast] is true (default), falls back to absolute high-contrast
  ///      endpoints (pure black #000000 or pure white #FFFFFF) ensuring WCAG AA compliance.
  ///    - When [enforceMinContrast] is false, returns whichever candidate provided the highest contrast.
  static Color computeContrastColor(
    Color background, {
    Color darkCandidate = const Color(0xFF11162C),
    Color lightCandidate = const Color(0xFFFFFFFF),
    double minContrast = 4.5,
    bool enforceMinContrast = true,
  }) {
    final darkRatio = contrastRatio(darkCandidate, background);
    final lightRatio = contrastRatio(lightCandidate, background);

    if (lightRatio >= minContrast && darkRatio < minContrast) {
      return lightCandidate;
    }
    if (darkRatio >= minContrast && lightRatio < minContrast) {
      return darkCandidate;
    }
    if (darkRatio >= minContrast && lightRatio >= minContrast) {
      return lightRatio >= darkRatio ? lightCandidate : darkCandidate;
    }

    if (enforceMinContrast) {
      const pureBlack = Color(0xFF000000);
      const pureWhite = Color(0xFFFFFFFF);
      final blackRatio = contrastRatio(pureBlack, background);
      final whiteRatio = contrastRatio(pureWhite, background);

      if (blackRatio >= minContrast && whiteRatio < minContrast) {
        return pureBlack;
      }
      if (whiteRatio >= minContrast && blackRatio < minContrast) {
        return pureWhite;
      }
      return whiteRatio >= blackRatio ? pureWhite : pureBlack;
    }

    return lightRatio >= darkRatio ? lightCandidate : darkCandidate;
  }

  /// Factory for Soflume Light theme colors.
  factory SoflumeColors.light({Color? customAccent, Color? customOnAccent}) {
    final accent = customAccent ?? const Color(0xFF4F46E5);
    final onAccent = customOnAccent ?? computeContrastColor(accent);
    return SoflumeColors(
      canvas: const Color(0xFFF8FAFC),
      surface: const Color(0xFFFFFFFF),
      surfaceRaised: const Color(0xFFFFFFFF),
      surfaceMuted: const Color(0xFFF1F5F9),
      contentPrimary: const Color(0xFF0F172A),
      contentSecondary: const Color(0xFF475569),
      contentTertiary: const Color(0xFF94A3B8),
      outlineSubtle: const Color(0xFFE2E8F0),
      outlineFocus: accent.withValues(alpha: 0.45),
      accent: accent,
      onAccent: onAccent,
      accentSubtle: accent.withValues(alpha: 0.10),
      success: const Color(0xFF059669),
      warning: const Color(0xFFD97706),
      danger: const Color(0xFFE11D48),
      overlay: const Color(0x40000000),
      isDark: false,
    );
  }

  /// Factory for Soflume Dark theme colors.
  factory SoflumeColors.dark({Color? customAccent, Color? customOnAccent}) {
    final accent = customAccent ?? const Color(0xFF6366F1);
    final onAccent = customOnAccent ?? computeContrastColor(accent);
    return SoflumeColors(
      canvas: const Color(0xFF0B0D14),
      surface: const Color(0xFF131722),
      surfaceRaised: const Color(0xFF191F2E),
      surfaceMuted: const Color(0xFF1E2538),
      contentPrimary: const Color(0xFFF8FAFC),
      contentSecondary: const Color(0xFF94A3B8),
      contentTertiary: const Color(0xFF64748B),
      outlineSubtle: const Color(0xFF242C3F),
      outlineFocus: accent.withValues(alpha: 0.55),
      accent: accent,
      onAccent: onAccent,
      accentSubtle: accent.withValues(alpha: 0.16),
      success: const Color(0xFF10B981),
      warning: const Color(0xFFF59E0B),
      danger: const Color(0xFFF43F5E),
      overlay: const Color(0x75000000),
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
