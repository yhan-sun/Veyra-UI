import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';

/// Item descriptor for [SofSegmentedControl].
class SofSegment<T> {
  const SofSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  final T value;
  final Widget label;
  final Widget? icon;
  final bool enabled;
}

/// Sliding segmented pill control with physics spring positioning.
class SofSegmentedControl<T> extends StatelessWidget {
  const SofSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.height = 38.0,
    this.borderRadius,
  }) : assert(segments.length >= 2, 'Segments must contain at least 2 items');

  final List<SofSegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final typography = theme.typography;

    final selectedIndex = segments.indexWhere((s) => s.value == value);
    final validIndex = selectedIndex >= 0 ? selectedIndex : 0;

    final outerRadius = borderRadius ?? radii.brMd;
    final innerRadius = SoflumeRadii.nestedBorderRadius(outerRadius.topLeft.x, 3.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasFiniteWidth = constraints.maxWidth.isFinite;
        final totalWidth = hasFiniteWidth ? constraints.maxWidth : (segments.length * 88.0);
        final segmentWidth = (totalWidth - 6.0) / segments.length;

        return Container(
          width: hasFiniteWidth ? null : totalWidth,
          height: height,
          padding: const EdgeInsets.all(3.0),
          decoration: ShapeDecoration(
            color: colors.isDark ? colors.surfaceMuted : colors.surfaceMuted,
            shape: SofSquircleBorder(
              borderRadius: outerRadius,
              side: BorderSide(color: colors.outlineSubtle, width: 0.8),
            ),
          ),
          child: Stack(
            children: [
              // Sliding active pill
              AnimatedPositioned(
                duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                curve: theme.motion.springSnappy,
                left: validIndex * segmentWidth,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: colors.isDark ? colors.surfaceRaised : colors.surface,
                    shape: SofSquircleBorder(
                      borderRadius: innerRadius,
                      side: BorderSide(
                        color: colors.isDark
                            ? colors.outlineSubtle
                            : const Color(0x18000000),
                        width: 0.8,
                      ),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),

              // Segment click targets and labels
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(segments.length, (index) {
                  final segment = segments[index];
                  final isSelected = index == validIndex;
                  final isSegmentInteractive = enabled && segment.enabled && onChanged != null;

                  final textColor = isSelected
                      ? colors.contentPrimary
                      : colors.contentSecondary;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: isSegmentInteractive
                          ? () {
                              if (!isSelected) {
                                HapticFeedback.selectionClick();
                                onChanged!(segment.value);
                              }
                            }
                          : null,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
                          style: typography.label.copyWith(
                            color: textColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: segment.icon != null
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconTheme(
                                        data: IconThemeData(
                                          size: 16,
                                          color: textColor,
                                        ),
                                        child: segment.icon!,
                                      ),
                                      const SizedBox(width: 6),
                                      segment.label,
                                    ],
                                  )
                                : segment.label,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
