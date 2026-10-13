import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// A widget builder that adapts automatically to the available width and screen class.
class SofAdaptiveBuilder extends StatelessWidget {
  const SofAdaptiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, SofScreenClass screenClass) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenClass = SofBreakpoints.ofWidth(constraints.maxWidth);
        return builder(context, screenClass);
      },
    );
  }
}
