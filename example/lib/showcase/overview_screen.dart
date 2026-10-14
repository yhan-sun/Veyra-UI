import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 官网首页：旗舰科技品牌官网风格、真实可交互 UI 舞台、系统基因交互专区与全组件沙盒
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({
    super.key,
    required this.onNavigateToComponents,
    this.onNavigateToDemos,
  });

  final VoidCallback onNavigateToComponents;
  final VoidCallback? onNavigateToDemos;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  // Hero Live Gadget Stage Interactive States
  bool _musicPlaying = true;
  double _musicProgress = 0.38; // 1:26 of 3:45
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = true;
  double _volumeSlider = 0.72;
  String _soundProfile = 'ring'; // 'mute', 'vibrate', 'ring'

  // Component Sandbox Interactive States
  int _sandboxCategoryIndex = 0;
  bool _sandboxToggle = true;
  double _sandboxSlider = 0.55;
  String _sandboxSelectVal = 'pro';
  int _codeSnippetTab = 0; // 0: pubspec, 1: main.dart, 2: button

  void _copyCode(BuildContext context, String code, String label) {
    Clipboard.setData(ClipboardData(text: code));
    showSofToast(
      context: context,
      message: '$label 已复制到剪贴板',
      variant: SofBadgeVariant.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;
    final isDark = theme.isDark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ==========================================
              // 1. HERO BRAND INTRO & HEADLINE
              // ==========================================
              _buildHeroHeader(context, colors, typography, radii, isDark),
              const SizedBox(height: 36),

              // ==========================================
              // 2. THE FLAGSHIP INTERACTIVE STAGE (核心可交互舞台)
              // ==========================================
              _buildInteractiveStage(context, colors, typography, radii, isDark),
              const SizedBox(height: 64),

              // ==========================================
              // 3. ARCHITECTURAL FEATURE SHOWCASES (五大系统基因专区)
              // ==========================================
              _buildPillarsShowcase(context, colors, typography, radii, isDark),
              const SizedBox(height: 64),

              // ==========================================
              // 4. LIVE COMPONENT PLAYGROUND SANDBOX (全组件速览沙盒)
              // ==========================================
              _buildComponentSandbox(context, colors, typography, radii, isDark),
              const SizedBox(height: 64),

              // ==========================================
              // 5. DEVELOPER QUICK START & ARCHITECTURE
              // ==========================================
              _buildQuickStartSection(context, colors, typography, radii, isDark),
              const SizedBox(height: 60),

              // Footer
              _buildFooter(context, colors, typography),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 1. HERO HEADER
  // --------------------------------------------------------------------------
  Widget _buildHeroHeader(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return Column(
      children: [
        // Luminous Eyebrow Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: isDark ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(radii.pill),
            border: Border.all(
              color: colors.accent.withValues(alpha: isDark ? 0.35 : 0.20),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SofIcon(SofIcons.sparkles, size: 14, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Soft Lumen Design System 2.0 • 旗舰级跨平台组件库',
                style: typography.caption.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Monumental Title
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: typography.display.copyWith(
                  fontSize: isCompact ? 36 : 52,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: isCompact ? -0.8 : -1.2,
                  color: colors.contentPrimary,
                ),
                children: [
                  const TextSpan(text: 'Soft to touch.\n'),
                  TextSpan(
                    text: 'Alive in motion.',
                    style: TextStyle(
                      color: colors.accent,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 18),

        // Subtitle / Mission Statement
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            '融聚四大国产旗舰 OS 与 iOS 的自然光学、G2 连续曲率、物理阻尼弹簧与温润柔光材质。告别廉价拟物与粗制渐变，为跨平台 Flutter 应用赋予真正的灵魂与质感。',
            textAlign: TextAlign.center,
            style: typography.body.copyWith(
              color: colors.contentSecondary,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Action CTA Row
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            SofButton(
              size: SofButtonSize.large,
              variant: SofButtonVariant.filled,
              leading: const SofIcon(SofIcons.component, size: 20, color: Color(0xFFFFFFFF)),
              onPressed: widget.onNavigateToComponents,
              child: const Text('探索全套交互组件'),
            ),
            SofButton(
              size: SofButtonSize.large,
              variant: SofButtonVariant.subtle,
              leading: const SofIcon(SofIcons.layout, size: 20),
              onPressed: widget.onNavigateToDemos ?? widget.onNavigateToComponents,
              child: const Text('场景实装体验'),
            ),
            SofButton(
              size: SofButtonSize.large,
              variant: SofButtonVariant.outlined,
              leading: const SofIcon(SofIcons.copy, size: 20),
              onPressed: () => _copyCode(
                context,
                'dependencies:\n  soflume_ui:\n    git: https://github.com/yhan-sun/Veyra-UI.git',
                '依赖配置',
              ),
              child: const Text('复制依赖配置'),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // 2. THE FLAGSHIP INTERACTIVE STAGE (核心可交互舞台)
  // --------------------------------------------------------------------------
  Widget _buildInteractiveStage(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return SofCard(
      variant: SofSurfaceVariant.ambient,
      padding: const EdgeInsets.all(28),
      borderRadius: radii.brXxl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage Top Bar
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LIVE SHOWCASE STAGE • 实时交互体验工作台',
                      style: typography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.5,
                        color: colors.contentSecondary,
                      ),
                    ),
                  ],
                ),
                const SofBadge(
                  label: Text('100% 原生 Flutter 渲染'),
                  variant: SofBadgeVariant.accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Top Dynamic Live Capsule (Expandable notification widget)
          SofLiveCapsule(
            leading: const SofIcon(SofIcons.zap, size: 16, color: Color(0xFFF59E0B)),
            title: const Text('系统状态 • 京沪极速专列 G128 • 准点运行中'),
            expandedChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('下一站：南京南 (14:32 到达)', style: typography.caption.copyWith(color: colors.contentSecondary)),
                        const SizedBox(height: 4),
                        Text('时速：348 km/h • 信号良好', style: typography.caption.copyWith(color: colors.contentSecondary)),
                      ],
                    ),
                  ),
                  SofButton(
                    size: SofButtonSize.small,
                    variant: SofButtonVariant.subtle,
                    onPressed: () {
                      showSofToast(context: context, message: '行程信息已同步至智能胶囊');
                    },
                    child: const Text('查看详情'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main Gadget Grid (Music Player & Quick Controls)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;

              final musicCard = _buildMusicPlayerWidget(context, colors, typography, radii, isDark);
              final controlCard = _buildQuickControlMatrix(context, colors, typography, radii, isDark);

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: musicCard),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: controlCard),
                  ],
                );
              } else {
                return Column(
                  children: [
                    musicCard,
                    const SizedBox(height: 20),
                    controlCard,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Interactive Music Player Card
  Widget _buildMusicPlayerWidget(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return SofCard(
      variant: SofSurfaceVariant.floating,
      padding: const EdgeInsets.all(20),
      borderRadius: radii.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Vinyl Cover Squircle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(radii.lg),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const SofIcon(SofIcons.music, size: 28, color: Color(0xFFFFFFFF)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Moonlight Waves',
                      style: typography.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: colors.contentPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Soflume Symphony Orchestra',
                      style: typography.caption.copyWith(color: colors.contentSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Hi-Res Lossless 24-bit',
                            style: typography.caption.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.accent,
                            ),
                          ),
                        ),
                        Text('空间音频已启用', style: typography.caption.copyWith(fontSize: 10, color: colors.contentTertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Interactive Scrubber Slider
          SofSlider(
            value: _musicProgress,
            onChanged: (val) => setState(() => _musicProgress = val),
            luminous: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(_musicProgress),
                  style: typography.caption.copyWith(fontSize: 11, color: colors.contentSecondary),
                ),
                Text(
                  '3:45',
                  style: typography.caption.copyWith(fontSize: 11, color: colors.contentTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SofIconButton(
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.shuffle, size: 18),
                onPressed: () {
                  showSofToast(context: context, message: '随机播放已切换');
                },
              ),
              SofIconButton(
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.skipBack, size: 20),
                onPressed: () {
                  setState(() => _musicProgress = 0.0);
                },
              ),
              // Morphing Play/Pause button
              SofButton(
                variant: SofButtonVariant.filled,
                size: SofButtonSize.medium,
                leading: SofIcon(
                  _musicPlaying ? SofIcons.pause : SofIcons.play,
                  size: 18,
                  color: const Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  setState(() => _musicPlaying = !_musicPlaying);
                },
                child: Text(_musicPlaying ? '暂停' : '播放'),
              ),
              SofIconButton(
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.skipForward, size: 20),
                onPressed: () {
                  setState(() => _musicProgress = 0.0);
                  showSofToast(context: context, message: '切换下一首: Superellipse Nocturne');
                },
              ),
              SofIconButton(
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.repeat, size: 18),
                onPressed: () {
                  showSofToast(context: context, message: '单曲循环已开启');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Interactive Quick Controls Card
  Widget _buildQuickControlMatrix(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return SofCard(
      variant: SofSurfaceVariant.floating,
      padding: const EdgeInsets.all(20),
      borderRadius: radii.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '控制中心快捷矩阵',
                style: typography.headline.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: colors.contentPrimary,
                ),
              ),
              Text(
                'OriginOS 6 拟态触感',
                style: typography.caption.copyWith(color: colors.accent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Two toggle cards (Wi-Fi and Bluetooth)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(radii.md),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _wifiEnabled ? colors.accent : colors.outlineSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const SofIcon(SofIcons.wifi, size: 16, color: Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Wi-Fi 7', style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
                            Text(_wifiEnabled ? '已连接' : '已关闭',
                                style: typography.caption.copyWith(fontSize: 10, color: colors.contentSecondary)),
                          ],
                        ),
                      ),
                      SofToggle(
                        value: _wifiEnabled,
                        onChanged: (v) => setState(() => _wifiEnabled = v),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(radii.md),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _bluetoothEnabled ? colors.accent : colors.outlineSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const SofIcon(SofIcons.bluetooth, size: 16, color: Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('蓝牙 5.4', style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
                            Text(_bluetoothEnabled ? '已就绪' : '已关闭',
                                style: typography.caption.copyWith(fontSize: 10, color: colors.contentSecondary)),
                          ],
                        ),
                      ),
                      SofToggle(
                        value: _bluetoothEnabled,
                        onChanged: (v) => setState(() => _bluetoothEnabled = v),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Volume / Luminescence Slider with live %
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SofIcon(SofIcons.volume, size: 16),
                  const SizedBox(width: 6),
                  Text('系统音量 / 动态光阶', style: typography.caption.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              Text(
                '${(_volumeSlider * 100).round()}%',
                style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.accent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SofSlider(
            value: _volumeSlider,
            onChanged: (v) => setState(() => _volumeSlider = v),
          ),
          const SizedBox(height: 12),

          // Sound Profile Segmented Control
          Text('声音场景模式', style: typography.caption.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SofSegmentedControl<String>(
            value: _soundProfile,
            onChanged: (val) => setState(() => _soundProfile = val),
            segments: const [
              SofSegment(value: 'mute', label: Text('静音模式')),
              SofSegment(value: 'vibrate', label: Text('触感振动')),
              SofSegment(value: 'ring', label: Text('全面响铃')),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 3. ARCHITECTURAL FEATURE SHOWCASES (五大系统基因专区)
  // --------------------------------------------------------------------------
  Widget _buildPillarsShowcase(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SofIcon(SofIcons.cpu, size: 18, color: colors.accent),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '旗舰操作系统基因重构',
                  style: typography.display.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '汲取各大旗舰 OS 交互思想，演化为 Soflume 独有的 Soft Lumen 柔光设计语法。',
                  style: typography.body.copyWith(fontSize: 14, color: colors.contentSecondary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 5 Interactive Feature Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            final isTablet = constraints.maxWidth > 600 && !isDesktop;

            final cardWidth = isDesktop
                ? (constraints.maxWidth - 32) / 3
                : isTablet
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  width: cardWidth,
                  icon: SofIcons.activity,
                  accentColor: const Color(0xFF6366F1),
                  title: 'vivo OriginOS 动效哲学',
                  subtitle: '连续动力学与全程可打断物理弹簧',
                  desc: '基于调和弹簧物理（Harmonic Springs），拒绝突兀切角与僵硬补间，任意手势过程可随时自然打断重定向。',
                  badge: '自然流体',
                ),
                _buildFeatureCard(
                  context,
                  width: cardWidth,
                  icon: SofIcons.layout,
                  accentColor: const Color(0xFF0EA5E9),
                  title: '华为 HarmonyOS 空间秩序',
                  subtitle: '多端自适应布局断点与空间层级',
                  desc: '内置 Compact / Medium / Expanded 断点与自适应密度引擎，折叠屏、平板与桌面端无缝布局迁移。',
                  badge: '全端统一',
                ),
                _buildFeatureCard(
                  context,
                  width: cardWidth,
                  icon: SofIcons.sparkles,
                  accentColor: const Color(0xFF10B981),
                  title: 'OPPO ColorOS 材质光感',
                  subtitle: '克制通透的 Soft Lumen 四重材质',
                  desc: '提供 Solid（实色）、Frost（20σ 动态高斯半透）、Ambient（柔光漫射）与 Floating（立体弥散）。',
                  badge: '透光美学',
                ),
                _buildFeatureCard(
                  context,
                  width: cardWidth,
                  icon: SofIcons.zap,
                  accentColor: const Color(0xFFF59E0B),
                  title: '小米 HyperOS 灵动胶囊',
                  subtitle: '常驻状态胶囊与多阶吸附底板',
                  desc: '包含 LiveCapsule 状态指示胶囊、FluidSheet 动态手势吸附底板与 Morphing 变形按键体系。',
                  badge: '灵动触控',
                ),
                _buildFeatureCard(
                  context,
                  width: cardWidth,
                  icon: SofIcons.shield,
                  accentColor: const Color(0xFF8B5CF6),
                  title: 'Apple iOS/macOS 触控一致',
                  subtitle: '严格 WCAG AA/AAA 与全键盘导航',
                  desc: '完备 ESC / Back 键关闭响应、焦点环（SofFocusRing）环视导航与无障碍语义标签深度适配。',
                  badge: '严苛无障碍',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required double width,
    required String icon,
    required Color accentColor,
    required String title,
    required String subtitle,
    required String desc,
    required String badge,
  }) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return SizedBox(
      width: width,
      child: SofCard(
        variant: SofSurfaceVariant.solid,
        padding: const EdgeInsets.all(22),
        borderRadius: radii.brXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SofIcon(icon, size: 20, color: accentColor),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: typography.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.contentSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: typography.headline.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: colors.contentPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: typography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              style: typography.body.copyWith(
                fontSize: 13,
                height: 1.55,
                color: colors.contentSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 4. LIVE COMPONENT PLAYGROUND SANDBOX (全组件速览沙盒)
  // --------------------------------------------------------------------------
  Widget _buildComponentSandbox(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '核心十件套组件速览沙盒',
                  style: typography.display.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '无须跳转即可在首页立即测试组件的微交互、触感回弹与状态变化。',
                  style: typography.body.copyWith(fontSize: 14, color: colors.contentSecondary),
                ),
              ],
            ),
            SofButton(
              variant: SofButtonVariant.subtle,
              size: SofButtonSize.small,
              trailing: const SofIcon(SofIcons.chevronRight, size: 14),
              onPressed: widget.onNavigateToComponents,
              child: const Text('进入完整组件展馆'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Category Tab Switcher
        SofSegmentedControl<int>(
          value: _sandboxCategoryIndex,
          onChanged: (idx) => setState(() => _sandboxCategoryIndex = idx),
          segments: const [
            SofSegment(value: 0, label: Text('按钮体系 Button')),
            SofSegment(value: 1, label: Text('开关与滑块 Toggle & Slider')),
            SofSegment(value: 2, label: Text('输入选择 Input & Select')),
            SofSegment(value: 3, label: Text('弹层与通知 Overlay & Toast')),
          ],
        ),
        const SizedBox(height: 18),

        // Sandbox Interactive Display Stage
        SofCard(
          variant: SofSurfaceVariant.solid,
          padding: const EdgeInsets.all(28),
          borderRadius: radii.brXl,
          child: _buildSandboxContent(context, colors, typography, radii, isDark),
        ),
      ],
    );
  }

  Widget _buildSandboxContent(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    switch (_sandboxCategoryIndex) {
      case 0:
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SofButton(
              variant: SofButtonVariant.filled,
              leading: const SofIcon(SofIcons.sparkles, size: 18, color: Color(0xFFFFFFFF)),
              onPressed: () => showSofToast(context: context, message: '点击了 Filled 强调按钮'),
              child: const Text('Filled 按钮 (微弹簧)'),
            ),
            SofButton(
              variant: SofButtonVariant.subtle,
              onPressed: () => showSofToast(context: context, message: '点击了 Subtle 柔和按钮'),
              child: const Text('Subtle 柔色按钮'),
            ),
            SofButton(
              variant: SofButtonVariant.outlined,
              onPressed: () => showSofToast(context: context, message: '点击了 Outlined 描边按钮'),
              child: const Text('Outlined 边框按钮'),
            ),
            SofButton(
              variant: SofButtonVariant.ghost,
              onPressed: () => showSofToast(context: context, message: '点击了 Ghost 幽灵按钮'),
              child: const Text('Ghost 幽灵按钮'),
            ),
            SofButton(
              variant: SofButtonVariant.danger,
              onPressed: () => showSofToast(context: context, message: '点击了 Danger 警示按钮', variant: SofBadgeVariant.danger),
              child: const Text('Danger 破坏性按钮'),
            ),
            const SofButton(
              variant: SofButtonVariant.filled,
              onPressed: null,
              child: Text('Disabled 禁用态'),
            ),
          ],
        );

      case 1:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('触感开关 (带弹性伸缩)：', style: typography.body),
                      const SizedBox(width: 12),
                      SofToggle(
                        value: _sandboxToggle,
                        onChanged: (v) => setState(() => _sandboxToggle = v),
                        luminous: true,
                      ),
                      const SizedBox(width: 10),
                      Text(_sandboxToggle ? '已开启' : '已关闭',
                          style: typography.caption.copyWith(fontWeight: FontWeight.w600, color: colors.accent)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('高精度光学滑块：', style: typography.body),
                const SizedBox(width: 16),
                Expanded(
                  child: SofSlider(
                    value: _sandboxSlider,
                    onChanged: (v) => setState(() => _sandboxSlider = v),
                    luminous: true,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: BorderRadius.circular(6)),
                  child: Text('${(_sandboxSlider * 100).round()}%',
                      style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.accent)),
                ),
              ],
            ),
          ],
        );

      case 2:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '用户名或邮箱',
                    style: typography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.contentPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SofTextField(
                    placeholder: '请输入您的账号...',
                    prefix: SofIcon(SofIcons.users, size: 18),
                    helperText: '支持全键盘聚焦环与 IME 输入优化',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SofSelect<String>(
                label: '性能规格选择',
                placeholder: '选择规格',
                value: _sandboxSelectVal,
                items: const [
                  SofSelectItem(value: 'standard', label: '标准规格 (Standard 4vCPU)'),
                  SofSelectItem(value: 'pro', label: '旗舰规格 (Pro 8vCPU + NPU)'),
                  SofSelectItem(value: 'enterprise', label: '企业旗舰 (Ultra 16vCPU 集群)'),
                ],
                onChanged: (v) => setState(() => _sandboxSelectVal = v),
              ),
            ),
          ],
        );

      case 3:
      default:
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SofButton(
              variant: SofButtonVariant.filled,
              leading: const SofIcon(SofIcons.bell, size: 18, color: Color(0xFFFFFFFF)),
              onPressed: () {
                showSofToast(
                  context: context,
                  message: '这是旗舰级 SofToast，具备多端队列与平滑弹簧淡出！',
                  variant: SofBadgeVariant.accent,
                );
              },
              child: const Text('触发系统通知 Toast'),
            ),
            SofButton(
              variant: SofButtonVariant.subtle,
              leading: const SofIcon(SofIcons.alertCircle, size: 18),
              onPressed: () {
                showSofDialog(
                  context: context,
                  builder: (ctx) => SofDialog(
                    title: const Text('旗舰级高斯模糊对话框'),
                    actions: [
                      SofButton(
                        variant: SofButtonVariant.subtle,
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('稍后再说'),
                      ),
                      SofButton(
                        variant: SofButtonVariant.filled,
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('确定'),
                      ),
                    ],
                    child: const Text('SofDialog 具备 24σ 动态背景高斯雾化、ESC 键响应与无障碍焦点自动锁定，关闭后无缝归还焦点。'),
                  ),
                );
              },
              child: const Text('打开系统模态弹窗 Dialog'),
            ),
            SofButton(
              variant: SofButtonVariant.outlined,
              leading: const SofIcon(SofIcons.layout, size: 18),
              onPressed: () {
                showSofSheet(
                  context: context,
                  builder: (ctx) {
                    return SofSheet(
                      title: const Text('手势交互底板 Bottom Sheet'),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SofListTile(
                            leading: SofIcon(SofIcons.sparkles, size: 20),
                            title: Text('支持连续下坠手势吸附'),
                            subtitle: Text('多阶吸附与内部滚动智能协作'),
                          ),
                          const SizedBox(height: 16),
                          SofButton(
                            variant: SofButtonVariant.filled,
                            fullWidth: true,
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('关闭底板'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text('呼出手势底板 Sheet'),
            ),
          ],
        );
    }
  }

  // --------------------------------------------------------------------------
  // 5. DEVELOPER QUICK START & CODE TABS
  // --------------------------------------------------------------------------
  Widget _buildQuickStartSection(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
    SoflumeRadii radii,
    bool isDark,
  ) {
    final snippets = [
      '''dependencies:
  flutter:
    sdk: flutter
  soflume_ui:
    git: https://github.com/yhan-sun/Veyra-UI.git''',
      '''import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  runApp(SoflumeApp(
    theme: SoflumeThemeData.light(),
    home: const MyHomeScreen(),
  ));
}''',
      '''SofButton(
  variant: SofButtonVariant.filled,
  leading: const SofIcon(SofIcons.sparkles),
  onPressed: () {
    showSofToast(context: context, message: '欢迎使用 Soflume UI');
  },
  child: const Text('体验极致交互'),
);''',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '极速集成 Developer Quick Start',
          style: typography.display.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          '零繁重依赖，30 秒接入现代化旗舰 Flutter 生态。',
          style: typography.body.copyWith(fontSize: 14, color: colors.contentSecondary),
        ),
        const SizedBox(height: 20),

        // Terminal Card
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F131D) : const Color(0xFF1E2433),
            borderRadius: BorderRadius.circular(radii.xl),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark ? const Color(0x20FFFFFF) : const Color(0x10FFFFFF),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Terminal Top Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A27) : const Color(0xFF181D29),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(radii.xl)),
                ),
                child: Row(
                  children: [
                    // Mac-style window dots
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F56))),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF27C93F))),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // Tabs inside terminal
                    _buildTerminalTab('1. pubspec.yaml', 0),
                    _buildTerminalTab('2. main.dart', 1),
                    _buildTerminalTab('3. 使用组件', 2),
                    const Spacer(),
                    SofButton(
                      variant: SofButtonVariant.ghost,
                      size: SofButtonSize.small,
                      leading: const SofIcon(SofIcons.copy, size: 14, color: Color(0xFFCBD5E1)),
                      onPressed: () => _copyCode(context, snippets[_codeSnippetTab], '代码片段'),
                      child: const Text('复制', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                    ),
                  ],
                ),
              ),

              // Code Content View
              Padding(
                padding: const EdgeInsets.all(22),
                child: SelectableText(
                  snippets[_codeSnippetTab],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13.5,
                    color: Color(0xFFE2E8F0),
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTerminalTab(String label, int index) {
    final isSelected = _codeSnippetTab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _codeSnippetTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x28FFFFFF) : const Color(0x00000000),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // FOOTER
  // --------------------------------------------------------------------------
  Widget _buildFooter(
    BuildContext context,
    SoflumeColors colors,
    SoflumeTypography typography,
  ) {
    return Column(
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: colors.outlineSubtle,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              Text(
                'Soflume UI • Soft Lumen Design System • MIT Licensed',
                style: typography.caption.copyWith(color: colors.contentTertiary),
              ),
              Text(
                'Developed for Next-Gen Cross-Platform Flutter Experiences',
                style: typography.caption.copyWith(color: colors.contentTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(double fraction) {
    final totalSeconds = (fraction * 225).round();
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}
