part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isNewUser;
  final String phoneNumber;

  const ProfileState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isNewUser = false,
    this.phoneNumber = '',
  });

  String get userName => isNewUser ? 'newUserName' : 'defaultUserName';

  ProfileState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isNewUser,
    String? phoneNumber,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isNewUser: isNewUser ?? this.isNewUser,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isAuthenticated,
        isNewUser,
        phoneNumber,
      ];
}
