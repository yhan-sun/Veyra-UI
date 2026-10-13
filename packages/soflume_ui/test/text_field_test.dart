import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofTextField Tests', () {
    testWidgets('Renders placeholder when text is empty and hides it when text is entered', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        SoflumeApp(
          home: Center(
            child: SofTextField(
              controller: controller,
              placeholder: 'Enter your name...',
            ),
          ),
        ),
      );

      // Verify placeholder is visible
      expect(find.text('Enter your name...'), findsOneWidget);

      // Focus and enter text
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'Alex');
      await tester.pump();

      // Placeholder should now be hidden
      expect(find.text('Enter your name...'), findsNothing);
      expect(find.text('Alex'), findsOneWidget);

      // Clear text
      controller.clear();
      await tester.pump();

      // Placeholder should be visible again
      expect(find.text('Enter your name...'), findsOneWidget);
    });

    testWidgets('didUpdateWidget safely swaps external TextEditingController and FocusNode', (tester) async {
      final controller1 = TextEditingController(text: 'Initial');
      final controller2 = TextEditingController(text: 'Updated');
      final focusNode1 = FocusNode();
      final focusNode2 = FocusNode();

      bool useSecond = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Column(
                children: [
                  SofButton(
                    onPressed: () => setState(() => useSecond = !useSecond),
                    child: const Text('Swap'),
                  ),
                  SofTextField(
                    controller: useSecond ? controller2 : controller1,
                    focusNode: useSecond ? focusNode2 : focusNode1,
                    placeholder: 'Type here...',
                  ),
                ],
              ),
            );
          },
        ),
      );

      expect(find.text('Initial'), findsOneWidget);
      expect(find.text('Updated'), findsNothing);

      // Tap Swap button to trigger didUpdateWidget with new controller & focusNode
      await tester.tap(find.text('Swap'));
      await tester.pump();

      expect(find.text('Initial'), findsNothing);
      expect(find.text('Updated'), findsOneWidget);

      // Clean up
      controller1.dispose();
      controller2.dispose();
      focusNode1.dispose();
      focusNode2.dispose();
    });

    testWidgets('Renders errorText and helperText properly', (tester) async {
      await tester.pumpWidget(
        const SoflumeApp(
          home: Center(
            child: SofTextField(
              errorText: 'Invalid email address',
            ),
          ),
        ),
      );

      expect(find.text('Invalid email address'), findsOneWidget);
    });
  });
}
