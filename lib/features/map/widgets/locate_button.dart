import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';

/// Bouton « Ma position » : carré de 48 px (rayon 8, fond « surface », ombre
/// « Elevation 1 », icône primaire), posé 12 px au-dessus du bouton « Signaler ».
///
/// Ajout hors maquette : même style que le bouton « Partager » de l'écran
/// Commentaires. Pendant la recherche GPS, l'icône devient un petit indicateur.
class LocateButton extends StatelessWidget {
  const LocateButton({super.key, required this.onPressed, this.isLoading = false});

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(AppRadius.sm);

    return Semantics(
      button: true,
      label: 'Me localiser sur la carte',
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: shape, boxShadow: AppShadows.elevation1),
        child: Material(
          color: c.surface,
          borderRadius: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
                      )
                    : Icon(Symbols.my_location_rounded, size: 24, color: c.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
