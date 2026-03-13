import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';
import '../entities/otp_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpEntity>> sendOtp({required String phoneNumber});
  Future<Either<Failure, AuthEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String verificationId,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
}
