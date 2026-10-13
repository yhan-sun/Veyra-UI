import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Corner radius tokens for Soflume UI.
///
/// Implements proportional squircle/continuous curvature radii and nested corner heuristics.
@immutable
class SoflumeRadii {
  const SoflumeRadii({
    this.xs = 8.0,
    this.sm = 12.0,
    this.md = 16.0,
    this.lg = 22.0,
    this.xl = 28.0,
    this.xxl = 36.0,
    this.pill = 999.0,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double pill;

  BorderRadius get brXs => BorderRadius.circular(xs);
  BorderRadius get brSm => BorderRadius.circular(sm);
  BorderRadius get brMd => BorderRadius.circular(md);
  BorderRadius get brLg => BorderRadius.circular(lg);
  BorderRadius get brXl => BorderRadius.circular(xl);
  BorderRadius get brXxl => BorderRadius.circular(xxl);
  BorderRadius get brPill => BorderRadius.circular(pill);

  /// Heuristic nested corner formula:
  /// `innerRadius = max(outerRadius - inset, 6.0)`
  /// Prevents nested cards from looking visually jarring or dissonant.
  static double nested(double outerRadius, double inset, {double minRadius = 6.0}) {
    if (outerRadius >= 900) return outerRadius; // Pills keep pill shape
    return math.max(outerRadius - inset, minRadius);
  }

  /// Returns [BorderRadius] with calculated nested radius.
  static BorderRadius nestedBorderRadius(double outerRadius, double inset, {double minRadius = 6.0}) {
    return BorderRadius.circular(nested(outerRadius, inset, minRadius: minRadius));
  }

  SoflumeRadii copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? pill,
  }) {
    return SoflumeRadii(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      pill: pill ?? this.pill,
    );
  }

  static SoflumeRadii lerp(SoflumeRadii a, SoflumeRadii b, double t) {
    return SoflumeRadii(
      xs: _lerpDouble(a.xs, b.xs, t),
      sm: _lerpDouble(a.sm, b.sm, t),
      md: _lerpDouble(a.md, b.md, t),
      lg: _lerpDouble(a.lg, b.lg, t),
      xl: _lerpDouble(a.xl, b.xl, t),
      xxl: _lerpDouble(a.xxl, b.xxl, t),
      pill: _lerpDouble(a.pill, b.pill, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeRadii &&
          runtimeType == other.runtimeType &&
          xs == other.xs &&
          sm == other.sm &&
          md == other.md &&
          lg == other.lg &&
          xl == other.xl &&
          xxl == other.xxl &&
          pill == other.pill;

  @override
  int get hashCode => Object.hash(xs, sm, md, lg, xl, xxl, pill);
}
