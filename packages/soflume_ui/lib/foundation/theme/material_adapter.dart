import 'package:flutter/material.dart';
import 'theme_data.dart';

/// Extension enabling seamless integration with Flutter's standard [ThemeData].
class SoflumeThemeExtension extends ThemeExtension<SoflumeThemeExtension> {
  const SoflumeThemeExtension(this.data);

  final SoflumeThemeData data;

  /// Looks up [SoflumeThemeData] attached to the nearest Material [Theme], if any.
  static SoflumeThemeData? maybeOf(BuildContext context) {
    return Theme.of(context).extension<SoflumeThemeExtension>()?.data;
  }

  @override
  ThemeExtension<SoflumeThemeExtension> copyWith({SoflumeThemeData? data}) {
    return SoflumeThemeExtension(data ?? this.data);
  }

  @override
  ThemeExtension<SoflumeThemeExtension> lerp(
    covariant ThemeExtension<SoflumeThemeExtension>? other,
    double t,
  ) {
    if (other is! SoflumeThemeExtension) return this;
    return SoflumeThemeExtension(SoflumeThemeData.lerp(data, other.data, t));
  }
}
