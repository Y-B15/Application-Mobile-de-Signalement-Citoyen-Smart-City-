/// Couleur d'accent de l'avatar d'un commentaire (fond teinté à 10 % + initiales).
enum CommentTone { primary, inProgress, reported, resolved }

/// Un commentaire sous un signalement.
class Comment {
  const Comment({
    required this.id,
    required this.authorName,
    required this.initials,
    required this.tone,
    required this.createdAt,
    required this.text,
    this.likes = 0,
    this.likedByMe = false,
    this.isReply = false,
    this.isOfficial = false,
    this.role,
  });

  final String id;
  final String authorName;
  final String initials;
  final CommentTone tone;
  final DateTime createdAt;
  final String text;
  final int likes;
  final bool likedByMe;

  /// Réponse à un commentaire : affichée décalée de 48 px.
  final bool isReply;

  /// Réponse d'un agent de la ville (icône « vérifié » à la place des initiales).
  final bool isOfficial;

  /// Fonction affichée dans une pastille (« Agent municipal »).
  final String? role;

  Comment copyWith({int? likes, bool? likedByMe}) => Comment(
        id: id,
        authorName: authorName,
        initials: initials,
        tone: tone,
        createdAt: createdAt,
        text: text,
        likes: likes ?? this.likes,
        likedByMe: likedByMe ?? this.likedByMe,
        isReply: isReply,
        isOfficial: isOfficial,
        role: role,
      );
}

/// Tout ce qu'affiche l'écran « Commentaires » : soutiens et fil de discussion.
class CommentThread {
  const CommentThread({
    required this.comments,
    required this.supportCount,
    required this.supportedByMe,
  });

  final List<Comment> comments;

  /// Nombre de citoyens qui soutiennent le signalement.
  final int supportCount;
  final bool supportedByMe;
}
