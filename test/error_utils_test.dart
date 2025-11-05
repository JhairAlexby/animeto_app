import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animeto_app/core/errors/error_utils.dart';

void main() {
  group('messageFromDioException', () {
    test('returns friendly message for SocketException host lookup', () {
      final dioEx = DioException(
        requestOptions: RequestOptions(
          path: '/posts',
          baseUrl: 'https://animeto-api-production.up.railway.app/api',
        ),
        type: DioExceptionType.connectionError,
        error: const SocketException('Failed host lookup: animeto-api-production.up.railway.app'),
      );

      final msg = messageFromDioException(dioEx);
      expect(msg, contains('No se pudo conectar'));
      expect(msg, contains('animeto-api-production.up.railway.app'));
    });

    test('uses API message when badResponse has message field', () {
      final dioEx = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {'message': 'Credenciales inválidas'},
        ),
      );
      final msg = messageFromDioException(dioEx);
      expect(msg, 'Credenciales inválidas');
    });
  });
}