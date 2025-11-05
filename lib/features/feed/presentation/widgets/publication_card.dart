import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/presentation/widgets/publication_actions.dart';
import 'package:animeto_app/features/feed/domain/constants/reaction_constants.dart';
import 'package:animeto_app/features/feed/presentation/providers/feed_provider.dart';
import 'package:animeto_app/features/feed/presentation/widgets/authenticated_network_image.dart';

class PublicationCard extends StatelessWidget {
  final Publication publication;

  const PublicationCard({super.key, required this.publication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text(
                publication.author.name.substring(0, 1),
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
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              publication.description,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
            ),
          ),
          if (publication.hasImage && publication.imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AuthenticatedNetworkImage(
                  url: 'https://animeto-api-production.up.railway.app/api${publication.imageUrl!}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (publication.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: publication.tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 16),
          PublicationActions(
            reactionCount: publication.reactions.length,
            commentCount: publication.comments.length,
            onLike: () async {
              final messenger = ScaffoldMessenger.of(context);
              final theme = Theme.of(context);
              final provider = context.read<FeedProvider>();
              final ok = await provider.reactToPublication(
                publication.id,
                ReactionTypes.like,
              );
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
                  ),
                );
              }
            },
            onDislike: () async {
              final messenger = ScaffoldMessenger.of(context);
              final theme = Theme.of(context);
              final provider = context.read<FeedProvider>();
              final ok = await provider.reactToPublication(
                publication.id,
                ReactionTypes.dislike,
              );
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
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
