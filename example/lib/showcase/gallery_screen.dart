import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 综合交互展馆与设计规范解读平台。
///
/// 包含设计哲学、连续曲率、物理弹簧、暗色光学层级详解，以及各组件的交互演练与 Dart 代码示例。
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // 交互状态
  bool _toggleVal1 = true;
  bool _toggleVal2 = true;
  bool? _checkboxVal1 = true;
  bool? _checkboxVal2 = false;
  int _radioVal = 1;
  int _segmentedVal = 0;
  double _sliderVal = 0.68;
  SofMorphingState _morphState = SofMorphingState.idle;
  bool _buttonLoading = false;
  final TextEditingController _inputController = TextEditingController(text: 'Soft Lumen 柔光设计');

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _cycleMorphState() {
    setState(() {
      switch (_morphState) {
        case SofMorphingState.idle:
          _morphState = SofMorphingState.loading;
          break;
        case SofMorphingState.loading:
          _morphState = SofMorphingState.success;
          break;
        case SofMorphingState.success:
          _morphState = SofMorphingState.error;
          break;
        case SofMorphingState.error:
          _morphState = SofMorphingState.idle;
          break;
      }
    });
  }

  void _showCodeDialog(String title, String code) {
    showSofDialog(
      context: context,
      builder: (context) {
        return SofDialog(
          title: Text('$title 代码示例'),
          actions: [
            SofButton(
              variant: SofButtonVariant.ghost,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
            SofButton(
              variant: SofButtonVariant.filled,
              leading: const SofIcon(SofIcons.clipboard, size: 16, color: Color(0xFFFFFFFF)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                Navigator.of(context).pop();
                showSofToast(
                  context: context,
                  message: '代码已复制到剪贴板',
                  variant: SofBadgeVariant.success,
                );
              },
              child: const Text('复制代码'),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SoflumeTheme.colorsOf(context).canvas,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SoflumeTheme.colorsOf(context).outlineSubtle),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    code,
                    style: SoflumeTheme.typographyOf(context).code.copyWith(
                          fontSize: 12,
                          color: SoflumeTheme.colorsOf(context).contentPrimary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部欢迎与设计哲学 Banner
          SofCard(
            variant: SofSurfaceVariant.ambient,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Soft Lumen / 柔光美学',
                          style: typography.headline.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 12),
                        const SofBadge(label: Text('v1.0 规范'), variant: SofBadgeVariant.accent),
                      ],
                    ),
                    Text(
                      'vivo OriginOS • 华为 HarmonyOS • OPPO ColorOS • 小米 HyperOS • Apple iOS/macOS',
                      style: typography.caption.copyWith(color: colors.contentSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '现代旗舰操作系统设计系统的集大成者：摒弃生硬切角与廉价拟物，聚焦 G2 连续超椭圆轮廓、调和弹簧动力学、多阶柔光材质与空间纵深感。',
                  style: typography.body.copyWith(color: colors.contentSecondary, height: 1.6),
                ),
                const SizedBox(height: 16),
                const Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    SofBadge(label: Text('物理弹簧无割裂动效'), variant: SofBadgeVariant.neutral),
                    SofBadge(label: Text('Superellipse 连续平滑曲率'), variant: SofBadgeVariant.neutral),
                    SofBadge(label: Text('WCAG AA 级暗色自适应'), variant: SofBadgeVariant.neutral),
                    SofBadge(label: Text('零冗余依赖纯原生实现'), variant: SofBadgeVariant.neutral),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 核心设计系统原理专区（中文深度解析）
          _buildCategoryHeader('0. 核心设计规范与光学原理'),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              final colWidth = isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  // 原理 1：连续曲率与超椭圆
                  SizedBox(
                    width: colWidth,
                    child: SofCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colors.accentSubtle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SofIcon(SofIcons.ruler, color: colors.accent, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('G2 连续曲率轮廓 (Squircle)', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '传统圆角（RoundedRect）在直线与圆弧相切处的曲率从 0 突变到 1/R，视觉上会形成明显的接缝凹折感。'
                            'Soflume 采用与 iOS 及 OriginOS 一致的连续曲率超椭圆算法（cornerSmoothing=0.67），利用三次贝塞尔平滑切线，令视觉过渡浑然天成。',
                            style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.5),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: colors.canvas,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('嵌套圆角公式：', style: typography.caption.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('R_inner = max(R_outer - Inset, 6.0)', overflow: TextOverflow.ellipsis, style: typography.code.copyWith(color: colors.accent)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 原理 2：暗色模式光学层级
                  SizedBox(
                    width: colWidth,
                    child: SofCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colors.accentSubtle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SofIcon(SofIcons.moon, color: colors.accent, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('暗色模式光学层级与边界', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '真正的暗色模式绝不是简单的背景反色：'
                            '1. 背景不使用纯黑（避免 OLED 快速滚动拖影与过高对比疲劳），采用深邃太空灰 #101218；'
                            '2. 深度由表面亮度差构建（Canvas 10 → Surface 1A → Raised 23）；'
                            '3. 阴影在暗色下失效，由 1dp 边缘对比高光线（OutlineSubtle）确立空间层次。',
                            style: typography.caption.copyWith(color: colors.contentSecondary, height: 1.5),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: colors.canvas,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('强调色暗色自动升亮：', style: typography.caption.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('Light #5362E8 → Dark #9EA8FF', overflow: TextOverflow.ellipsis, style: typography.code.copyWith(color: colors.accent)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 36),

          // 1. 品牌标志性组件 (Signature)
          _buildCategoryHeader('一、品牌标志性特色组件 (Signature Components)'),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              // 1.1 动态状态胶囊 LiveCapsule
              SofCard(
                width: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('SofLiveCapsule 动态胶囊', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        _buildCodeButton('SofLiveCapsule', '''SofLiveCapsule(
  leading: SofIcon(SofIcons.zap),
  title: Text('导出 4K 视频中...'),
  trailing: SofBadge(label: Text('78%')),
  expandedChild: Row(
    children: [
      Text('剩余时间: 14秒'),
      SofButton(child: Text('取消')),
    ],
  ),
)'''),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('灵感来自 HyperOS 与 iOS 灵动岛。常态为极简悬浮药丸，点击丝滑形变展开为全功能交互卡片。', style: typography.caption),
                    const SizedBox(height: 18),
                    SofLiveCapsule(
                      leading: const SofIcon(SofIcons.zap, size: 16),
                      title: const Text('导出 4K 柔光宣传片...'),
                      trailing: const SofBadge(label: Text('78%'), variant: SofBadgeVariant.accent),
                      expandedChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('预计剩余时间: 14 秒', style: TextStyle(fontSize: 12)),
                          SofButton(
                            size: SofButtonSize.small,
                            variant: SofButtonVariant.subtle,
                            onPressed: () {},
                            child: const Text('暂停任务'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 1.2 形变按钮 MorphingButton
              SofCard(
                width: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('SofMorphingButton 同源形变', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        _buildCodeButton('SofMorphingButton', '''SofMorphingButton(
  state: _morphState, // idle -> loading -> success -> error
  onPressed: _cycleMorphState,
  child: Text('提交并结账'),
)'''),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('按钮 → 环形转圈胶囊 → 成功/失败勾选的同源无损变形，零闪烁与跳帧。', style: typography.caption),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        SofMorphingButton(
                          state: _morphState,
                          onPressed: _cycleMorphState,
                          child: const Text('点击体验形变'),
                        ),
                        const SizedBox(width: 14),
                        SofButton(
                          size: SofButtonSize.small,
                          variant: SofButtonVariant.ghost,
                          onPressed: () => setState(() => _morphState = SofMorphingState.idle),
                          child: const Text('重置'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 1.3 动态磁贴 AdaptiveTile
              SizedBox(
                width: 360,
                child: SofAdaptiveTile(
                  variant: SofSurfaceVariant.ambient,
                  icon: const SofIcon(SofIcons.headphones, size: 18),
                  value: const Text('空间音频增强'),
                  title: const Text('杜比全景声已激活'),
                  subtitle: const Text('动态头部追踪已建立低延迟连接'),
                  statusBadge: const SofBadge(label: Text('96kHz 无损'), variant: SofBadgeVariant.accent),
                  footer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('已连接到 Soflume Studio Headset', style: TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      _buildCodeButton('SofAdaptiveTile', '''SofAdaptiveTile(
  variant: SofSurfaceVariant.ambient,
  icon: SofIcon(SofIcons.headphones),
  value: Text('空间音频增强'),
  title: Text('杜比全景声已激活'),
  subtitle: Text('动态头部追踪'),
  statusBadge: SofBadge(label: Text('无损')),
)'''),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // 2. 按钮与微交互
          _buildCategoryHeader('二、按钮与微交互体系 (Buttons & Micro-interactions)'),
          SofCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('多尺寸与语义变体', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    _buildCodeButton('SofButton', '''SofButton(
  variant: SofButtonVariant.filled, // filled | subtle | outlined | ghost | danger
  size: SofButtonSize.medium,       // small (34dp) | medium (42dp) | large (50dp)
  loading: false,
  onPressed: () {},
  child: Text('主要操作'),
)'''),
                  ],
                ),
                const SizedBox(height: 6),
                Text('全组件内置 0.97x 阻尼弹簧按压反馈、键盘聚焦环、悬停光晕与多态加载动画。', style: typography.caption),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SofButton(
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                      child: const Text('主要操作 Filled'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                      child: const Text('柔光半透 Subtle'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.outlined,
                      onPressed: () {},
                      child: const Text('线条边框 Outlined'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.ghost,
                      onPressed: () {},
                      child: const Text('幽灵态 Ghost'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.danger,
                      onPressed: () {},
                      child: const Text('警示危险 Danger'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.filled,
                      loading: _buttonLoading,
                      onPressed: () {
                        setState(() => _buttonLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _buttonLoading = false);
                        });
                      },
                      child: const Text('点击测试 Loading 状态'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('图标按钮与曲率模式 (Icon Buttons)', style: typography.label.copyWith(color: colors.contentSecondary)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SofIconButton(
                      icon: const SofIcon(SofIcons.star, size: 18),
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                      tooltip: '收藏',
                    ),
                    SofIconButton(
                      icon: const SofIcon(SofIcons.heart, size: 18),
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                      tooltip: '喜欢',
                    ),
                    SofIconButton(
                      icon: const SofIcon(SofIcons.zap, size: 18),
                      shape: SofIconButtonShape.circle,
                      variant: SofButtonVariant.outlined,
                      onPressed: () {},
                      tooltip: '圆形闪电',
                    ),
                    SofIconButton(
                      icon: const SofIcon(SofIcons.settings, size: 18),
                      variant: SofButtonVariant.ghost,
                      onPressed: () {},
                      tooltip: '系统偏好设置',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // 3. 输入与选择控件
          _buildCategoryHeader('三、输入与选择控件 (Selection & Inputs)'),
          SofCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('连续弹簧开关与滑块 (Toggle & Sliders)', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    _buildCodeButton('Toggle & Slider', '''SofToggle(
  value: _toggleVal,
  luminous: true, // 开启拇指环境光晕
  onChanged: (val) => setState(() => _toggleVal = val),
)

SofSlider(
  value: _sliderVal,
  luminous: true, // 开启发光轨道
  onChanged: (val) => setState(() => _sliderVal = val),
)'''),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('标准弹簧开关 SofToggle', style: typography.label),
                          const SizedBox(height: 4),
                          Text('按压时轻微拉伸形变，释放自然吸附', style: typography.caption),
                          const SizedBox(height: 10),
                          SofToggle(
                            value: _toggleVal1,
                            onChanged: (val) => setState(() => _toggleVal1 = val),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('柔光开关 SofToggle (Luminous)', style: typography.label),
                          const SizedBox(height: 4),
                          Text('开启时光斑向周围发射环境软光晕', style: typography.caption),
                          const SizedBox(height: 10),
                          SofToggle(
                            value: _toggleVal2,
                            luminous: true,
                            onChanged: (val) => setState(() => _toggleVal2 = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 复选框与单选按钮
                Text('连续圆角复选框与单选按钮 (Checkbox & Radio)', style: typography.label),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SofCheckbox(
                      value: _checkboxVal1,
                      label: const Text('自动云同步已勾选'),
                      onChanged: (val) => setState(() => _checkboxVal1 = val),
                    ),
                    const SizedBox(width: 24),
                    SofCheckbox(
                      value: _checkboxVal2,
                      label: const Text('硬件加速渲染'),
                      onChanged: (val) => setState(() => _checkboxVal2 = val),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    SofRadio<int>(
                      value: 1,
                      groupValue: _radioVal,
                      label: const Text('极速模式 (60Hz)'),
                      onChanged: (v) => setState(() => _radioVal = v!),
                    ),
                    const SizedBox(width: 24),
                    SofRadio<int>(
                      value: 2,
                      groupValue: _radioVal,
                      label: const Text('超清高刷 (120Hz)'),
                      onChanged: (v) => setState(() => _radioVal = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 分段滑动控制器
                Text('分段滑动控制器 (SofSegmentedControl)', style: typography.label),
                const SizedBox(height: 4),
                Text('底部药丸指示块根据弹簧物理滑动，文字平滑插值过渡', style: typography.caption),
                const SizedBox(height: 10),
                SofSegmentedControl<int>(
                  value: _segmentedVal,
                  onChanged: (v) => setState(() => _segmentedVal = v),
                  segments: const [
                    SofSegment(value: 0, label: Text('日视图')),
                    SofSegment(value: 1, label: Text('周统计')),
                    SofSegment(value: 2, label: Text('月报表')),
                    SofSegment(value: 3, label: Text('年总览')),
                  ],
                ),
                const SizedBox(height: 24),

                // 柔光滑块
                Text('发光滑块 SofSlider (Luminous Glow)', style: typography.label),
                const SizedBox(height: 4),
                Text('拖拽时拇指产生 1.25x 弹性膨胀，带有物理回弹', style: typography.caption),
                const SizedBox(height: 10),
                SofSlider(
                  value: _sliderVal,
                  luminous: true,
                  onChanged: (val) => setState(() => _sliderVal = val),
                ),
                const SizedBox(height: 24),

                // 输入框
                Text('文本输入框 (SofTextField)', style: typography.label),
                const SizedBox(height: 4),
                Text('超椭圆连续边框，悬停与聚焦拥有零跳动的发光过渡', style: typography.caption),
                const SizedBox(height: 10),
                SofTextField(
                  controller: _inputController,
                  placeholder: '请输入组件或主题名称...',
                  prefix: const SofIcon(SofIcons.edit, size: 16),
                  suffix: const SofIcon(SofIcons.check, size: 16),
                  helperText: '已适配系统原生输入法、光标绘制与读屏标签支持',
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // 4. Soft Lumen 材质模型对比
          _buildCategoryHeader('四、Soft Lumen 四重材质模型 (Materials & Surfaces)'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SofCard(
                variant: SofSurfaceVariant.solid,
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Solid 实色表面', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('最高文本对比度与最佳渲染性能，零 GPU 模糊开销。正文与常规卡片默认材质。', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.frost,
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Frost 亚克力磨砂', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('18σ 高斯背景模糊 + 半透底色 + 细致高光边缘线。用于底部抽屉、顶栏与悬浮窗。', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.ambient,
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ambient 柔光漫射', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('方向性微光渐变与局部光照漫射深度。专为焦点卡片、音乐播放与品牌展示打造。', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.floating,
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Floating 抬升悬浮', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('多阶自然弥散阴影结合轮廓对比。用于模态弹窗、Popover 与重要通知。', style: typography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // 5. 模态与弹窗
          _buildCategoryHeader('五、弹层与全局通知 (Overlays & Feedback)'),
          SofCard(
            padding: const EdgeInsets.all(22),
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                SofButton(
                  variant: SofButtonVariant.subtle,
                  leading: const SofIcon(SofIcons.layout, size: 16),
                  onPressed: () {
                    showSofDialog(
                      context: context,
                      builder: (context) {
                        return SofDialog(
                          title: const Text('Soflume 模态弹窗'),
                          actions: [
                            SofButton(
                              variant: SofButtonVariant.filled,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('我已知晓'),
                            ),
                          ],
                          child: const Text('高质感超椭圆轮廓、深色高透毛玻璃遮罩背景，支持 ESC 键快捷关闭与焦点恢复。'),
                        );
                      },
                    );
                  },
                  child: const Text('打开模态弹窗 Dialog'),
                ),
                SofButton(
                  variant: SofButtonVariant.subtle,
                  leading: const SofIcon(SofIcons.fileText, size: 16),
                  onPressed: () {
                    showSofSheet(
                      context: context,
                      builder: (context) {
                        return SofSheet(
                          title: const Text('Soflume 底部抽屉'),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('拥有顶部药丸手柄、连续超椭圆顶部转角与手势向下滑动关闭。'),
                              const SizedBox(height: 20),
                              SofButton(
                                variant: SofButtonVariant.filled,
                                fullWidth: true,
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('关闭抽屉'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('打开底部抽屉 Sheet'),
                ),
                SofButton(
                  variant: SofButtonVariant.subtle,
                  leading: const SofIcon(SofIcons.bell, size: 16),
                  onPressed: () {
                    showSofToast(
                      context: context,
                      message: '配置与设计 Token 已成功保存',
                      icon: const SofIcon(SofIcons.check, size: 16, color: Color(0xFFFFFFFF)),
                      variant: SofBadgeVariant.success,
                    );
                  },
                  child: const Text('触发悬浮通知 Toast'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: SoflumeTheme.colorsOf(context).accent,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildCodeButton(String title, String code) {
    return GestureDetector(
      onTap: () => _showCodeDialog(title, code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: SoflumeTheme.colorsOf(context).accentSubtle,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('</>', style: TextStyle(fontSize: 10, color: SoflumeTheme.colorsOf(context).accent, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text('示例代码', style: TextStyle(fontSize: 11, color: SoflumeTheme.colorsOf(context).accent)),
          ],
        ),
      ),
    );
  }
}
