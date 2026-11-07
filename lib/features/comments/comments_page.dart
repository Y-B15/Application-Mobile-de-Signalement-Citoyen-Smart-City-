import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/comment.dart';
import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/city_app_bar.dart';
import '../../shared/widgets/city_toast.dart';
import '../../shared/widgets/report_card.dart';
import '../../shared/widgets/state_cards.dart';
import 'widgets/comment_input_bar.dart';
import 'widgets/comment_tile.dart';
import 'widgets/support_section.dart';

/// Écran « Commentaires » (Figma : « Commentaires », clair et sombre).
///
/// Marges 16 / 8, espace de 16 entre les blocs : carte du signalement, bouton
/// « Soutenir », soutiens, en-tête « Commentaires (n) », fil de discussion.
/// La barre de saisie reste collée en bas, au-dessus du clavier.
class CommentsPage extends StatefulWidget {
  const CommentsPage({
    super.key,
    required this.report,
    ReportsRepository? repository,
  }) : repository = repository ?? const MockReportsRepository();

  final Report report;
  final ReportsRepository repository;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  // Utilisateur de démonstration (viendra de Firebase Auth plus tard).
  static const String _myInitials = 'YB';

  final TextEditingController _input = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scroll = ScrollController();

  List<Comment> _comments = const [];
  int _supportCount = 0;
  bool _supported = false;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {})); // active / estompe le bouton d'envoi
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final thread = await widget.repository.fetchComments(widget.report);
      if (!mounted) return;
      setState(() {
        _comments = thread.comments;
        _supportCount = thread.supportCount;
        _supported = thread.supportedByMe;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  /// Soutenir / retirer son soutien (le compteur change tout de suite).
  void _toggleSupport() {
    setState(() {
      _supported = !_supported;
      _supportCount += _supported ? 1 : -1;
    });
    widget.repository.setSupport(widget.report, supported: _supported);
  }

  void _toggleLike(Comment comment) {
    final liked = !comment.likedByMe;
    setState(() {
      _comments = [
        for (final c in _comments)
          if (c.id == comment.id)
            c.copyWith(likes: c.likes + (liked ? 1 : -1), likedByMe: liked)
          else
            c,
      ];
    });
    widget.repository.setCommentLike(comment.id, liked: liked);
  }

  /// « Répondre » : place le curseur dans le champ avec « @Prénom ».
  void _reply(Comment comment) {
    final mention = '@${comment.authorName.split(' ').first} ';
    _input.value = TextEditingValue(
      text: mention,
      selection: TextSelection.collapsed(offset: mention.length),
    );
    _focus.requestFocus();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      final comment = await widget.repository.addComment(widget.report, text);
      if (!mounted) return;
      setState(() {
        _comments = [comment, ..._comments];
        _isSending = false;
      });
      _input.clear();
      FocusScope.of(context).unfocus();
      if (_scroll.hasClients) {
        _scroll.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
      CityToast.show(context, 'Commentaire envoyé ✓', icon: Symbols.send_rounded);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSending = false);
      CityToast.show(context, 'Envoi impossible, réessayez');
    }
  }

  Future<void> _share() async {
    // Lien fictif : sera le vrai lien du signalement plus tard.
    await Clipboard.setData(
      ClipboardData(text: 'https://cityalert.ma/signalement/${widget.report.trackingNumber}'),
    );
    if (!mounted) return;
    CityToast.show(context, 'Lien copié ✓', icon: Symbols.share_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(statusBarColor: Colors.transparent, systemNavigationBarColor: c.surface);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CityAppBar(
                title: 'Signalement #${widget.report.trackingNumber}',
                iconColor: c.text,
                trailingIcon: Symbols.more_vert_rounded,
                trailingLabel: 'Options',
                onTrailingTap: () => CityToast.show(
                  context,
                  'Options bientôt disponibles',
                  icon: Symbols.more_vert_rounded,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView(
                    controller: _scroll,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    children: [
                      // Touche la carte : retour au détail du signalement.
                      ReportCard(
                        report: widget.report,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 16),
                      SupportSection(
                        count: _supportCount,
                        supported: _supported,
                        onSupport: _toggleSupport,
                        onShare: _share,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Commentaires (${_comments.length})',
                              style: AppText.cardTitle(c.text)),
                          InkWell(
                            onTap: () => CityToast.show(
                              context,
                              'Options bientôt disponibles',
                              icon: Symbols.more_vert_rounded,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Plus récents', style: AppText.captionStrong(c.primary)),
                                const SizedBox(width: 2),
                                Icon(Symbols.expand_more_rounded, size: 16, color: c.primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._buildThread(),
                    ],
                  ),
                ),
              ),
              CommentInputBar(
                controller: _input,
                focusNode: _focus,
                initials: _myInitials,
                canSend: _input.text.trim().isNotEmpty && !_isSending,
                onSend: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fil de discussion selon l'état : chargement, erreur ou commentaires.
  List<Widget> _buildThread() {
    if (_isLoading) return const [SkeletonCard()];
    if (_hasError) return [ErrorStateCard(onRetry: _load)];

    return [
      for (var i = 0; i < _comments.length; i++) ...[
        if (i > 0) const SizedBox(height: 16),
        CommentTile(
          key: ValueKey(_comments[i].id),
          comment: _comments[i],
          onLike: () => _toggleLike(_comments[i]),
          onReply: () => _reply(_comments[i]),
        ),
      ],
    ];
  }
}
