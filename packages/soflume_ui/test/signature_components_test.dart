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

    testWidgets('SofFluidSheet renders content and handles drag snapping', (tester) async {
      int? changedSnap;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: 600,
              width: 400,
              child: SofFluidSheet(
                snapPoints: const [0.3, 0.6, 0.9],
                initialSnapIndex: 1,
                onSnapChanged: (index) {
                  changedSnap = index;
                },
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: const [
                      Text('Item 1'),
                      Text('Item 2'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      // Drag handle up to trigger snap change
      await tester.drag(find.byType(GestureDetector).first, const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(changedSnap, isNotNull);
    });

    testWidgets('SofFluidSheet dragging down at top of list reduces sheet extent', (tester) async {
      int? changedSnap;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: 600,
              width: 400,
              child: SofFluidSheet(
                snapPoints: const [0.3, 0.6, 0.9],
                initialSnapIndex: 1, // 0.6
                onSnapChanged: (index) {
                  changedSnap = index;
                },
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 50, child: Text('List Item 1')),
                      SizedBox(height: 50, child: Text('List Item 2')),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Drag list down at the top edge (overscroll downwards)
      await tester.drag(find.text('List Item 1'), const Offset(0, 150));
      await tester.pumpAndSettle();

      // Should snap to lowest point (index 0 = 0.3)
      expect(changedSnap, equals(0));
    });

    testWidgets('SofFluidSheet ignores horizontal scrolling inside content', (tester) async {
      int? changedSnap;

      await tester.pumpWidget(
        SoflumeTheme(
          data: SoflumeThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: 600,
              width: 400,
              child: SofFluidSheet(
                snapPoints: const [0.3, 0.6, 0.9],
                initialSnapIndex: 1, // 0.6
                onSnapChanged: (index) {
                  changedSnap = index;
                },
                builder: (context, scrollController) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(width: 300, child: Text('Horizontal 1')),
                      SizedBox(width: 300, child: Text('Horizontal 2')),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Drag horizontally
      await tester.drag(find.text('Horizontal 1'), const Offset(-150, 0));
      await tester.pumpAndSettle();

      // changedSnap must remain null because horizontal gestures do not drive vertical sheet expansion
      expect(changedSnap, isNull);
    });
  });
}
