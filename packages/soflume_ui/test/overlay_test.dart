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

    testWidgets('Non-dismissible SofDialog cannot be closed via ESC', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => const SofDialog(
                      title: Text('Locked Dialog'),
                      child: Text('Cannot ESC'),
                    ),
                  );
                },
                child: const Text('Open Locked'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Locked'));
      await tester.pumpAndSettle();
      expect(find.text('Locked Dialog'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Dialog must remain open
      expect(find.text('Locked Dialog'), findsOneWidget);
    });

    testWidgets('Non-dismissible SofSheet cannot be closed via ESC or drag', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofSheet<void>(
                    context: context,
                    isDismissible: false,
                    builder: (ctx) => const SofSheet(
                      title: Text('Locked Sheet'),
                      child: Text('Sheet Body'),
                    ),
                  );
                },
                child: const Text('Open Locked Sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Locked Sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Locked Sheet'), findsOneWidget);

      // Attempt ESC
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Locked Sheet'), findsOneWidget);

      // Attempt drag down on handle
      await tester.fling(find.text('Locked Sheet'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Locked Sheet'), findsOneWidget);
    });

    testWidgets('Nested dialogs maintain independent route stacks and close in LIFO order', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Builder(
            builder: (context) {
              return SofButton(
                onPressed: () {
                  showSofDialog<void>(
                    context: context,
                    builder: (ctx1) => SofDialog(
                      title: const Text('Dialog 1'),
                      actions: [
                        SofButton(
                          onPressed: () {
                            showSofDialog<void>(
                              context: ctx1,
                              builder: (ctx2) => const SofDialog(
                                title: Text('Dialog 2'),
                                child: Text('Child modal'),
                              ),
                            );
                          },
                          child: const Text('Open Dialog 2'),
                        ),
                      ],
                      child: const Text('First level'),
                    ),
                  );
                },
                child: const Text('Open First'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open First'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog 1'), findsOneWidget);

      await tester.tap(find.text('Open Dialog 2'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog 2'), findsOneWidget);

      // ESC dismisses top-level Dialog 2 only
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Dialog 2'), findsNothing);
      expect(find.text('Dialog 1'), findsOneWidget);

      // Second ESC dismisses Dialog 1
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Dialog 1'), findsNothing);
    });
  });
}
