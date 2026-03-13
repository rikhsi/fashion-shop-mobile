import '../../domain/entities/otp_entity.dart';

class OtpModel extends OtpEntity {
  const OtpModel({
    required super.verificationId,
    required super.isSuccess,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      verificationId: json['verification_id'] as String,
      isSuccess: json['is_success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verification_id': verificationId,
      'is_success': isSuccess,
    };
  }
}
