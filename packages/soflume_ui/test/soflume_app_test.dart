import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SoflumeApp Tests', () {
    testWidgets('Provides Navigator, Overlay, and theme inheritance to home widget', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        SoflumeApp(
          theme: SoflumeThemeData.light(),
          home: Builder(
            builder: (context) {
              testContext = context;
              return const Text('Home Screen');
            },
          ),
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      // Verify SoflumeTheme is inherited
      final theme = SoflumeTheme.of(testContext);
      expect(theme, isNotNull);
      expect(theme.isDark, isFalse);

      // Verify Navigator is available
      final navigator = Navigator.maybeOf(testContext);
      expect(navigator, isNotNull);

      // Verify Overlay is available
      final overlay = Overlay.maybeOf(testContext);
      expect(overlay, isNotNull);
    });

    testWidgets('Opens and closes SofDialog seamlessly within SoflumeApp', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofDialog<String>(
                    context: context,
                    builder: (ctx) => SofDialog(
                      title: const Text('Modal Test'),
                      actions: [
                        SofButton(
                          onPressed: () => Navigator.of(ctx).pop('result_ok'),
                          child: const Text('Close'),
                        ),
                      ],
                      child: const Text('Dialog Content'),
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );

      // Tap to open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Modal Test'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Modal Test'), findsNothing);
    });

    testWidgets('showSofToast queues and displays message via Overlay', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofToast(
                    context: context,
                    message: 'Hello Soflume Toast',
                    variant: SofBadgeVariant.success,
                  );
                },
                child: const Text('Trigger Toast'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Trigger Toast'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Hello Soflume Toast'), findsOneWidget);
    });
  });
}
