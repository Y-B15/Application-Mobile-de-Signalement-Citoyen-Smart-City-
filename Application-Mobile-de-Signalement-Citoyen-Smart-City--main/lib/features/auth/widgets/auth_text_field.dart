import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Champ de saisie d'authentification (Figma : « input-email » / « input-password »).
///
/// Structure : label (12/600 captionStrong, couleur caption) au-dessus d'un
/// champ 280×40 (radius 8, bg surface, ombre Elevation 1, padding 8 y / 16 x).
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focus;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_refresh);
  }

  void _refresh() => setState(() => _focused = _focus.hasFocus);

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    // Ombre portée active uniquement sur focus (Figma montre un trait
    // primaire à 10 % en état focus).
    final border = _focused
        ? BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: c.tint(c.primary), width: 1),
            boxShadow: AppShadows.elevation1,
          )
        : BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: AppShadows.elevation1,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppText.captionStrong(c.caption)),
        const SizedBox(height: 8),
        Container(
          width: 280,
          height: 40,
          decoration: border,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: widget.obscureText,
                  obscuringCharacter: '•',
                  style: AppText.body(c.text),
                  cursorColor: c.primary,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: AppText.body(c.caption),
                  ),
                ),
              ),
              Icon(widget.icon, size: 24, color: c.caption),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
