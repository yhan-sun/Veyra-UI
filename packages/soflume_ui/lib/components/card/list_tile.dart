import 'package:flutter/widgets.dart';
import '../../foundation/icons/icon.dart';
import '../../foundation/icons/soflume_icons.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/focus_ring.dart';
import '../../primitives/pressable.dart';

/// Flagship list tile item designed for grouped settings, menus, and item lists.
class SofListTile extends StatelessWidget {
  const SofListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showChevron = false,
    this.onPressed,
    this.enabled = true,
    this.padding,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onPressed;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final density = theme.density;

    final isInteractive = enabled && onPressed != null;

    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: 16.0 * density.horizontalFactor,
          vertical: 12.0 * density.verticalFactor,
        );

    final tileContent = Padding(
      padding: effectivePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                  style: typography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: enabled ? colors.contentPrimary : colors.contentSecondary,
                  ),
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  DefaultTextStyle.merge(
                    style: typography.caption.copyWith(
                      color: colors.contentSecondary,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
          if (showChevron) ...[
            const SizedBox(width: 8),
            SofIcon(
              SofIcons.chevronRight,
              size: 16,
              color: colors.contentSecondary.withValues(alpha: 0.65),
            ),
          ],
        ],
      ),
    );

    if (isInteractive) {
      return SofPressable(
        onPressed: onPressed,
        enabled: enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: semanticLabel,
        pressScale: 0.99,
        builder: (context, state) {
          return SofFocusRing(
            focused: state.isFocused,
            borderRadius: theme.radii.brMd,
            ringOffset: 0.5,
            child: AnimatedContainer(
              duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
              decoration: BoxDecoration(
                color: state.isHovered
                    ? colors.surfaceMuted.withValues(alpha: 0.5)
                    : const Color(0x00000000),
              ),
              child: tileContent,
            ),
          );
        },
      );
    }

    return tileContent;
  }
}
