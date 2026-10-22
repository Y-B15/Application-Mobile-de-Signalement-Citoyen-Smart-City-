import 'package:flutter/material.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/report_icons.dart';

/// Section « Catégorie » : trois lignes de 56 px (Figma : « Category Rows »).
/// La ligne choisie a un fond « accent » et un contour primaire de 1 px.
class CategorySection extends StatelessWidget {
  const CategorySection({super.key, required this.selected, required this.onChanged});

  final ReportCategory selected;
  final ValueChanged<ReportCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Catégorie', style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 8),
        for (var i = 0; i < ReportCategory.values.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _CategoryRow(
            category: ReportCategory.values[i],
            selected: ReportCategory.values[i] == selected,
            onTap: () => onChanged(ReportCategory.values[i]),
          ),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ReportCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = BorderRadius.circular(AppRadius.md);

    return Semantics(
      button: true,
      selected: selected,
      label: category.label,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: shape, boxShadow: AppShadows.elevation1),
        child: Material(
          color: selected ? c.accentTint : c.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: shape,
            side: selected ? BorderSide(color: c.primary) : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected ? c.accentTint : c.background,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(category.icon, size: 24, color: c.caption),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(category.label, style: AppText.bodyStrong(c.text)),
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
