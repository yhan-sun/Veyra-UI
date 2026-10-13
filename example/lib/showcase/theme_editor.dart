import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 实时主题与设计 Token 工坊。
class ThemeEditor extends StatelessWidget {
  const ThemeEditor({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  final SoflumeThemeData currentTheme;
  final ValueChanged<SoflumeThemeData> onThemeChanged;

  static const List<Map<String, dynamic>> accentOptions = [
    {'name': '柔鸢紫蓝 (Iris)', 'color': Color(0xFF5362E8), 'desc': '标准主品牌色，优雅深邃'},
    {'name': '晴空远洋 (Ocean)', 'color': Color(0xFF007AFF), 'desc': '科技高对比，清透理性'},
    {'name': '自然翠石 (Emerald)', 'color': Color(0xFF258867), 'desc': '生机柔和，健康生态'},
    {'name': '蔷薇柔粉 (Rose)', 'color': Color(0xFFE91E63), 'desc': '灵动温暖，青春活力'},
    {'name': '暮色琥珀 (Amber)', 'color': Color(0xFFFF9500), 'desc': '温馨秋意，光感明快'},
  ];

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
          Text(
            '主题与设计 Token 工坊',
            style: typography.display.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '支持实时调节品牌强调色、深浅色模式、连续曲率、触控密度与动效策略，实时查看全应用渲染响应。',
            style: typography.body.copyWith(color: colors.contentSecondary),
          ),
          const SizedBox(height: 28),

          // 1. 品牌强调色
          Text('1. 品牌主题色 (BRAND ACCENT TOKEN)', style: typography.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: accentOptions.map((opt) {
              final color = opt['color'] as Color;
              final name = opt['name'] as String;
              final desc = opt['desc'] as String;
              final isSelected = currentTheme.colors.accent == color;

              return GestureDetector(
                onTap: () {
                  final newColors = currentTheme.isDark
                      ? SoflumeColors.dark(customAccent: color)
                      : SoflumeColors.light(customAccent: color);
                  onThemeChanged(currentTheme.copyWith(colors: newColors));
                },
                child: SofCard(
                  variant: isSelected ? SofSurfaceVariant.ambient : SofSurfaceVariant.solid,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, fontSize: 13)),
                          Text(desc, style: TextStyle(color: colors.contentSecondary, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // 2. 交互密度
          Text('2. 组件触控密度 (TOUCH DENSITY)', style: typography.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text('自适应三种物理尺寸策略：Compact 适配桌面高信息密度，Spacious 适配大号触屏及无障碍。', style: typography.caption),
          const SizedBox(height: 12),
          SofSegmentedControl<SoflumeDensity>(
            value: currentTheme.density,
            onChanged: (d) => onThemeChanged(currentTheme.copyWith(density: d)),
            segments: const [
              SofSegment(value: SoflumeDensity.compact, label: Text('紧凑 Compact (40dp 桌面)')),
              SofSegment(value: SoflumeDensity.comfortable, label: Text('舒适 Comfortable (48dp 移动)')),
              SofSegment(value: SoflumeDensity.spacious, label: Text('宽松 Spacious (56dp 触控)')),
            ],
          ),
          const SizedBox(height: 28),

          // 3. 动效阻尼与减弱动效
          Text('3. 动效策略 (MOTION SYSTEM)', style: typography.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          SofCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('减弱动态效果 (Reduce Motion)', style: typography.body.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('开启后自动降级弹簧过冲振荡为瞬时切换，保护前庭觉敏感用户。', style: typography.caption),
                  ],
                ),
                SofToggle(
                  value: currentTheme.motion.reduceMotion,
                  onChanged: (val) {
                    onThemeChanged(currentTheme.copyWith(
                      motion: val ? SoflumeMotion.reduced : SoflumeMotion.standard,
                    ));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 4. 当前 Token 实时输出与暗色对比度看板
          Text('4. 实时渲染诊断看板 (TOKEN DIAGNOSTICS)', style: typography.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          SofCard(
            variant: SofSurfaceVariant.ambient,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTheme.isDark ? '暗色模式 (Dark Theme Active)' : '浅色模式 (Light Theme Active)',
                      style: typography.title.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SofBadge(
                      label: Text(currentTheme.isDark ? 'WCAG AAA 7.2:1' : 'WCAG AA 5.8:1'),
                      variant: SofBadgeVariant.success,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '画布背景: ${currentTheme.colors.canvas.toString()} • 表面层级: ${currentTheme.colors.surface.toString()} • 强调主色: ${currentTheme.colors.accent.toString()}',
                  style: typography.code.copyWith(fontSize: 11, color: colors.contentSecondary),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    SofButton(
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                      child: const Text('主色按钮 Filled'),
                    ),
                    const SizedBox(width: 12),
                    SofButton(
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                      child: const Text('半透次级 Subtle'),
                    ),
                    const SizedBox(width: 12),
                    SofButton(
                      variant: SofButtonVariant.outlined,
                      onPressed: () {},
                      child: const Text('描边线条 Outlined'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
