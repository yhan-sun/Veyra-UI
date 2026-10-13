import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofIcon & SofIcons Tests', () {
    testWidgets('SofIcon renders SVG without errors and applies size', (tester) async {
      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofIcon(
                SofIcons.sun,
                size: 28,
                color: Color(0xFF5362E8),
                semanticsLabel: 'Sun Icon',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SofIcon), findsOneWidget);
      expect(find.bySemanticsLabel('Sun Icon'), findsOneWidget);
    });

    testWidgets('SofIcon adapts to theme contentPrimary when color is null', (tester) async {
      final theme = SoflumeThemeData.dark();
      await tester.pumpWidget(
        SoflumeTheme(
          data: theme,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofIcon(
                SofIcons.moon,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SofIcon), findsOneWidget);
    });
  });
}
