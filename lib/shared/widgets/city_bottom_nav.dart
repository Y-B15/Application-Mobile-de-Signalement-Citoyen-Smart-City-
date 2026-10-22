import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';

/// Barre de navigation du bas (Figma : « Bottom Nav », 72 px).
///
/// Padding gauche/droite 56, haut 12, bas 16 ; les deux onglets sont répartis
/// aux extrémités. Onglet actif : pastille ronde de 24 px (#E6F7F5), icône et
/// libellé en couleur primaire. Onglet inactif : icône et libellé « caption ».
class CityBottomNav extends StatelessWidget {
  const CityBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// 0 = Carte, 1 = Mon espace.
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_Destination> _items = [
    _Destination(Symbols.map_rounded, 'Carte'),
    _Destination(Symbols.person_rounded, 'Mon espace'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        boxShadow: AppShadows.elevation1,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(56, 12, 56, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < _items.length; i++)
                _NavItem(
                  destination: _items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.caption;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? c.selectedTint : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(destination.icon, size: 24, color: color),
            ),
            const SizedBox(height: 4),
            Text(destination.label, style: AppText.captionStrong(color)),
          ],
        ),
      ),
    );
  }
}
