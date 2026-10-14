import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme.dart';

/// Soflume 现代化矢量 SVG 图标组件
///
/// 具备自动颜色继承（支持 [IconTheme] 与 [SoflumeTheme] 语义色）、
/// 动态尺寸缩放以及无障碍标签支持。
class SofIcon extends StatelessWidget {
  /// 原始 SVG 矢量标记字符串（通常传入 [SofIcons] 预置常量）
  final String svg;

  /// 图标尺寸（宽与高相等），默认自适应当前上下文（一般为 20.0）
  final double? size;

  /// 图标着色。未指定时自动沿用当前 [IconTheme] 或 [SoflumeColors.contentPrimary]
  final Color? color;

  /// 无障碍读屏标签
  final String? semanticsLabel;

  const SofIcon(
    this.svg, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final soflumeTheme = SoflumeTheme.of(context);

    final effectiveSize = size ?? iconTheme.size ?? 20.0;
    final effectiveColor = color ??
        iconTheme.color ??
        soflumeTheme.colors.contentPrimary;

    return Semantics(
      label: semanticsLabel,
      image: true,
      child: SvgPicture.string(
        svg,
        width: effectiveSize,
        height: effectiveSize,
        colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      ),
    );
  }
}
