class AddRoomParams {
  late final String createdAt;
  late final String updatedAt;
  final int userId;
  final String name;
  final String description;
  final String image;
  final bool isPrivate;
  final String? privateKey;

  AddRoomParams({
    required this.userId,
    required this.name,
    required this.description,
    this.image = '',
    this.isPrivate = false,
    this.privateKey,
  }) {
    createdAt = DateTime.now().toIso8601String();
    updatedAt = DateTime.now().toIso8601String();
  }
}