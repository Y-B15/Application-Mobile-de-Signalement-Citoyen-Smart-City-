import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Séparateur « ou » entre deux lignes (Figma : « divider »).
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: c.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ou',
            style: AppText.caption(c.caption),
          ),
        ),
        Expanded(child: Container(height: 1, color: c.line)),
      ],
    );
  }
}
