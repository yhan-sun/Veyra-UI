import 'package:flutter/widgets.dart';

/// Spacing tokens for Soflume UI layout grid and component paddings.
@immutable
class SoflumeSpacing {
  const SoflumeSpacing({
    this.xxs = 4.0,
    this.xs = 8.0,
    this.sm = 12.0,
    this.md = 16.0,
    this.lg = 20.0,
    this.xl = 24.0,
    this.xxl = 32.0,
    this.huge = 40.0,
    this.massive = 48.0,
    this.jumbo = 64.0,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double huge;
  final double massive;
  final double jumbo;

  // Convenient EdgeInsets helpers
  EdgeInsets get insetsAllXxs => EdgeInsets.all(xxs);
  EdgeInsets get insetsAllXs => EdgeInsets.all(xs);
  EdgeInsets get insetsAllSm => EdgeInsets.all(sm);
  EdgeInsets get insetsAllMd => EdgeInsets.all(md);
  EdgeInsets get insetsAllLg => EdgeInsets.all(lg);
  EdgeInsets get insetsAllXl => EdgeInsets.all(xl);

  SoflumeSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? huge,
    double? massive,
    double? jumbo,
  }) {
    return SoflumeSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      huge: huge ?? this.huge,
      massive: massive ?? this.massive,
      jumbo: jumbo ?? this.jumbo,
    );
  }

  static SoflumeSpacing lerp(SoflumeSpacing a, SoflumeSpacing b, double t) {
    return SoflumeSpacing(
      xxs: _lerp(a.xxs, b.xxs, t),
      xs: _lerp(a.xs, b.xs, t),
      sm: _lerp(a.sm, b.sm, t),
      md: _lerp(a.md, b.md, t),
      lg: _lerp(a.lg, b.lg, t),
      xl: _lerp(a.xl, b.xl, t),
      xxl: _lerp(a.xxl, b.xxl, t),
      huge: _lerp(a.huge, b.huge, t),
      massive: _lerp(a.massive, b.massive, t),
      jumbo: _lerp(a.jumbo, b.jumbo, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeSpacing &&
          runtimeType == other.runtimeType &&
          xxs == other.xxs &&
          xs == other.xs &&
          sm == other.sm &&
          md == other.md &&
          lg == other.lg &&
          xl == other.xl &&
          xxl == other.xxl &&
          huge == other.huge &&
          massive == other.massive &&
          jumbo == other.jumbo;

  @override
  int get hashCode => Object.hash(xxs, xs, sm, md, lg, xl, xxl, huge, massive, jumbo);
}
