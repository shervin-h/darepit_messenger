class RoomEntity {
  late final int roomId;
  late final int userId;
  late final String name;
  late final String description;
  late final String roomImage;
  late final bool isPrivate;
  String? privateKey;
  String? createdAt;
  String? updatedAt;

  RoomEntity({
    required this.roomId,
    required this.userId,
    required this.name,
    required this.description,
    required this.roomImage,
    this.isPrivate = false,
    this.privateKey,
    this.createdAt,
    this.updatedAt,
  }) {
    createdAt ??= DateTime.now().toIso8601String();
    updatedAt ??= DateTime.now().toIso8601String();
  }

  Map<String, dynamic> toJsonDb() {
    final data = <String, dynamic>{};
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['name'] = name;
    data['description'] = description;
    data['room_image'] = roomImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_private'] = isPrivate ? 1 : 0;
    data['private_key'] = privateKey;
    return data;
  }

  RoomEntity.fromJsonDb(Map<String, dynamic> json) {
    roomId = json['room_id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    roomImage = json['room_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isPrivate = json['is_private'] == 1 ? true : false;
    privateKey = json['private_key'];
  }
}