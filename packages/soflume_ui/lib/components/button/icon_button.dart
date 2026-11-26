import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/pressable.dart';
import '../../primitives/focus_ring.dart';
import '../../primitives/surface.dart';
import '../../src/button_style.dart';
import 'button.dart';

/// Shape of the icon button.
enum SofIconButtonShape {
  /// Continuous curvature squircle.
  squircle,

  /// Pure circle.
  circle,
}

/// A compact, tactile icon button in the Soft Lumen style.
class SofIconButton extends StatelessWidget {
  const SofIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = SofButtonVariant.ghost,
    this.size = SofButtonSize.medium,
    this.shape = SofIconButtonShape.squircle,
    this.enabled = true,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final SofButtonVariant variant;
  final SofButtonSize size;
  final SofIconButtonShape shape;
  final bool enabled;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final density = theme.density;

    final dimension = (size == SofButtonSize.small
            ? 34.0
            : size == SofButtonSize.large
                ? 48.0
                : 40.0) *
        density.verticalFactor;

    final isInteractive = enabled && onPressed != null;

    final effectiveRadius = shape == SofIconButtonShape.circle
        ? BorderRadius.circular(dimension / 2)
        : (size == SofButtonSize.small ? radii.brSm : radii.brMd);

    final Widget button = SofPressable(
      onPressed: isInteractive ? onPressed : null,
      enabled: isInteractive,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: tooltip,
      pressScale: 0.94,
      builder: (context, state) {
        final palette = SofButtonPalette.resolve(
          variant: variant,
          colors: colors,
          isHovered: state.isHovered,
        );

        final ShapeBorder shapeBorder = shape == SofIconButtonShape.circle
            ? CircleBorder(side: palette.borderSide)
            : SofSquircleBorder(
                borderRadius: effectiveRadius,
                side: palette.borderSide,
              );

        final container = AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
          width: dimension,
          height: dimension,
          decoration: ShapeDecoration(
            color: palette.background,
            shape: shapeBorder,
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: palette.foreground,
              size: size.iconSize,
            ),
            child: icon,
          ),
        );

        return SofFocusRing(
          focused: state.isFocused,
          borderRadius: effectiveRadius,
          child: container,
        );
      },
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return _SofHoverTooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class _SofHoverTooltip extends StatefulWidget {
  const _SofHoverTooltip({
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  State<_SofHoverTooltip> createState() => _SofHoverTooltipState();
}

class _SofHoverTooltipState extends State<_SofHoverTooltip> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _show() {
    if (_entry != null) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    final theme = SoflumeTheme.of(context);

    _entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topLeft,
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: const Offset(0, 6),
              child: SoflumeTheme(
                data: theme,
                child: SofSurface(
                  variant: SofSurfaceVariant.floating,
                  borderRadius: theme.radii.brSm,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    widget.message,
                    style: theme.typography.caption.copyWith(
                      color: theme.colors.contentPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: MouseRegion(
        onEnter: (_) => _show(),
        onExit: (_) => _hide(),
        child: widget.child,
      ),
    );
  }
}
