import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 概览模块：设计哲学、跨系统融合、快速上手与架构分层
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, required this.onNavigateToComponents});

  final VoidCallback onNavigateToComponents;

  void _copySnippet(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    showSofToast(
      context: context,
      message: '代码已复制到剪贴板',
      variant: SofBadgeVariant.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              SofCard(
                variant: SofSurfaceVariant.ambient,
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.accentSubtle,
                            borderRadius: BorderRadius.circular(radii.xs),
                            border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SofIcon(SofIcons.sparkles, size: 14, color: colors.accent),
                              const SizedBox(width: 6),
                              Text(
                                'Soft Lumen Design System v1.0',
                                style: typography.caption.copyWith(
                                  color: colors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SofBadge(label: Text('开源旗舰级'), variant: SofBadgeVariant.accent),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '面向未来的 Flutter 现代化跨平台组件库',
                      style: typography.display.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '不是简单封装 Material，而是融合 vivo OriginOS 自然光学、华为 HarmonyOS 空间秩序、OPPO ColorOS 细腻材质、小米 HyperOS 灵动胶囊与 Apple iOS/macOS 触控一致性的独立设计语言。聚焦 G2 连续超椭圆轮廓、调和弹簧动力学与柔光通透材质。',
                      style: typography.body.copyWith(
                        color: colors.contentSecondary,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SofButton(
                          variant: SofButtonVariant.filled,
                          leading: const SofIcon(SofIcons.component, size: 18, color: Color(0xFFFFFFFF)),
                          onPressed: onNavigateToComponents,
                          child: const Text('探索所有组件'),
                        ),
                        SofButton(
                          variant: SofButtonVariant.subtle,
                          leading: const SofIcon(SofIcons.copy, size: 18),
                          onPressed: () => _copySnippet(
                            context,
                            'dependencies:\n  soflume_ui:\n    git: https://github.com/yhan-sun/Veyra-UI.git',
                          ),
                          child: const Text('复制依赖配置'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // 核心五大设计基因
              Text(
                '旗舰操作系统设计基因融合',
                style: typography.headline.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '博采各大旗舰 OS 交互精髓，经过系统化重构，演化为 Soflume 独有的柔光设计语法。',
                style: typography.caption.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 18),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final itemWidth = isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.activity,
                        title: 'vivo OriginOS 动效哲学',
                        desc: '连续光学与真实物理弹簧，拒绝生硬切角与状态跳变，交互过程全程可打断。',
                      ),
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.layout,
                        title: '华为 HarmonyOS 空间秩序',
                        desc: '多端自适应布局断点、温润卡片层级与无障碍严谨对比度保障。',
                      ),
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.sparkles,
                        title: 'OPPO ColorOS 材质光感',
                        desc: '克制通透的 Soft Lumen 四重材质（Solid, Frost, Ambient, Floating），告别廉价拟物。',
                      ),
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.zap,
                        title: '小米 HyperOS 灵动胶囊',
                        desc: '标志性 LiveCapsule 状态胶囊、FluidSheet 多阶吸附底板与 Morphing 变形按键。',
                      ),
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.shield,
                        title: 'Apple iOS/macOS 触控一致性',
                        desc: '完备的 ESC / Android Back 键关闭响应、焦点环导航与无障碍语义标签支持。',
                      ),
                      _buildPillarCard(
                        context,
                        width: itemWidth,
                        icon: SofIcons.cpu,
                        title: '100% 纯原生 Flutter 实现',
                        desc: '零繁重第三方依赖，基于 Canvas 自绘与核心 Engine 渲染，跨 Web、iOS、Android、macOS 极致流畅。',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),

              // 快速上手 Quick Start
              Text(
                '快速上手 Quick Start',
                style: typography.headline.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),

              _buildCodeBlock(
                context,
                title: '1. 添加依赖 (pubspec.yaml)',
                code: 'dependencies:\n  flutter:\n    sdk: flutter\n  soflume_ui:\n    git: https://github.com/yhan-sun/Veyra-UI.git',
              ),
              const SizedBox(height: 16),

              _buildCodeBlock(
                context,
                title: '2. 初始化根应用 (main.dart)',
                code: "import 'package:flutter/widgets.dart';\nimport 'package:soflume_ui/soflume_ui.dart';\n\nvoid main() {\n  runApp(SoflumeApp(\n    theme: SoflumeThemeData.light(),\n    home: const HomeScreen(),\n  ));\n}",
              ),
              const SizedBox(height: 16),

              _buildCodeBlock(
                context,
                title: '3. 使用组件与呼出弹层',
                code: "SofButton(\n  variant: SofButtonVariant.filled,\n  onPressed: () {\n    showSofToast(\n      context: context,\n      message: '欢迎体验 Soflume UI 柔光设计系统',\n      variant: SofBadgeVariant.accent,\n    );\n  },\n  child: const Text('体验交互'),\n);",
              ),
              const SizedBox(height: 36),

              // 分层架构图
              Text(
                '工程架构分层模型',
                style: typography.headline.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              SofCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLayerRow(context, 'Application Patterns', 'Flagship Demo Apps (设置、音乐、文件、看板)、响应式模版'),
                    _buildLayerRow(context, 'Advanced / Signatures', 'FluidSheet, MorphingButton, LiveCapsule, AdaptiveTile'),
                    _buildLayerRow(context, 'Components', 'Button, Input, Toggle, Selection, Card, Dialog, Sheet, Toast, Tabs'),
                    _buildLayerRow(context, 'Primitives', 'SofSurface, SofPressable, SofFocusRing, SofAdaptiveBuilder'),
                    _buildLayerRow(context, 'Foundation', 'Design Tokens (Color, Shape, Motion, Typography, Spacing, Density), SoflumeApp'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarCard(
    BuildContext context, {
    required double width,
    required String icon,
    required String title,
    required String desc,
  }) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SizedBox(
      width: width,
      child: SofCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.accentSubtle,
                borderRadius: BorderRadius.circular(radii.xs),
              ),
              child: SofIcon(icon, size: 20, color: colors.accent),
            ),
            const SizedBox(height: 14),
            Text(title, style: typography.title.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              desc,
              style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlock(BuildContext context, {required String title, required String code}) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SofCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
              SofButton(
                size: SofButtonSize.small,
                variant: SofButtonVariant.ghost,
                leading: const SofIcon(SofIcons.clipboard, size: 14),
                onPressed: () => _copySnippet(context, code),
                child: const Text('复制'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.canvas,
              borderRadius: BorderRadius.circular(radii.xs),
              border: Border.all(color: colors.outlineSubtle),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                code,
                style: typography.code.copyWith(fontSize: 12, color: colors.contentPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerRow(BuildContext context, String layerName, String desc) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              layerName,
              style: typography.body.copyWith(fontWeight: FontWeight.w700, color: colors.accent),
            ),
          ),
          Expanded(
            child: Text(
              desc,
              style: typography.body.copyWith(color: colors.contentSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
