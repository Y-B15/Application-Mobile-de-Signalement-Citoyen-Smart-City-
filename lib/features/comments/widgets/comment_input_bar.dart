import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Barre de saisie du bas (Figma : « Comment Input ») : avatar de 36 px, champ
/// arrondi (rayon 16, contour 1 px) et bouton d'envoi rond de 40 px.
/// Padding 16 / 12 / 16 / 24, espace 12, ombre « Elevation 1 ».
class CommentInputBar extends StatelessWidget {
  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.initials,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String initials;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    // 24 px en bas au repos ; plus serré quand le clavier est ouvert.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final systemBottom = MediaQuery.paddingOf(context).bottom;
    final bottom = keyboardOpen ? 12.0 : (systemBottom + 8 > 24 ? systemBottom + 8 : 24.0);

    return DecoratedBox(
      decoration: BoxDecoration(color: c.surface, boxShadow: AppShadows.elevation1),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottom),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
              child: Text(initials, style: AppText.captionStrong(c.surface)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: c.line),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: c.primary,
                  style: AppText.body(c.text),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Ajouter un commentaire…',
                    hintStyle: AppText.body(c.caption),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Semantics(
              button: true,
              label: 'Envoyer le commentaire',
              child: Opacity(
                // Un peu estompé tant qu'il n'y a rien à envoyer.
                opacity: canSend ? 1 : 0.5,
                child: Material(
                  color: c.primary,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: canSend ? onSend : null,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Symbols.send_rounded, size: 20, color: c.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
