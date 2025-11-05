import 'package:flutter/material.dart';
import 'package:animeto_app/core/theme/app_colors.dart';

class PublicationActions extends StatelessWidget {
  final int reactionCount;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const PublicationActions({
    super.key,
    required this.reactionCount,
    required this.commentCount,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$reactionCount Reacciones',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$commentCount Comentarios',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              context,
              icon: Icons.thumb_up_alt_outlined,
              label: 'Like',
              color: AppColors.persimmon,
              onPressed: onLike,
            ),
            _buildActionButton(
              context,
              icon: Icons.thumb_down_alt_outlined,
              label: 'Dislike',
              color: AppColors.cerulean,
              onPressed: onDislike,
            ),
            _buildActionButton(
              context,
              icon: Icons.comment_outlined,
              label: 'Comentar',
              color: AppColors.cerulean,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          label,
          style:
              Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}