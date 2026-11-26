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
    this.label,
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
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.borderRadius,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
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
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
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
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(SofTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
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
    final isMultiline = (widget.maxLines ?? 1) > 1 || (widget.minLines ?? 1) > 1;

    Color borderColor;
    if (hasError) {
      borderColor = colors.danger;
    } else if (_isFocused && widget.enabled) {
      borderColor = colors.accent;
    } else if (_isHovered && widget.enabled) {
      borderColor = colors.outlineFocus.withValues(alpha: 0.8);
    } else {
      borderColor = colors.outlineSubtle;
    }

    final bgColor = !widget.enabled
        ? colors.surfaceMuted.withValues(alpha: 0.5)
        : (colors.isDark ? colors.surfaceMuted : colors.surface);

    final verticalPad = 11.0 * density.verticalFactor;
    final horizontalPad = 14.0 * density.horizontalFactor;

    final List<TextInputFormatter> formatters = [
      ...?widget.inputFormatters,
      if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      label: widget.label ?? widget.placeholder,
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
        onEnter: (_) {
          if (widget.enabled) setState(() => _isHovered = true);
        },
        onExit: (_) {
          if (_isHovered) setState(() => _isHovered = false);
        },
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
              focused: _isFocused && !hasError && widget.enabled,
              borderRadius: effectiveRadius,
              ringWidth: 2.0,
              ringOffset: 1.5,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.enabled) {
                    _focusNode.requestFocus();
                    widget.onTap?.call();
                  }
                },
                child: AnimatedContainer(
                  duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: verticalPad),
                  decoration: ShapeDecoration(
                    color: bgColor,
                    shape: SofSquircleBorder(
                      borderRadius: effectiveRadius,
                      side: BorderSide(
                        color: borderColor,
                        width: _isFocused || hasError ? 1.5 : 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    children: [
                      if (widget.prefix != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: widget.enabled
                                ? colors.contentSecondary
                                : colors.contentTertiary,
                            size: 18,
                          ),
                          child: widget.prefix!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Stack(
                          alignment:
                              isMultiline ? Alignment.topLeft : Alignment.centerLeft,
                          children: [
                            if (widget.placeholder != null)
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _controller,
                                builder: (context, value, _) {
                                  if (value.text.isNotEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return IgnorePointer(
                                    child: Text(
                                      widget.placeholder!,
                                      style: typography.body.copyWith(
                                        color: colors.contentTertiary,
                                      ),
                                      maxLines: widget.maxLines,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            EditableText(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: typography.body.copyWith(
                                color: widget.enabled
                                    ? colors.contentPrimary
                                    : colors.contentTertiary,
                              ),
                              cursorColor: colors.accent,
                              backgroundCursorColor: colors.outlineSubtle,
                              selectionColor: colors.accent.withValues(alpha: 0.25),
                              obscureText: widget.obscureText,
                              autofocus: widget.autofocus,
                              readOnly: widget.readOnly || !widget.enabled,
                              maxLines: widget.maxLines,
                              minLines: widget.minLines,
                              keyboardType: widget.keyboardType,
                              textInputAction: widget.textInputAction,
                              textCapitalization: widget.textCapitalization,
                              autocorrect: widget.autocorrect,
                              enableSuggestions: widget.enableSuggestions,
                              textAlign: widget.textAlign,
                              inputFormatters: formatters.isEmpty ? null : formatters,
                              onChanged: widget.onChanged,
                              onSubmitted: widget.onSubmitted,
                              onEditingComplete: widget.onEditingComplete,
                            ),
                          ],
                        ),
                      ),
                      if (widget.suffix != null) ...[
                        const SizedBox(width: 8),
                        IconTheme(
                          data: IconThemeData(
                            color: widget.enabled
                                ? colors.contentSecondary
                                : colors.contentTertiary,
                            size: 18,
                          ),
                          child: widget.suffix!,
                        ),
                      ],
                    ],
                  ),
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
      ),
    );
  }
}
