import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';

/// Item descriptor for [SofTabs].
class SofTabItem {
  const SofTabItem({
    required this.label,
    this.icon,
    this.badge,
  });

  final String label;
  final Widget? icon;
  final Widget? badge;
}

/// Visual style of the tabs.
enum SofTabVariant {
  /// Sliding pill highlight enclosing active tab.
  pill,

  /// Clean underline indicator sliding along bottom edge.
  underline,
}

/// Navigation tabs with smooth physics spring active indicator.
class SofTabs extends StatelessWidget {
  const SofTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = SofTabVariant.pill,
    this.height = 42.0,
  }) : assert(tabs.length > 0);

  final List<SofTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final SofTabVariant variant;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final validIndex = selectedIndex.clamp(0, tabs.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final tabWidth = totalWidth / tabs.length;

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              // Sliding indicator
              if (variant == SofTabVariant.pill)
                AnimatedPositioned(
                  duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                  curve: theme.motion.springSnappy,
                  left: validIndex * tabWidth + 4,
                  top: 4,
                  bottom: 4,
                  width: tabWidth - 8,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: colors.isDark ? colors.surfaceRaised : colors.surface,
                      shape: SofSquircleBorder(
                        borderRadius: radii.brMd,
                        side: BorderSide(color: colors.outlineSubtle, width: 0.8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                )
              else
                AnimatedPositioned(
                  duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                  curve: theme.motion.springSnappy,
                  left: validIndex * tabWidth + 12,
                  bottom: 0,
                  width: tabWidth - 24,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),

              // Tab items
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  final isSelected = index == validIndex;
                  final textColor = isSelected ? colors.contentPrimary : colors.contentSecondary;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!isSelected) {
                          HapticFeedback.selectionClick();
                          onChanged(index);
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (tab.icon != null) ...[
                              IconTheme(
                                data: IconThemeData(color: textColor, size: 16),
                                child: tab.icon!,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Flexible(
                              child: AnimatedDefaultTextStyle(
                                duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
                                style: typography.label.copyWith(
                                  color: textColor,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                child: Text(tab.label),
                              ),
                            ),
                            if (tab.badge != null) ...[
                              const SizedBox(width: 4),
                              tab.badge!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
