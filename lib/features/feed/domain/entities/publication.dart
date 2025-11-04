import 'package:animeto_app/features/feed/domain/entities/author.dart';
import 'package:animeto_app/features/feed/domain/entities/comment.dart';
import 'package:animeto_app/features/feed/domain/entities/reaction.dart';

class Publication {
  final String id;
  final String description;
  final DateTime createdAt;
  final bool hasImage;
  final String? imageUrl;
  final Author author;
  final List<Reaction> reactions;
  final List<Comment> comments;

  Publication({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.hasImage,
    this.imageUrl,
    required this.author,
    required this.reactions,
    required this.comments,
  });
}