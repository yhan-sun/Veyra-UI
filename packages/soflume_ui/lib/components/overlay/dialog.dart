import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';

/// Soft Lumen modal dialog with frosted backdrop, spring entrance, and accessible keyboard dismissal.
class SofDialog extends StatelessWidget {
  const SofDialog({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.borderRadius,
    this.maxWidth = 440.0,
    this.padding,
  });

  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final BorderRadius? borderRadius;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final effectiveRadius = borderRadius ?? radii.brXl;
    final effectivePadding = padding ?? const EdgeInsets.all(24.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SofSurface(
            variant: SofSurfaceVariant.floating,
            borderRadius: effectiveRadius,
            padding: effectivePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  DefaultTextStyle.merge(
                    style: typography.title.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.contentPrimary,
                    ),
                    child: title!,
                  ),
                  const SizedBox(height: 14),
                ],
                DefaultTextStyle.merge(
                  style: typography.body.copyWith(
                    color: colors.contentSecondary,
                  ),
                  child: child,
                ),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!
                        .map((action) => Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: action,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a modal [SofDialog] with spring animation and blurred backdrop.
///
/// Supports ESC key dismissal, Android Back / system pop handling, barrier accessibility labels,
/// nested/root navigators, and returns typed result [T].
Future<T?> showSofDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) {
  final theme = SoflumeTheme.of(context);

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    PageRouteBuilder<T>(
      settings: routeSettings,
      opaque: false,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel ?? (barrierDismissible ? 'Dismiss' : null),
      barrierColor: theme.colors.overlay,
      transitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationRegular),
      reverseTransitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FocusScope(
          autofocus: true,
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                DismissIntent: CallbackAction<DismissIntent>(
                  onInvoke: (intent) {
                    if (barrierDismissible) {
                      Navigator.maybeOf(context)?.maybePop();
                    }
                    return null;
                  },
                ),
              },
              child: PopScope(
                canPop: barrierDismissible,
                child: SoflumeTheme(
                  data: theme,
                  child: builder(context),
                ),
              ),
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: theme.motion.springGentle,
          reverseCurve: Curves.easeIn,
        );

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}
