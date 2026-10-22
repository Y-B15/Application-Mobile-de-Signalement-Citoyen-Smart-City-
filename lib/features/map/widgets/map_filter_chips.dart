import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Puces de filtre : Tous / Signalé / En cours / Résolu (Figma : « Filters »).
/// Hauteur 32, padding 4, espace 4, rayon 8, icône de 24 px + libellé.
///
/// [selected] vaut null pour « Tous ».
///
/// Dessinées dans Figma : « Tous » sélectionné (fond #E6F7F5) et les trois
/// statuts non sélectionnés (fond teinté à 10 % + ombre). Les deux états
/// manquants sont déduits : un statut sélectionné prend le fond #E6F7F5 sans
/// ombre ; « Tous » non sélectionné prend le fond « surface » avec ombre.
class MapFilterChips extends StatelessWidget {
  const MapFilterChips({super.key, required this.selected, required this.onChanged});

  final ReportStatus? selected;
  final ValueChanged<ReportStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final chips = <Widget>[
      _Chip(
        label: 'Tous',
        icon: Symbols.filter_list_rounded,
        color: c.primary,
        background: selected == null ? c.selectedTint : c.surface,
        elevated: selected != null,
        onTap: () => onChanged(null),
      ),
      for (final entry in const [
        (ReportStatus.reported, 'Signalé', Symbols.warning_rounded),
        (ReportStatus.inProgress, 'En cours', Symbols.construction_rounded),
        (ReportStatus.resolved, 'Résolu', Symbols.check_circle_rounded),
      ])
        _Chip(
          label: entry.$2,
          icon: entry.$3,
          color: c.statusColor(entry.$1),
          background: selected == entry.$1
              ? c.selectedTint
              : c.tint(c.statusColor(entry.$1)),
          elevated: selected != entry.$1,
          onTap: () => onChanged(selected == entry.$1 ? null : entry.$1),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            chips[i],
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.elevated,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final bool elevated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.sm);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: elevated ? AppShadows.elevation1 : null,
      ),
      child: Material(
        color: background,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(width: 4),
                Text(label, style: AppText.captionStrong(color)),
                // Le dernier 4 px de padding à droite est fourni par Padding.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
