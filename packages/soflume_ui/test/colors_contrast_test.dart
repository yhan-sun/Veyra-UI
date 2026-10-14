import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/foundation/tokens/colors.dart';

void main() {
  group('SoflumeColors Contrast & WCAG Tests', () {
    test('contrastRatio returns 21.0 for pure black and pure white', () {
      final ratio = SoflumeColors.contrastRatio(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
      );
      expect(ratio, closeTo(21.0, 0.05));
    });

    test('contrastRatio returns 1.0 for identical colors', () {
      final ratio = SoflumeColors.contrastRatio(
        const Color(0xFF5362E8),
        const Color(0xFF5362E8),
      );
      expect(ratio, closeTo(1.0, 0.001));
    });

    test('computeContrastColor selects compliant candidate on various backgrounds', () {
      final testCases = <Color, String>{
        const Color(0xFFFFFFFF): 'pure white',
        const Color(0xFF000000): 'pure black',
        const Color(0xFFF5A623): 'vibrant amber/yellow',
        const Color(0xFF00D2D3): 'cyan teal',
        const Color(0xFF091E42): 'deep navy blue',
        const Color(0xFFA3E635): 'lime green',
        const Color(0xFFFBCFE8): 'pastel pink',
        const Color(0xFF3B0764): 'dark purple',
        const Color(0xFF5362E8): 'Soflume brand indigo',
        const Color(0xFF9EA8FF): 'Soflume brand light purple',
        const Color(0xFF7B7B7B): 'challenging mid-gray boundary #7B7B7B',
        const Color(0xFF808080): 'standard mid-gray #808080',
      };

      for (final entry in testCases.entries) {
        final bg = entry.key;
        final chosenColor = SoflumeColors.computeContrastColor(bg);
        final ratio = SoflumeColors.contrastRatio(chosenColor, bg);

        // Verify that the chosen color satisfies at least WCAG AA (>= 4.5:1)
        expect(
          ratio >= 4.5,
          isTrue,
          reason: 'Failed WCAG AA on background ${entry.value} (hex: ${bg.toARGB32().toRadixString(16)}). '
              'Chosen color ${chosenColor.toARGB32().toRadixString(16)} had ratio $ratio:1',
        );
      }
    });

    test('boundary mid-gray #7B7B7B achieves >= 4.5:1 via guaranteed black fallback', () {
      const midGray = Color(0xFF7B7B7B);
      final chosen = SoflumeColors.computeContrastColor(midGray);
      final ratio = SoflumeColors.contrastRatio(chosen, midGray);

      expect(ratio >= 4.5, isTrue);
      expect(chosen, equals(const Color(0xFF000000)));
    });

    test('computeContrastColor respects custom candidates and minContrast', () {
      const bg = Color(0xFF1E293B); // dark slate
      const customLight = Color(0xFFF8FAFC);
      const customDark = Color(0xFF0F172A);

      final chosen = SoflumeColors.computeContrastColor(
        bg,
        lightCandidate: customLight,
        darkCandidate: customDark,
        minContrast: 7.0, // AAA target
      );

      expect(chosen, equals(customLight));
      final ratio = SoflumeColors.contrastRatio(chosen, bg);
      expect(ratio >= 7.0, isTrue);
    });

    test('handles custom candidates failing minContrast with enforceMinContrast toggle', () {
      const bg = Color(0xFF888888);
      // Restricted custom candidates that cannot reach 4.5:1
      const weakLight = Color(0xFFAAAAAA);
      const weakDark = Color(0xFF666666);

      // With enforceMinContrast: true (default) -> falls back to pure black/white achieving >= 4.5
      final enforced = SoflumeColors.computeContrastColor(
        bg,
        lightCandidate: weakLight,
        darkCandidate: weakDark,
        minContrast: 4.5,
        enforceMinContrast: true,
      );
      final enforcedRatio = SoflumeColors.contrastRatio(enforced, bg);
      expect(enforcedRatio >= 4.5, isTrue);

      // With enforceMinContrast: false -> returns best of custom candidates
      final nonEnforced = SoflumeColors.computeContrastColor(
        bg,
        lightCandidate: weakLight,
        darkCandidate: weakDark,
        minContrast: 4.5,
        enforceMinContrast: false,
      );
      expect(nonEnforced == weakLight || nonEnforced == weakDark, isTrue);
    });
  });
}
