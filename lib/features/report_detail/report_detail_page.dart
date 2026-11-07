import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/report.dart';
import '../../core/models/report_detail.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/city_app_bar.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/state_cards.dart';
import '../../shared/widgets/surface_card.dart';
import '../comments/comments_page.dart';
import 'widgets/report_info_card.dart';
import 'widgets/tracking_timeline.dart';

/// Écran « Détail du signalement » (Figma : « 4 · Suivi du signalement » et
/// « 4a · départ Signalé »). Marges 16 / 8, espace de 12 entre la carte du
/// signalement et l'historique.
class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({
    super.key,
    required this.report,
    ReportsRepository? repository,
  }) : repository = repository ?? const MockReportsRepository();

  final Report report;
  final ReportsRepository repository;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  ReportDetail? _detail;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _hasError = false);
    try {
      final detail = await widget.repository.fetchReportDetail(widget.report);
      if (!mounted) return;
      setState(() => _detail = detail);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.background,
    );

    final detail = _detail;
    final Widget body;
    if (detail != null) {
      body = SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReportInfoCard(detail: detail),
            const SizedBox(height: 12),
            TrackingTimeline(detail: detail),
            const SizedBox(height: 12),
            _CommentsLink(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CommentsPage(
                    report: detail.report,
                    repository: widget.repository,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_hasError) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ErrorStateCard(onRetry: _load),
        ),
      );
    } else {
      body = const Center(child: CircularProgressIndicator());
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CityAppBar(title: 'Détail du signalement'),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne qui ouvre l'écran « Commentaires ».
/// Ajout hors maquette : Figma ne montre pas comment on arrive sur les commentaires.
class _CommentsLink extends StatelessWidget {
  const _CommentsLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Symbols.chat_bubble_rounded, size: 24, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Commentaires et soutiens', style: AppText.bodyStrong(c.text)),
                const SizedBox(height: 4),
                Text('Voir la discussion autour de ce signalement',
                    style: AppText.caption(c.caption)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Symbols.chevron_right_rounded, size: 24, color: c.caption),
        ],
      ),
    );
  }
}
