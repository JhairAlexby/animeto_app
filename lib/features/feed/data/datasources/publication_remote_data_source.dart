import 'package:dio/dio.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/features/feed/data/models/publication_model.dart';

abstract class PublicationRemoteDataSource {
  Future<List<PublicationModel>> getPublications(int page, int limit);
}

class PublicationRemoteDataSourceImpl implements PublicationRemoteDataSource {
  final ApiService apiService;

  PublicationRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<PublicationModel>> getPublications(int page, int limit) async {
    try {
      final response = await apiService.dio.get(
        '/publicaciones/completas',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List publications = response.data['data']['publicaciones'];
        return publications
            .map((pub) => PublicationModel.fromJson(pub))
            .toList();
      } else {
        throw ServerException(
            response.data['message'] ?? 'Error al cargar publicaciones');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Error de red: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}