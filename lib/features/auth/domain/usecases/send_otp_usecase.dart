import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/otp_entity.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase extends UseCase<OtpEntity, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(SendOtpParams params) {
    return repository.sendOtp(phoneNumber: params.phoneNumber);
  }
}

class SendOtpParams extends Equatable {
  final String phoneNumber;

  const SendOtpParams({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}
