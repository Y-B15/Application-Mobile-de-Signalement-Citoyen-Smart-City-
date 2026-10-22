import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';

/// Barre de titre des écrans secondaires (Figma : « App Bar », 56 px) :
/// bouton retour de 48 × 48 (rayon 8, icône « caption ») puis le titre.
/// Padding 4, espace 4.
class CityAppBar extends StatelessWidget {
  const CityAppBar({super.key, required this.title, this.onBack});

  final String title;

  /// Par défaut : revenir à l'écran précédent.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Tooltip(
            message: 'Retour',
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Symbols.arrow_back_rounded, size: 24, color: c.caption),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.title(c.text),
            ),
          ),
        ],
      ),
    );
  }
}
