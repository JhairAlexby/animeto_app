import 'dart:io';
import 'package:dio/dio.dart';

/// Returns a human-friendly error message for Dio network errors.
///
/// Input: a DioException captured from a failed request.
/// Output: a localized Spanish string describing the error cause.
String messageFromDioException(DioException e) {
  final RequestOptions opts = e.requestOptions;
  String? host;
  try {
    final uri = Uri.parse((opts.baseUrl ?? '') + (opts.path));
    host = uri.host.isNotEmpty ? uri.host : null;
  } catch (_) {
    host = null;
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Tiempo de conexión agotado. Verifica tu red e inténtalo de nuevo.';
    case DioExceptionType.sendTimeout:
      return 'Tiempo de envío agotado. La red está lenta o inestable.';
    case DioExceptionType.receiveTimeout:
      return 'El servidor tardó demasiado en responder.';
    case DioExceptionType.badCertificate:
      return 'Error de certificado TLS al conectar con el servidor.';
    case DioExceptionType.badResponse:
      final int? code = e.response?.statusCode;
      final dynamic data = e.response?.data;
      final String? apiMessage = (data is Map<String, dynamic>)
          ? (data['message'] as String?)
          : null;
      if (apiMessage != null && apiMessage.isNotEmpty) {
        return apiMessage;
      }
      return 'Error HTTP${code != null ? ' $code' : ''} al procesar la solicitud.';
    case DioExceptionType.cancel:
      return 'La petición fue cancelada.';
    case DioExceptionType.connectionError:
      if (e.error is SocketException) {
        final se = e.error as SocketException;
        final hostMsg = host != null ? ' ($host)' : '';
        return 'No se pudo conectar con el servidor$hostMsg. ${se.message}. Verifica tu conexión a internet o tu DNS.';
      }
      return 'Error de conexión de red: ${e.message}';
    case DioExceptionType.unknown:
      final underlying = e.error;
      if (underlying is SocketException) {
        final hostMsg = host != null ? ' ($host)' : '';
        return 'No se pudo resolver o conectar con el servidor$hostMsg. ${underlying.message}.';
      }
      return 'Error de red desconocido: ${e.message}';
  }
}