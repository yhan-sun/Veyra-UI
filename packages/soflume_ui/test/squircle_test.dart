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

  group('SofSpringCurve', () {
    test('Curve endpoints t=0 and t=1', () {
      const spring = SofSpringCurve.snappy();
      expect(spring.transform(0.0), 0.0);
      expect(spring.transform(1.0), 1.0);
    });

    test('Gentle spring curve values', () {
      const spring = SofSpringCurve.gentle();
      final mid = spring.transform(0.5);
      expect(mid, greaterThan(0.5));
      expect(mid, lessThan(1.5));
    });
  });
}
