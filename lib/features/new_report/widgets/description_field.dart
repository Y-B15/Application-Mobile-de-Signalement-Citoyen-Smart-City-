import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Section « Description » : libellé puis zone de texte de 96 px
/// (Figma : « Textarea », rayon 8, padding 16 × 12) avec compteur « 0 / 300 ».
class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key, required this.controller});

  final TextEditingController controller;

  static const int maxLength = 300;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Description', style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 8),
        Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                  cursorColor: c.primary,
                  style: AppText.body(c.text),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Décrivez le problème (taille, danger, repère proche)…',
                    hintStyle: AppText.body(c.caption),
                  ),
                ),
              ),
              // Le compteur se met à jour à chaque lettre grâce au controller.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) => SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${value.text.length} / $maxLength',
                    textAlign: TextAlign.right,
                    style: AppText.caption(c.caption),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
