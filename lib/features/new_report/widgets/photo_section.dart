import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_button.dart';
import '../../../shared/widgets/surface_card.dart';

/// Carte « Ajouter une photo du problème » (Figma : « Photo Section », 160 px).
///
/// Contenu centré, espace 4 : pastille appareil photo de 40 px, titre,
/// phrase d'aide, puis deux boutons (« Prendre une photo » / « Galerie »).
///
/// Quand une photo est choisie (état non dessiné dans Figma), la pastille est
/// remplacée par la miniature de la photo et les textes changent.
class PhotoSection extends StatelessWidget {
  const PhotoSection({
    super.key,
    required this.photoPath,
    required this.onCamera,
    required this.onGallery,
  });

  final String? photoPath;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasPhoto = photoPath != null;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 144,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasPhoto)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(photoPath!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  // Si le fichier a disparu, on retombe sur la pastille.
                  errorBuilder: (_, __, ___) => _CameraCircle(color: c.accentTint),
                ),
              )
            else
              _CameraCircle(color: c.accentTint),
            const SizedBox(height: 4),
            Text(
              hasPhoto ? 'Photo ajoutée' : 'Ajouter une photo du problème',
              style: AppText.bodyStrong(c.text),
            ),
            const SizedBox(height: 4),
            Text(
              hasPhoto
                  ? 'Vous pouvez la remplacer avant l’envoi'
                  : 'Une photo aide les équipes à intervenir plus vite',
              style: AppText.caption(c.caption),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CityButton(
                  label: hasPhoto ? 'Reprendre' : 'Prendre une photo',
                  compact: true,
                  onPressed: onCamera,
                ),
                const SizedBox(width: 8),
                CityButton(
                  label: 'Galerie',
                  compact: true,
                  style: CityButtonStyle.secondary,
                  onPressed: onGallery,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraCircle extends StatelessWidget {
  const _CameraCircle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(
        Symbols.photo_camera_rounded,
        size: 24,
        color: context.colors.caption,
      ),
    );
  }
}
