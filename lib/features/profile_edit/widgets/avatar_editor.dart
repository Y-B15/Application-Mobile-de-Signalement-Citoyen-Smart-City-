import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Avatar de 96 px (fond primaire à 10 %, contour primaire de 1 px, initiales
/// en « Display ») avec la pastille d'édition de 36 px en bas à droite
/// (fond primaire, contour de 3 px de la couleur du fond). Zone totale : 104 px.
class AvatarEditor extends StatelessWidget {
  const AvatarEditor({super.key, required this.initials, required this.onEdit});

  final String initials;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SizedBox(
      width: 104,
      height: 104,
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.tint(c.primary),
              shape: BoxShape.circle,
              border: Border.all(color: c.primary),
            ),
            child: Text(initials, style: AppText.display(c.primary)),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Semantics(
              button: true,
              label: 'Changer la photo de profil',
              child: Material(
                color: c.primary,
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(side: BorderSide(color: c.background, width: 3)),
                child: InkWell(
                  onTap: onEdit,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Symbols.edit_rounded, size: 18, color: c.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
