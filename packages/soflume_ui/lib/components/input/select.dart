import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/icons/icon.dart';
import '../../foundation/icons/soflume_icons.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/focus_ring.dart';
import '../../primitives/surface.dart';

/// An item descriptor for [SofSelect].
@immutable
class SofSelectItem<T> {
  const SofSelectItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// The unique value associated with this option.
  final T value;

  /// The human-readable label displayed in the select and menu.
  final String label;

  /// Optional leading icon or thumbnail.
  final Widget? icon;

  /// Whether this option can be selected.
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SofSelectItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label &&
          enabled == other.enabled;

  @override
  int get hashCode => Object.hash(value, label, enabled);
}

/// A Soft Lumen dropdown select component with squircle styling, spring animations,
/// keyboard navigation, and accessible dismissal.
class SofSelect<T> extends StatefulWidget {
  const SofSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder = 'Select an option',
    this.label,
    this.errorText,
    this.helperText,
    this.disabled = false,
    this.prefix,
    this.borderRadius,
  });

  /// The list of selectable options.
  final List<SofSelectItem<T>> items;

  /// The currently selected value.
  final T? value;

  /// Callback fired when a new value is selected.
  final ValueChanged<T>? onChanged;

  /// Text shown when no option is selected.
  final String placeholder;

  /// Optional field label above the selector.
  final String? label;

  /// Validation error text displayed below the field.
  final String? errorText;

  /// Descriptive helper text displayed below the field.
  final String? helperText;

  /// Whether the select field is disabled.
  final bool disabled;

  /// Optional leading widget inside the select box.
  final Widget? prefix;

  /// Custom corner radius for the select box and menu.
  final BorderRadius? borderRadius;

  @override
  State<SofSelect<T>> createState() => _SofSelectState<T>();
}

