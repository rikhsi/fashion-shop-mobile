import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/settings/app_settings_cubit.dart';
import 'core/theme/app_theme.dart';

class FashionShopApp extends StatelessWidget {
  const FashionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AppSettingsCubit>(),
      child: BlocBuilder<AppSettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            locale: settings.locale.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('uz'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
