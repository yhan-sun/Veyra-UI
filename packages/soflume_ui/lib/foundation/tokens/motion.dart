import 'package:flutter/widgets.dart';
import '../motion/spring_curve.dart';

/// Motion tokens for Soflume UI.
///
/// Encapsulates durations and spring curves for natural, physics-inspired micro-interactions.
@immutable
class SoflumeMotion {
  const SoflumeMotion({
    this.durationInstant = const Duration(milliseconds: 100),
    this.durationQuick = const Duration(milliseconds: 180),
    this.durationRegular = const Duration(milliseconds: 260),
    this.durationExpressive = const Duration(milliseconds: 360),
    this.springGentle = const SofSpringCurve.gentle(),
    this.springSnappy = const SofSpringCurve.snappy(),
    this.springSettle = const SofSpringCurve.settle(),
    this.reduceMotion = false,
  });

  /// Standard motion configuration.
  static const standard = SoflumeMotion();

  /// Reduced motion configuration for accessibility settings.
  static const reduced = SoflumeMotion(
    durationInstant: Duration.zero,
    durationQuick: Duration(milliseconds: 50),
    durationRegular: Duration(milliseconds: 80),
    durationExpressive: Duration(milliseconds: 100),
    springGentle: Curves.linear,
    springSnappy: Curves.linear,
    springSettle: Curves.linear,
    reduceMotion: true,
  );

  final Duration durationInstant;
  final Duration durationQuick;
  final Duration durationRegular;
  final Duration durationExpressive;
  final Curve springGentle;
  final Curve springSnappy;
  final Curve springSettle;
  final bool reduceMotion;

  Duration getEffectiveDuration(Duration duration) {
    if (reduceMotion) {
      return duration == Duration.zero ? Duration.zero : const Duration(milliseconds: 50);
    }
    return duration;
  }

  SoflumeMotion copyWith({
    Duration? durationInstant,
    Duration? durationQuick,
    Duration? durationRegular,
    Duration? durationExpressive,
    Curve? springGentle,
    Curve? springSnappy,
    Curve? springSettle,
    bool? reduceMotion,
  }) {
    return SoflumeMotion(
      durationInstant: durationInstant ?? this.durationInstant,
      durationQuick: durationQuick ?? this.durationQuick,
      durationRegular: durationRegular ?? this.durationRegular,
      durationExpressive: durationExpressive ?? this.durationExpressive,
      springGentle: springGentle ?? this.springGentle,
      springSnappy: springSnappy ?? this.springSnappy,
      springSettle: springSettle ?? this.springSettle,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoflumeMotion &&
          runtimeType == other.runtimeType &&
          durationInstant == other.durationInstant &&
          durationQuick == other.durationQuick &&
          durationRegular == other.durationRegular &&
          durationExpressive == other.durationExpressive &&
          springGentle == other.springGentle &&
          springSnappy == other.springSnappy &&
          springSettle == other.springSettle &&
          reduceMotion == other.reduceMotion;

  @override
  int get hashCode => Object.hash(
        durationInstant,
        durationQuick,
        durationRegular,
        durationExpressive,
        springGentle,
        springSnappy,
        springSettle,
        reduceMotion,
      );
}
