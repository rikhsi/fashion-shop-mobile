import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

// TEMP: fast auth flow for profile UI QA.
const bool _profilePreviewAuthBypass = true;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  StreamSubscription<int>? _timerSubscription;

  LoginBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(const LoginState()) {
    on<LoginPhoneNumberChanged>(_onPhoneNumberChanged);
    on<LoginSendOtpRequested>(_onSendOtpRequested);
    on<LoginOtpChanged>(_onOtpChanged);
    on<LoginVerifyOtpRequested>(_onVerifyOtpRequested);
    on<LoginBackToPhoneRequested>(_onBackToPhoneRequested);
    on<LoginResendOtpRequested>(_onResendOtpRequested);
    on<_LoginTimerTicked>(_onTimerTicked);
  }

  void _onPhoneNumberChanged(
    LoginPhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) {
    final nextState = state.copyWith(
      phoneNumber: event.phoneNumber,
      status: LoginStatus.initial,
    );

    if (_profilePreviewAuthBypass &&
        nextState.isPhoneValid &&
        state.step == LoginStep.phone) {
      emit(nextState.copyWith(step: LoginStep.otp, resendTimerSeconds: 0));
      return;
    }

    emit(nextState);
  }

  Future<void> _onSendOtpRequested(
    LoginSendOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (_profilePreviewAuthBypass) {
      emit(state.copyWith(
        status: LoginStatus.initial,
        step: LoginStep.otp,
        verificationId: 'preview-verification-id',
        resendTimerSeconds: 0,
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final digits = state.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final fullNumber = '${state.countryCode}$digits';
    final result = await sendOtpUseCase(
      SendOtpParams(phoneNumber: fullNumber),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (otpEntity) {
        emit(state.copyWith(
          status: LoginStatus.initial,
          step: LoginStep.otp,
          verificationId: otpEntity.verificationId,
          resendTimerSeconds: AppConstants.resendTimerDuration,
        ));
        _startResendTimer();
      },
    );
  }

  void _onOtpChanged(
    LoginOtpChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      otp: event.otp,
      status: LoginStatus.initial,
    ));
  }

  Future<void> _onVerifyOtpRequested(
    LoginVerifyOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (_profilePreviewAuthBypass) {
      final digits = state.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final fullNumber = '${state.countryCode}$digits';
      emit(state.copyWith(
        status: LoginStatus.success,
        authEntity: AuthEntity(
          token: 'preview-token',
          phoneNumber: fullNumber,
          isNewUser: false,
        ),
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final digits = state.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final fullNumber = '${state.countryCode}$digits';
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        phoneNumber: fullNumber,
        otp: state.otp,
        verificationId: state.verificationId,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (authEntity) => emit(state.copyWith(
        status: LoginStatus.success,
        authEntity: authEntity,
      )),
    );
  }

  void _onBackToPhoneRequested(
    LoginBackToPhoneRequested event,
    Emitter<LoginState> emit,
  ) {
    _timerSubscription?.cancel();
    emit(state.copyWith(
      step: LoginStep.phone,
      status: LoginStatus.initial,
      otp: '',
      verificationId: '',
      resendTimerSeconds: 0,
    ));
  }

  Future<void> _onResendOtpRequested(
    LoginResendOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (_profilePreviewAuthBypass) {
      emit(state.copyWith(
        status: LoginStatus.initial,
        resendTimerSeconds: 0,
      ));
      return;
    }

    if (!state.canResend) return;

    emit(state.copyWith(status: LoginStatus.loading));

    final digits = state.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final fullNumber = '${state.countryCode}$digits';
    final result = await sendOtpUseCase(
      SendOtpParams(phoneNumber: fullNumber),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (otpEntity) {
        emit(state.copyWith(
          status: LoginStatus.initial,
          verificationId: otpEntity.verificationId,
          otp: '',
          resendTimerSeconds: AppConstants.resendTimerDuration,
        ));
        _startResendTimer();
      },
    );
  }

  void _onTimerTicked(
    _LoginTimerTicked event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(resendTimerSeconds: event.remainingSeconds));
  }

  void _startResendTimer() {
    _timerSubscription?.cancel();
    _timerSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (tick) => AppConstants.resendTimerDuration - 1 - tick,
    ).take(AppConstants.resendTimerDuration).listen(
      (seconds) => add(_LoginTimerTicked(seconds)),
    );
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
