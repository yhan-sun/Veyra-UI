import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/pressable.dart';

/// Interactive chip for filters, tags, and selections.
class SofChip extends StatelessWidget {
  const SofChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.avatar,
    this.enabled = true,
  });

  final Widget label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Widget? avatar;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final isInteractive = enabled && (onSelected != null || onDeleted != null);

    final bgColor = selected
        ? (colors.isDark ? colors.accent.withValues(alpha: 0.25) : colors.accentSubtle)
        : (colors.isDark ? colors.surfaceMuted : colors.surfaceMuted);

    final textColor = selected ? colors.accent : colors.contentPrimary;
    final borderColor = selected ? colors.accent : colors.outlineSubtle;

    return SofPressable(
      onPressed: isInteractive && onSelected != null ? () => onSelected!(!selected) : null,
      enabled: isInteractive,
      pressScale: 0.96,
      builder: (context, state) {
        return AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: state.isHovered
                ? Color.lerp(bgColor, colors.accent, 0.15)!
                : bgColor,
            shape: SofSquircleBorder(
              borderRadius: radii.brPill,
              side: BorderSide(
                color: borderColor,
                width: selected ? 1.4 : 1.0,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: 6),
              ],
              DefaultTextStyle.merge(
                style: typography.label.copyWith(
                  color: textColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: label,
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: IconTheme(
                    data: IconThemeData(
                      color: textColor.withValues(alpha: 0.8),
                      size: 14,
                    ),
                    child: const Text('×', style: TextStyle(fontSize: 16, height: 1)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
