import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/city_button.dart';
import '../../shared/widgets/city_toast.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/surface_card.dart';
import '../home/home_shell.dart';

/// Écran « Signalement envoyé ✓ » (Figma : « Confirmation de signalement »).
///
/// Marges 16 / 24, espace de 24 entre les blocs : coche, titre, numéro de suivi,
/// prochaines étapes, deux boutons.
class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key, required this.trackingNumber});

  /// Numéro de suivi sans le « # » (par exemple « CA-2050 »).
  final String trackingNumber;

  /// Revient à la coque (Carte / Mon espace) sur l'onglet voulu.
  void _goHome(BuildContext context, int tab) {
    homeTabNotifier.value = tab;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _copyNumber(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '#$trackingNumber'));
    if (!context.mounted) return;
    CityToast.show(context, 'Numéro copié ✓', icon: Symbols.content_copy_rounded);
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Coche : halo de 144 px (vert à 10 %) et disque de 96 px.
                Center(
                  child: Container(
                    width: 144,
                    height: 144,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.tint(c.resolved),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: c.resolved, shape: BoxShape.circle),
                      child: Icon(Symbols.check_rounded, size: 56, color: c.onPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Signalement envoyé ✓',
                  textAlign: TextAlign.center,
                  style: AppText.display(c.text),
                ),
                const SizedBox(height: 8),
                Text(
                  'Merci ! Votre signalement a bien été transmis aux services de la ville.',
                  textAlign: TextAlign.center,
                  style: AppText.body(c.caption),
                ),
                const SizedBox(height: 24),
                // Numéro de suivi : on peut le copier en touchant la ligne.
                SurfaceCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () => _copyNumber(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Numéro de suivi', style: AppText.caption(c.caption)),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('#$trackingNumber', style: AppText.cardTitle(c.text)),
                                const SizedBox(width: 6),
                                Icon(Symbols.content_copy_rounded, size: 16, color: c.primary),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const StatusBadge(status: ReportStatus.reported),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const _NextSteps(),
                const SizedBox(height: 24),
                CityButton(
                  label: 'Voir sur la carte',
                  onPressed: () => _goHome(context, 0),
                ),
                const SizedBox(height: 12),
                CityButton(
                  label: 'Retour à l’accueil',
                  style: CityButtonStyle.secondary,
                  onPressed: () => _goHome(context, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Carte « Prochaines étapes » : trois étapes, la première est en cours.
class _NextSteps extends StatelessWidget {
  const _NextSteps();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Prochaines étapes', style: AppText.cardTitle(c.text)),
          const SizedBox(height: 12),
          const _NextStep(
            title: 'Pris en charge sous 48 h',
            subtitle: 'Un agent de la ville vérifie votre signalement',
            current: true,
          ),
          const _NextStep(
            title: 'Intervention',
            subtitle: 'Une équipe se rend sur place',
          ),
          const _NextStep(
            title: 'Résolu',
            subtitle: 'Vous êtes notifié dès que c’est réglé',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep({
    required this.title,
    required this.subtitle,
    this.current = false,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final bool current;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rail : point de 20 px (contour de 2 px) et trait de 28 px.
        SizedBox(
          width: 20,
          child: Column(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: current ? c.primary : c.line, width: 2),
                ),
                child: current
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                      )
                    : null,
              ),
              if (!isLast) ...[
                const SizedBox(height: 2),
                Container(
                  width: 2,
                  height: 28,
                  decoration: BoxDecoration(
                    color: c.line,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.bodyStrong(current ? c.text : c.caption)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppText.caption(c.caption)),
            ],
          ),
        ),
      ],
    );
  }
}
