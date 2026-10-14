import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// Strictly import ONLY public package library root
import 'package:soflume_ui/soflume_ui.dart';

/// Integration test simulating an external 3rd-party Flutter application
/// consuming soflume_ui as a published package dependency.
void main() {
  testWidgets('External consumer can build and interact with Soflume UI public APIs', (tester) async {
    String? selectedTech = 'flutter';

    await tester.pumpWidget(
      SoflumeApp(
        theme: SoflumeThemeData.light(
          customAccent: const Color(0xFF10B981),
        ),
        home: Builder(
          builder: (context) {
            final theme = SoflumeTheme.of(context);
            expect(theme.colors.accent, equals(const Color(0xFF10B981)));

            return Column(
              children: [
                const SofIcon(SofIcons.sparkles, size: 24),
                SofButton(
                  variant: SofButtonVariant.filled,
                  onPressed: () {
                    showSofToast(
                      context: context,
                      message: 'Consumer Toast Works',
                    );
                  },
                  child: const Text('Consumer Action'),
                ),
                SofSelect<String>(
                  value: selectedTech,
                  items: const [
                    SofSelectItem(value: 'flutter', label: 'Flutter Impeller'),
                    SofSelectItem(value: 'dart', label: 'Dart Native'),
                  ],
                  onChanged: (v) => selectedTech = v,
                ),
                const SofPopover(
                  content: Text('Consumer Popover Content'),
                  child: Text('Open Popover'),
                ),
                const SofLiveCapsule(
                  leading: SofIcon(SofIcons.music, size: 16),
                  title: Text('Live Status'),
                  expandedChild: Text('Expanded Consumer Data'),
                ),
              ],
            );
          },
        ),
      ),
    );

    // Verify elements rendered
    expect(find.text('Consumer Action'), findsOneWidget);
    expect(find.text('Flutter Impeller'), findsOneWidget);
    expect(find.text('Live Status'), findsOneWidget);

    // Verify button toast interaction
    await tester.tap(find.text('Consumer Action'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Consumer Toast Works'), findsOneWidget);
  });
}
