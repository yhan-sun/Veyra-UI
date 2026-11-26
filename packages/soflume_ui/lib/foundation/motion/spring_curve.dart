import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Damped harmonic spring curve for Flutter animations.
///
/// Implements authentic physical spring response with smooth continuous deceleration
/// matching flagship OS interaction dynamics (vivo OriginOS, iOS, HyperOS).
class SofSpringCurve extends Curve {
  const SofSpringCurve({
    this.mass = 1.0,
    this.stiffness = 300.0,
    this.damping = 32.0,
    this.timeScale = 1.0,
  });

  /// Gentle spring: smooth, airy, low overshoot.
  /// Ideal for cards, dialog reveals, and backdrop transitions.
  const SofSpringCurve.gentle()
      : mass = 1.0,
        stiffness = 240.0,
        damping = 28.0,
        timeScale = 0.85;

  /// Snappy spring: rapid initial response, crisp settlement.
  /// Ideal for toggles, switches, selection tabs, and press feedback.
  const SofSpringCurve.snappy()
      : mass = 1.0,
        stiffness = 420.0,
        damping = 32.0,
        timeScale = 1.0;

  /// Settle spring: balanced cadence with smooth landing.
  /// Ideal for morphing buttons, sheet drag release, and navigation transitions.
  const SofSpringCurve.settle()
      : mass = 1.0,
        stiffness = 300.0,
        damping = 36.0,
        timeScale = 0.9;

  final double mass;
  final double stiffness;
  final double damping;
  final double timeScale;

  SpringDescription toSpringDescription() {
    return SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );
  }

  @override
  double transformInternal(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    final w0 = math.sqrt(stiffness / mass);
    final zeta = damping / (2.0 * math.sqrt(mass * stiffness));

    // Scale virtual time to the physical ~99% settling window so motion spans [0, 1] evenly.
    final double effectiveRate;
    if (zeta <= 1.0) {
      effectiveRate = math.max(zeta * w0, 1.0);
    } else {
      effectiveRate = math.max(w0 * (zeta - math.sqrt(zeta * zeta - 1.0)), 1.0);
    }
    final horizon = (4.6 / effectiveRate) / timeScale;

    double evaluate(double elapsed) {
      if (zeta < 1.0) {
        final wd = w0 * math.sqrt(1.0 - zeta * zeta);
        final decay = math.exp(-zeta * w0 * elapsed);
        final envelope = math.cos(wd * elapsed) + ((zeta * w0) / wd) * math.sin(wd * elapsed);
        return 1.0 - decay * envelope;
      } else if (zeta == 1.0) {
        final decay = math.exp(-w0 * elapsed);
        return 1.0 - (1.0 + w0 * elapsed) * decay;
      } else {
        final r1 = -w0 * (zeta - math.sqrt(zeta * zeta - 1.0));
        final r2 = -w0 * (zeta + math.sqrt(zeta * zeta - 1.0));
        final c2 = r1 / (r1 - r2);
        final c1 = 1.0 - c2;
        return 1.0 - (c1 * math.exp(r1 * elapsed) + c2 * math.exp(r2 * elapsed));
      }
    }

    final endValue = evaluate(horizon);
    final value = evaluate(t * horizon);
    return endValue.abs() > 1e-6 ? value / endValue : value;
  }
}
