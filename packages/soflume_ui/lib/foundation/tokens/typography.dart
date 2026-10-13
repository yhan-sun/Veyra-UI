import 'package:flutter/widgets.dart';
import 'colors.dart';

/// Typography hierarchy for Soflume UI.
///
/// Designed with balanced weights (w650/w620/w550), optical line-heights,
/// and support for dynamic font scaling and tabular figures.
@immutable
class SoflumeTypography {
  const SoflumeTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.label,
    required this.caption,
    required this.code,
  });

  /// Default typography system using system font stack.
  factory SoflumeTypography.standard() {
    return const SoflumeTypography(
      display: TextStyle(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      headline: TextStyle(
        fontSize: 26,
        height: 34 / 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      title: TextStyle(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 23 / 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      label: TextStyle(
        fontSize: 13,
        height: 20 / 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      caption: TextStyle(
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      code: TextStyle(
        fontSize: 13,
        height: 20 / 13,
        fontWeight: FontWeight.w400,
        fontFamily: 'monospace',
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle code;

  /// Applies semantic colors to text styles.
  SoflumeTypography applyColors(SoflumeColors colors) {
    return SoflumeTypography(
      display: display.copyWith(color: colors.contentPrimary),
      headline: headline.copyWith(color: colors.contentPrimary),
      title: title.copyWith(color: colors.contentPrimary),
      body: body.copyWith(color: colors.contentPrimary),
      label: label.copyWith(color: colors.contentPrimary),
      caption: caption.copyWith(color: colors.contentSecondary),
      code: code.copyWith(color: colors.contentSecondary),
    );
  }

  SoflumeTypography copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? code,
  }) {
    return SoflumeTypography(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
      code: code ?? this.code,
    );
  }

  static SoflumeTypography lerp(SoflumeTypography a, SoflumeTypography b, double t) {
    return SoflumeTypography(
      display: TextStyle.lerp(a.display, b.display, t)!,
      headline: TextStyle.lerp(a.headline, b.headline, t)!,
      title: TextStyle.lerp(a.title, b.title, t)!,
      body: TextStyle.lerp(a.body, b.body, t)!,
      label: TextStyle.lerp(a.label, b.label, t)!,
      caption: TextStyle.lerp(a.caption, b.caption, t)!,
      code: TextStyle.lerp(a.code, b.code, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeTypography &&
          runtimeType == other.runtimeType &&
          display == other.display &&
          headline == other.headline &&
          title == other.title &&
          body == other.body &&
          label == other.label &&
          caption == other.caption &&
          code == other.code;

  @override
  int get hashCode => Object.hash(display, headline, title, body, label, caption, code);
}
