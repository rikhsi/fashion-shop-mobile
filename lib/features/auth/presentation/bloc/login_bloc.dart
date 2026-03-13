import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  LoginBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(const LoginState()) {
    on<LoginPhoneNumberChanged>(_onPhoneNumberChanged);
    on<LoginSendOtpRequested>(_onSendOtpRequested);
    on<LoginOtpChanged>(_onOtpChanged);
    on<LoginVerifyOtpRequested>(_onVerifyOtpRequested);
    on<LoginBackToPhoneRequested>(_onBackToPhoneRequested);
  }

  void _onPhoneNumberChanged(
    LoginPhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      status: LoginStatus.initial,
    ));
  }

  Future<void> _onSendOtpRequested(
    LoginSendOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final fullNumber = '${state.countryCode}${state.phoneNumber}';
    final result = await sendOtpUseCase(
      SendOtpParams(phoneNumber: fullNumber),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (otpEntity) => emit(state.copyWith(
        status: LoginStatus.initial,
        step: LoginStep.otp,
        verificationId: otpEntity.verificationId,
      )),
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
    emit(state.copyWith(status: LoginStatus.loading));

    final fullNumber = '${state.countryCode}${state.phoneNumber}';
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
      )),
    );
  }

  void _onBackToPhoneRequested(
    LoginBackToPhoneRequested event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      step: LoginStep.phone,
      status: LoginStatus.initial,
      otp: '',
      verificationId: '',
    ));
  }
}
