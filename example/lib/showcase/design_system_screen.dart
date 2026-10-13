import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 设计系统规范解析平台：色彩、超椭圆曲率、物理动效、材质层级与排版间距
class DesignSystemScreen extends StatefulWidget {
  const DesignSystemScreen({super.key});

  @override
  State<DesignSystemScreen> createState() => _DesignSystemScreenState();
}

class _DesignSystemScreenState extends State<DesignSystemScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _motionController;
  int _selectedCurveIndex = 0; // 0: Snappy, 1: Bouncy, 2: Settle

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  void _triggerMotion() {
    if (_motionController.isCompleted) {
      _motionController.reverse();
    } else {
      _motionController.forward();
    }
  }

  Curve get _activeCurve {
    switch (_selectedCurveIndex) {
      case 1:
        return const SofSpringCurve.gentle();
      case 2:
        return const SofSpringCurve.settle();
      case 0:
      default:
        return const SofSpringCurve.snappy();
    }
  }

  String _formatHex(Color c) {
    return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  double _luminance(Color c) {
    return (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b);
  }

  String _contrastRatio(Color c1, Color c2) {
    final l1 = _luminance(c1);
    final l2 = _luminance(c2);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    final ratio = (lighter + 0.05) / (darker + 0.05);
    return '${ratio.toStringAsFixed(1)}:1';
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;
    final spacing = theme.spacing;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 模块标题
              Text(
                '设计规范与 Design Tokens',
                style: typography.display.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Soflume 坚持以严谨的数学规律与光学原理为基底，所有 Token 均具备类型安全与语义化定义。',
                style: typography.body.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 32),

              // 1. 色彩体系
              _buildSectionTitle('一、色彩系统 (Color System & Luminance)'),
              const SizedBox(height: 6),
              Text(
                '支持语义化前景色动态推导，自动根据相对明度计算出最符合 WCAG AA/AAA 对比度的前景色。',
                style: typography.caption.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 16),

              // 主色与对比度卡片
              SofCard(
                variant: SofSurfaceVariant.ambient,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(radii.md),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Aa',
                        style: TextStyle(
                          color: colors.onAccent,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '当前品牌主色 (Accent) & 前景色 (onAccent)',
                            style: typography.title.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Accent: ${_formatHex(colors.accent)} • onAccent: ${_formatHex(colors.onAccent)} • 对比度: ${_contrastRatio(colors.accent, colors.onAccent)}',
                            style: typography.caption.copyWith(color: colors.contentSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SofBadge(
                      label: Text('WCAG 达标'),
                      variant: SofBadgeVariant.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 颜色网格
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final itemWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildColorTile('Canvas (底色)', colors.canvas, itemWidth),
                      _buildColorTile('Surface (表面)', colors.surface, itemWidth),
                      _buildColorTile('Surface Raised', colors.surfaceRaised, itemWidth),
                      _buildColorTile('Surface Muted', colors.surfaceMuted, itemWidth),
                      _buildColorTile('Accent (主强调)', colors.accent, itemWidth),
                      _buildColorTile('Accent Subtle', colors.accentSubtle, itemWidth),
                      _buildColorTile('Success (成功)', colors.success, itemWidth),
                      _buildColorTile('Danger (危险)', colors.danger, itemWidth),
                      _buildColorTile('Warning (警告)', colors.warning, itemWidth),
                      _buildColorTile('Overlay (遮罩)', colors.overlay, itemWidth),
                      _buildColorTile('Content Primary', colors.contentPrimary, itemWidth),
                      _buildColorTile('Outline Subtle', colors.outlineSubtle, itemWidth),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),

              // 2. 连续曲率形状系统
              _buildSectionTitle('二、连续曲率形状系统 (G2 Squircle vs Circle)'),
              const SizedBox(height: 6),
              Text(
                '标准圆角在切点处曲率瞬间突变为零，会产生肉眼可辨的生硬折痕；Soflume 全局采用超椭圆（Squircle）算法，实现切线斜率与曲率的二阶连续过渡。',
                style: typography.caption.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 18),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 780;
                  final colWidth = isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      // G2 超椭圆
                      SizedBox(
                        width: colWidth,
                        child: SofCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const SofBadge(label: Text('Soflume 标准'), variant: SofBadgeVariant.accent),
                                  Text('G2 连续曲率超椭圆', style: typography.title.copyWith(fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: ShapeDecoration(
                                    color: colors.accentSubtle,
                                    shape: SofSquircleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: BorderSide(color: colors.accent, width: 2),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'G2 Squircle',
                                    style: typography.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.accent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• 连续曲率导数平滑无断点\n• 视觉圆润饱满、重心稳健\n• 符合 vivo / Apple 旗舰系统工业设计语言',
                                style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.6),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 普通圆角对比
                      SizedBox(
                        width: colWidth,
                        child: SofCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const SofBadge(label: Text('传统方案'), variant: SofBadgeVariant.neutral),
                                  Text('传统双圆弧切角', style: typography.title.copyWith(fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: colors.surfaceRaised,
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(color: colors.outlineSubtle, width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Standard Radius',
                                    style: typography.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.contentSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• 直线向弧线切点处曲率突变跳跃\n• 容易在四个边角产生生硬的方正感\n• 缺乏系统级的柔润质感',
                                style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),

              // 3. 物理弹簧动效系统
              _buildSectionTitle('三、物理弹簧动效系统 (Physics Spring Motion)'),
              const SizedBox(height: 6),
              Text(
                '告别机械单调的贝塞尔线性过渡。Soflume 动效由简谐振动物理模型驱动，支持实时交互打断与初速度保留。',
                style: typography.caption.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 18),

              SofCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('物理曲线试炼场', style: typography.title.copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        SofSegmentedControl<int>(
                          value: _selectedCurveIndex,
                          onChanged: (val) {
                            setState(() => _selectedCurveIndex = val);
                            _triggerMotion();
                          },
                          segments: const [
                            SofSegment(value: 0, label: Text('Snappy 紧致')),
                            SofSegment(value: 1, label: Text('Gentle 柔和')),
                            SofSegment(value: 2, label: Text('Settle 柔顺')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 动画运行轨道
                    Container(
                      width: double.infinity,
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: colors.canvas,
                        borderRadius: BorderRadius.circular(radii.md),
                        border: Border.all(color: colors.outlineSubtle),
                      ),
                      alignment: Alignment.centerLeft,
                      child: LayoutBuilder(
                        builder: (context, trackConstraints) {
                          final maxTravel = trackConstraints.maxWidth - 52;

                          return AnimatedBuilder(
                            animation: _motionController,
                            builder: (context, child) {
                              final curvedVal = _activeCurve.transform(_motionController.value);
                              final offsetDx = maxTravel * curvedVal;

                              return Transform.translate(
                                offset: Offset(offsetDx, 0),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: ShapeDecoration(
                                    color: colors.accent,
                                    shape: SofSquircleBorder(
                                      borderRadius: BorderRadius.circular(radii.sm),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: colors.accent.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const SofIcon(
                                    SofIcons.zap,
                                    size: 20,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        SofButton(
                          variant: SofButtonVariant.filled,
                          leading: const SofIcon(SofIcons.play, size: 16, color: Color(0xFFFFFFFF)),
                          onPressed: _triggerMotion,
                          child: const Text('触发物理回弹'),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '当前参数: ${_selectedCurveIndex == 0 ? "Snappy (Stiffness: 420, Damping: 32)" : _selectedCurveIndex == 1 ? "Gentle (Stiffness: 240, Damping: 28)" : "Settle (Stiffness: 300, Damping: 36)"}',
                          style: typography.caption.copyWith(color: colors.contentSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 4. Soft Lumen 四重材质模型
              _buildSectionTitle('四、Soft Lumen 四重材质模型 (Surfaces)'),
              const SizedBox(height: 6),
              Text(
                '空间层级由材质折射与光影扩散深度明确表达，在保持极简现代的前提下建立清晰信息纵深。',
                style: typography.caption.copyWith(color: colors.contentSecondary),
              ),
              const SizedBox(height: 18),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final colWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildSurfaceModelCard('Solid Surface', '实体表面', '纯色背景配合超细微弱描边，适用于绝大多数静态信息卡片。', SofSurfaceVariant.solid, colWidth),
                      _buildSurfaceModelCard('Frost Surface', '通透磨砂', '高保真 BackdropFilter 背景模糊，用于悬浮导航底栏与侧滑面板。', SofSurfaceVariant.frost, colWidth),
                      _buildSurfaceModelCard('Ambient Surface', '微光漫反射', '柔和弥散环境光投影，营造高级温润的焦点强调，用于 Hero 卡片。', SofSurfaceVariant.ambient, colWidth),
                      _buildSurfaceModelCard('Floating Surface', '高悬浮阶梯', '多阶扩散大范围投影与抬升层级，用于模态弹窗、Sheet 与 Toast 通知。', SofSurfaceVariant.floating, colWidth),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),

              // 5. 排版与间距规范
              _buildSectionTitle('五、排版规范与间距标尺 (Typography & Spacing)'),
              const SizedBox(height: 18),

              SofCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypographyRow(context, 'Display 28/34', typography.display, '高端标题与展馆主视觉'),
                    _buildTypographyRow(context, 'Headline 22/28', typography.headline, '页面级大栏目标题'),
                    _buildTypographyRow(context, 'Title 18/24', typography.title, '卡片模块核心标题'),
                    _buildTypographyRow(context, 'Body 14/20', typography.body, '正文、表单录入与常规交互信息'),
                    _buildTypographyRow(context, 'Caption 12/16', typography.caption, '辅助描述、状态角标与次要提示'),
                    _buildTypographyRow(context, 'Code 13/18', typography.code, '等宽技术代码片段展示'),
                    const SizedBox(height: 20),
                    const DividerBorder(),
                    const SizedBox(height: 20),
                    Text('间距标尺 (Spacing Grid)', style: typography.title.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSpacingBadge('xxs: ${spacing.xxs.toInt()}dp'),
                        _buildSpacingBadge('xs: ${spacing.xs.toInt()}dp'),
                        _buildSpacingBadge('sm: ${spacing.sm.toInt()}dp'),
                        _buildSpacingBadge('md: ${spacing.md.toInt()}dp'),
                        _buildSpacingBadge('lg: ${spacing.lg.toInt()}dp'),
                        _buildSpacingBadge('xl: ${spacing.xl.toInt()}dp'),
                        _buildSpacingBadge('xxl: ${spacing.xxl.toInt()}dp'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = SoflumeTheme.of(context);
    return Text(
      title,
      style: theme.typography.headline.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildColorTile(String label, Color color, double width) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SizedBox(
      width: width,
      child: SofCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radii.xs),
                border: Border.all(color: colors.outlineSubtle),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(
              _formatHex(color),
              style: typography.code.copyWith(fontSize: 10, color: colors.contentSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurfaceModelCard(String name, String subname, String desc, SofSurfaceVariant variant, double width) {
    final theme = SoflumeTheme.of(context);
    final typography = theme.typography;
    final colors = theme.colors;

    return SizedBox(
      width: width,
      child: SofCard(
        variant: variant,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: typography.title.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subname, style: typography.caption.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              desc,
              style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyRow(BuildContext context, String label, TextStyle style, String desc) {
    final colors = SoflumeTheme.colorsOf(context);
    final typography = SoflumeTheme.typographyOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: style.copyWith(color: colors.contentPrimary)),
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

  Widget _buildSpacingBadge(String label) {
    return SofBadge(label: Text(label), variant: SofBadgeVariant.neutral);
  }
}

class DividerBorder extends StatelessWidget {
  const DividerBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: SoflumeTheme.colorsOf(context).outlineSubtle,
    );
  }
}
