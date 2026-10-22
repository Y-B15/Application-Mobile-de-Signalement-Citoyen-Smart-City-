import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/city_fab.dart';
import '../../shared/widgets/report_card.dart';
import '../../shared/widgets/state_cards.dart';
import '../new_report/new_report_page.dart';
import 'report_filter.dart';
import 'widgets/account_row.dart';
import 'widgets/filter_tabs.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_card.dart';

/// Écran « Mon espace » (Figma : « 5 · Mon espace », clair et sombre).
/// La barre de navigation du bas est fournie par `HomeShell`.
///
/// Ordre des blocs, espacés de 12 px : profil, statistiques, compte, onglets,
/// liste « Mes signalements ». Marges de l'écran : 16 (gauche/droite/bas) et 8 (haut).
class MyAreaPage extends StatefulWidget {
  /// [repository] choisit la source des données (démo aujourd'hui, Firestore demain).
  const MyAreaPage({super.key, ReportsRepository? repository})
      : repository = repository ?? const MockReportsRepository();

  final ReportsRepository repository;

  @override
  State<MyAreaPage> createState() => _MyAreaPageState();
}

class _MyAreaPageState extends State<MyAreaPage> {
  // Utilisateur de démonstration (viendra de Firebase Auth plus tard).
  static const String _userName = 'Yassine B.';
  static const String _userSubtitle = 'Citoyen · Casablanca';

  List<Report> _reports = const [];
  bool _isLoading = true;
  bool _hasError = false;
  ReportFilter _filter = ReportFilter.all;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  /// Charge les signalements. [showLoader] est false pour le « tirer pour
  /// rafraîchir », qui affiche déjà son propre indicateur.
  Future<void> _loadReports({bool showLoader = true}) async {
    if (showLoader && !_isLoading) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final reports = await widget.repository.fetchMyReports();
      if (!mounted) return; // la page a été fermée pendant l'attente
      setState(() {
        _reports = reports;
        _hasError = false;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  int _count(ReportStatus status) =>
      _reports.where((r) => r.status == status).length;

  void _showSoon(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label : bientôt disponible')));
  }

  /// Ouvre le formulaire de signalement ; à son retour, confirme l'envoi.
  Future<void> _openNewReport() async {
    final tracking = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const NewReportPage()),
    );
    if (tracking != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Signalement #$tracking envoyé (démonstration)'),
        ));
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous quitterez la session actuelle.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _showSoon('Déconnexion');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    // Icônes de la barre d'état adaptées au thème.
    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.surface,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: c.primary,
                backgroundColor: c.surface,
                onRefresh: () => _loadReports(showLoader: false),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Bas : 16 + place du bouton flottant (19 + 56) pour que la
                  // dernière carte puisse défiler au-dessus de lui.
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 91),
                  children: [
                    const ProfileHeader(name: _userName, subtitle: _userSubtitle),
                    const SizedBox(height: 12),
                    StatsCard(
                      total: _reports.length,
                      reported: _count(ReportStatus.reported),
                      inProgress: _count(ReportStatus.inProgress),
                      resolved: _count(ReportStatus.resolved),
                    ),
                    const SizedBox(height: 12),
                    _Section(
                      title: 'Compte',
                      children: [
                        AccountRow(
                          icon: Symbols.settings_rounded,
                          title: 'Paramètres',
                          subtitle: 'Notifications, profil et préférences',
                          onTap: () => _showSoon('Paramètres'),
                        ),
                        AccountRow(
                          icon: Symbols.logout_rounded,
                          title: 'Déconnexion',
                          subtitle: 'Quitter la session actuelle',
                          onTap: _confirmLogout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilterTabs(
                      selected: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                    const SizedBox(height: 12),
                    _Section(title: 'Mes signalements', children: _buildReports()),
                  ],
                ),
              ),
            ),
            // Bouton flottant : 16 du bord droit, 19 au-dessus de la barre du bas.
            Positioned(
              right: 16,
              bottom: 19,
              child: CityFab(onPressed: _openNewReport),
            ),
          ],
        ),
      ),
    );
  }

  /// Contenu de la section « Mes signalements » selon l'état.
  List<Widget> _buildReports() {
    if (_isLoading) return const [SkeletonCard()];
    if (_hasError) return [ErrorStateCard(onRetry: _loadReports)];

    final visible = _reports.where(_filter.matches).toList();
    if (visible.isEmpty) {
      return [
        EmptyStateCard(
          message: 'Aucun signalement à afficher pour le moment.',
          actionLabel: 'Signaler un problème',
          onAction: _openNewReport,
        ),
      ];
    }

    return [
      for (final report in visible)
        ReportCard(
          key: ValueKey(report.id),
          report: report,
          onTap: () => _showSoon('Signalement #${report.trackingNumber}'),
        ),
    ];
  }
}

/// Titre de section (style « Title ») suivi de ses éléments, espacés de 8 px.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppText.title(c.text)),
        for (final child in children) ...[
          const SizedBox(height: 8),
          child,
        ],
      ],
    );
  }
}
