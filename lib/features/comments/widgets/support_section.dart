import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_extended_fab.dart';

/// Bouton « Soutenir (+24) », bouton partager et ligne des soutiens
/// (Figma : « Support Row » 48 px puis « Supporters » 24 px, espace 12).
class SupportSection extends StatelessWidget {
  const SupportSection({
    super.key,
    required this.count,
    required this.supported,
    required this.onSupport,
    required this.onShare,
  });

  final int count;
  final bool supported;
  final VoidCallback onSupport;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CityExtendedFab(
                expand: true,
                icon: Symbols.thumb_up_rounded,
                // « Soutenu » après le toucher : état non dessiné dans Figma.
                label: supported ? 'Soutenu (+$count)' : 'Soutenir (+$count)',
                onPressed: onSupport,
              ),
            ),
            const SizedBox(width: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: AppShadows.elevation1,
              ),
              child: Material(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                clipBehavior: Clip.antiAlias,
                child: Semantics(
                  button: true,
                  label: 'Partager',
                  child: InkWell(
                    onTap: onShare,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Symbols.share_rounded, size: 22, color: c.text),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Trois mini-avatars de 24 px qui se chevauchent de 8 px.
            SizedBox(
              width: 56,
              height: 24,
              child: Stack(
                children: [
                  for (var i = 0; i < 3; i++)
                    Positioned(
                      left: i * 16.0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: c.tint([c.primary, c.inProgress, c.reported][i]),
                          shape: BoxShape.circle,
                          border: Border.all(color: c.background, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$count citoyens soutiennent ce signalement',
                style: AppText.caption(c.caption),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
