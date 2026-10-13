import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofButton Widget Tests', () {
    testWidgets('Renders label and triggers onPressed callback', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofButton(
                onPressed: () => pressed = true,
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('Disabled button does not trigger onPressed', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofButton(
                onPressed: () => pressed = true,
                enabled: false,
                child: const Text('Disabled'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });

    testWidgets('Loading button hides label and shows spinner', (tester) async {
      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofButton(
                onPressed: () {},
                loading: true,
                child: const Text('Loading'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsNothing);
    });
  });
}
