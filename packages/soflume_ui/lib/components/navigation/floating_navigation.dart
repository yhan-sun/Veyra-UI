import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/focus_ring.dart';
import '../../primitives/surface.dart';

/// Item descriptor for [SofFloatingNavigation].
class SofNavItem {
  const SofNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badge,
  });

  final Widget icon;
  final String label;
  final Widget? selectedIcon;
  final Widget? badge;
}

/// Brand Signature: Floating frosted navigation dock with spring indicator and keyboard navigation.
class SofFloatingNavigation extends StatelessWidget {
  const SofFloatingNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 64.0,
    this.maxWidth = 420.0,
  }) : assert(items.length >= 2, 'Must have at least 2 navigation items');

  final List<SofNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final typography = theme.typography;

    final validIndex = selectedIndex.clamp(0, items.length - 1);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SofSurface(
            variant: SofSurfaceVariant.frost,
            borderRadius: radii.brPill,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : maxWidth;
                final itemWidth = totalWidth / items.length;

                return Stack(
                  children: [
                    // Spring sliding active bubble
                    AnimatedPositioned(
                      duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                      curve: theme.motion.getEffectiveCurve(theme.motion.springSnappy),
                      left: validIndex * itemWidth + 4,
                      top: 2,
                      bottom: 2,
                      width: (itemWidth - 8).clamp(0.0, totalWidth),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: colors.accent.withValues(alpha: colors.isDark ? 0.22 : 0.12),
                          shape: SofSquircleBorder(
                            borderRadius: radii.brPill,
                          ),
                        ),
                      ),
                    ),

                    // Nav items
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final isSelected = index == validIndex;
                        final activeColor = isSelected ? colors.onAccentSubtle : colors.contentSecondary;

                        return Expanded(
                          child: _NavTarget(
                            label: item.label,
                            isSelected: isSelected,
                            borderRadius: radii.brPill,
                            onTap: () {
                              if (!isSelected) {
                                HapticFeedback.selectionClick();
                                onChanged(index);
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    IconTheme(
                                      data: IconThemeData(
                                        color: activeColor,
                                        size: 20,
                                      ),
                                      child: isSelected && item.selectedIcon != null
                                          ? item.selectedIcon!
                                          : item.icon,
                                    ),
                                    if (item.badge != null)
                                      Positioned(
                                        top: -4,
                                        right: -8,
                                        child: item.badge!,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                AnimatedDefaultTextStyle(
                                  duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
                                  style: typography.caption.copyWith(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: activeColor,
                                  ),
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTarget extends StatefulWidget {
  const _NavTarget({
    required this.label,
    required this.isSelected,
    required this.borderRadius,
    required this.onTap,
    required this.child,
  });

  final String label;
  final bool isSelected;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_NavTarget> createState() => _NavTargetState();
}

class _NavTargetState extends State<_NavTarget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: widget.isSelected,
      button: true,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (focused) {
          if (mounted) setState(() => _isFocused = focused);
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: SofFocusRing(
            focused: _isFocused,
            borderRadius: widget.borderRadius,
            ringOffset: 0.5,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
