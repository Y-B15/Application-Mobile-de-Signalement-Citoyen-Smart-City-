import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Bloc « Thème » (Figma : padding 16 / 12 / 16 / 16, espace 10) : titre puis
/// sélecteur à trois choix (Clair, Sombre, Auto) de 40 px de haut.
///
/// Choix actif : fond primaire à 10 %, contour primaire de 1 px, texte en gras.
class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key, required this.mode, required this.onChanged});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Symbols.palette_rounded, size: 22, color: c.caption),
              const SizedBox(width: 12),
              Text('Thème', style: AppText.body(c.text)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                _Segment(
                  label: 'Clair',
                  icon: Symbols.light_mode_rounded,
                  selected: mode == ThemeMode.light,
                  onTap: () => onChanged(ThemeMode.light),
                ),
                const SizedBox(width: 3),
                _Segment(
                  label: 'Sombre',
                  icon: Symbols.dark_mode_rounded,
                  selected: mode == ThemeMode.dark,
                  onTap: () => onChanged(ThemeMode.dark),
                ),
                const SizedBox(width: 3),
                _Segment(
                  label: 'Auto',
                  icon: Symbols.brightness_auto_rounded,
                  selected: mode == ThemeMode.system,
                  onTap: () => onChanged(ThemeMode.system),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(8);

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Material(
          color: selected ? c.tint(c.primary) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: shape,
            side: selected ? BorderSide(color: c.primary) : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: selected ? c.primary : c.caption),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: selected ? AppText.bodyStrong(c.primary) : AppText.body(c.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
