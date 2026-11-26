import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofSquircleBorder & Shapes', () {
    test('Outer path calculation', () {
      const border = SofSquircleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        cornerSmoothing: 0.67,
      );

      final path = border.getOuterPath(const Rect.fromLTWH(0, 0, 100, 50));
      expect(path, isNotNull);
      expect(path.getBounds().width, 100);
      expect(path.getBounds().height, 50);
    });

    test('Pill and circular radii do not self-intersect', () {
      const pillBorder = SofSquircleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999)),
        cornerSmoothing: 0.67,
      );

      final pillPath = pillBorder.getOuterPath(const Rect.fromLTWH(0, 0, 120, 40));
      expect(pillPath.getBounds(), const Rect.fromLTWH(0, 0, 120, 40));
      final pillLength = pillPath.computeMetrics().first.length;
      // Perimeter of a 120x40 stadium pill is 2*(120-40) + pi*40 ≈ 285.66
      expect(pillLength, inInclusiveRange(275.0, 295.0));

      final circlePath = pillBorder.getOuterPath(const Rect.fromLTWH(0, 0, 40, 40));
      expect(circlePath.getBounds(), const Rect.fromLTWH(0, 0, 40, 40));
      final circleLength = circlePath.computeMetrics().first.length;
      expect(circleLength, inInclusiveRange(120.0, 132.0));
    });

    test('Inner path handles thin rects safely', () {
      const border = SofSquircleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(width: 10),
      );
      final emptyInner = border.getInnerPath(const Rect.fromLTWH(0, 0, 10, 10));
      expect(emptyInner.getBounds(), Rect.zero);
    });

    test('Zero radius returns rectangular path', () {
      const border = SofSquircleBorder(
        borderRadius: BorderRadius.zero,
      );

      final path = border.getOuterPath(const Rect.fromLTWH(0, 0, 80, 40));
      expect(path.getBounds(), const Rect.fromLTWH(0, 0, 80, 40));
    });

    test('Border scaling and equality', () {
      const border1 = SofSquircleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        cornerSmoothing: 0.67,
      );
      final borderScaled = border1.scale(2.0) as SofSquircleBorder;
      expect(borderScaled.borderRadius.topLeft.x, 32.0);
    });
  });

  group('SofSpringCurve & Motion', () {
    test('Curve endpoints t=0 and t=1', () {
      const spring = SofSpringCurve.snappy();
      expect(spring.transform(0.0), 0.0);
      expect(spring.transform(1.0), 1.0);
    });

    test('Gentle spring curve spans smoothly across [0, 1]', () {
      const spring = SofSpringCurve.gentle();
      final early = spring.transform(0.2);
      final mid = spring.transform(0.5);
      expect(early, inInclusiveRange(0.2, 0.85));
      expect(mid, greaterThan(0.5));
      expect(mid, lessThan(1.5));
    });

    test('Snappy spring does not finish 99.9% before t=0.15', () {
      const spring = SofSpringCurve.snappy();
      final v15 = spring.transform(0.15);
      expect(v15, lessThan(0.9));
    });

    test('SoflumeMotion lerp and reduceMotion curve fallback', () {
      final mid = SoflumeMotion.lerp(SoflumeMotion.standard, SoflumeMotion.reduced, 0.5);
      expect(mid.durationRegular.inMilliseconds, 170);
      expect(SoflumeMotion.reduced.getEffectiveCurve(const SofSpringCurve.snappy()), Curves.linear);
      expect(SoflumeMotion.standard.getEffectiveCurve(const SofSpringCurve.snappy()), isA<SofSpringCurve>());
    });
  });
}
