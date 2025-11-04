import 'package:animeto_app/features/feed/domain/entities/author.dart';

class AuthorModel extends Author {
  AuthorModel({
    required super.id,
    required super.name,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
    );
  }
}