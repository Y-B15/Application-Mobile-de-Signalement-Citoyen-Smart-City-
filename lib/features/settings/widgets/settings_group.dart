import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/surface_card.dart';

/// Section de « Paramètres » : petit titre (« Compte »), puis une carte à contour
/// fin (rayon 16) dont les lignes sont séparées par un trait de 1 px.
/// Espace de 8 px entre le titre et la carte (Figma : « Section … »).
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 8),
        SurfaceCard(
          outlined: true,
          radius: AppRadius.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Container(height: 1, color: c.line),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Ligne de 52 px : icône de 22 px, libellé, puis (au choix) une valeur,
/// un interrupteur et/ou un chevron. Padding horizontal 16, espace 12.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.showChevron = false,
    this.onTap,
  });

  final IconData icon;
  final String label;

  /// Valeur à droite (« Français », « 1.0.0 »), en couleur « caption ».
  final String? value;

  /// Widget à droite (l'interrupteur).
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final row = SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c.caption),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppText.body(c.text))),
            if (value != null) ...[
              const SizedBox(width: 12),
              Text(value!, style: AppText.body(c.caption)),
            ],
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            if (showChevron) ...[
              const SizedBox(width: 12),
              Icon(Symbols.chevron_right_rounded, size: 22, color: c.caption),
            ],
          ],
        ),
      ),
    );

    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }
}
