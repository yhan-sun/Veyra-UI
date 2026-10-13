import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';

/// Clean empty state placeholder with icon/illustration, title, message, and action.
class SofEmptyState extends StatelessWidget {
  const SofEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  final Widget title;
  final Widget? message;
  final Widget? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(
                    color: colors.contentSecondary,
                    size: 32,
                  ),
                  child: icon!,
                ),
              ),
              const SizedBox(height: 20),
            ],
            DefaultTextStyle.merge(
              style: typography.title.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.contentPrimary,
              ),
              child: title,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                style: typography.body.copyWith(
                  color: colors.contentSecondary,
                ),
                child: message!,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
