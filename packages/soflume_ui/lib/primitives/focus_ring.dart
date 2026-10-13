import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/shapes/squircle_border.dart';

/// Renders a soft luminous focus ring for keyboard navigation accessibility.
class SofFocusRing extends StatelessWidget {
  const SofFocusRing({
    super.key,
    required this.focused,
    required this.child,
    this.borderRadius,
    this.ringWidth = 2.5,
    this.ringOffset = 2.0,
  });

  final bool focused;
  final Widget child;
  final BorderRadius? borderRadius;
  final double ringWidth;
  final double ringOffset;

  @override
  Widget build(BuildContext context) {
    if (!focused) return child;

    final theme = SoflumeTheme.of(context);
    final effectiveRadius = borderRadius ?? theme.radii.brMd;

    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          top: -ringOffset,
          left: -ringOffset,
          right: -ringOffset,
          bottom: -ringOffset,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: SofSquircleBorder(
                  borderRadius: BorderRadius.circular(
                    effectiveRadius.topLeft.x + ringOffset,
                  ),
                  side: BorderSide(
                    color: theme.colors.outlineFocus,
                    width: ringWidth,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
