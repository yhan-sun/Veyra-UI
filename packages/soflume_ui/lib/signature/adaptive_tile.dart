import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../primitives/surface.dart';
import '../primitives/pressable.dart';

/// Brand Signature: Dynamic interactive tile for music, metrics, sensors, and status dashboards.
class SofAdaptiveTile extends StatelessWidget {
  const SofAdaptiveTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.statusBadge,
    this.footer,
    this.onPressed,
    this.variant = SofSurfaceVariant.ambient,
    this.width,
    this.height,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? icon;
  final Widget? value;
  final Widget? statusBadge;
  final Widget? footer;
  final VoidCallback? onPressed;
  final SofSurfaceVariant variant;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final content = SofSurface(
      variant: variant,
      borderRadius: radii.brLg,
      width: width,
      height: height,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: colors.isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: colors.accent, size: 20),
                    child: icon!,
                  ),
                ),
              if (statusBadge != null) statusBadge!,
            ],
          ),
          const SizedBox(height: 14),
          DefaultTextStyle.merge(
            style: typography.headline.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.contentPrimary,
            ),
            child: value ?? const SizedBox(),
          ),
          const SizedBox(height: 4),
          DefaultTextStyle.merge(
            style: typography.body.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.contentPrimary,
            ),
            child: title,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            DefaultTextStyle.merge(
              style: typography.caption.copyWith(
                color: colors.contentSecondary,
              ),
              child: subtitle!,
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 14),
            footer!,
          ],
        ],
      ),
    );

    if (onPressed != null) {
      return SofPressable(
        onPressed: onPressed,
        pressScale: 0.98,
        child: content,
      );
    }

    return content;
  }
}
