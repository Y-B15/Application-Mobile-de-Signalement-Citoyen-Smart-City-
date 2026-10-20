import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/status_badge.dart';

/// Illustration d'une diapositive : zone de 300 × 280 avec un halo rond de
/// 260 px (primaire à 10 %) et des éléments placés à la position exacte de
/// la maquette Figma.
///
/// [index] : 0 = téléphone, 1 = suivi, 2 = quartier.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.index});

  final int index;

  static const double width = 300;
  static const double height = 280;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Halo de fond.
            Positioned(
              left: 20,
              top: 10,
              width: 260,
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.tint(c.primary),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ...switch (index) {
              0 => _phone(c),
              1 => _tracking(c),
              _ => _neighbourhood(c),
            },
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- slide 1
  List<Widget> _phone(CityAlertColors c) {
    Widget bar(double w) => Container(
          width: w,
          height: 8,
          decoration: BoxDecoration(
            color: c.line,
            borderRadius: BorderRadius.circular(4),
          ),
        );

    return [
      // Téléphone : photo, deux traits de texte, bouton « Envoyer ».
      Positioned(
        left: 83,
        top: 34,
        width: 134,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 114,
                height: 104,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.line,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Symbols.photo_camera_rounded, size: 36, color: c.caption),
              ),
              const SizedBox(height: 8),
              bar(96),
              const SizedBox(height: 8),
              bar(64),
              const SizedBox(height: 8),
              Container(
                width: 114,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text('Envoyer', style: AppText.captionStrong(c.onPrimary)),
              ),
            ],
          ),
        ),
      ),
      // Pastille « 30 s ».
      Positioned(
        left: 198,
        top: 40,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.elevation1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.timer_rounded, size: 16, color: c.onPrimary),
              const SizedBox(width: 4),
              Text('30 s', style: AppText.captionStrong(c.onPrimary)),
            ],
          ),
        ),
      ),
      _floating(
        left: 30, top: 170, size: 52, background: c.surface,
        icon: Symbols.location_on_rounded, iconColor: c.primary, iconSize: 28,
        shadow: true,
      ),
    ];
  }

  // ---------------------------------------------------------------- slide 2
  List<Widget> _tracking(CityAlertColors c) {
    Widget row(String label, ReportStatus status) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppText.captionStrong(c.text)),
            StatusBadge(status: status),
          ],
        );

    return [
      Positioned(
        left: 50,
        top: 56,
        width: 200,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              row('Reçu', ReportStatus.reported),
              const SizedBox(height: 10),
              row('Pris en charge', ReportStatus.inProgress),
              const SizedBox(height: 10),
              row('Terminé', ReportStatus.resolved),
            ],
          ),
        ),
      ),
      _floating(
        left: 216, top: 22, size: 48, background: c.primary,
        icon: Symbols.notifications_rounded, iconColor: c.onPrimary, iconSize: 26,
        shadow: true,
      ),
      _floating(
        left: 34, top: 190, size: 40, background: c.tint(c.resolved),
        icon: Symbols.check_circle_rounded, iconColor: c.resolved, iconSize: 24,
      ),
    ];
  }

  // ---------------------------------------------------------------- slide 3
  List<Widget> _neighbourhood(CityAlertColors c) {
    const groundY = 214.0;
    // [x, hauteur] de chaque immeuble ; les immeubles pairs sont en contour.
    const buildings = <List<double>>[
      [34, 90],
      [78, 138],
      [122, 76],
      [166, 116],
      [210, 96],
    ];

    Widget window(double left, double top) => Positioned(
          left: left,
          top: top,
          width: 8,
          height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );

    final children = <Widget>[
      Positioned(
        left: 30,
        top: groundY,
        width: 240,
        height: 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.line,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ];

    for (var k = 0; k < buildings.length; k++) {
      final x = buildings[k][0];
      final h = buildings[k][1];
      final outlined = k.isEven;
      children.add(
        Positioned(
          left: x + 10,
          top: groundY - h,
          width: 36,
          height: h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: outlined ? c.tint(c.primary) : c.primary,
              borderRadius: BorderRadius.circular(4),
              border: outlined ? Border.all(color: c.primary) : null,
            ),
          ),
        ),
      );
      children.add(window(x + 24, groundY - h + 16));
      children.add(window(x + 24, groundY - h + 36));
    }

    children.add(_floating(
      left: 222, top: 30, size: 52, background: c.surface,
      icon: Symbols.favorite_rounded, iconColor: c.primary, iconSize: 28,
      shadow: true,
    ));
    children.add(_floating(
      left: 26, top: 60, size: 44, background: c.tint(c.resolved),
      icon: Symbols.groups_rounded, iconColor: c.resolved, iconSize: 26,
    ));
    return children;
  }

  /// Pastille ronde flottante avec une icône au centre.
  Widget _floating({
    required double left,
    required double top,
    required double size,
    required Color background,
    required IconData icon,
    required Color iconColor,
    required double iconSize,
    bool shadow = false,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: shadow ? AppShadows.elevation1 : null,
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
