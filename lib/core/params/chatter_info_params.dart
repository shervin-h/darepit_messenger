class ChatterInfoParams {
  final int? userId;
  final String? username;
  final String email;
  final String? profileImage;
  final String? profileImagePublicUrl;
  late final String? createdAt;
  late final String? updatedAt;

  ChatterInfoParams({
    this.userId,
    this.username,
    required this.email,
    this.profileImage,
    this.profileImagePublicUrl,
    this.createdAt,
  }) {
    createdAt = DateTime.now().toIso8601String();
    updatedAt = DateTime.now().toIso8601String();
  }
}