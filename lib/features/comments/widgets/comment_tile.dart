import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/comment.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/date_format.dart';

/// Un commentaire (Figma : « comment » / « comment reply ») : avatar de 36 px,
/// nom, pastille de fonction, date, texte, puis « j'aime » et « Répondre ».
/// Une réponse est décalée de 48 px.
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.onLike,
    required this.onReply,
  });

  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;

  Color _toneColor(CityAlertColors c) => switch (comment.tone) {
        CommentTone.primary => c.primary,
        CommentTone.inProgress => c.inProgress,
        CommentTone.reported => c.reported,
        CommentTone.resolved => c.resolved,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tone = _toneColor(c);

    return Padding(
      padding: EdgeInsets.only(left: comment.isReply ? 48 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: c.tint(tone), shape: BoxShape.circle),
            child: comment.isOfficial
                ? Icon(Symbols.verified_rounded, size: 20, color: tone)
                : Text(comment.initials, style: AppText.captionStrong(tone)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wrap : si la place manque, la date passe à la ligne au lieu de déborder.
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(comment.authorName, style: AppText.bodyStrong(c.text)),
                    if (comment.role != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.tint(c.primary),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(comment.role!, style: AppText.captionStrong(c.primary)),
                      ),
                    Text(formatCommentDate(comment.createdAt), style: AppText.caption(c.caption)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text, style: AppText.body(c.text)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.favorite_rounded,
                            size: 16,
                            color: comment.likedByMe ? c.urgent : c.caption,
                          ),
                          const SizedBox(width: 4),
                          Text('${comment.likes}', style: AppText.captionStrong(c.caption)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: onReply,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Text('Répondre', style: AppText.captionStrong(c.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
