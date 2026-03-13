import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.token,
    required super.phoneNumber,
    required super.isNewUser,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] as String,
      phoneNumber: json['phone_number'] as String,
      isNewUser: json['is_new_user'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'phone_number': phoneNumber,
      'is_new_user': isNewUser,
    };
  }
}
