import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/core/services/api_service.dart';

class AuthenticatedNetworkImage extends StatefulWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const AuthenticatedNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit,
  });

  @override
  State<AuthenticatedNetworkImage> createState() =>
      _AuthenticatedNetworkImageState();
}

class _AuthenticatedNetworkImageState extends State<AuthenticatedNetworkImage> {
  Uint8List? _bytes;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.dio.get(
        widget.url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );

      if (mounted) {
        setState(() {
          _bytes = response.data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error || _bytes == null) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: const Center(child: Icon(Icons.error)),
      );
    }

    return Image.memory(
      _bytes!,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
    );
  }
}
