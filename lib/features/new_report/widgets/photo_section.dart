import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_button.dart';
import '../../../shared/widgets/surface_card.dart';

/// Carte « Ajouter une photo du problème » (Figma : « Photo Section », 160 px).
///
/// Contenu centré, espace 4 : pastille de 40 px, titre, phrase, deux boutons.
///
/// Deux états, tous deux dessinés dans Figma :
/// - sans photo : pastille appareil photo, « Prendre une photo » / « Galerie »
/// - avec photo (« 3b ») : pastille grise avec icône image, « Photo ajoutée »,
///   résumé « 1 photo · Nid-de-poule, Rue Hassan II », « Reprendre » / « Galerie »
class PhotoSection extends StatelessWidget {
  const PhotoSection({
    super.key,
    required this.hasPhoto,
    required this.summary,
    required this.onCamera,
    required this.onGallery,
  });

  final bool hasPhoto;

  /// Résumé affiché sous « Photo ajoutée ».
  final String summary;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  /// Gris de la pastille « photo ajoutée » : #424A54 en clair et en sombre.
  static const Color _photoAddedCircle = Color(0xFF424A54);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 144,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasPhoto ? _photoAddedCircle : c.accentTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasPhoto ? Symbols.image_rounded : Symbols.photo_camera_rounded,
                size: 24,
                color: hasPhoto ? Colors.white : c.caption,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasPhoto ? 'Photo ajoutée' : 'Ajouter une photo du problème',
              style: AppText.bodyStrong(c.text),
            ),
            const SizedBox(height: 4),
            Text(
              hasPhoto ? summary : 'Une photo aide les équipes à intervenir plus vite',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
