import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Interrupteur de 44 × 26 (Figma : « toggle on » / « toggle off »).
/// Actif : fond primaire, bouton à droite. Inactif : fond « caption », bouton à
/// gauche. Le bouton (20 px) a la couleur « onPrimary ». Padding 3.
class CityToggle extends StatelessWidget {
  const CityToggle({super.key, required this.value, required this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool> onChanged;

  /// Texte lu par les lecteurs d'écran.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 44,
          height: 26,
          padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? c.primary : c.caption,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: c.onPrimary, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
