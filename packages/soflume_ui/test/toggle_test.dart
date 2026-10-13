import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofToggle & Selection Tests', () {
    testWidgets('Tapping toggle switches state', (tester) async {
      bool currentValue = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeTheme(
              data: SoflumeThemeData.light(),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: SofToggle(
                    value: currentValue,
                    onChanged: (val) {
                      setState(() => currentValue = val);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );

      expect(currentValue, isFalse);

      await tester.tap(find.byType(SofToggle));
      await tester.pumpAndSettle();

      expect(currentValue, isTrue);
    });

    testWidgets('Disabled toggle does not call onChanged', (tester) async {
      bool called = false;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofToggle(
                value: false,
                enabled: false,
                onChanged: (val) => called = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SofToggle));
      await tester.pumpAndSettle();

      expect(called, isFalse);
    });
  });
}
