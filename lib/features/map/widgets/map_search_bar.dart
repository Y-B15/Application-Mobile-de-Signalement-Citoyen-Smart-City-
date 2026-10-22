import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';

/// Barre de recherche flottante (Figma : « Search », 328 × 52, rayon 8).
/// Padding gauche 20 / droit 12, espace 12 : loupe, texte, avatar de 34 px.
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key, required this.initials, required this.onTap});

  /// Initiales de l'utilisateur affichées dans l'avatar (« YB »).
  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      radius: AppRadius.sm,
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Icon(Symbols.search_rounded, size: 20, color: c.caption),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Rechercher une adresse…',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(c.caption),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
              // Dans Figma le texte de l'avatar est en couleur « surface ».
              child: Text(initials, style: AppText.captionStrong(c.surface)),
            ),
          ],
        ),
      ),
    );
  }
}
