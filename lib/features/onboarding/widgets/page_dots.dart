import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Indicateur de page : le point actif s'allonge (24 × 8, primaire),
/// les autres font 8 × 8 (couleur « line »). Espace de 6 px.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Semantics(
      label: 'Page ${current + 1} sur $count',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: i == current ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == current ? c.primary : c.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
