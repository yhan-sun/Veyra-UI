import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/focus_ring.dart';

/// Soft Lumen text input field with squircle geometry and smooth state transitions.
class SofTextField extends StatefulWidget {
  const SofTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final BorderRadius? borderRadius;

  @override
  State<SofTextField> createState() => _SofTextFieldState();
}

class _SofTextFieldState extends State<SofTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(SofTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.removeListener(_handleTextChange);
        _controller.dispose();
      } else {
        oldWidget.controller!.removeListener(_handleTextChange);
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleTextChange);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      } else {
        oldWidget.focusNode!.removeListener(_handleFocusChange);
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
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

    Color borderColor;
    if (hasError) {
      borderColor = colors.danger;
    } else if (_isFocused) {
      borderColor = colors.accent;
    } else if (_isHovered) {
      borderColor = colors.outlineFocus.withValues(alpha: 0.8);
    } else {
      borderColor = colors.outlineSubtle;
    }

    final verticalPad = 11.0 * density.verticalFactor;
    final horizontalPad = 14.0 * density.horizontalFactor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SofFocusRing(
            focused: _isFocused && !hasError,
            borderRadius: effectiveRadius,
            ringWidth: 2.0,
            ringOffset: 1.5,
            child: AnimatedContainer(
              duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
              padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad),
              decoration: ShapeDecoration(
                color: colors.isDark ? colors.surfaceMuted : colors.surface,
                shape: SofSquircleBorder(
                  borderRadius: effectiveRadius,
                  side: BorderSide(
                    color: borderColor,
                    width: _isFocused || hasError ? 1.5 : 1.0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.prefix != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: colors.contentSecondary,
                        size: 18,
                      ),
                      child: widget.prefix!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        if (_controller.text.isEmpty && widget.placeholder != null)
                          IgnorePointer(
                            child: Text(
                              widget.placeholder!,
                              style: typography.body.copyWith(
                                color: colors.contentTertiary,
                              ),
                              maxLines: widget.maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        EditableText(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: typography.body.copyWith(
                            color: widget.enabled ? colors.contentPrimary : colors.contentSecondary,
                          ),
                          cursorColor: colors.accent,
                          backgroundCursorColor: colors.outlineSubtle,
                          obscureText: widget.obscureText,
                          autofocus: widget.autofocus,
                          readOnly: widget.readOnly || !widget.enabled,
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          keyboardType: widget.keyboardType,
                          textInputAction: widget.textInputAction,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                        ),
                      ],
                    ),
                  ),
                  if (widget.suffix != null) ...[
                    const SizedBox(width: 8),
                    IconTheme(
                      data: IconThemeData(
                        color: colors.contentSecondary,
                        size: 18,
                      ),
                      child: widget.suffix!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasError || widget.helperText != null) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                hasError ? widget.errorText! : widget.helperText!,
                style: typography.caption.copyWith(
                  color: hasError ? colors.danger : colors.contentSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
