import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';

/// Surface blanche (ou sombre) arrondie avec l'ombre « Elevation 1 ».
///
/// C'est la brique de base de presque tout l'écran : carte de profil, carte de
/// statistiques, lignes de compte, onglets, cartes de signalement.
///
/// Astuce : l'ombre est dessinée par un `DecoratedBox` placé AU-DESSUS, et la
/// couleur de fond par un `Material` placé dedans. Ainsi l'effet d'ondulation
/// d'`InkWell` reste visible (un fond opaque dessiné par-dessus le cacherait).
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = AppRadius.md,
    this.shadow = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// false pour les éléments « à plat » (onglets non sélectionnés).
  final bool shadow;

  /// Si fourni, la carte réagit au toucher.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    final content = Padding(padding: padding, child: child);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: shadow ? AppShadows.elevation1 : null,
      ),
      child: Material(
        color: context.colors.surface,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
