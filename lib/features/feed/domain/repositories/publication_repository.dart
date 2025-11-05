import 'package:animeto_app/features/feed/domain/entities/publication.dart';

abstract class PublicationRepository {
  Future<List<Publication>> getPublications(int page, int limit);
  Future<Publication> createPost({
    required String description,
    required String type,
    int? currentChapters,
    List<String>? tags,
    String? imagePath,
  });
}