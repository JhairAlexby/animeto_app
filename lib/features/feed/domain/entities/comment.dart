import 'package:animeto_app/features/feed/domain/entities/author.dart';

class Comment {
  final String id;
  final String content;
  final int likesCount;
  final int dislikesCount;
  final int repliesCount;
  final DateTime createdAt;
  final Author author;
  final Post? post;
  final Comment? parentComment;

  Comment({
    required this.id,
    required this.content,
    required this.likesCount,
    required this.dislikesCount,
    required this.repliesCount,
    required this.createdAt,
    required this.author,
    this.post,
    this.parentComment,
  });
}

class Post {
  final String id;
  final String description;

  Post({
    required this.id,
    required this.description,
  });
}
