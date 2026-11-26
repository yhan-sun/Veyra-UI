import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('Navigation Components Tests', () {
    testWidgets('SofTabs switches tabs and handles unbounded Row safely', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SofTabs(
                      selectedIndex: selected,
                      onChanged: (idx) => setState(() => selected = idx),
                      tabs: const [
                        SofTabItem(label: 'First'),
                        SofTabItem(label: 'Second'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();
      expect(selected, equals(1));
    });

    testWidgets('SofBreadcrumb triggers onTap on parent crumbs only', (tester) async {
      String? clicked;

      await tester.pumpWidget(
        SoflumeApp(
          home: Center(
            child: SofBreadcrumb(
              items: [
                SofBreadcrumbItem(label: 'Root', onTap: () => clicked = 'Root'),
                const SofBreadcrumbItem(label: 'Current'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Root'));
      await tester.pump();
      expect(clicked, equals('Root'));
    });

    testWidgets('SofFloatingNavigation switches items', (tester) async {
      int index = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: SofFloatingNavigation(
                selectedIndex: index,
                onChanged: (i) => setState(() => index = i),
                items: const [
                  SofNavItem(icon: SofIcon(SofIcons.activity), label: 'Home'),
                  SofNavItem(icon: SofIcon(SofIcons.settings), label: 'Settings'),
                ],
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(index, equals(1));
    });
  });

  group('Containers & IconButton Tests', () {
    testWidgets('SofCard variants and onPressed work cleanly', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        SoflumeApp(
          home: Column(
            children: [
              SofCard(
                variant: SofSurfaceVariant.ambient,
                onPressed: () => tapped = true,
                child: const Text('Ambient Card'),
              ),
              const SofCard(
                variant: SofSurfaceVariant.floating,
                child: Text('Floating Card'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Ambient Card'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      // Verify ambient top-left gradient stop stays opaque
      final container = tester.widgetList<Container>(find.byType(Container)).firstWhere(
        (c) => c.decoration is ShapeDecoration && (c.decoration as ShapeDecoration).gradient is LinearGradient,
      );
      final gradient = (container.decoration as ShapeDecoration).gradient as LinearGradient;
      expect(gradient.colors.first.a, equals(1.0));
    });

    testWidgets('SofListTile renders title, subtitle, chevron and fires tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        SoflumeApp(
          home: SofListTile(
            leading: const SofIcon(SofIcons.wifi),
            title: const Text('Wi-Fi'),
            subtitle: const Text('Connected'),
            showChevron: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);
      await tester.tap(find.text('Wi-Fi'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('SofIconButton handles circle and squircle shapes', (tester) async {
      int taps = 0;

      await tester.pumpWidget(
        SoflumeApp(
          home: Row(
            children: [
              SofIconButton(
                shape: SofIconButtonShape.circle,
                tooltip: 'Like',
                icon: const SofIcon(SofIcons.heart),
                onPressed: () => taps++,
              ),
              SofIconButton(
                shape: SofIconButtonShape.squircle,
                icon: const SofIcon(SofIcons.star),
                onPressed: () => taps++,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(SofIconButton).first);
      await tester.pumpAndSettle();
      expect(taps, equals(1));
    });
  });
}
