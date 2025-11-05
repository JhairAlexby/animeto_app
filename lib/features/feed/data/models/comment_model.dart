import 'package:animeto_app/features/feed/data/models/author_model.dart';
import 'package:animeto_app/features/feed/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.content,
    required super.likesCount,
    required super.dislikesCount,
    required super.repliesCount,
    required super.createdAt,
    required super.author,
    super.post,
    super.parentComment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] ?? json['user'];
    return CommentModel(
      id: json['id'],
      content: json['content'],
      likesCount: json['likesCount'] ?? 0,
      dislikesCount: json['dislikesCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      author: AuthorModel.fromJson(authorJson),
      post: json['post'] != null ? PostModel.fromJson(json['post']) : null,
      parentComment: json['parentComment'] != null
          ? CommentModel.fromJson(json['parentComment'])
          : null,
    );
  }
}

class PostModel extends Post {
  PostModel({required super.id, required super.description});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      description: json['description'],
    );
  }
}
