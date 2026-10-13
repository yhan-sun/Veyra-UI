import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_gallery/main.dart';

void main() {
  testWidgets('SoflumeShowcaseApp boots and switches tabs', (tester) async {
    await tester.pumpWidget(const SoflumeShowcaseApp());
    await tester.pumpAndSettle();

    // Verify header and initial gallery screen
    expect(find.text('Soflume UI'), findsOneWidget);
    expect(find.text('Soft Lumen / 柔光美学'), findsOneWidget);

    // Switch to Settings tab
    await tester.tap(find.text('设置应用').first);
    await tester.pumpAndSettle();
    expect(find.text('Airplane Mode'), findsOneWidget);

    // Switch to Music tab
    await tester.tap(find.text('音乐播放').first);
    await tester.pumpAndSettle();
    expect(find.text('Luminous Waves'), findsOneWidget);

    // Switch to Files tab
    await tester.tap(find.text('文件管理').first);
    await tester.pumpAndSettle();
    expect(find.text('Design-Tokens-v1.json'), findsOneWidget);

    // Switch to Dashboard tab
    await tester.tap(find.text('数据看板').first);
    await tester.pumpAndSettle();
    expect(find.text('Total Revenue'), findsOneWidget);
  });
}
