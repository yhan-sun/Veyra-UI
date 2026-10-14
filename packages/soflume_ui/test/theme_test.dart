import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SoflumeTheme & Tokens', () {
    test('Light theme defaults', () {
      final light = SoflumeThemeData.light();
      expect(light.brightness, Brightness.light);
      expect(light.isDark, isFalse);
      expect(light.colors.canvas, const Color(0xFFF8FAFC));
      expect(light.colors.accent, const Color(0xFF4F46E5));
      expect(light.radii.md, 16.0);
      expect(light.radii.pill, 999.0);
    });

    test('Dark theme defaults', () {
      final dark = SoflumeThemeData.dark();
      expect(dark.brightness, Brightness.dark);
      expect(dark.isDark, isTrue);
      expect(dark.colors.canvas, const Color(0xFF0B0D14));
      expect(dark.colors.accent, const Color(0xFF6366F1));
    });

    test('Custom brand accent', () {
      const customColor = Color(0xFFFF5500);
      final customTheme = SoflumeThemeData.light(customAccent: customColor);
      expect(customTheme.colors.accent, customColor);
    });

    test('ThemeData lerp', () {
      final light = SoflumeThemeData.light();
      final dark = SoflumeThemeData.dark();
      final mid = SoflumeThemeData.lerp(light, dark, 0.5);
      expect(mid.colors.canvas, isNotNull);
    });

    test('Nested radius calculation heuristic', () {
      expect(SoflumeRadii.nested(22.0, 4.0), 18.0);
      expect(SoflumeRadii.nested(10.0, 8.0), 6.0); // Bounded by min 6
      expect(SoflumeRadii.nested(999.0, 4.0), 999.0); // Pill stays pill
    });

    test('Density scale padding adjustment', () {
      const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      final compact = SoflumeDensity.compact.adjustPadding(padding);
      expect(compact.top, 8.0); // 10 * 0.8
      expect(compact.left, 17.0); // 20 * 0.85
    });

    testWidgets('SoflumeTheme.of provides context values', (tester) async {
      late SoflumeThemeData foundData;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.dark(),
          child: Builder(
            builder: (context) {
              foundData = SoflumeTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(foundData.isDark, isTrue);
    });
  });
}
