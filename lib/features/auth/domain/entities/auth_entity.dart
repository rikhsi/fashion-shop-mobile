import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String token;
  final String phoneNumber;
  final bool isNewUser;

  const AuthEntity({
    required this.token,
    required this.phoneNumber,
    required this.isNewUser,
  });

  @override
  List<Object?> get props => [token, phoneNumber, isNewUser];
}
