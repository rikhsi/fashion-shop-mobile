import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fashion_shop/core/errors/failures.dart';
import 'package:fashion_shop/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_shop/features/auth/domain/entities/otp_entity.dart';
import 'package:fashion_shop/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:fashion_shop/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fashion_shop/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([SendOtpUseCase, VerifyOtpUseCase])
void main() {
  late LoginBloc bloc;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;

  setUp(() {
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    bloc = LoginBloc(
      sendOtpUseCase: mockSendOtpUseCase,
      verifyOtpUseCase: mockVerifyOtpUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('LoginBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, const LoginState());
      expect(bloc.state.step, LoginStep.phone);
      expect(bloc.state.status, LoginStatus.initial);
    });

    blocTest<LoginBloc, LoginState>(
      'emits updated phone number when LoginPhoneNumberChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoginPhoneNumberChanged('9991234567')),
      expect: () => [
        const LoginState(phoneNumber: '9991234567'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading then otp step when SendOtp succeeds',
      build: () {
        when(mockSendOtpUseCase(any)).thenAnswer(
          (_) async => const Right(
            OtpEntity(verificationId: 'test-id', isSuccess: true),
          ),
        );
        return bloc;
      },
      seed: () => const LoginState(phoneNumber: '9991234567'),
      act: (bloc) => bloc.add(const LoginSendOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '9991234567',
          status: LoginStatus.loading,
        ),
        const LoginState(
          phoneNumber: '9991234567',
          status: LoginStatus.initial,
          step: LoginStep.otp,
          verificationId: 'test-id',
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading then failure when SendOtp fails',
      build: () {
        when(mockSendOtpUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      seed: () => const LoginState(phoneNumber: '9991234567'),
      act: (bloc) => bloc.add(const LoginSendOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '9991234567',
          status: LoginStatus.loading,
        ),
        const LoginState(
          phoneNumber: '9991234567',
          status: LoginStatus.failure,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits success when VerifyOtp succeeds',
      build: () {
        when(mockVerifyOtpUseCase(any)).thenAnswer(
          (_) async => const Right(
            AuthEntity(
              token: 'test-token',
              phoneNumber: '+79991234567',
              isNewUser: false,
            ),
          ),
        );
        return bloc;
      },
      seed: () => const LoginState(
        phoneNumber: '9991234567',
        step: LoginStep.otp,
        otp: '123456',
        verificationId: 'test-id',
      ),
      act: (bloc) => bloc.add(const LoginVerifyOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '9991234567',
          step: LoginStep.otp,
          otp: '123456',
          verificationId: 'test-id',
          status: LoginStatus.loading,
        ),
        const LoginState(
          phoneNumber: '9991234567',
          step: LoginStep.otp,
          otp: '123456',
          verificationId: 'test-id',
          status: LoginStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits phone step when BackToPhone is requested',
      build: () => bloc,
      seed: () => const LoginState(
        step: LoginStep.otp,
        phoneNumber: '9991234567',
        verificationId: 'test-id',
        otp: '123',
      ),
      act: (bloc) => bloc.add(const LoginBackToPhoneRequested()),
      expect: () => [
        const LoginState(
          step: LoginStep.phone,
          phoneNumber: '9991234567',
          status: LoginStatus.initial,
        ),
      ],
    );
  });
}
