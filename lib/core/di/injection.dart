import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../network/api_client.dart';
import '../settings/app_settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<AppSettingsCubit>(() => AppSettingsCubit());

  // Auth - Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );

  // Auth - Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
    ),
  );

  // Auth - Usecases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // Auth - Bloc
  sl.registerFactory(
    () => LoginBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
    ),
  );
}
