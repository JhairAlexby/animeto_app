import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/presentation/widgets/publication_actions.dart';
import 'package:animeto_app/features/feed/domain/constants/reaction_constants.dart';
import 'package:animeto_app/features/feed/presentation/providers/feed_provider.dart';
import 'package:animeto_app/features/feed/presentation/widgets/authenticated_network_image.dart';

import 'package:animeto_app/features/feed/presentation/widgets/comment_card.dart';

class PublicationCard extends StatelessWidget {
  final Publication publication;

  const PublicationCard({super.key, required this.publication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text(
                publication.author.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              publication.author.name,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timeago.format(publication.createdAt, locale: 'es'),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              publication.description,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
            ),
          ),
          if (publication.hasImage && publication.imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AuthenticatedNetworkImage(
                url: 'https://animeto-api-production.up.railway.app/api${publication.imageUrl!}',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (publication.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: publication.tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),
            ),
          const Divider(height: 1),
          PublicationActions(
            reactionCount: publication.reactions.length,
            commentCount: publication.comments.length,
            onLike: () => _react(context, ReactionTypes.like),
            onDislike: () => _react(context, ReactionTypes.dislike),
            onComment: () => _showCommentDialog(context, publication.id),
          ),
          if (publication.comments.isNotEmpty)
            _buildCommentsSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context, ThemeData theme) {
    final commentsToShow = publication.comments.take(2).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...commentsToShow.map((comment) => CommentCard(comment: comment)),
          if (publication.comments.length > 2)
            TextButton(
              onPressed: () {},
              child: Text('Ver todos los ${publication.comments.length} comentarios'),
            ),
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context, String postId) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escribe un comentario'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tu comentario...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final content = controller.text.trim();
              if (content.isNotEmpty) {
                final provider = context.read<FeedProvider>();
                final ok = await provider.createComment(
                  content: content,
                  postId: postId,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  void _react(BuildContext context, String type) async {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final provider = context.read<FeedProvider>();
    final ok = await provider.reactToPublication(publication.id, type);
    if (!context.mounted) return;
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Reacción enviada'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}