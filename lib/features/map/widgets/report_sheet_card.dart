import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/date_format.dart';
import '../../../shared/widgets/report_icons.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/surface_card.dart';

/// Fiche du signalement touché sur la carte (Figma : ReportCard, layout « Fiche »,
/// 328 × 120, rayon 16, padding 16 × 12, espace 8) : poignée, photo de 56 px,
/// titre, adresse · date, badge de statut et chevron.
class ReportSheetCard extends StatelessWidget {
  const ReportSheetCard({super.key, required this.report, this.onTap});

  final Report report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée : 36 × 4.
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: c.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Photo(report: report),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.cardTitle(c.text),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${report.address} · ${formatReportDate(report.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(c.caption),
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(status: report.status),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Symbols.chevron_right_rounded, size: 24, color: c.caption),
            ],
          ),
        ],
      ),
    );
  }
}

/// Photo de 56 × 56 (rayon 8). Sans photo, on affiche l'icône de la catégorie.
class _Photo extends StatelessWidget {
  const _Photo({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final placeholder = Container(
      color: c.divider,
      alignment: Alignment.center,
      child: Icon(report.category.icon, size: 28, color: c.caption),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 56,
        height: 56,
        child: report.photoUrl == null
            ? placeholder
            : Image.network(
                report.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}
