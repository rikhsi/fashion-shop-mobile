part of 'login_bloc.dart';

enum LoginStep { phone, otp }

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStep step;
  final LoginStatus status;
  final String phoneNumber;
  final String countryCode;
  final String otp;
  final String verificationId;
  final String? errorMessage;

  const LoginState({
    this.step = LoginStep.phone,
    this.status = LoginStatus.initial,
    this.phoneNumber = '',
    this.countryCode = '+7',
    this.otp = '',
    this.verificationId = '',
    this.errorMessage,
  });

  bool get isPhoneValid => phoneNumber.replaceAll(RegExp(r'[^\d]'), '').length >= 10;
  bool get isOtpValid => otp.length == 6;

  LoginState copyWith({
    LoginStep? step,
    LoginStatus? status,
    String? phoneNumber,
    String? countryCode,
    String? otp,
    String? verificationId,
    String? errorMessage,
  }) {
    return LoginState(
      step: step ?? this.step,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      otp: otp ?? this.otp,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    phoneNumber,
    countryCode,
    otp,
    verificationId,
    errorMessage,
  ];
}
