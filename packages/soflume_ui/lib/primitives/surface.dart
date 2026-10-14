import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/shapes/squircle_border.dart';

/// Material surface variants in the Soft Lumen aesthetic.
enum SofSurfaceVariant {
  /// Default solid surface: highest contrast, zero blur overhead.
  solid,

  /// Frosted surface: translucent acrylic with gaussian backdrop blur and fine rim light.
  frost,

  /// Ambient surface: subtle directional luminescence, ideal for spotlight cards and hero elements.
  ambient,

  /// Floating surface: raised with soft multi-layered diffusion shadow.
  floating,
}

/// A container widget that renders the Soft Lumen material surfaces.
///
/// Automatically uses [SofSquircleBorder] for flagship continuous curvature
/// and handles high-performance fallback when reduced transparency is enabled.
class SofSurface extends StatelessWidget {
  const SofSurface({
    super.key,
    this.variant = SofSurfaceVariant.solid,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
    this.child,
  });

  final SofSurfaceVariant variant;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final isDark = theme.isDark;

    final effectiveRadius = borderRadius ?? radii.brMd;
    final squircleShape = SofSquircleBorder(
      borderRadius: effectiveRadius,
      side: borderWidth > 0
          ? BorderSide(
              color: borderColor ?? (isDark ? colors.outlineSubtle.withValues(alpha: 0.6) : colors.outlineSubtle),
              width: borderWidth,
            )
          : BorderSide.none,
    );

    // If reduced transparency is requested, degrade frost and ambient to solid
    final effectiveVariant = theme.reducedTransparency && variant == SofSurfaceVariant.frost
        ? SofSurfaceVariant.solid
        : variant;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      child: child,
    );

    switch (effectiveVariant) {
      case SofSurfaceVariant.solid:
        return Container(
          margin: margin,
          decoration: ShapeDecoration(
            color: color ?? colors.surface,
            shape: squircleShape,
            shadows: isDark
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x050F172A),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          clipBehavior: clipBehavior,
          child: content,
        );

      case SofSurfaceVariant.floating:
        final shadows = isDark
            ? const [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x0C0F172A),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Color(0x060F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ];
        return Container(
          margin: margin,
          decoration: ShapeDecoration(
            color: color ?? (isDark ? colors.surfaceRaised : colors.surface),
            shape: squircleShape,
            shadows: shadows,
          ),
          clipBehavior: clipBehavior,
          child: content,
        );

      case SofSurfaceVariant.frost:
        final frostBg = color ??
            (isDark
                ? const Color(0xD0131722)
                : const Color(0xE8FFFFFF));
        return Container(
          margin: margin,
          child: ClipPath(
            clipper: _ShapeBorderClipper(squircleShape),
            clipBehavior: clipBehavior,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: frostBg,
                  shape: squircleShape,
                ),
                child: content,
              ),
            ),
          ),
        );

      case SofSurfaceVariant.ambient:
        final baseColor = color ?? colors.surface;
        final glowColor = colors.accent.withValues(alpha: isDark ? 0.14 : 0.08);
        return Container(
          margin: margin,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(baseColor, glowColor, 0.6)!,
                baseColor,
              ],
            ),
            shape: squircleShape,
            shadows: [
              BoxShadow(
                color: colors.accent.withValues(alpha: isDark ? 0.18 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 6),
                spreadRadius: -6,
              ),
            ],
          ),
          clipBehavior: clipBehavior,
          child: content,
        );
    }
  }
}

class _ShapeBorderClipper extends CustomClipper<Path> {
  const _ShapeBorderClipper(this.shape);

  final ShapeBorder shape;

  @override
  Path getClip(Size size) {
    return shape.getOuterPath(Offset.zero & size);
  }

  @override
  bool shouldReclip(_ShapeBorderClipper oldClipper) => oldClipper.shape != shape;
}
