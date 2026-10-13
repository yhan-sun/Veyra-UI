import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_gallery/main.dart';

void main() {
  testWidgets('SoflumeShowcaseApp boots and switches tabs', (tester) async {
    await tester.pumpWidget(const SoflumeShowcaseApp());
    await tester.pumpAndSettle();

    // Verify header and initial gallery screen
    expect(find.text('Soflume UI'), findsOneWidget);
    expect(find.text('Component Gallery'), findsOneWidget);

    // Switch to Settings tab
    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();
    expect(find.text('Airplane Mode'), findsOneWidget);

    // Switch to Music tab
    await tester.tap(find.text('Music').first);
    await tester.pumpAndSettle();
    expect(find.text('Luminous Waves'), findsOneWidget);

    // Switch to Files tab
    await tester.tap(find.text('Files').first);
    await tester.pumpAndSettle();
    expect(find.text('Design-Tokens-v1.json'), findsOneWidget);

    // Switch to Dashboard tab
    await tester.tap(find.text('Dashboard').first);
    await tester.pumpAndSettle();
    expect(find.text('Total Revenue'), findsOneWidget);
  });
}
