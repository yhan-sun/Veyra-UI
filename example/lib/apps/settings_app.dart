import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 标杆应用：旗舰手机级系统设置应用 (Settings App)
///
/// 遵循 vivo OriginOS 6 与 OPPO ColorOS 16 空间秩序规范：
/// 包含全局搜索胶囊、用户云账户卡片、圆角分组列表、自适应分栏、
/// 原生触感开关、高精度滑块、分段控制器与动态网络底板。
class SettingsApp extends StatefulWidget {
  const SettingsApp({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  // Connectivity
  bool _airplaneMode = false;
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = true;
  bool _cellularData = true;

  // Display & Sound
  double _brightness = 0.82;
  double _mediaVolume = 0.65;
  bool _eyeComfort = false;
  bool _hapticFeedback = true;
  int _appearanceIndex = 1; // 0: Auto, 1: Light, 2: Dark
  String _refreshRate = '120hz';

  @override
  void initState() {
    super.initState();
    _appearanceIndex = widget.isDark ? 2 : 1;
  }

  @override
  void didUpdateWidget(SettingsApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      _appearanceIndex = widget.isDark ? 2 : 1;
    }
  }

  void _showNetworkSheet() {
    showSofSheet(
      context: context,
      builder: (context) {
        return SofSheet(
          title: const Text('无线局域网 (Wi-Fi 7)'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SofListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SofIcon(SofIcons.wifi, size: 20, color: Color(0xFF10B981)),
                ),
                title: const Text('Soflume-5G-Pro'),
                subtitle: const Text('已连接 • 极佳信号 (1200 Mbps)'),
                trailing: const SofBadge(label: Text('当前连接'), variant: SofBadgeVariant.success),
              ),
              const SizedBox(height: 8),
              SofListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SoflumeTheme.colorsOf(context).surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SofIcon(SofIcons.wifi, size: 20),
                ),
                title: const Text('OriginOS-Office-Guest'),
                subtitle: const Text('开放网络 • 信号良好'),
                showChevron: true,
                onPressed: () {
                  showSofToast(context: context, message: '正在切换网络...');
                  Navigator.of(context).pop();
                },
              ),
              SofListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SoflumeTheme.colorsOf(context).surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SofIcon(SofIcons.shield, size: 20),
                ),
                title: const Text('Harmony-Enterprise-Secure'),
                subtitle: const Text('加密 WPA3 • 安全防护'),
                showChevron: true,
                onPressed: () {
                  showSofToast(context: context, message: '正在验证安全证书...');
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),
              SofButton(
                variant: SofButtonVariant.subtle,
                fullWidth: true,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('完成'),
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
    final radii = theme.radii;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Title & Device Model
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '设置 Settings',
                        style: typography.display.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          letterSpacing: -0.6,
                          color: colors.contentPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Soflume Pro 16 Max • OriginOS 旗舰交互规范',
                        style: typography.caption.copyWith(color: colors.contentSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'OS 2.0',
                      style: typography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Pill
              const SofTextField(
                placeholder: '搜索设置项、快捷功能与智慧建议...',
                prefix: SofIcon(SofIcons.search, size: 18),
              ),
              const SizedBox(height: 24),

              // Profile Card (Apple ID / Account style)
              SofCard(
                variant: SofSurfaceVariant.ambient,
                padding: const EdgeInsets.all(18),
                borderRadius: radii.brXl,
                onPressed: () {
                  showSofToast(context: context, message: '查看苏云汉账户详情');
                },
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'YH',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
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
                            '苏云汉 (Yhan Sun)',
                            style: typography.title.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colors.contentPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Soflume 旗舰云服务 • 设备数据与钥匙串实时同步',
                            style: typography.caption.copyWith(color: colors.contentSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SofIcon(SofIcons.chevronRight, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Group 1: Connectivity
              _buildSectionHeader(context, '无线局域网与网络 CONNECTIVITY'),
              SofCard(
                variant: SofSurfaceVariant.solid,
                padding: EdgeInsets.zero,
                borderRadius: radii.brXl,
                child: Column(
                  children: [
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.airplane, const Color(0xFFF59E0B)),
                      title: const Text('Airplane Mode'),
                      subtitle: const Text('飞行模式 · 暂停所有无线通信连接'),
                      trailing: SofToggle(
                        value: _airplaneMode,
                        onChanged: (val) => setState(() => _airplaneMode = val),
                      ),
                    ),
                    _buildDivider(colors),
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.wifi, const Color(0xFF10B981)),
                      title: const Text('无线局域网 Wi-Fi'),
                      subtitle: Text(_wifiEnabled ? '已连接: Soflume-5G-Pro' : '已关闭'),
                      showChevron: true,
                      trailing: SofToggle(
                        value: _wifiEnabled,
                        onChanged: (val) => setState(() => _wifiEnabled = val),
                      ),
                      onPressed: _showNetworkSheet,
                    ),
                    _buildDivider(colors),
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.bluetooth, const Color(0xFF3B82F6)),
                      title: const Text('蓝牙 Bluetooth 5.4'),
                      subtitle: Text(_bluetoothEnabled ? 'AirPods Pro (2代) 已连接' : '已关闭'),
                      trailing: SofToggle(
                        value: _bluetoothEnabled,
                        luminous: true,
                        onChanged: (val) => setState(() => _bluetoothEnabled = val),
                      ),
                    ),
                    _buildDivider(colors),
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.activity, const Color(0xFF8B5CF6)),
                      title: const Text('移动蜂窝网络 5G'),
                      subtitle: const Text('中国移动 5G • 双卡双通'),
                      trailing: SofToggle(
                        value: _cellularData,
                        onChanged: (val) => setState(() => _cellularData = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Group 2: Display & Aesthetics
              _buildSectionHeader(context, '显示、外观与柔光美学 DISPLAY & LUMEN'),
              SofCard(
                variant: SofSurfaceVariant.solid,
                padding: const EdgeInsets.all(20),
                borderRadius: radii.brXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('系统外观模式', style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SofSegmentedControl<int>(
                      value: _appearanceIndex,
                      onChanged: (idx) {
                        setState(() => _appearanceIndex = idx);
                        if (idx == 1) widget.onToggleTheme(false);
                        if (idx == 2) widget.onToggleTheme(true);
                      },
                      segments: const [
                        SofSegment(value: 0, label: Text('跟随系统')),
                        SofSegment(value: 1, label: Text('浅色模式')),
                        SofSegment(value: 2, label: Text('深色模式')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SofIcon(SofIcons.sun, size: 18),
                            const SizedBox(width: 8),
                            Text('屏幕亮度调节', style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        Text(
                          '${(_brightness * 100).round()}%',
                          style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SofSlider(
                      value: _brightness,
                      onChanged: (v) => setState(() => _brightness = v),
                      luminous: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('原彩柔光舒适显示 (TrueTone)', style: typography.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('根据环境光动态微调色温与柔光漫射', style: typography.caption.copyWith(color: colors.contentSecondary)),
                          ],
                        ),
                        SofToggle(
                          value: _eyeComfort,
                          onChanged: (v) => setState(() => _eyeComfort = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SofSelect<String>(
                      label: '动态自适应刷新率',
                      value: _refreshRate,
                      items: const [
                        SofSelectItem(value: '120hz', label: '智能极速 1-120Hz LTPO (极度流畅)'),
                        SofSelectItem(value: '60hz', label: '标准节能 60Hz'),
                      ],
                      onChanged: (v) => setState(() => _refreshRate = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Group 3: Sound & Haptics
              _buildSectionHeader(context, '声音、触感与系统反馈 AUDIO & HAPTICS'),
              SofCard(
                variant: SofSurfaceVariant.solid,
                padding: const EdgeInsets.all(20),
                borderRadius: radii.brXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SofIcon(SofIcons.volume, size: 18),
                            const SizedBox(width: 8),
                            Text('媒体音量', style: typography.caption.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        Text(
                          '${(_mediaVolume * 100).round()}%',
                          style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SofSlider(
                      value: _mediaVolume,
                      onChanged: (v) => setState(() => _mediaVolume = v),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('系统级自然触感反馈 (OriginOS Haptic)', style: typography.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('拟态机械弹簧阻尼微振感', style: typography.caption.copyWith(color: colors.contentSecondary)),
                          ],
                        ),
                        SofToggle(
                          value: _hapticFeedback,
                          luminous: true,
                          onChanged: (v) => setState(() => _hapticFeedback = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Group 4: About
              _buildSectionHeader(context, '关于本机 ABOUT DEVICE'),
              SofCard(
                variant: SofSurfaceVariant.solid,
                padding: EdgeInsets.zero,
                borderRadius: radii.brXl,
                child: Column(
                  children: [
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.cpu, const Color(0xFF6366F1)),
                      title: const Text('设备型号'),
                      subtitle: const Text('Soflume Pro 16 Max (16GB RAM + 512GB ROM)'),
                      showChevron: true,
                      onPressed: () => showSofToast(context: context, message: '硬件规格：旗舰级 8 核心 NPU'),
                    ),
                    _buildDivider(colors),
                    SofListTile(
                      leading: _buildIconSquircle(SofIcons.sparkles, const Color(0xFF10B981)),
                      title: const Text('系统版本'),
                      subtitle: const Text('Soflume UI 2.0 (Flutter 3.27+ 对齐引擎)'),
                      trailing: const SofBadge(label: Text('最新版本'), variant: SofBadgeVariant.accent),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colors = SoflumeTheme.colorsOf(context);
    final typography = SoflumeTheme.typographyOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 10),
      child: Text(
        title,
        style: typography.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: colors.contentSecondary,
        ),
      ),
    );
  }

  Widget _buildIconSquircle(String svgIcon, Color bg) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: SofIcon(svgIcon, size: 18, color: const Color(0xFFFFFFFF)),
    );
  }

  Widget _buildDivider(SoflumeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Container(
        height: 0.8,
        color: colors.outlineSubtle,
      ),
    );
  }
}
