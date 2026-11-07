import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Champ de saisie du profil : libellé « Caption strong », puis une zone de
/// 48 px (fond surface, contour de 1 px, rayon 8, padding 12, espace 10) avec une
/// icône de 20 px et le texte.
///
/// Le contour devient primaire quand le champ est actif (état non dessiné dans Figma).
class ProfileField extends StatefulWidget {
  const ProfileField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label, style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: _focused ? c.primary : c.line),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: c.caption),
              const SizedBox(width: 10),
              Expanded(
                child: Focus(
                  onFocusChange: (focused) => setState(() => _focused = focused),
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    textCapitalization: widget.textCapitalization,
                    cursorColor: c.primary,
                    style: AppText.body(c.text),
                    decoration: const InputDecoration.collapsed(hintText: ''),
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
