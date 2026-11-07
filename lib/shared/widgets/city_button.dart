import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';

/// Style d'un bouton CityAlert.
enum CityButtonStyle {
  /// Fond primaire, texte « onPrimary » (Figma : Button, type Principal / Photo).
  primary,

  /// Fond surface + ombre « Elevation 1 », texte principal (type Secondaire).
  secondary,
}

/// Bouton CityAlert (Figma : composant « Button »).
///
/// - normal : padding 16 × 16 (hauteur 52), pleine largeur
/// - [compact] : padding 12 × 8 (hauteur 36), largeur du contenu
/// - [isLoading] : remplace le texte par un indicateur et désactive le bouton
class CityButton extends StatelessWidget {
  const CityButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.compact = false,
    this.style = CityButtonStyle.primary,
    this.isLoading = false,
    this.radius = AppRadius.sm,
    this.heading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool compact;
  final CityButtonStyle style;
  final bool isLoading;

  /// Rayon des coins : 8 par défaut, 12 sur « Enregistrer » (Figma).
  final double radius;

  /// true : texte « Card title » (16 / 24) avec padding vertical 14, comme le
  /// bouton « Enregistrer » de « Modifier le profil ». Hauteur : 52 px.
  final bool heading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(radius);
    final primary = style == CityButtonStyle.primary;
    final background = primary ? c.primary : c.surface;
    final foreground = primary ? c.onPrimary : c.text;
    final enabled = onPressed != null && !isLoading;

    final content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Text(
            label,
            style: heading ? AppText.cardTitle(foreground) : AppText.bodyStrong(foreground),
          );

    final button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: primary ? null : AppShadows.elevation1,
      ),
      child: Material(
        color: background,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Padding(
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                : (heading
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
                    : const EdgeInsets.all(16)),
            child: Center(
              widthFactor: compact ? 1 : null,
              heightFactor: 1,
              child: content,
            ),
          ),
        ),
      ),
    );

    return compact
        ? IntrinsicWidth(child: button)
        : SizedBox(width: double.infinity, child: button);
  }
}
