import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_localizations.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final AppLocale locale;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.locale = AppLocale.en,
  });

  AppSettings copyWith({ThemeMode? themeMode, AppLocale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}

class AppSettingsCubit extends Cubit<AppSettings> {
  AppSettingsCubit() : super(const AppSettings());

  void setThemeMode(ThemeMode mode) =>
      emit(state.copyWith(themeMode: mode));

  void setLocale(AppLocale locale) =>
      emit(state.copyWith(locale: locale));

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: next));
  }
}
