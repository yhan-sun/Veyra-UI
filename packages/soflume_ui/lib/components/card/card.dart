import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';
import '../../primitives/pressable.dart';

/// Versatile card component supporting all Soft Lumen material surfaces.
class SofCard extends StatelessWidget {
  const SofCard({
    super.key,
    required this.child,
    this.variant = SofSurfaceVariant.solid,
    this.onPressed,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.width,
    this.height,
  });

  final Widget child;
  final SofSurfaceVariant variant;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final effectivePadding = padding ?? theme.spacing.insetsAllMd;

    final surface = SofSurface(
      variant: variant,
      borderRadius: borderRadius ?? theme.radii.brLg,
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
        onPressed: onPressed,
        pressScale: 0.985,
        child: surface,
      );
    }

    return surface;
  }
}
