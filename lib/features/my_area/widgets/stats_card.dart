import 'package:flutter/material.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';

/// Carte de statistiques : total au centre, trait fin, puis la répartition par
/// statut en trois colonnes égales. Figma : « Stats Card » (padding 12, espace 12).
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.total,
    required this.reported,
    required this.inProgress,
    required this.resolved,
  });

  final int total;
  final int reported;
  final int inProgress;
  final int resolved;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$total', textAlign: TextAlign.center, style: AppText.display(c.text)),
          Text('Signalements au total',
              textAlign: TextAlign.center, style: AppText.caption(c.caption)),
          const SizedBox(height: 12),
          Container(height: 1, color: c.divider),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Stat(value: reported, status: ReportStatus.reported)),
              const SizedBox(width: 12),
              Expanded(child: _Stat(value: inProgress, status: ReportStatus.inProgress)),
              const SizedBox(width: 12),
              Expanded(child: _Stat(value: resolved, status: ReportStatus.resolved)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.status});

  final int value;
  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.statusColor(status);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$value', style: AppText.title(color)),
        Text(status.label, style: AppText.caption(color)),
      ],
    );
  }
}
