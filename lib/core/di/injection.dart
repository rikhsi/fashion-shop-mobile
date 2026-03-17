import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/cart/data/cart_service.dart';
import '../../features/catalog/data/api/catalog_api_service.dart';
import '../../features/catalog/data/mocks/mock_catalog_api_service.dart';
import '../../features/favorites/data/favorites_service.dart';
import '../../features/home/data/datasources/home_datasource.dart';
import '../../features/home/data/datasources/home_mock_datasource.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/preferences/data/seasonal_preferences_service.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/tryon/data/tryon_service.dart';
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

  // Profile - Cubit
  sl.registerFactory(() => ProfileCubit(authRepository: sl()));

  // Favorites & Cart
  sl.registerLazySingleton<FavoritesService>(() => FavoritesService());
  sl.registerLazySingleton<CartService>(() => CartService());

  // Home - DataSource (swap HomeMockDataSource → HomeRemoteDataSource for real backend)
  sl.registerLazySingleton<HomeDataSource>(() => HomeMockDataSource());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl()));

  // Catalog - API Service (swap MockCatalogApiService with real implementation later)
  sl.registerLazySingleton<CatalogApiService>(() => MockCatalogApiService());

  // Try-On
  sl.registerLazySingleton<TryOnService>(() => TryOnService());

  // Preferences
  sl.registerLazySingleton<SeasonalPreferencesService>(
    () => SeasonalPreferencesService(),
  );
}
