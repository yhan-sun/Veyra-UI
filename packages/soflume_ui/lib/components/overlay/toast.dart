import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';
import '../feedback/badge.dart';

/// Floating toast pill notification.
class SofToast extends StatelessWidget {
  const SofToast({
    super.key,
    required this.message,
    this.icon,
    this.variant = SofBadgeVariant.accent,
  });

  final String message;
  final Widget? icon;
  final SofBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    Color themeColor;
    switch (variant) {
      case SofBadgeVariant.accent:
        themeColor = colors.accent;
        break;
      case SofBadgeVariant.success:
        themeColor = colors.success;
        break;
      case SofBadgeVariant.warning:
        themeColor = colors.warning;
        break;
      case SofBadgeVariant.danger:
        themeColor = colors.danger;
        break;
      case SofBadgeVariant.neutral:
        themeColor = colors.contentSecondary;
        break;
    }

    return SofSurface(
      variant: SofSurfaceVariant.floating,
      borderRadius: radii.brPill,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: themeColor, size: 18),
              child: icon!,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            message,
            style: typography.body.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.contentPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a floating [SofToast] using [OverlayEntry].
void showSofToast({
  required BuildContext context,
  required String message,
  Widget? icon,
  SofBadgeVariant variant = SofBadgeVariant.accent,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlayState = Overlay.maybeOf(context, rootOverlay: true);
  if (overlayState == null) return;

  final theme = SoflumeTheme.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return SoflumeTheme(
        data: theme,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SofToast(
                message: message,
                icon: icon,
                variant: variant,
              ),
            ),
          ),
        ),
      );
    },
  );

  overlayState.insert(entry);
  Future.delayed(duration, () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
