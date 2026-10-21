import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';
import 'city_button.dart';
import 'surface_card.dart';

/// État « chargement » : deux lignes squelette dans une carte
/// (Figma : ReportCard, State=Chargement).
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chargement',
      child: const SurfaceCard(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _SkeletonRow(widths: [140, 92, 36]),
            SizedBox(height: 12),
            _SkeletonRow(widths: [132, 104, 40]),
          ],
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.widths});

  /// Largeurs des trois barres de texte (hauteurs 12, 10 et 8).
  final List<double> widths;

  static const Color _grey = Color(0xFFE2E8F0); // identique en clair et en sombre (Figma)

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: _grey,
            borderRadius: BorderRadius.circular(6),
          ),
        );

    return Container(
      height: 70,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(widths[0], 12),
                const SizedBox(height: 8),
                bar(widths[1], 10),
                const SizedBox(height: 8),
                bar(widths[2], 8),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: _grey, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

/// État « vide » : petite illustration de ville + message + bouton
/// (Figma : ReportCard, State=Vide).
class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const _CityIllustration(),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.body(c.caption),
          ),
          const SizedBox(height: 12),
          CityButton(label: actionLabel, onPressed: onAction, compact: true),
        ],
      ),
    );
  }
}

/// Illustration 296 × 104 : cinq immeubles, une ligne de sol et un repère.
class _CityIllustration extends StatelessWidget {
  const _CityIllustration();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final building = context.isDark ? const Color(0xFF294440) : const Color(0xFFD8EBE7);

    // [x, largeur, hauteur] dans une zone de 256 px de large.
    const buildings = <List<double>>[
      [0, 32, 44],
      [52, 40, 64],
      [112, 32, 48],
      [172, 40, 72],
      [232, 32, 52],
    ];
    const groundY = 84.0;

    return Container(
      height: 104,
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(
        child: SizedBox(
          width: 256,
          height: 104,
          child: Stack(
            children: [
              for (final b in buildings)
                Positioned(
                  left: b[0],
                  top: groundY - b[2],
                  width: b[1],
                  height: b[2],
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: building,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                top: groundY,
                width: 256,
                height: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Positioned(
                left: 116,
                top: 12,
                width: 24,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Icon(Symbols.location_on_rounded, size: 24, color: c.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carte d'erreur réseau avec bouton « Réessayer » (état ajouté, même style).
class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Symbols.wifi_off_rounded, size: 32, color: c.caption),
          const SizedBox(height: 8),
          Text('Impossible de charger vos signalements',
              textAlign: TextAlign.center, style: AppText.bodyStrong(c.text)),
          const SizedBox(height: 4),
          Text('Vérifiez votre connexion puis réessayez.',
              textAlign: TextAlign.center, style: AppText.body(c.caption)),
          const SizedBox(height: 12),
          CityButton(label: 'Réessayer', onPressed: onRetry, compact: true),
        ],
      ),
    );
  }
}
