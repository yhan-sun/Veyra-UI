import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';

/// Modal bottom sheet container with squircle top corners and drag handle.
class SofSheet extends StatelessWidget {
  const SofSheet({
    super.key,
    required this.child,
    this.title,
    this.borderRadius,
    this.showDragHandle = true,
    this.padding,
  });

  final Widget child;
  final Widget? title;
  final BorderRadius? borderRadius;
  final bool showDragHandle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final typography = theme.typography;

    final effectiveRadius = borderRadius ??
        BorderRadius.only(
          topLeft: Radius.circular(radii.xxl),
          topRight: Radius.circular(radii.xxl),
        );

    return Align(
      alignment: Alignment.bottomCenter,
      child: SofSurface(
        variant: SofSurfaceVariant.floating,
        borderRadius: effectiveRadius,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDragHandle) ...[
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.outlineSubtle,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: DefaultTextStyle.merge(
                    style: typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.contentPrimary,
                    ),
                    child: title!,
                  ),
                ),
              ],
              Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays a modal [SofSheet] sliding up from the bottom.
Future<T?> showSofSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  final theme = SoflumeTheme.of(context);

  return Navigator.of(context, rootNavigator: true).push<T>(
    PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: isDismissible,
      barrierColor: theme.colors.overlay,
      transitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationExpressive),
      reverseTransitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationRegular),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SoflumeTheme(
          data: theme,
          child: builder(context),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: theme.motion.springSettle,
          reverseCurve: Curves.easeIn,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    ),
  );
}
