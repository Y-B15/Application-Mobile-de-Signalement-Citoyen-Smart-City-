import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/date_format.dart';
import '../../../shared/widgets/city_button.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/surface_card.dart';

/// Fiche flottante d'un signalement sélectionné sur la carte
/// (Maquette Figma : Carte avec signalement sélectionné L 37:355 / S 62:171).
class MapSelectedCard extends StatelessWidget {
  const MapSelectedCard({
    super.key,
    required this.report,
    required this.onClose,
    required this.onDetailTap,
  });

  final Report report;
  final VoidCallback onClose;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête : Catégorie + Numéro de suivi et bouton de fermeture X
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${report.category.label} · ${report.trackingNumber}',
                style: AppText.caption(c.caption),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Symbols.close_rounded, size: 20, color: c.caption),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Titre du signalement
          Text(
            report.title,
            style: AppText.cardTitle(c.text),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Adresse et Date
          Text(
            '${report.address} · ${formatReportDate(report.createdAt)}',
            style: AppText.caption(c.caption),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Statut + Bouton d'action
          Row(
            children: [
              StatusBadge(status: report.status),
              const Spacer(),
              CityButton(
                label: 'Voir le suivi',
                compact: true,
                onPressed: onDetailTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
