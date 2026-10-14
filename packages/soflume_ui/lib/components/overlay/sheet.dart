import 'package:flutter/services.dart';
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
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity != null && details.primaryVelocity! > 250) {
                      Navigator.maybeOf(context)?.maybePop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        width: 38,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.outlineSubtle,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: DefaultTextStyle.merge(
                    style: typography.title.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.contentPrimary,
                    ),
                    child: title!,
                  ),
                ),
              ],
              Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
///
/// Supports ESC key dismiss, barrier dismiss, barrier accessibility labels,
/// downward swipe on handle, nested/root navigators, and PopScope.
Future<T?> showSofSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) {
  final theme = SoflumeTheme.of(context);

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    PageRouteBuilder<T>(
      settings: routeSettings,
      opaque: false,
      barrierDismissible: isDismissible,
      barrierLabel: barrierLabel ?? (isDismissible ? 'Dismiss' : null),
      barrierColor: theme.colors.overlay,
      transitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationExpressive),
      reverseTransitionDuration: theme.motion.getEffectiveDuration(theme.motion.durationRegular),
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
                    if (isDismissible) {
                      Navigator.maybeOf(context)?.maybePop();
                    }
                    return null;
                  },
                ),
              },
              child: PopScope(
                canPop: isDismissible,
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
