part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class LoginSendOtpRequested extends LoginEvent {
  const LoginSendOtpRequested();
}

class LoginOtpChanged extends LoginEvent {
  final String otp;

  const LoginOtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class LoginVerifyOtpRequested extends LoginEvent {
  const LoginVerifyOtpRequested();
}

class LoginBackToPhoneRequested extends LoginEvent {
  const LoginBackToPhoneRequested();
}

class LoginResendOtpRequested extends LoginEvent {
  const LoginResendOtpRequested();
}

class _LoginTimerTicked extends LoginEvent {
  final int remainingSeconds;

  const _LoginTimerTicked(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}
