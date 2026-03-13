import 'package:equatable/equatable.dart';

class OtpEntity extends Equatable {
  final String verificationId;
  final bool isSuccess;

  const OtpEntity({
    required this.verificationId,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [verificationId, isSuccess];
}
