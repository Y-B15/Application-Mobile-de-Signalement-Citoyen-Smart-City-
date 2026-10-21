import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';
import '../report_filter.dart';

/// Onglets « Tous / En cours / Résolus » : trois petites cartes de même
/// largeur (espace 4). L'onglet actif a l'ombre, le texte primaire et un
/// soulignement de 24 × 2. Figma : « Tabs ».
class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key, required this.selected, required this.onChanged});

  final ReportFilter selected;
  final ValueChanged<ReportFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < ReportFilter.values.length; i++) {
      final filter = ReportFilter.values[i];
      if (i > 0) children.add(const SizedBox(width: 4));
      children.add(
        Expanded(
          child: _Tab(
            label: filter.label,
            selected: filter == selected,
            onTap: () => onChanged(filter),
          ),
        ),
      );
    }
    return Row(children: children);
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: SurfaceCard(
        radius: AppRadius.sm,
        shadow: selected,
        padding: const EdgeInsets.all(8),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppText.bodyStrong(selected ? c.primary : c.caption)),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 24,
              height: 2,
              decoration: BoxDecoration(
                color: selected ? c.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
