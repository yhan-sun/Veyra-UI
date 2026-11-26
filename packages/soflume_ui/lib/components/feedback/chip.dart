import 'package:flutter/widgets.dart';
import '../../foundation/icons/icon.dart';
import '../../foundation/icons/soflume_icons.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/focus_ring.dart';
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

    final isInteractive = enabled && onSelected != null;

    final bgColor = selected
        ? (colors.isDark ? colors.accent.withValues(alpha: 0.25) : colors.accentSubtle)
        : colors.surfaceMuted;

    final textColor = selected ? colors.onAccentSubtle : colors.contentPrimary;
    final borderColor = selected ? colors.accent : colors.outlineSubtle;

    Widget buildChipContainer({required bool isHovered, required bool isFocused}) {
      return SofFocusRing(
        focused: isFocused,
        borderRadius: radii.brPill,
        child: AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: isHovered ? Color.lerp(bgColor, colors.accent, 0.15)! : bgColor,
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
                SofPressable(
                  onPressed: enabled ? onDeleted : null,
                  enabled: enabled,
                  semanticLabel: 'Remove',
                  pressScale: 0.88,
                  child: SofIcon(
                    SofIcons.x,
                    size: 13,
                    color: textColor.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (!isInteractive) {
      return Opacity(
        opacity: enabled ? 1.0 : 0.45,
        child: buildChipContainer(isHovered: false, isFocused: false),
      );
    }

    return Semantics(
      selected: selected,
      enabled: enabled,
      child: SofPressable(
        onPressed: () => onSelected!(!selected),
        enabled: enabled,
        pressScale: 0.96,
        builder: (context, state) => buildChipContainer(
          isHovered: state.isHovered,
          isFocused: state.isFocused,
        ),
      ),
    );
  }
}
