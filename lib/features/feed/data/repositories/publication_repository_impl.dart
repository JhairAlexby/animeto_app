import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/feed/data/datasources/publication_remote_data_source.dart';
import 'package:animeto_app/features/feed/domain/entities/publication.dart';
import 'package:animeto_app/features/feed/domain/repositories/publication_repository.dart';

class PublicationRepositoryImpl implements PublicationRepository {
  final PublicationRemoteDataSource remoteDataSource;

  PublicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Publication>> getPublications(int page, int limit) async {
    try {
      final publications = await remoteDataSource.getPublications(page, limit);
      return publications;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<Publication> createPost({
    required String description,
    required String type,
    int? currentChapters,
    List<String>? tags,
    String? imagePath,
  }) async {
    try {
      final publication = await remoteDataSource.createPost(
        description: description,
        type: type,
        currentChapters: currentChapters,
        tags: tags,
        imagePath: imagePath,
      );
      return publication;
    } on ServerException {
      rethrow;
    }
  }
}