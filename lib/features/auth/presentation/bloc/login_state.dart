part of 'login_bloc.dart';

enum LoginStep { phone, otp }

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStep step;
  final LoginStatus status;
  final String phoneNumber;
  final String otp;
  final String verificationId;
  final String? errorMessage;
  final int resendTimerSeconds;

  const LoginState({
    this.step = LoginStep.phone,
    this.status = LoginStatus.initial,
    this.phoneNumber = '',
    this.otp = '',
    this.verificationId = '',
    this.errorMessage,
    this.resendTimerSeconds = 0,
  });

  String get countryCode => AppConstants.defaultCountryCode;

  bool get isPhoneValid =>
      phoneNumber.replaceAll(RegExp(r'[^\d]'), '').length ==
      AppConstants.phoneDigitsLength;

  bool get isOtpValid => otp.length == AppConstants.otpLength;

  bool get canResend => resendTimerSeconds == 0;

  String get formattedPhone {
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 2) return '$countryCode $digits';
    if (digits.length < 5) return '$countryCode ${digits.substring(0, 2)} ${digits.substring(2)}';
    if (digits.length < 7) {
      return '$countryCode ${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5)}';
    }
    return '$countryCode ${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7)}';
  }

  String get timerDisplay {
    final minutes = resendTimerSeconds ~/ 60;
    final seconds = resendTimerSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  LoginState copyWith({
    LoginStep? step,
    LoginStatus? status,
    String? phoneNumber,
    String? otp,
    String? verificationId,
    String? errorMessage,
    int? resendTimerSeconds,
  }) {
    return LoginState(
      step: step ?? this.step,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      resendTimerSeconds: resendTimerSeconds ?? this.resendTimerSeconds,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    phoneNumber,
    otp,
    verificationId,
    errorMessage,
    resendTimerSeconds,
  ];
}
