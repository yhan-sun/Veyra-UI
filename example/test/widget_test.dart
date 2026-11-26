import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soflume_gallery/main.dart';

void main() {
  testWidgets('SoflumeShowcaseApp boots and switches through all modular sections', (tester) async {
    await tester.pumpWidget(const SoflumeShowcaseApp());
    await tester.pumpAndSettle();

    // Verify brand header and initial Overview screen
    expect(find.text('Soflume UI'), findsOneWidget);
    expect(find.text('Soft Lumen Design System v1.0'), findsOneWidget);

    // Switch to Design System (设计规范)
    await tester.tap(find.text('设计规范').first);
    await tester.pumpAndSettle();
    expect(find.text('设计规范与 Design Tokens'), findsOneWidget);
    expect(find.text('G2 连续曲率超椭圆'), findsOneWidget);

    // Switch to Components Showcase (组件展馆)
    await tester.tap(find.text('组件展馆').first);
    await tester.pumpAndSettle();
    expect(find.text('标志性特色组件 (Signature Components)'), findsOneWidget);

    // Verify SofPopover opens when clicking SofButton trigger in Overlays section
    await tester.tap(find.text('弹层与通知').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('点击打开 SofPopover'));
    await tester.tap(find.text('点击打开 SofPopover'));
    await tester.pumpAndSettle();
    expect(find.text('快速操作上下文'), findsOneWidget);

    // Dismiss popover via outside tap
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    // Switch to Theme Workshop (主题工坊)
    await tester.tap(find.text('主题工坊').first);
    await tester.pumpAndSettle();

    // Switch to Flagship Demos (场景演示)
    await tester.tap(find.text('场景演示').first);
    await tester.pumpAndSettle();
    expect(find.text('Airplane Mode'), findsOneWidget);

    // Switch sub-demo to Music
    await tester.tap(find.text('音乐播放').first);
    await tester.pumpAndSettle();
    expect(find.text('Luminous Waves'), findsOneWidget);

    // Switch sub-demo to Files
    await tester.tap(find.text('文件管理').first);
    await tester.pumpAndSettle();
    expect(find.text('Design-Tokens-v1.json'), findsOneWidget);

    // Switch sub-demo to Dashboard
    await tester.tap(find.text('数据看板').first);
    await tester.pumpAndSettle();
    expect(find.text('Total Revenue'), findsOneWidget);
  });

  testWidgets('Mobile 390px viewport renders overview and floating nav without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SoflumeShowcaseApp());
    await tester.pumpAndSettle();

    expect(find.text('Soflume UI'), findsOneWidget);
    expect(find.text('演示'), findsOneWidget);
  });
}
