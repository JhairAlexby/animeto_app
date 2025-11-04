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
    var reactionsList = (json['reactions'] as List)
        .map((i) => ReactionModel.fromJson(i))
        .toList();
    var commentsList = (json['comments'] as List)
        .map((i) => CommentModel.fromJson(i))
        .toList();

    return PublicationModel(
      id: json['id'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      hasImage: json['hasImage'] ?? false,
      imageUrl: json['imageUrl'],
      author: AuthorModel.fromJson(json['author']),
      reactions: reactionsList,
      comments: commentsList,
    );
  }
}