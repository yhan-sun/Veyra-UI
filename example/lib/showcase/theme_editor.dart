import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Live Theme Customization Sandbox.
class ThemeEditor extends StatelessWidget {
  const ThemeEditor({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  final SoflumeThemeData currentTheme;
  final ValueChanged<SoflumeThemeData> onThemeChanged;

  static const List<Map<String, dynamic>> accentOptions = [
    {'name': 'Iris (Default)', 'color': Color(0xFF5362E8)},
    {'name': 'Ocean Blue', 'color': Color(0xFF007AFF)},
    {'name': 'Emerald Green', 'color': Color(0xFF258867)},
    {'name': 'Rose Quartz', 'color': Color(0xFFE91E63)},
    {'name': 'Amber Glow', 'color': Color(0xFFFF9500)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Editor',
            style: typography.display.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Live tuning of Design Tokens: Brand Accents, Surface Hierarchy, Density and Curvature.',
            style: typography.body.copyWith(color: colors.contentSecondary),
          ),
          const SizedBox(height: 24),

          // Brand Accent Color Selector
          Text('BRAND ACCENT COLOR', style: typography.caption.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: accentOptions.map((opt) {
              final color = opt['color'] as Color;
              final name = opt['name'] as String;
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Density Scale
          Text('TOUCH TARGET DENSITY', style: typography.caption.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          SofSegmentedControl<SoflumeDensity>(
            value: currentTheme.density,
            onChanged: (d) => onThemeChanged(currentTheme.copyWith(density: d)),
            segments: const [
              SofSegment(value: SoflumeDensity.compact, label: Text('Compact (Desktop)')),
              SofSegment(value: SoflumeDensity.comfortable, label: Text('Comfortable (Mobile)')),
              SofSegment(value: SoflumeDensity.spacious, label: Text('Spacious (A11y)')),
            ],
          ),
          const SizedBox(height: 24),

          // Reduce Motion Toggle
          SofCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reduce Motion', style: typography.body.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('Disables spring overshoot and physics scaling', style: typography.caption),
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

          // Live Preview Card
          Text('LIVE COMPONENT PREVIEW', style: typography.caption.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          SofCard(
            variant: SofSurfaceVariant.ambient,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Soft Lumen Preview', style: typography.title.copyWith(fontWeight: FontWeight.w700)),
                    const SofBadge(label: Text('Active Accent'), variant: SofBadgeVariant.accent),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Continuous curvature squircle border with ${currentTheme.colors.accent.toString()} highlight.',
                  style: typography.body.copyWith(color: colors.contentSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SofButton(
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                      child: const Text('Primary Filled'),
                    ),
                    const SizedBox(width: 12),
                    SofButton(
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                      child: const Text('Subtle Tint'),
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
