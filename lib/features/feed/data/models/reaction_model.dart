import 'package:animeto_app/features/feed/domain/entities/reaction.dart';

class ReactionModel extends Reaction {
  ReactionModel({
    required super.type,
    required super.userId,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    // API puede devolver:
    // - userId directo
    // - user: { id }
    // - user_id (snake_case)
    final type = (json['type'] as String?) ?? '';
    final dynamic userField = json['user'];
    final String? userId = (json['userId'] as String?) ??
        (userField is Map<String, dynamic> ? userField['id'] as String? : null) ??
        (json['user_id'] as String?);

    return ReactionModel(
      type: type,
      userId: userId ?? '',
    );
  }
}