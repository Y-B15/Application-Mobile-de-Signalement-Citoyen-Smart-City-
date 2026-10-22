import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/date_format.dart';
import 'report_icons.dart';
import 'status_badge.dart';
import 'surface_card.dart';

/// Carte de signalement, variante « Liste » (composant Figma « ReportCard »).
///
/// Mesures Figma : padding 12, espace 12, vignette 40 × 40 (rayon 10),
/// titre « Card title », ligne « Caption », badge, chevron de 24.
class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, this.onTap});

  final Report report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          // Vignette : pastel fixe (identique en clair et en sombre, comme dans Figma).
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _thumbTint(report),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(report.category.icon, size: 24, color: c.caption),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  '${report.address} · ${formatReportDate(report.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption(c.caption),
                ),
                const SizedBox(height: 4),
                StatusBadge(status: report.status),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Symbols.chevron_right_rounded, size: 24, color: c.caption),
        ],
      ),
    );
  }

  /// Pastel de la vignette, relevé dans Figma :
  /// signalé #FEF2F2, en cours #FFF7ED, résolu #ECFDF5.
  /// Exception relevée dans la maquette : « lampadaire résolu » est #EFF6FF.
  static Color _thumbTint(Report r) {
    if (r.category == ReportCategory.streetLight && r.status == ReportStatus.resolved) {
      return const Color(0xFFEFF6FF);
    }
    return switch (r.status) {
      ReportStatus.reported => const Color(0xFFFEF2F2),
      ReportStatus.inProgress => const Color(0xFFFFF7ED),
      ReportStatus.resolved => const Color(0xFFECFDF5),
    };
  }
}
