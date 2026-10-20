import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';

/// Bouton principal CityAlert (Figma : composant « Button », type Principal).
///
/// - normal : padding 16 × 16 (hauteur 52), pleine largeur
/// - [compact] : padding 12 × 8 (hauteur 36), largeur du contenu
class CityButton extends StatelessWidget {
  const CityButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(AppRadius.sm);

    final button = Material(
      color: c.primary,
      borderRadius: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : const EdgeInsets.all(16),
          child: Center(
            widthFactor: compact ? 1 : null,
            heightFactor: 1,
            child: Text(label, style: AppText.bodyStrong(c.onPrimary)),
          ),
        ),
      ),
    );

    return compact ? IntrinsicWidth(child: button) : SizedBox(width: double.infinity, child: button);
  }
}
