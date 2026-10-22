import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';

/// Section « Localisation » (Figma : « Location Section ») : libellé, puis une
/// carte de 56 px avec pastille de 40 px, adresse, coordonnées et « Modifier ».
///
/// États : position trouvée (dessiné dans Figma), recherche en cours et erreur
/// (non dessinés, déduits avec les mêmes styles).
class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
    required this.place,
    required this.isLoading,
    required this.errorMessage,
    required this.onEdit,
    required this.onRetry,
  });

  final PlaceInfo? place;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onEdit;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final String title;
    final String subtitle;
    final String actionLabel;
    final VoidCallback? action;

    if (isLoading) {
      title = 'Localisation en cours…';
      subtitle = 'Recherche du signal GPS';
      actionLabel = '';
      action = null;
    } else if (place == null) {
      title = 'Position indisponible';
      subtitle = errorMessage ?? 'Impossible de trouver votre position.';
      actionLabel = 'Réessayer';
      action = onRetry;
    } else {
      title = place!.address;
      subtitle = '${place!.coordinates} · GPS actif';
      actionLabel = 'Modifier';
      action = onEdit;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Localisation', style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 8),
        SurfaceCard(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Symbols.location_on_rounded, size: 24, color: c.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong(c.text)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption(c.caption)),
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: action,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(actionLabel, style: AppText.captionStrong(c.primary)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
