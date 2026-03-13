import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<AuthEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
      verificationId: params.verificationId,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String phoneNumber;
  final String otp;
  final String verificationId;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
    required this.verificationId,
  });

  @override
  List<Object?> get props => [phoneNumber, otp, verificationId];
}
