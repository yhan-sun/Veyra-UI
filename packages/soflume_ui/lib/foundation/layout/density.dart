import 'package:flutter/widgets.dart';

/// Component density scale for Soflume UI.
enum SoflumeDensity {
  /// Compact density: tighter vertical padding and borders, ideal for desktop windows, data tables, and high-density productivity.
  compact(
    verticalFactor: 0.8,
    horizontalFactor: 0.85,
    minTouchTarget: 40.0,
  ),

  /// Comfortable density: balanced default, ideal for mobile apps, everyday browsing, and touch screens.
  comfortable(
    verticalFactor: 1.0,
    horizontalFactor: 1.0,
    minTouchTarget: 48.0,
  ),

  /// Spacious density: generous breathing space, large touch targets, ideal for accessibility and relaxed browsing.
  spacious(
    verticalFactor: 1.25,
    horizontalFactor: 1.2,
    minTouchTarget: 56.0,
  );

  const SoflumeDensity({
    required this.verticalFactor,
    required this.horizontalFactor,
    required this.minTouchTarget,
  });

  final double verticalFactor;
  final double horizontalFactor;
  final double minTouchTarget;

  EdgeInsets adjustPadding(EdgeInsets insets) {
    return EdgeInsets.fromLTRB(
      insets.left * horizontalFactor,
      insets.top * verticalFactor,
      insets.right * horizontalFactor,
      insets.bottom * verticalFactor,
    );
  }
}
