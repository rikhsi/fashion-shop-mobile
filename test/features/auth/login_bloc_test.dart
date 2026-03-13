import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fashion_shop/core/constants/app_constants.dart';
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
      expect(bloc.state.resendTimerSeconds, 0);
      expect(bloc.state.canResend, isTrue);
    });

    test('isPhoneValid returns true for 9 digits', () {
      const state = LoginState(phoneNumber: '90 123 45 67');
      expect(state.isPhoneValid, isTrue);
    });

    test('isPhoneValid returns false for less than 9 digits', () {
      const state = LoginState(phoneNumber: '90 123');
      expect(state.isPhoneValid, isFalse);
    });

    test('timerDisplay formats correctly', () {
      const state = LoginState(resendTimerSeconds: 59);
      expect(state.timerDisplay, '0:59');

      const state2 = LoginState(resendTimerSeconds: 5);
      expect(state2.timerDisplay, '0:05');
    });

    blocTest<LoginBloc, LoginState>(
      'emits updated phone when LoginPhoneNumberChanged is added',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const LoginPhoneNumberChanged('90 123 45 67')),
      expect: () => [
        const LoginState(phoneNumber: '90 123 45 67'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading then otp step with timer when SendOtp succeeds',
      build: () {
        when(mockSendOtpUseCase(any)).thenAnswer(
          (_) async => const Right(
            OtpEntity(verificationId: 'test-id', isSuccess: true),
          ),
        );
        return bloc;
      },
      seed: () => const LoginState(phoneNumber: '90 123 45 67'),
      act: (bloc) => bloc.add(const LoginSendOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '90 123 45 67',
          status: LoginStatus.loading,
        ),
        LoginState(
          phoneNumber: '90 123 45 67',
          status: LoginStatus.initial,
          step: LoginStep.otp,
          verificationId: 'test-id',
          resendTimerSeconds: AppConstants.resendTimerDuration,
        ),
      ],
      verify: (_) {
        verify(mockSendOtpUseCase(any)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading then failure when SendOtp fails',
      build: () {
        when(mockSendOtpUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      seed: () => const LoginState(phoneNumber: '90 123 45 67'),
      act: (bloc) => bloc.add(const LoginSendOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '90 123 45 67',
          status: LoginStatus.loading,
        ),
        const LoginState(
          phoneNumber: '90 123 45 67',
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
              phoneNumber: '+998901234567',
              isNewUser: false,
            ),
          ),
        );
        return bloc;
      },
      seed: () => const LoginState(
        phoneNumber: '90 123 45 67',
        step: LoginStep.otp,
        otp: '123456',
        verificationId: 'test-id',
        resendTimerSeconds: 45,
      ),
      act: (bloc) => bloc.add(const LoginVerifyOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '90 123 45 67',
          step: LoginStep.otp,
          otp: '123456',
          verificationId: 'test-id',
          status: LoginStatus.loading,
          resendTimerSeconds: 45,
        ),
        const LoginState(
          phoneNumber: '90 123 45 67',
          step: LoginStep.otp,
          otp: '123456',
          verificationId: 'test-id',
          status: LoginStatus.success,
          resendTimerSeconds: 45,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure when VerifyOtp fails',
      build: () {
        when(mockVerifyOtpUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Invalid code')),
        );
        return bloc;
      },
      seed: () => const LoginState(
        phoneNumber: '90 123 45 67',
        step: LoginStep.otp,
        otp: '000000',
        verificationId: 'test-id',
        resendTimerSeconds: 30,
      ),
      act: (bloc) => bloc.add(const LoginVerifyOtpRequested()),
      expect: () => [
        const LoginState(
          phoneNumber: '90 123 45 67',
          step: LoginStep.otp,
          otp: '000000',
          verificationId: 'test-id',
          status: LoginStatus.loading,
          resendTimerSeconds: 30,
        ),
        const LoginState(
          phoneNumber: '90 123 45 67',
          step: LoginStep.otp,
          otp: '000000',
          verificationId: 'test-id',
          status: LoginStatus.failure,
          errorMessage: 'Invalid code',
          resendTimerSeconds: 30,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'resets to phone step and cancels timer on BackToPhone',
      build: () => bloc,
      seed: () => const LoginState(
        step: LoginStep.otp,
        phoneNumber: '90 123 45 67',
        verificationId: 'test-id',
        otp: '123',
        resendTimerSeconds: 40,
      ),
      act: (bloc) => bloc.add(const LoginBackToPhoneRequested()),
      expect: () => [
        const LoginState(
          step: LoginStep.phone,
          phoneNumber: '90 123 45 67',
          status: LoginStatus.initial,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'does not resend when timer is still active',
      build: () => bloc,
      seed: () => const LoginState(
        step: LoginStep.otp,
        phoneNumber: '90 123 45 67',
        verificationId: 'test-id',
        resendTimerSeconds: 30,
      ),
      act: (bloc) => bloc.add(const LoginResendOtpRequested()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockSendOtpUseCase(any));
      },
    );
  });
}
