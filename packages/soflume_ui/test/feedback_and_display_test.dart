import 'package:flutter/material.dart' show MaterialApp, ThemeData;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  group('Feedback & Display Components Tests', () {
    testWidgets('SofBadge renders label, dot, and child overlay', (tester) async {
      await tester.pumpWidget(
        const SoflumeApp(
          home: Row(
            children: [
              SofBadge(label: Text('New'), variant: SofBadgeVariant.warning),
              SofBadge(
                dot: true,
                variant: SofBadgeVariant.danger,
                child: SofIcon(SofIcons.bell),
              ),
            ],
          ),
        ),
      );

      expect(find.text('New'), findsOneWidget);
      expect(find.byType(SofIcon), findsOneWidget);
    });

    testWidgets('SofChip supports selection and SVG deletion', (tester) async {
      bool selected = false;
      bool deleted = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return SoflumeApp(
              home: Center(
                child: SofChip(
                  label: const Text('Tag'),
                  selected: selected,
                  onSelected: (v) => setState(() => selected = v),
                  onDeleted: () => deleted = true,
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('Tag'));
      await tester.pumpAndSettle();
      expect(selected, isTrue);

      await tester.tap(find.byType(SofIcon));
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
    });

    testWidgets('SofProgress & SofSkeleton handle standard and reduceMotion states', (tester) async {
      await tester.pumpWidget(
        SoflumeApp(
          theme: SoflumeThemeData.light(motion: SoflumeMotion.reduced),
          home: const Column(
            children: [
              SofProgress(value: 0.6),
              SofProgress(value: null, shape: SofProgressShape.circular),
              SofSkeleton(width: 120, height: 16),
            ],
          ),
        ),
      );

      expect(find.byType(SofProgress), findsNWidgets(2));
      expect(find.byType(SofSkeleton), findsOneWidget);
    });

    testWidgets('SofAlert, SofAvatar, and SofEmptyState render properly', (tester) async {
      bool closed = false;

      await tester.pumpWidget(
        SoflumeApp(
          home: Column(
            children: [
              SofAlert(
                title: const Text('Notice'),
                message: const Text('Details'),
                onClose: () => closed = true,
              ),
              const SofAvatar(initials: 'SY', statusColor: Color(0xFF10B981)),
              const SofEmptyState(
                icon: SofIcon(SofIcons.folder),
                title: Text('Empty'),
                message: Text('Nothing here'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Notice'), findsOneWidget);
      expect(find.text('SY'), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);

      await tester.tap(find.byType(SofIcon).first);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('SoflumeThemeExtension integrates with Material ThemeData', (tester) async {
      late SoflumeThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [SoflumeThemeExtension(SoflumeThemeData.dark())],
          ),
          home: Builder(
            builder: (context) {
              resolved = SoflumeTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.isDark, isTrue);
    });
  });
}
