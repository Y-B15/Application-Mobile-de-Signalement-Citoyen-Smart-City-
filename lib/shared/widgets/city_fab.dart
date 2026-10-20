import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';

/// Bouton d'action flottant rond de 56 px (Figma : « Button / Action »).
class CityFab extends StatelessWidget {
  const CityFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Semantics(
      button: true,
      label: 'Nouveau signalement',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: AppShadows.elevation1,
        ),
        child: Material(
          color: c.primary,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(Symbols.add_rounded, size: 24, color: c.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
