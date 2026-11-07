import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/models/report_detail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/date_format.dart';

/// Section « Historique » : quatre étapes reliées par un trait vertical
/// (Figma : « Timeline Section », titre puis 4 lignes de 56 px).
///
/// - étape faite : point de 16 px à la couleur du statut, avec une coche
/// - étape en cours : point de 24 px de la couleur « surface »
/// - étape à venir : point de 16 px « surface », texte « caption », « En attente »
///
/// Figma dessine « Signalé » (étape 1 seule faite) et « En cours » (étapes 1 et 2
/// faites, étape 3 en cours). L'état « Résolu » (tout fait) est déduit.
class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({super.key, required this.detail});

  final ReportDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final steps = _buildSteps(c);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique', style: AppText.cardTitle(c.text)),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++)
          _StepRow(step: steps[i], isLast: i == steps.length - 1),
      ],
    );
  }

  List<_Step> _buildSteps(CityAlertColors c) {
    final report = detail.report;
    final status = report.status;

    final String interventionLabel;
    if (detail.interventionAt == null) {
      interventionLabel = 'En attente';
    } else if (status == ReportStatus.inProgress) {
      // Étape en cours : date et précision (« 17 oct. · équipe sur place »).
      interventionLabel =
          '${formatDayMonth(detail.interventionAt!)} · ${detail.interventionNote ?? ''}';
    } else {
      interventionLabel = formatDayMonthTime(detail.interventionAt!);
    }

    String dateOrWaiting(DateTime? d) =>
        d == null ? 'En attente' : formatDayMonthTime(d);

    return [
      _Step(
        title: 'Signalement reçu',
        right: formatDayMonthTime(report.createdAt),
        state: _StepState.done,
        color: c.reported,
      ),
      _Step(
        title: 'Pris en charge par ${report.category.serviceWithArticle}',
        right: dateOrWaiting(detail.takenAt),
        state: status == ReportStatus.reported ? _StepState.pending : _StepState.done,
        color: c.inProgress,
      ),
      _Step(
        title: 'Intervention en cours',
        right: interventionLabel,
        state: switch (status) {
          ReportStatus.reported => _StepState.pending,
          ReportStatus.inProgress => _StepState.current,
          ReportStatus.resolved => _StepState.done,
        },
        color: c.inProgress,
      ),
      _Step(
        title: 'Problème résolu',
        right: dateOrWaiting(detail.resolvedAt),
        state: status == ReportStatus.resolved ? _StepState.done : _StepState.pending,
        color: c.resolved,
      ),
    ];
  }
}

enum _StepState { done, current, pending }

class _Step {
  const _Step({
    required this.title,
    required this.right,
    required this.state,
    required this.color,
  });

  final String title;
  final String right;
  final _StepState state;
  final Color color;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  final _Step step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pending = step.state == _StepState.pending;
    final dotSize = step.state == _StepState.current ? 24.0 : 16.0;

    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rail : point en haut, puis un trait de 2 px qui descend jusqu'au
          // point suivant (il dépasse de 2 px, comme dans Figma).
          SizedBox(
            width: 24,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                if (!isLast)
                  Positioned(
                    top: dotSize + 4,
                    child: Container(
                      width: 2,
                      height: 58 - (dotSize + 4),
                      color: c.divider,
                    ),
                  ),
                _Dot(size: dotSize, state: step.state, color: step.color),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    step.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyStrong(pending ? c.caption : c.text),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 112,
                  child: Text(
                    step.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppText.caption(c.caption),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.state, required this.color});

  final double size;
  final _StepState state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = state == _StepState.done;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? color : c.surface,
        shape: BoxShape.circle,
      ),
      // Coche blanche de 12 px sur les étapes faites.
      child: done
          ? const Icon(Symbols.check_rounded, size: 12, color: Colors.white)
          : null,
    );
  }
}
