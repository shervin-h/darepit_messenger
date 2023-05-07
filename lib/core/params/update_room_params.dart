class UpdateRoomParams {
  late final String updatedAt;
  final int roomId;
  final String name;
  final String description;
  final String image;

  UpdateRoomParams({
    required this.roomId,
    required this.name,
    this.description = '',
    this.image = '',
  }) {
    updatedAt = DateTime.now().toIso8601String();
  }
}