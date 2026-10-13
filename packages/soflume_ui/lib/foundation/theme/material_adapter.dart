import 'package:flutter/material.dart';
import 'theme_data.dart';

/// Extension enabling seamless integration with Flutter's standard [ThemeData].
class SoflumeThemeExtension extends ThemeExtension<SoflumeThemeExtension> {
  const SoflumeThemeExtension(this.data);

  final SoflumeThemeData data;

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
