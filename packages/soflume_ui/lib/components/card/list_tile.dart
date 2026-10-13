import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
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
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onPressed;
  final bool enabled;
  final EdgeInsetsGeometry? padding;

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
            CustomPaint(
              size: const Size(8, 14),
              painter: _ChevronPainter(
                color: colors.contentSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );

    if (isInteractive) {
      return SofPressable(
        onPressed: onPressed,
        enabled: enabled,
        pressScale: 0.99,
        builder: (context, state) {
          return AnimatedContainer(
            duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
            decoration: BoxDecoration(
              color: state.isHovered
                  ? colors.surfaceMuted.withValues(alpha: 0.5)
                  : const Color(0x00000000),
            ),
            child: tileContent,
          );
        },
      );
    }

    return tileContent;
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(1.5, 1.5);
    path.lineTo(size.width - 1.5, size.height / 2);
    path.lineTo(1.5, size.height - 1.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => oldDelegate.color != color;
}
