import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 现代化组件展馆：分类目录、交互参数演练、状态切换、代码片段复制与无障碍说明
class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({super.key});

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  int _activeCategoryIndex = 0;

  // 演练交互状态
  bool _toggleVal1 = true;
  bool _toggleVal2 = true;
  bool? _checkboxVal1 = true;
  bool? _checkboxVal2 = false;
  int _radioVal = 1;
  int _segmentedVal = 0;
  double _sliderVal = 0.65;
  SofMorphingState _morphState = SofMorphingState.idle;
  bool _buttonLoading = false;
  bool _componentDisabled = false;
  final TextEditingController _inputController = TextEditingController(text: 'Soft Lumen 柔光设计');
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
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

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showSofToast(
      context: context,
      message: '代码已成功复制到剪贴板',
      variant: SofBadgeVariant.success,
    );
  }

  void _showCodeModal(String title, String code) {
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
          child: Container(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    const categories = [
      _CategoryMeta('标志性组件', 'Signature', SofIcons.zap),
      _CategoryMeta('按钮体系', 'Buttons', SofIcons.target),
      _CategoryMeta('输入表单', 'Inputs', SofIcons.edit),
      _CategoryMeta('选择控件', 'Selection', SofIcons.checkCircle),
      _CategoryMeta('容器架构', 'Containers', SofIcons.layout),
      _CategoryMeta('导航体系', 'Navigation', SofIcons.grid),
      _CategoryMeta('弹层与通知', 'Overlays', SofIcons.bell),
      _CategoryMeta('反馈展示', 'Feedback', SofIcons.sparkles),
    ];

    return SofAdaptiveBuilder(
      builder: (context, screenClass) {
        final isDesktop = !screenClass.isCompact;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 桌面端左侧分类目录栏
              Container(
                width: 240,
                decoration: BoxDecoration(
                  color: colors.isDark ? colors.surfaceRaised : colors.surface,
                  border: Border(
                    right: BorderSide(color: colors.outlineSubtle, width: 0.8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Text(
                        '组件目录',
                        style: typography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.contentSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = index == _activeCategoryIndex;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            child: SofPressable(
                              onPressed: () => setState(() => _activeCategoryIndex = index),
                              builder: (context, state) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: ShapeDecoration(
                                    color: isSelected
                                        ? colors.accentSubtle
                                        : (state.isHovered ? colors.surfaceMuted : const Color(0x00000000)),
                                    shape: SofSquircleBorder(
                                      borderRadius: BorderRadius.circular(radii.xs),
                                      side: isSelected
                                          ? BorderSide(color: colors.accent.withValues(alpha: 0.3))
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SofIcon(
                                        cat.icon,
                                        size: 16,
                                        color: isSelected ? colors.accent : colors.contentSecondary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          cat.title,
                                          style: typography.body.copyWith(
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? colors.accent : colors.contentPrimary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        cat.enTitle,
                                        style: typography.caption.copyWith(
                                          fontSize: 10,
                                          color: isSelected ? colors.accent : colors.contentTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 右侧组件演示区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 880),
                      child: _buildCategoryContent(_activeCategoryIndex),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // 移动端：顶部水平可滑动分类条 + 竖向滚动内容
        return Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(bottom: BorderSide(color: colors.outlineSubtle, width: 0.8)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = index == _activeCategoryIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SofPressable(
                      onPressed: () => setState(() => _activeCategoryIndex = index),
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: ShapeDecoration(
                            color: isSelected ? colors.accent : colors.surfaceRaised,
                            shape: SofSquircleBorder(
                              borderRadius: BorderRadius.circular(radii.pill),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat.title,
                            style: typography.caption.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? colors.onAccent : colors.contentPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: _buildCategoryContent(_activeCategoryIndex),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryContent(int index) {
    switch (index) {
      case 0:
        return _buildSignatureSection();
      case 1:
        return _buildButtonsSection();
      case 2:
        return _buildInputsSection();
      case 3:
        return _buildSelectionSection();
      case 4:
        return _buildContainersSection();
      case 5:
        return _buildNavigationSection();
      case 6:
        return _buildOverlaysSection();
      case 7:
      default:
        return _buildFeedbackSection();
    }
  }

  // --- 0. 标志性组件 ---
  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('标志性特色组件 (Signature Components)', '具备极高辨识度的柔光动效与空间折叠形态，为现代应用提供系统级微交互质感。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofMorphingButton (无缝变态按键)',
          desc: '按键与加载胶囊、成功勾选、失败叹号之间无缝几何形变，基于简谐弹簧物理展开收缩。',
          code: 'SofMorphingButton(\n  state: _morphState,\n  onPressed: _cycleMorphState,\n  child: const Text("提交订单"),\n);',
          preview: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SofMorphingButton(
                state: _morphState,
                onPressed: _cycleMorphState,
                child: const Text('点击触发形变'),
              ),
              SofButton(
                variant: SofButtonVariant.subtle,
                size: SofButtonSize.small,
                onPressed: () => setState(() => _morphState = SofMorphingState.idle),
                child: const Text('重置为 Idle'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofLiveCapsule (灵动动态胶囊)',
          desc: '系统级状态常驻与呼吸指示胶囊，支持音频播放、电量传输、任务进程等多维状态表达。',
          code: 'SofLiveCapsule(\n  leading: const SofIcon(SofIcons.music, size: 14),\n  title: const Text("正在播放: Clair de Lune"),\n);',
          preview: const Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SofLiveCapsule(
                leading: SofIcon(SofIcons.music, size: 14),
                title: Text('正在播放: Moonlight Sonata'),
              ),
              SofLiveCapsule(
                leading: SofIcon(SofIcons.wifi, size: 14),
                title: Text('Wi-Fi 7 已连接'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '3. SofAdaptiveTile (跨端自适应魔术卡片)',
          desc: '根据容器宽度与设备形态自动平滑重排为紧凑型横排或展开型方块布局。',
          code: 'SofAdaptiveTile(\n  icon: const SofIcon(SofIcons.cloud, size: 22),\n  title: const Text("云端备份"),\n  subtitle: const Text("已同步 98.4 GB"),\n  statusBadge: const SofBadge(label: Text("良好"), variant: SofBadgeVariant.success),\n);',
          preview: const Column(
            children: [
              SofAdaptiveTile(
                icon: SofIcon(SofIcons.cloud, size: 22),
                title: Text('云端备份存储'),
                subtitle: Text('已同步 98.4 GB / 2 TB'),
                statusBadge: SofBadge(label: Text('良好'), variant: SofBadgeVariant.success),
              ),
              SizedBox(height: 12),
              SofAdaptiveTile(
                icon: SofIcon(SofIcons.shield, size: 22),
                title: Text('安全防御中心'),
                subtitle: Text('实时防线已开启'),
                statusBadge: SofBadge(label: Text('已保护'), variant: SofBadgeVariant.accent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 1. 按钮体系 ---
  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('按钮体系 (Buttons & Micro-interactions)', '覆盖 Filled、Tonal、Subtle、Outline、Ghost 五重变体，配备 G2 弹性缩放与触控反馈。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '按钮变体与状态演练',
          desc: '提供不同尺寸（Small, Medium, Large）与交互状态（Disabled, Loading）。',
          code: 'SofButton(\n  variant: SofButtonVariant.filled,\n  loading: _buttonLoading,\n  leading: const SofIcon(SofIcons.zap, size: 16),\n  onPressed: () {},\n  child: const Text("立即体验"),\n);',
          controls: Row(
            children: [
              SofButton(
                size: SofButtonSize.small,
                variant: _buttonLoading ? SofButtonVariant.filled : SofButtonVariant.subtle,
                onPressed: () => setState(() => _buttonLoading = !_buttonLoading),
                child: Text(_buttonLoading ? '关闭 Loading' : '开启 Loading'),
              ),
              const SizedBox(width: 10),
              SofButton(
                size: SofButtonSize.small,
                variant: _componentDisabled ? SofButtonVariant.filled : SofButtonVariant.subtle,
                onPressed: () => setState(() => _componentDisabled = !_componentDisabled),
                child: Text(_componentDisabled ? '解除 Disabled' : '设为 Disabled'),
              ),
            ],
          ),
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SofButton(
                variant: SofButtonVariant.filled,
                loading: _buttonLoading,
                enabled: !_componentDisabled,
                leading: const SofIcon(SofIcons.zap, size: 16, color: Color(0xFFFFFFFF)),
                onPressed: () => _copyCode('SofButton(variant: SofButtonVariant.filled)'),
                child: const Text('Filled 强行动'),
              ),
              SofButton(
                variant: SofButtonVariant.subtle,
                loading: _buttonLoading,
                enabled: !_componentDisabled,
                onPressed: () => _copyCode('SofButton(variant: SofButtonVariant.subtle)'),
                child: const Text('Subtle 次级色'),
              ),
              SofButton(
                variant: SofButtonVariant.outlined,
                loading: _buttonLoading,
                enabled: !_componentDisabled,
                onPressed: () => _copyCode('SofButton(variant: SofButtonVariant.outlined)'),
                child: const Text('Outlined 线框'),
              ),
              SofButton(
                variant: SofButtonVariant.ghost,
                loading: _buttonLoading,
                enabled: !_componentDisabled,
                onPressed: () => _copyCode('SofButton(variant: SofButtonVariant.ghost)'),
                child: const Text('Ghost 幽灵'),
              ),
              SofIconButton(
                variant: SofButtonVariant.filled,
                enabled: !_componentDisabled,
                icon: const SofIcon(SofIcons.heart, size: 16, color: Color(0xFFFFFFFF)),
                onPressed: () {},
              ),
              SofIconButton(
                variant: SofButtonVariant.subtle,
                enabled: !_componentDisabled,
                icon: const SofIcon(SofIcons.star, size: 16),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 2. 输入表单 ---
  Widget _buildInputsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('输入表单 (Input & Slider Controls)', '具备 Squircle 平滑轮廓、WCAG 焦点环、占位符自适应与微光滑块。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofTextField (柔光文本框)',
          desc: '支持前后缀光学图标、占位文本、即时错误/辅助提示与生命周期自动管理。',
          code: 'SofTextField(\n  controller: _inputController,\n  placeholder: "请输入搜索关键字...",\n  prefix: const SofIcon(SofIcons.search, size: 18),\n  helperText: "支持中英文模糊匹配",\n);',
          preview: Column(
            children: [
              SofTextField(
                controller: _inputController,
                placeholder: '请输入搜索关键字...',
                prefix: const SofIcon(SofIcons.search, size: 18),
                helperText: '支持中英文全量模糊匹配',
              ),
              const SizedBox(height: 16),
              const SofTextField(
                placeholder: '禁用状态输入框',
                enabled: false,
                prefix: SofIcon(SofIcons.shield, size: 18),
              ),
              const SizedBox(height: 16),
              const SofTextField(
                placeholder: '包含异常校验的输入框',
                errorText: '格式有误，请输入有效的邮箱地址',
                prefix: SofIcon(SofIcons.alertCircle, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofSlider (微光发光滑块)',
          desc: '弹性拖拽触点，支持标准模式与 Luminous 微光渐变呼吸模式。',
          code: 'SofSlider(\n  value: _sliderVal,\n  luminous: true,\n  onChanged: (v) => setState(() => _sliderVal = v),\n);',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('环境微光亮度调节'),
                  Text('${(_sliderVal * 100).toInt()}%'),
                ],
              ),
              const SizedBox(height: 8),
              SofSlider(
                value: _sliderVal,
                luminous: true,
                onChanged: (v) => setState(() => _sliderVal = v),
              ),
              const SizedBox(height: 16),
              SofSlider(
                value: 0.4,
                luminous: false,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 3. 选择控件 ---
  Widget _buildSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('选择控件 (Selection Controls)', '包含物理回弹开关、三态复选框、单选胶囊与分段控制器。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofToggle (柔光物理开关)',
          desc: '弹簧拉伸与收缩动画，支持 Luminous 柔光辉光模式。',
          code: 'SofToggle(\n  value: _toggleVal1,\n  luminous: true,\n  onChanged: (v) => setState(() => _toggleVal1 = v),\n);',
          preview: Wrap(
            spacing: 24,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofToggle(
                    value: _toggleVal1,
                    luminous: true,
                    onChanged: (v) => setState(() => _toggleVal1 = v),
                  ),
                  const SizedBox(width: 8),
                  const Text('微光开关'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofToggle(
                    value: _toggleVal2,
                    luminous: false,
                    onChanged: (v) => setState(() => _toggleVal2 = v),
                  ),
                  const SizedBox(width: 8),
                  const Text('常规开关'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofToggle(
                    value: false,
                    enabled: false,
                    onChanged: (_) {},
                  ),
                  const SizedBox(width: 8),
                  const Text('禁用态'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofCheckbox & SofRadio (复选框与单选)',
          desc: '基于物理弹簧缩放的勾选态与三态（Tristate）支持。',
          code: 'SofCheckbox(value: _checkboxVal1, onChanged: (v) => setState(() => _checkboxVal1 = v));\nSofRadio(value: 1, groupValue: _radioVal, onChanged: (v) => setState(() => _radioVal = v));',
          preview: Wrap(
            spacing: 24,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofCheckbox(
                    value: _checkboxVal1,
                    onChanged: (v) => setState(() => _checkboxVal1 = v),
                  ),
                  const SizedBox(width: 8),
                  const Text('已勾选'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofCheckbox(
                    value: _checkboxVal2,
                    onChanged: (v) => setState(() => _checkboxVal2 = v),
                  ),
                  const SizedBox(width: 8),
                  const Text('未勾选'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofRadio<int>(
                    value: 1,
                    groupValue: _radioVal,
                    onChanged: (v) => setState(() => _radioVal = v ?? 1),
                  ),
                  const SizedBox(width: 6),
                  const Text('单选 A'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofRadio<int>(
                    value: 2,
                    groupValue: _radioVal,
                    onChanged: (v) => setState(() => _radioVal = v ?? 2),
                  ),
                  const SizedBox(width: 6),
                  const Text('单选 B'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '3. SofSegmentedControl (分段切换胶囊)',
          desc: '支持平滑指示器滑动的多选胶囊，用于视图模式与过滤切换。',
          code: 'SofSegmentedControl<int>(\n  value: _segmentedVal,\n  onChanged: (v) => setState(() => _segmentedVal = v),\n  segments: const [SofSegment(value: 0, label: Text("全量视图")), SofSegment(value: 1, label: Text("最近使用"))],\n);',
          preview: SofSegmentedControl<int>(
            value: _segmentedVal,
            onChanged: (v) => setState(() => _segmentedVal = v),
            segments: const [
              SofSegment(value: 0, label: Text('全量视图')),
              SofSegment(value: 1, label: Text('最近使用')),
              SofSegment(value: 2, label: Text('收藏归档')),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. 容器架构 ---
  Widget _buildContainersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('容器架构 (Containers & Lists)', 'SofCard、SofListTile 与 SofSurface 构成信息组织的基底。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofCard (超椭圆信息卡片)',
          desc: '支持四种材质变体（Solid, Frost, Ambient, Floating）与悬停微交互。',
          code: 'SofCard(\n  variant: SofSurfaceVariant.ambient,\n  padding: const EdgeInsets.all(20),\n  child: Text("卡片内容"),\n);',
          preview: const Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 250,
                child: SofCard(
                  variant: SofSurfaceVariant.solid,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solid Card', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('实体纯净底色与超微弱边框'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: SofCard(
                  variant: SofSurfaceVariant.ambient,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ambient Card', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('环境柔光投影与空间纵深感'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofListTile (列表项单元)',
          desc: '标准的前置图标、主标题、副描述与尾部指示箭头或开关组件。',
          code: 'SofListTile(\n  leading: const SofIcon(SofIcons.settings, size: 20),\n  title: const Text("偏好设置"),\n  subtitle: const Text("管理个人偏好与账号同步"),\n  showChevron: true,\n  onPressed: () {},\n);',
          preview: Column(
            children: [
              SofListTile(
                leading: const SofIcon(SofIcons.settings, size: 20),
                title: const Text('系统通用偏好设置'),
                subtitle: const Text('管理显示、声音与全局交互动效'),
                showChevron: true,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              SofListTile(
                leading: const SofIcon(SofIcons.shield, size: 20),
                title: const Text('生物识别与安全认证'),
                subtitle: const Text('指纹解锁与端到端密钥'),
                trailing: SofToggle(value: true, onChanged: (_) {}),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 5. 导航体系 ---
  Widget _buildNavigationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('导航体系 (Navigation Elements)', '包含 SofTabs 标签栏、SofBreadcrumb 面包屑与 SofFloatingNavigation 悬浮胶囊底栏。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofTabs (分段标签页)',
          desc: '平滑滑动选框与高清晰度文本切换。',
          code: 'SofTabs(\n  selectedIndex: _segmentedVal,\n  onChanged: (idx) => setState(() => _segmentedVal = idx),\n  tabs: const [SofTabItem(label: "设计规范"), SofTabItem(label: "组件目录")],\n);',
          preview: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SofTabs(
                selectedIndex: _segmentedVal,
                onChanged: (idx) => setState(() => _segmentedVal = idx),
                tabs: const [
                  SofTabItem(label: '视觉规范'),
                  SofTabItem(label: '组件目录'),
                  SofTabItem(label: '实战案例'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofBreadcrumb (路径面包屑)',
          desc: '支持点击跳转的分层路径展示。',
          code: 'SofBreadcrumb(\n  items: const [SofBreadcrumbItem(label: "设计系统"), SofBreadcrumbItem(label: "组件"), SofBreadcrumbItem(label: "按钮")],\n);',
          preview: const SofBreadcrumb(
            items: [
              SofBreadcrumbItem(label: 'Soflume UI'),
              SofBreadcrumbItem(label: 'Design System'),
              SofBreadcrumbItem(label: 'Components'),
              SofBreadcrumbItem(label: 'Button'),
            ],
          ),
        ),
      ],
    );
  }

  // --- 6. 弹层与通知 ---
  Widget _buildOverlaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('弹层与通知 (Overlays & Feedback)', '完备支持 ESC 键、Android Back 键、平滑阻尼滑入与消息队列排队。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. showSofDialog (模态对话框)',
          desc: '聚焦环、键盘 ESC 监听、Barrier 遮罩与平滑缩放进入。',
          code: 'showSofDialog(\n  context: context,\n  builder: (context) => SofDialog(\n    title: const Text("确认提交更改？"),\n    content: const Text("提交后所有设置将立即生效并同步至云端。"),\n    actions: [\n      SofButton(variant: SofButtonVariant.ghost, onPressed: () => Navigator.pop(context), child: const Text("取消")),\n      SofButton(variant: SofButtonVariant.filled, onPressed: () => Navigator.pop(context), child: const Text("确认")),\n    ],\n  ),\n);',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SofButton(
                variant: SofButtonVariant.filled,
                onPressed: () {
                  showSofDialog(
                    context: context,
                    builder: (ctx) => SofDialog(
                      title: const Text('系统升级确认'),
                      actions: [
                        SofButton(
                          variant: SofButtonVariant.ghost,
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('稍后再说'),
                        ),
                        SofButton(
                          variant: SofButtonVariant.filled,
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            showSofToast(
                              context: context,
                              message: '已开始后台静默下载',
                              variant: SofBadgeVariant.success,
                            );
                          },
                          child: const Text('立即更新'),
                        ),
                      ],
                      child: const Text('Soflume UI v1.0.1 升级补丁已就绪。支持桌面键盘 ESC 键快捷关闭。'),
                    ),
                  );
                },
                child: const Text('打开模态 Dialog'),
              ),
              SofButton(
                variant: SofButtonVariant.subtle,
                onPressed: () {
                  showSofSheet(
                    context: context,
                    builder: (ctx) => Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('底部操作抽屉 (SofSheet)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 12),
                          const Text('支持下拉手势快速划出关闭，或使用键盘 ESC 键退回。'),
                          const SizedBox(height: 20),
                          SofButton(
                            variant: SofButtonVariant.filled,
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('完成并退出'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('打开底部 Sheet'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. showSofToast (轻量级通知排队)',
          desc: '自动排队、顶层 Overlay 弹簧滑入、多级别色彩语义。',
          code: 'showSofToast(\n  context: context,\n  message: "操作成功保存",\n  variant: SofBadgeVariant.success,\n);',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SofButton(
                variant: SofButtonVariant.subtle,
                leading: const SofIcon(SofIcons.checkCircle, size: 16),
                onPressed: () => showSofToast(
                  context: context,
                  message: '操作已成功同步到云端',
                  variant: SofBadgeVariant.success,
                ),
                child: const Text('Success Toast'),
              ),
              SofButton(
                variant: SofButtonVariant.subtle,
                leading: const SofIcon(SofIcons.alertCircle, size: 16),
                onPressed: () => showSofToast(
                  context: context,
                  message: '网络连接微弱，请检查代理',
                  variant: SofBadgeVariant.danger,
                ),
                child: const Text('Danger Toast'),
              ),
              SofButton(
                variant: SofButtonVariant.subtle,
                leading: const SofIcon(SofIcons.info, size: 16),
                onPressed: () => showSofToast(
                  context: context,
                  message: '已有新的系统升级补丁可用',
                  variant: SofBadgeVariant.accent,
                ),
                child: const Text('Accent Toast'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 7. 反馈展示 ---
  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('反馈与状态 (Feedback & Display)', '状态角标、标签芯片、进度条、骨架屏与提示条。'),
        const SizedBox(height: 20),

        _buildPlaygroundCard(
          title: '1. SofBadge & SofChip (角标与标签)',
          desc: '紧凑型状态表达与可交互可删除标签芯片。',
          code: 'SofBadge(label: Text("PRO"), variant: SofBadgeVariant.accent);\nSofChip(label: Text("Flutter Web"), onDeleted: () {});',
          preview: const Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SofBadge(label: Text('Accent'), variant: SofBadgeVariant.accent),
              SofBadge(label: Text('Success'), variant: SofBadgeVariant.success),
              SofBadge(label: Text('Danger'), variant: SofBadgeVariant.danger),
              SofBadge(label: Text('Neutral'), variant: SofBadgeVariant.neutral),
              SofChip(label: Text('Cross-Platform')),
              SofChip(label: Text('Soft Lumen')),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '2. SofProgress & SofSkeleton (进度条与骨架屏)',
          desc: '平滑插值进度条与加载占位呼吸骨架。',
          code: 'SofProgress(value: 0.72);\nSofSkeleton(width: 180, height: 16);',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SofProgress(value: 0.72),
              SizedBox(height: 16),
              SofProgress(value: null), // Indeterminate
              SizedBox(height: 16),
              Row(
                children: [
                  SofSkeleton(width: 44, height: 44, borderRadius: BorderRadius.all(Radius.circular(12))),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SofSkeleton(width: 140, height: 14),
                      SizedBox(height: 8),
                      SofSkeleton(width: 90, height: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPlaygroundCard(
          title: '3. SofAlert (行内通知条)',
          desc: '用于表单页或页面顶部的静态语义警告。',
          code: 'SofAlert(title: const Text("安全提醒"), message: const Text("检测到新设备登录，请确认是否为本人操作。"));',
          preview: const Column(
            children: [
              SofAlert(
                title: Text('系统维护提醒'),
                message: Text('今晚 02:00 将进行无停机数据库索引优化，所有读写服务正常。'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 通用辅助渲染函数 ---
  Widget _buildSectionHeader(String title, String desc) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.headline.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(desc, style: typography.caption.copyWith(color: colors.contentSecondary)),
      ],
    );
  }

  Widget _buildPlaygroundCard({
    required String title,
    required String desc,
    required String code,
    required Widget preview,
    Widget? controls,
  }) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SofCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: typography.title.copyWith(fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SofButton(
                    size: SofButtonSize.small,
                    variant: SofButtonVariant.ghost,
                    leading: const SofIcon(SofIcons.code, size: 14),
                    onPressed: () => _showCodeModal(title, code),
                    child: const Text('查看代码'),
                  ),
                  const SizedBox(width: 6),
                  SofButton(
                    size: SofButtonSize.small,
                    variant: SofButtonVariant.subtle,
                    leading: const SofIcon(SofIcons.clipboard, size: 14),
                    onPressed: () => _copyCode(code),
                    child: const Text('复制'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: typography.caption.copyWith(color: colors.contentSecondary)),
          if (controls != null) ...[
            const SizedBox(height: 14),
            controls,
          ],
          const SizedBox(height: 18),

          // 预览区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.canvas,
              borderRadius: BorderRadius.circular(radii.sm),
              border: Border.all(color: colors.outlineSubtle),
            ),
            child: preview,
          ),
        ],
      ),
    );
  }
}

class _CategoryMeta {
  const _CategoryMeta(this.title, this.enTitle, this.icon);
  final String title;
  final String enTitle;
  final String icon;
}
