import 'package:flutter/material.dart';

class PublicationActions extends StatelessWidget {
  final int reactionCount;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onComment;

  const PublicationActions({
    super.key,
    required this.reactionCount,
    required this.commentCount,
    required this.onLike,
    required this.onDislike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up_alt_outlined, color: iconColor),
                onPressed: onLike,
              ),
              Text(reactionCount.toString()),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.thumb_down_alt_outlined, color: iconColor),
                onPressed: onDislike,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.comment_outlined, color: iconColor),
                onPressed: onComment,
              ),
              Text(commentCount.toString()),
            ],
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: iconColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
