import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/focus_ring.dart';
import '../../primitives/surface.dart';
import '../../primitives/pressable.dart';

/// Versatile card component supporting all Soft Lumen material surfaces.
class SofCard extends StatelessWidget {
  const SofCard({
    super.key,
    required this.child,
    this.variant = SofSurfaceVariant.solid,
    this.onPressed,
    this.enabled = true,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.width,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  final Widget child;
  final SofSurfaceVariant variant;
  final VoidCallback? onPressed;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final effectivePadding = padding ?? theme.spacing.insetsAllMd;
    final effectiveRadius = borderRadius ?? theme.radii.brLg;

    final surface = SofSurface(
      variant: variant,
      borderRadius: effectiveRadius,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: effectivePadding,
      margin: margin,
      width: width,
      height: height,
      child: child,
    );

    if (onPressed != null) {
      return SofPressable(
        onPressed: enabled ? onPressed : null,
        enabled: enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: semanticLabel,
        pressScale: 0.985,
        builder: (context, state) {
          return SofFocusRing(
            focused: state.isFocused,
            borderRadius: effectiveRadius,
            child: surface,
          );
        },
      );
    }

    return surface;
  }
}
