import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';

/// Ligne de la section « Compte » : icône dans une pastille de 24 px, titre,
/// sous-titre et chevron. Figma : « settings-row » / « logout-row »
/// (padding 12 × 8, espace 12, hauteur 48).
class AccountRow extends StatelessWidget {
  const AccountRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
            child: Icon(icon, size: 24, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong(c.text)),
                const SizedBox(height: 4),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
