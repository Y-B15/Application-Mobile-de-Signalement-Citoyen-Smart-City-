import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';

/// Bouton d'action « étendu » : icône + libellé, primaire, rayon 8, hauteur 48
/// (Figma : Button, type « Action étendue »). Padding 16 × 12, espace 8.
class CityExtendedFab extends StatelessWidget {
  const CityExtendedFab({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(AppRadius.sm);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: shape, boxShadow: AppShadows.elevation1),
      child: Material(
        color: c.primary,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: c.onPrimary),
                const SizedBox(width: 8),
                Text(label, style: AppText.bodyStrong(c.onPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
