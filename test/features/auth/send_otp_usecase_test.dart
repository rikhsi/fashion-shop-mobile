import 'package:dartz/dartz.dart';
import 'package:fashion_shop/core/errors/failures.dart';
import 'package:fashion_shop/features/auth/domain/entities/otp_entity.dart';
import 'package:fashion_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:fashion_shop/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_otp_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SendOtpUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendOtpUseCase(mockRepository);
  });

  const testPhone = '+79991234567';
  const testOtpEntity = OtpEntity(
    verificationId: 'verification-123',
    isSuccess: true,
  );

  test('should send OTP successfully', () async {
    when(mockRepository.sendOtp(phoneNumber: testPhone))
        .thenAnswer((_) async => const Right(testOtpEntity));

    final result = await useCase(const SendOtpParams(phoneNumber: testPhone));

    expect(result, const Right(testOtpEntity));
    verify(mockRepository.sendOtp(phoneNumber: testPhone));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when sending OTP fails', () async {
    when(mockRepository.sendOtp(phoneNumber: testPhone))
        .thenAnswer((_) async => const Left(ServerFailure('Server error')));

    final result = await useCase(const SendOtpParams(phoneNumber: testPhone));

    expect(result, const Left(ServerFailure('Server error')));
    verify(mockRepository.sendOtp(phoneNumber: testPhone));
    verifyNoMoreInteractions(mockRepository);
  });
}
