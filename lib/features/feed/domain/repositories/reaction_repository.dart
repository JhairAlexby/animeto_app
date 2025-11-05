import 'package:animeto_app/features/feed/domain/entities/reaction.dart';

abstract class ReactionRepository {
  Future<Reaction> createReaction({
    required String type,
    required String target,
    String? postId,
    String? commentId,
  });
}