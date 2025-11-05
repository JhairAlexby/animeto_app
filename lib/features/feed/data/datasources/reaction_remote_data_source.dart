import 'package:dio/dio.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/features/feed/data/models/reaction_model.dart';

abstract class ReactionRemoteDataSource {
  Future<ReactionModel> createReaction({
    required String type,
    required String target,
    String? postId,
    String? commentId,
  });
}

class ReactionRemoteDataSourceImpl implements ReactionRemoteDataSource {
  final ApiService apiService;

  ReactionRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ReactionModel> createReaction({
    required String type,
    required String target,
    String? postId,
    String? commentId,
  }) async {
    try {
      final data = <String, dynamic>{
        'type': type,
        'target': target,
        if (postId != null) 'postId': postId,
        if (commentId != null) 'commentId': commentId,
      };

      final response = await apiService.dio.post(
        '/reactions',
        data: data,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        final reactionData = response.data['data'];
        // Si la API hace toggle off, puede devolver data = null
        if (reactionData == null) {
          return ReactionModel(type: '', userId: '');
        }
        return ReactionModel.fromJson(Map<String, dynamic>.from(reactionData));
      } else {
        throw ServerException(
          response.data['message'] ?? 'Error al crear reacción',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Error de red: ${e.message}',
      );
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}