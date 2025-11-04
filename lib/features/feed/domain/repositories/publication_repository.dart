import 'package:animeto_app/features/feed/domain/entities/publication.dart';

abstract class PublicationRepository {
  Future<List<Publication>> getPublications(int page, int limit);
}