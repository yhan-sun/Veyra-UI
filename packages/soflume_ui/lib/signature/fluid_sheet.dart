import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../primitives/surface.dart';

/// Brand Signature: Gesture-driven, interruptible draggable sheet with continuous spring physics and multi-stage snapping.
class SofFluidSheet extends StatefulWidget {
  const SofFluidSheet({
    super.key,
    required this.builder,
    this.snapPoints = const [0.25, 0.65, 0.92],
    this.initialSnapIndex = 1,
    this.onSnapChanged,
  }) : assert(snapPoints.length >= 2, 'Must specify at least 2 snap points');

  final List<double> snapPoints;
  final int initialSnapIndex;
  final ValueChanged<int>? onSnapChanged;
  final Widget Function(BuildContext context, ScrollController? scrollController) builder;

  @override
  State<SofFluidSheet> createState() => _SofFluidSheetState();
}

class _SofFluidSheetState extends State<SofFluidSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentSnapIndex;

  @override
  void initState() {
    super.initState();
    _currentSnapIndex = widget.initialSnapIndex.clamp(0, widget.snapPoints.length - 1);
    final initialExtent = widget.snapPoints[_currentSnapIndex];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: initialExtent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snapToNearest(double currentExtent, double velocity) {
    int targetIndex = 0;
    double minDistance = double.infinity;

    // Projected extent based on velocity
    final projected = currentExtent + (velocity * 0.0003);

    for (int i = 0; i < widget.snapPoints.length; i++) {
      final dist = (widget.snapPoints[i] - projected).abs();
      if (dist < minDistance) {
        minDistance = dist;
        targetIndex = i;
      }
    }

    final targetExtent = widget.snapPoints[targetIndex];
    if (targetIndex != _currentSnapIndex) {
      HapticFeedback.lightImpact();
      _currentSnapIndex = targetIndex;
      widget.onSnapChanged?.call(targetIndex);
    }

    _controller.animateTo(
      targetExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;

    final topRadius = BorderRadius.only(
      topLeft: Radius.circular(radii.xxl),
      topRight: Radius.circular(radii.xxl),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final extent = _controller.value;
            final sheetHeight = totalHeight * extent;

            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: sheetHeight,
                width: double.infinity,
                child: SofSurface(
                  variant: SofSurfaceVariant.frost,
                  borderRadius: topRadius,
                  child: Column(
                    children: [
                      // Drag Handle zone
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (details) {
                          final deltaFraction = -details.primaryDelta! / totalHeight;
                          _controller.value = (_controller.value + deltaFraction).clamp(
                            widget.snapPoints.first * 0.8,
                            widget.snapPoints.last * 1.05,
                          );
                        },
                        onVerticalDragEnd: (details) {
                          _snapToNearest(_controller.value, -details.velocity.pixelsPerSecond.dy);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: colors.outlineSubtle,
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Expanded(
                        child: widget.builder(context, null),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
