import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('Overlay Dialog & Sheet Tests', () {
    testWidgets('SofDialog can be dismissed via ESC keyboard shortcut', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofDialog<void>(
                    context: context,
                    builder: (ctx) => const SofDialog(
                      title: Text('Escape Dialog'),
                      child: Text('Press Escape to close'),
                    ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Escape Dialog'), findsOneWidget);

      // Send ESC key
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Escape Dialog'), findsNothing);
    });

    testWidgets('SofSheet can be dismissed via ESC keyboard shortcut', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofSheet<void>(
                    context: context,
                    builder: (ctx) => const SizedBox(
                      height: 200,
                      child: Text('Sheet Content'),
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Sheet Content'), findsOneWidget);

      // Send ESC key
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Sheet Content'), findsNothing);
    });
  });
}
