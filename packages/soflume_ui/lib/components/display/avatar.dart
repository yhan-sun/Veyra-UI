import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';

/// Avatar shape.
enum SofAvatarShape {
  squircle,
  circle,
}

/// Avatar component supporting image, initials, and status indicator.
class SofAvatar extends StatelessWidget {
  const SofAvatar({
    super.key,
    this.image,
    this.initials,
    this.size = 40.0,
    this.shape = SofAvatarShape.squircle,
    this.statusColor,
  });

  final ImageProvider? image;
  final String? initials;
  final double size;
  final SofAvatarShape shape;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final effectiveRadius = shape == SofAvatarShape.circle
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(size * 0.32);

    Widget inner;
    if (image != null) {
      inner = Image(
        image: image!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else {
      inner = Container(
        width: size,
        height: size,
        color: colors.accentSubtle,
        alignment: Alignment.center,
        child: Text(
          initials ?? '',
          style: typography.label.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.accent,
            fontSize: size * 0.38,
          ),
        ),
      );
    }

    final avatarWidget = ClipPath(
      clipper: _AvatarClipper(effectiveRadius),
      child: inner,
    );

    if (statusColor == null) return avatarWidget;

    final dotSize = size * 0.28;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarWidget,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.surface,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarClipper extends CustomClipper<Path> {
  _AvatarClipper(this.borderRadius);

  final BorderRadius borderRadius;

  @override
  Path getClip(Size size) {
    return SofSquircleBorder(borderRadius: borderRadius)
        .getOuterPath(Offset.zero & size);
  }

  @override
  bool shouldReclip(_AvatarClipper oldClipper) =>
      oldClipper.borderRadius != borderRadius;
}
