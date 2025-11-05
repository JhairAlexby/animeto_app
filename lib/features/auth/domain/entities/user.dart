class User {
  final String id;
  final String name;
  final String email;
  final bool hasProfilePhoto;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hasProfilePhoto,
    required this.createdAt,
  });
}