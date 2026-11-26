import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// A shape border with continuous curvature (Squircle / Superellipse approximation).
///
/// Unlike standard [RoundedRectangleBorder] which has abrupt curvature jumps,
/// [SofSquircleBorder] smoothly transitions curvature from straight edges to corners
/// (G2 continuous curvature), characteristic of flagship OS aesthetics (OriginOS, iOS, ColorOS).
class SofSquircleBorder extends OutlinedBorder {
  const SofSquircleBorder({
    super.side,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.cornerSmoothing = 0.67,
  }) : assert(cornerSmoothing >= 0.0 && cornerSmoothing <= 1.0);

  final BorderRadius borderRadius;

  /// The degree of curvature smoothing from 0.0 (regular rounded rect) to 1.0 (maximum superellipse blending).
  /// Recommended default: 0.67.
  final double cornerSmoothing;

  @override
  ShapeBorder scale(double t) {
    return SofSquircleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      cornerSmoothing: cornerSmoothing,
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side, BorderRadius? borderRadius, double? cornerSmoothing}) {
    return SofSquircleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      cornerSmoothing: cornerSmoothing ?? this.cornerSmoothing,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final innerRect = rect.deflate(side.strokeInset);
    if (innerRect.width <= 0 || innerRect.height <= 0) {
      return Path();
    }
    return _computeSquirclePath(innerRect, borderRadius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _computeSquirclePath(rect, borderRadius);
  }

  Path _computeSquirclePath(Rect rect, BorderRadius br) {
    final path = Path();
    if (rect.isEmpty || rect.width <= 0 || rect.height <= 0) return path;

    final width = rect.width;
    final height = rect.height;
    final maxRadius = math.min(width, height) / 2.0;

    // Resolve corner radii bounded cleanly to [0, maxRadius]
    final tl = br.topLeft.x.clamp(0.0, maxRadius);
    final tr = br.topRight.x.clamp(0.0, maxRadius);
    final brRad = br.bottomRight.x.clamp(0.0, maxRadius);
    final bl = br.bottomLeft.x.clamp(0.0, maxRadius);

    if (tl <= 0 && tr <= 0 && brRad <= 0 && bl <= 0) {
      path.addRect(rect);
      return path;
    }

    final smooth = cornerSmoothing;

    // Clamp smoothing lead-ins independently per edge so adjacent corners never cross on pills/circles.
    double edgeExtra(double r, double oppositeR, double edgeLength) {
      if (r <= 0 || smooth <= 0.01) return 0.0;
      final desired = r * smooth * 0.2;
      final remaining = math.max(0.0, edgeLength - (r + oppositeR));
      final maxForCorner = remaining * (r / (r + oppositeR));
      return math.min(desired, maxForCorner);
    }

    final tlTop = tl + edgeExtra(tl, tr, width);
    final trTop = tr + edgeExtra(tr, tl, width);
    final trRight = tr + edgeExtra(tr, brRad, height);
    final brRight = brRad + edgeExtra(brRad, tr, height);
    final brBottom = brRad + edgeExtra(brRad, bl, width);
    final blBottom = bl + edgeExtra(bl, brRad, width);
    final blLeft = bl + edgeExtra(bl, tl, height);
    final tlLeft = tl + edgeExtra(tl, bl, height);

    final startX = rect.left + tlTop;
    path.moveTo(startX, rect.top);

    // Top edge -> Top-right corner
    final trStartX = rect.right - trTop;
    path.lineTo(trStartX, rect.top);
    if (tr > 0) {
      _addSmoothCorner(
        path,
        start: Offset(trStartX, rect.top),
        corner: Offset(rect.right, rect.top),
        end: Offset(rect.right, rect.top + trRight),
        radius: tr,
        smooth: smooth,
        hasExtension: trTop > tr || trRight > tr,
      );
    }

    // Right edge -> Bottom-right corner
    final brStartY = rect.bottom - brRight;
    path.lineTo(rect.right, brStartY);
    if (brRad > 0) {
      _addSmoothCorner(
        path,
        start: Offset(rect.right, brStartY),
        corner: Offset(rect.right, rect.bottom),
        end: Offset(rect.right - brBottom, rect.bottom),
        radius: brRad,
        smooth: smooth,
        hasExtension: brRight > brRad || brBottom > brRad,
      );
    }

    // Bottom edge -> Bottom-left corner
    final blStartX = rect.left + blBottom;
    path.lineTo(blStartX, rect.bottom);
    if (bl > 0) {
      _addSmoothCorner(
        path,
        start: Offset(blStartX, rect.bottom),
        corner: Offset(rect.left, rect.bottom),
        end: Offset(rect.left, rect.bottom - blLeft),
        radius: bl,
        smooth: smooth,
        hasExtension: blBottom > bl || blLeft > bl,
      );
    }

    // Left edge -> Top-left corner
    final tlStartY = rect.top + tlLeft;
    path.lineTo(rect.left, tlStartY);
    if (tl > 0) {
      _addSmoothCorner(
        path,
        start: Offset(rect.left, tlStartY),
        corner: Offset(rect.left, rect.top),
        end: Offset(startX, rect.top),
        radius: tl,
        smooth: smooth,
        hasExtension: tlLeft > tl || tlTop > tl,
      );
    }

    path.close();
    return path;
  }

  void _addSmoothCorner(
    Path path, {
    required Offset start,
    required Offset corner,
    required Offset end,
    required double radius,
    required double smooth,
    required bool hasExtension,
  }) {
    if (smooth <= 0.01 || !hasExtension) {
      // Fall back to true circular arc when smoothing is disabled or edge is pill/circle bounded.
      path.arcToPoint(end, radius: Radius.circular(radius));
      return;
    }

    // Continuous curvature approximation using cubic bezier curve
    // Control points calibrated for continuous tangential curvature (Apple / OriginOS ratio)
    final p0 = start;
    final p3 = end;

    final d0 = corner - start;
    final d3 = corner - end;

    final factor = 0.55 + 0.15 * smooth;

    final p1 = p0 + d0 * factor;
    final p2 = p3 + d3 * factor;

    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0.0) return;

    final paint = side.toPaint();
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is SofSquircleBorder) {
      return SofSquircleBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
        cornerSmoothing: _lerpDouble(cornerSmoothing, b.cornerSmoothing, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is SofSquircleBorder) {
      return SofSquircleBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
        cornerSmoothing: _lerpDouble(a.cornerSmoothing, cornerSmoothing, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SofSquircleBorder &&
          runtimeType == other.runtimeType &&
          side == other.side &&
          borderRadius == other.borderRadius &&
          cornerSmoothing == other.cornerSmoothing;

  @override
  int get hashCode => Object.hash(side, borderRadius, cornerSmoothing);
}
