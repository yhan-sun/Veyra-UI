import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofSelect Tests', () {
    final testItems = [
      const SofSelectItem<String>(value: 'opt1', label: 'Option 1'),
      const SofSelectItem<String>(value: 'opt2', label: 'Option 2'),
      const SofSelectItem<String>(value: 'opt3', label: 'Option 3 (Disabled)', enabled: false),
    ];

    testWidgets('Renders placeholder and opens dropdown menu on tap', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        SoflumeApp(
          home: Center(
            child: SizedBox(
              width: 260,
              child: SofSelect<String>(
                label: 'Framework Selection',
                placeholder: 'Choose framework',
                items: testItems,
                value: selectedValue,
                onChanged: (val) => selectedValue = val,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Framework Selection'), findsOneWidget);
      expect(find.text('Choose framework'), findsOneWidget);
      expect(find.text('Option 1'), findsNothing);

      // Tap to open menu
      await tester.tap(find.text('Choose framework'));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3 (Disabled)'), findsOneWidget);

      // Tap Option 2
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals('opt2'));
      // Dropdown closes after selection
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('Disabled option cannot be selected', (tester) async {
      String? selectedValue = 'opt1';

      await tester.pumpWidget(
        SoflumeApp(
          home: Center(
            child: SizedBox(
              width: 260,
              child: SofSelect<String>(
                items: testItems,
                value: selectedValue,
                onChanged: (val) => selectedValue = val,
              ),
            ),
          ),
        ),
      );

      // Open menu
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Tap disabled option 3
      await tester.tap(find.text('Option 3 (Disabled)'));
      await tester.pumpAndSettle();

      // Value unchanged and menu remains or closes without change
      expect(selectedValue, equals('opt1'));
    });

    testWidgets('ESC closes select menu', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          home: Center(
            child: SizedBox(
              width: 260,
              child: SofSelect<String>(
                items: testItems,
                value: 'opt1',
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(find.text('Option 2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Option 2'), findsNothing);
    });
  });

  group('SofPopover Tests', () {
    testWidgets('Tapping child opens popover, tapping outside closes it', (tester) async {
      await tester.pumpWidget(
        const SoflumeApp(
          home: Center(
            child: SofPopover(
              content: Text('Floating Popover Content'),
              child: Text('Click For Popover'),
            ),
          ),
        ),
      );

      expect(find.text('Click For Popover'), findsOneWidget);
      expect(find.text('Floating Popover Content'), findsNothing);

      // Tap trigger
      await tester.tap(find.text('Click For Popover'));
      await tester.pumpAndSettle();

      expect(find.text('Floating Popover Content'), findsOneWidget);

      // Tap outside (top left screen corner)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Floating Popover Content'), findsNothing);
    });

    testWidgets('ESC key closes popover', (tester) async {
      await tester.pumpWidget(
        const SoflumeApp(
          home: Center(
            child: SofPopover(
              content: Text('Keyboard Popover Content'),
              child: Text('Trigger Popover'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Popover'));
      await tester.pumpAndSettle();
      expect(find.text('Keyboard Popover Content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Keyboard Popover Content'), findsNothing);
    });
  });
}
