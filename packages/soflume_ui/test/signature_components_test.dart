import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('Signature Components Tests', () {
    testWidgets('SofMorphingButton transitions between states', (tester) async {
      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofMorphingButton(
                state: SofMorphingState.idle,
                onPressed: () {},
                child: const Text('Confirm Order'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Confirm Order'), findsOneWidget);

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofMorphingButton(
                state: SofMorphingState.success,
                onPressed: () {},
                child: const Text('Confirm Order'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SofIcon), findsOneWidget);
    });

    testWidgets('SofLiveCapsule renders title and toggles expansion', (tester) async {
      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofLiveCapsule(
                leading: SofIcon(SofIcons.music),
                title: Text('Now Playing'),
                expandedChild: Text('Expanded Player Details'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Expanded Player Details'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Now Playing'));
      await tester.pumpAndSettle();

      expect(find.text('Expanded Player Details'), findsOneWidget);
    });

    testWidgets('SofAdaptiveTile renders metrics and title', (tester) async {
      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SofAdaptiveTile(
                title: Text('Daily Steps'),
                value: Text('10,420'),
                subtitle: Text('+12% from yesterday'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Daily Steps'), findsOneWidget);
      expect(find.text('10,420'), findsOneWidget);
      expect(find.text('+12% from yesterday'), findsOneWidget);
    });
  });
}
