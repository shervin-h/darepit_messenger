import 'package:equatable/equatable.dart';

class ChatterEntity extends Equatable {
  late int userId;
  late String email;
  String? username;
  String? profileImage;
  String? profileImagePublicUrl;
  String? createdAt;
  String? updatedAt;

  ChatterEntity({
    required this.email,
    required this.userId,
    this.username = '',
    this.profileImage = '',
    this.profileImagePublicUrl = '',
    this.createdAt,
  }) {
    updatedAt = DateTime.now().toIso8601String();
  }

  /// the key of json param must be same with `app_user` table column titles
  ChatterEntity.fromJsonDb(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    username = json['username'];
    profileImage = json['profile_image'];
    profileImagePublicUrl = json['profile_image_public_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  /// the key of Map data must be equal to `app_user` table column titles
  Map<String, dynamic> toJsonDb() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = email;
    data['username'] = username ?? '';
    data['profile_image'] = profileImage ?? '';
    data['profile_image_public_url'] = profileImagePublicUrl ?? '';
    data['created_at'] = createdAt ?? DateTime.now().toIso8601String();
    data['updated_at'] = updatedAt ?? DateTime.now().toIso8601String();
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    email,
    username,
    profileImage,
    profileImagePublicUrl,
    createdAt,
    updatedAt,
  ];
}