class _SofSelectState<T> extends State<SofSelect<T>> {
  final GlobalKey _triggerKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _menuOverlay;
  bool _isOpen = false;
  bool _isHovered = false;
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (_isOpen) {
      _menuOverlay?.remove();
      _menuOverlay = null;
      _isOpen = false;
    }
    super.dispose();
  }

  SofSelectItem<T>? get _selectedItem {
    if (widget.value == null) return null;
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  void _toggleMenu() {
    if (widget.disabled) return;
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_isOpen || widget.disabled) return;
    final overlay = Overlay.of(context);
    final renderBox = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final triggerRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    final theme = SoflumeTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;

    // Detect available space to dynamically flip upwards if near screen bottom
    final spaceBelow = screenSize.height - triggerRect.bottom - padding.bottom;
    final spaceAbove = triggerRect.top - padding.top;
    final flipUp = spaceBelow < 220 && spaceAbove > spaceBelow;

    final currentIdx = widget.items.indexWhere((it) => it.value == widget.value);
    _highlightedIndex = currentIdx >= 0 ? currentIdx : 0;

    _menuOverlay = OverlayEntry(
      builder: (ctx) {
        return _SofSelectMenu<T>(
          layerLink: _layerLink,
          triggerWidth: triggerRect.width,
          flipUp: flipUp,
          items: widget.items,
          selectedValue: widget.value,
          highlightedIndex: _highlightedIndex,
          borderRadius: widget.borderRadius,
          theme: theme,
          onSelect: (item) {
            _closeMenu();
            if (item.enabled) {
              widget.onChanged?.call(item.value);
            }
          },
          onClose: _closeMenu,
        );
      },
    );

    overlay.insert(_menuOverlay!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    if (!_isOpen) return;
    _menuOverlay?.remove();
    _menuOverlay = null;
    _isOpen = false;
    if (mounted) {
      setState(() {});
      _focusNode.requestFocus();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (widget.disabled) return KeyEventResult.ignored;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        _toggleMenu();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape && _isOpen) {
        _closeMenu();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final typography = theme.typography;
    final density = theme.density;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final effectiveRadius = widget.borderRadius ?? radii.brMd;
    final isFocused = _focusNode.hasFocus || _isOpen;

    Color borderColor;
    if (hasError) {
      borderColor = colors.danger;
    } else if (isFocused) {
      borderColor = colors.accent;
    } else if (_isHovered && !widget.disabled) {
      borderColor = colors.outlineFocus.withValues(alpha: 0.8);
    } else {
      borderColor = colors.outlineSubtle;
    }

    final verticalPad = 11.0 * density.verticalFactor;
    final horizontalPad = 14.0 * density.horizontalFactor;
    final selected = _selectedItem;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: typography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.contentSecondary,
                ),
              ),
              const SizedBox(height: 6),
            ],
            SofFocusRing(
              focused: isFocused && !hasError,
              borderRadius: effectiveRadius,
              ringWidth: 2.0,
              ringOffset: 1.5,
              child: GestureDetector(
                key: _triggerKey,
                behavior: HitTestBehavior.opaque,
                onTap: _toggleMenu,
                child: AnimatedContainer(
                  duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad),
                  decoration: ShapeDecoration(
                    color: widget.disabled
                        ? colors.surfaceMuted.withValues(alpha: 0.5)
                        : (colors.isDark ? colors.surfaceMuted : colors.surface),
                    shape: SofSquircleBorder(
                      borderRadius: effectiveRadius,
                      side: BorderSide(
                        color: borderColor,
                        width: isFocused || hasError ? 1.5 : 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefix != null) ...[
                        widget.prefix!,
                        const SizedBox(width: 8),
                      ],
                      if (selected?.icon != null) ...[
                        selected!.icon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selected?.label ?? widget.placeholder,
                          style: typography.body.copyWith(
                            color: selected != null
                                ? (widget.disabled ? colors.contentTertiary : colors.contentPrimary)
                                : colors.contentTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                        turns: _isOpen ? 0.5 : 0.0,
                        curve: theme.motion.springGentle,
                        child: SofIcon(
                          SofIcons.chevronDown,
                          size: 16,
                          color: colors.contentSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 4),
              Text(
                widget.errorText!,
                style: typography.caption.copyWith(
                  color: colors.danger,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else if (widget.helperText != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.helperText!,
                style: typography.caption.copyWith(
                  color: colors.contentTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}

class _SofSelectMenu<T> extends StatefulWidget {
  const _SofSelectMenu({
    required this.layerLink,
    required this.triggerWidth,
    required this.flipUp,
    required this.items,
    required this.selectedValue,
    required this.highlightedIndex,
    required this.borderRadius,
    required this.theme,
    required this.onSelect,
    required this.onClose,
  });

  final LayerLink layerLink;
  final double triggerWidth;
  final bool flipUp;
  final List<SofSelectItem<T>> items;
  final T? selectedValue;
  final int highlightedIndex;
  final BorderRadius? borderRadius;
  final SoflumeThemeData theme;
  final ValueChanged<SofSelectItem<T>> onSelect;
  final VoidCallback onClose;

  @override
  State<_SofSelectMenu<T>> createState() => _SofSelectMenuState<T>();
}

class _SofSelectMenuState<T> extends State<_SofSelectMenu<T>>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late int _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
    _hoveredIndex = widget.highlightedIndex;
    _animController = AnimationController(
      vsync: this,
      duration: widget.theme.motion.getEffectiveDuration(widget.theme.motion.durationQuick),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: widget.theme.motion.springGentle),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _animController.forward();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _dismiss() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.theme.colors;
    final radii = widget.theme.radii;
    final typography = widget.theme.typography;
    final effectiveRadius = widget.borderRadius ?? radii.brMd;
    final menuWidth = widget.triggerWidth < 180 ? 180.0 : widget.triggerWidth;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          _dismiss();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          // Tap outside barrier
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _dismiss,
              child: const ColoredBox(color: Color(0x00000000)),
            ),
          ),

          // Follower anchored to the trigger via LayerLink
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: CompositedTransformFollower(
                link: widget.layerLink,
                showWhenUnlinked: false,
                targetAnchor: widget.flipUp ? Alignment.topLeft : Alignment.bottomLeft,
                followerAnchor: widget.flipUp ? Alignment.bottomLeft : Alignment.topLeft,
                offset: Offset(0, widget.flipUp ? -6.0 : 6.0),
                child: SizedBox(
                  width: menuWidth,
                  child: SoflumeTheme(
                    data: widget.theme,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        alignment: widget.flipUp ? Alignment.bottomCenter : Alignment.topCenter,
                        child: SofSurface(
                          variant: SofSurfaceVariant.floating,
                          borderRadius: effectiveRadius,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 280),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < widget.items.length; i++) ...[
                                    _buildMenuItem(widget.items[i], i, colors, radii, typography),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    SofSelectItem<T> item,
    int index,
    SoflumeColors colors,
    SoflumeRadii radii,
    SoflumeTypography typography,
  ) {
    final isSelected = item.value == widget.selectedValue;
    final isHovered = index == _hoveredIndex;

    Color bgColor;
    if (isSelected) {
      bgColor = colors.accentSubtle;
    } else if (isHovered && item.enabled) {
      bgColor = colors.isDark ? colors.surfaceRaised : colors.surfaceMuted;
    } else {
      bgColor = const Color(0x00000000);
    }

    return MouseRegion(
      cursor: item.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) {
        if (item.enabled) setState(() => _hoveredIndex = index);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (item.enabled) {
            widget.onSelect(item);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: ShapeDecoration(
            color: bgColor,
            shape: SofSquircleBorder(
              borderRadius: radii.brSm,
            ),
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                item.icon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: typography.body.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: item.enabled
                        ? (isSelected ? colors.accent : colors.contentPrimary)
                        : colors.contentTertiary,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                SofIcon(
                  SofIcons.check,
                  size: 16,
                  color: colors.accent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
