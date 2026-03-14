import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/otp_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, OtpEntity>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final result = await remoteDatasource.sendOtp(phoneNumber: phoneNumber);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String verificationId,
  }) async {
    try {
      final result = await remoteDatasource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        verificationId: verificationId,
      );
      await localDatasource.cacheToken(result.token);
      await localDatasource.cachePhoneNumber(result.phoneNumber);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final hasToken = await localDatasource.hasToken();
      return Right(hasToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedPhoneNumber() async {
    try {
      final phoneNumber = await localDatasource.getCachedPhoneNumber();
      return Right(phoneNumber);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
