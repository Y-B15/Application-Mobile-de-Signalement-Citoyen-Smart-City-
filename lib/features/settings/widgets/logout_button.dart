import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Bouton « Se déconnecter » : 52 px, rayon 12, fond rouge à 10 %, contour rouge
/// de 1 px, icône de 20 px et texte « Card title » rouges. Espace 8.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SizedBox(
      height: 52,
      child: Material(
        color: c.tint(c.urgent),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: c.urgent),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.logout_rounded, size: 20, color: c.urgent),
              const SizedBox(width: 8),
              Text('Se déconnecter', style: AppText.cardTitle(c.urgent)),
            ],
          ),
        ),
      ),
    );
  }
}
