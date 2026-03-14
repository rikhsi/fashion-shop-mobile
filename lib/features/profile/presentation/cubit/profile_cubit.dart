import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/auth_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit({required this.authRepository}) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));

    final isLoggedInResult = await authRepository.isLoggedIn();

    await isLoggedInResult.fold(
      (_) async {
        emit(state.copyWith(isLoading: false, isAuthenticated: false));
      },
      (isLoggedIn) async {
        if (!isLoggedIn) {
          emit(state.copyWith(isLoading: false, isAuthenticated: false));
          return;
        }

        final phoneResult = await authRepository.getCachedPhoneNumber();
        final phoneNumber = phoneResult.getOrElse(() => '');

        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            phoneNumber: phoneNumber ?? '',
          ),
        );
      },
    );
  }

  void onAuthenticated(AuthEntity auth) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        phoneNumber: auth.phoneNumber,
        isNewUser: auth.isNewUser,
      ),
    );
  }
}
