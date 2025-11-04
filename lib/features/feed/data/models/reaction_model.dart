import 'package:animeto_app/features/feed/domain/entities/reaction.dart';

class ReactionModel extends Reaction {
  ReactionModel({
    required super.type,
    required super.userId,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      type: json['type'],
      userId: json['user']['id'],
    );
  }
}