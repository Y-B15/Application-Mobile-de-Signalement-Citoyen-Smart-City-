import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report_detail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/date_format.dart';
import '../../../shared/widgets/report_icons.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/surface_card.dart';

/// Grande carte du signalement (Figma : « Report Card », padding 12, espace 8) :
/// service concerné, photo, titre + numéro + statut, adresse, date, coordonnées
/// et description.
class ReportInfoCard extends StatelessWidget {
  const ReportInfoCard({super.key, required this.detail});

  final ReportDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final report = detail.report;

    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service municipal concerné (« Voirie »).
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c.tint(c.primary),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(report.category.icon, size: 24, color: c.caption),
                  ),
                  const SizedBox(width: 8),
                  Text(report.category.service, style: AppText.captionStrong(c.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _Photo(photoUrl: report.photoUrl),
          const SizedBox(height: 8),
          // Titre, puis numéro de suivi et statut.
          Text(report.title, style: AppText.title(c.text)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('#${report.trackingNumber}', style: AppText.captionStrong(c.caption)),
              const SizedBox(width: 12),
              StatusBadge(status: report.status),
            ],
          ),
          const SizedBox(height: 8),
          // Adresse et date.
          _MetaRow(icon: Symbols.location_on_rounded, text: detail.fullAddress),
          const SizedBox(height: 8),
          _MetaRow(
            icon: Symbols.schedule_rounded,
            text: 'Signalé le ${formatFullDateTime(report.createdAt)}',
          ),
          if (report.latitude != null && report.longitude != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Symbols.location_on_rounded, size: 16, color: c.caption),
                const SizedBox(width: 8),
                Text(
                  '${report.latitude!.toStringAsFixed(4)}, ${report.longitude!.toStringAsFixed(4)}',
                  style: AppText.captionStrong(c.caption),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(detail.description, style: AppText.body(c.text)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        Icon(icon, size: 24, color: c.caption),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppText.body(c.text))),
      ],
    );
  }
}

/// Photo de 140 px de haut (rayon 12). Sans photo : fond neutre et icône image.
class _Photo extends StatelessWidget {
  const _Photo({required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final placeholder = Container(
      color: c.divider,
      alignment: Alignment.center,
      child: Icon(Symbols.image_rounded, size: 32, color: c.caption),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: photoUrl == null
            ? placeholder
            : Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}
