import 'package:dio/dio.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/core/errors/error_utils.dart';
import 'package:animeto_app/features/feed/data/models/publication_model.dart';

abstract class PublicationRemoteDataSource {
  Future<List<PublicationModel>> getPublications(int page, int limit);
  Future<PublicationModel> createPost({
    required String description,
    required String type,
    int? currentChapters,
    List<String>? tags,
    String? imagePath,
  });
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
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<PublicationModel> createPost({
    required String description,
    required String type,
    int? currentChapters,
    List<String>? tags,
    String? imagePath,
  }) async {
    try {
      Response response;

      if (imagePath != null) {
        // multipart/form-data con imagen
        final formData = FormData();
        formData.fields.add(MapEntry('description', description));
        formData.fields.add(MapEntry('type', type));
        if (currentChapters != null) {
          formData.fields
              .add(MapEntry('currentChapters', currentChapters.toString()));
        }
        if (tags != null) {
          for (final t in tags) {
            formData.fields.add(MapEntry('tags', t));
          }
        }
        final fileName = imagePath.split(RegExp(r'[\\/]')).last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(imagePath, filename: fileName),
          ),
        );

        final url = apiService.dio.options.baseUrl + '/posts';
        print('Calling URL: $url');

        response = await apiService.dio.post(
          '/posts',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
      } else {
        // application/json sin imagen
        final data = <String, dynamic>{
          'description': description,
          'type': type,
          if (currentChapters != null) 'currentChapters': currentChapters,
          if (tags != null) 'tags': tags,
        };

        final url = apiService.dio.options.baseUrl + '/posts';
        print('Calling URL: $url');

        response = await apiService.dio.post(
          '/posts',
          data: data,
        );
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        final pubJson = response.data['data'];
        return PublicationModel.fromJson(Map<String, dynamic>.from(pubJson));
      } else {
        throw ServerException(
          response.data['message'] ?? 'Error al crear publicación',
        );
      }
    } on DioException catch (e) {
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}