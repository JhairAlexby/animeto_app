import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/feed/data/datasources/reaction_remote_data_source.dart';
import 'package:animeto_app/features/feed/domain/entities/reaction.dart';
import 'package:animeto_app/features/feed/domain/repositories/reaction_repository.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final ReactionRemoteDataSource remoteDataSource;

  ReactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Reaction> createReaction({
    required String type,
    required String target,
    String? postId,
    String? commentId,
  }) async {
    try {
      final reaction = await remoteDataSource.createReaction(
        type: type,
        target: target,
        postId: postId,
        commentId: commentId,
      );
      return reaction;
    } on ServerException {
      rethrow;
    }
  }
}