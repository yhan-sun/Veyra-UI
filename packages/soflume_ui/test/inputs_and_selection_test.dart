import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('SofSlider Tests', () {
    testWidgets('Snaps divisions accurately when min != 0 and supports keyboard', (tester) async {
      double value = 10.0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: SizedBox(
                  width: 240,
                  child: SofSlider(
                    autofocus: true,
                    min: 10.0,
                    max: 20.0,
                    divisions: 2,
                    value: value,
                    onChanged: (v) => setState(() => value = v),
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(value, equals(15.0));

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(value, equals(20.0));

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(value, equals(10.0));
    });

    testWidgets('Handles min == max and disabled state cleanly', (tester) async {
      await tester.pumpWidget(
        const SoflumeApp(
          home: Center(
            child: SofSlider(
              min: 5.0,
              max: 5.0,
              value: 5.0,
              enabled: false,
              onChanged: null,
            ),
          ),
        ),
      );

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, equals(0.45));
    });
  });

  group('SofCheckbox & SofRadio Tests', () {
    testWidgets('SofCheckbox supports binary and tristate mixed semantics', (tester) async {
      bool? val = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SofCheckbox(
                      value: val,
                      label: const Text('Accept Terms'),
                      onChanged: (next) => setState(() => val = next),
                    ),
                    SofCheckbox(
                      value: null,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Accept Terms'));
      await tester.pumpAndSettle();
      expect(val, isTrue);

      final semanticsWidgets = tester.widgetList<Semantics>(find.byType(Semantics));
      expect(semanticsWidgets.any((s) => s.properties.mixed == true), isTrue);
    });

    testWidgets('SofRadio selects value within group', (tester) async {
      int groupValue = 1;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SofRadio<int>(
                      value: 1,
                      groupValue: groupValue,
                      label: const Text('One'),
                      onChanged: (v) => setState(() => groupValue = v ?? 1),
                    ),
                    SofRadio<int>(
                      value: 2,
                      groupValue: groupValue,
                      label: const Text('Two'),
                      onChanged: (v) => setState(() => groupValue = v ?? 2),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(groupValue, equals(2));
    });
  });

  group('SofSegmentedControl Tests', () {
    testWidgets('Switches active segment and ignores disabled segments', (tester) async {
      String current = 'a';

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: SofSegmentedControl<String>(
                  value: current,
                  onChanged: (v) => setState(() => current = v),
                  segments: const [
                    SofSegment(value: 'a', label: Text('Alpha')),
                    SofSegment(value: 'b', label: Text('Beta')),
                    SofSegment(value: 'c', label: Text('Gamma'), enabled: false),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(current, equals('b'));

      await tester.tap(find.text('Gamma'));
      await tester.pumpAndSettle();
      expect(current, equals('b'));
    });
  });
}
