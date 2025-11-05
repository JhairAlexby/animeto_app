import 'package:animeto_app/features/feed/data/models/author_model.dart';
import 'package:animeto_app/features/feed/data/models/comment_model.dart';
import 'package:animeto_app/features/feed/data/models/reaction_model.dart';
import 'package:animeto_app/features/feed/domain/entities/publication.dart';

class PublicationModel extends Publication {
  PublicationModel({
    required super.id,
    required super.description,
    required super.createdAt,
    required super.hasImage,
    super.imageUrl,
    required super.author,
    required super.reactions,
    required super.comments,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    final reactionsJson = json['reactions'];
    final commentsJson = json['comments'];
    final reactionsList = reactionsJson is List
        ? reactionsJson.map((i) => ReactionModel.fromJson(i)).toList()
        : <ReactionModel>[];
    final commentsList = commentsJson is List
        ? commentsJson.map((i) => CommentModel.fromJson(i)).toList()
        : <CommentModel>[];

    return PublicationModel(
      id: json['id'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      hasImage: json['image'] != null,
      imageUrl: json['image'],
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'])
          : AuthorModel(id: json['authorId'], name: '...'),
      reactions: reactionsList,
      comments: commentsList,
    );
  }
}