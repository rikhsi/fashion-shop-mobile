import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_localizations.dart';

/// Gender for style preferences and feed personalization.
enum AppGender { male, female, nonBinary, preferNotToSay }

extension AppGenderX on AppGender {
  String get label {
    switch (this) {
      case AppGender.male:
        return 'Male';
      case AppGender.female:
        return 'Female';
      case AppGender.nonBinary:
        return 'Non-binary';
      case AppGender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Quick weather filter for home feed.
enum AppWeatherFilter {
  all,
  spring,
  summer,
  autumn,
  winter,
  rainy,
  snowy,
  dryHot,
}

extension AppWeatherFilterX on AppWeatherFilter {
  String get label {
    switch (this) {
      case AppWeatherFilter.all:
        return 'All';
      case AppWeatherFilter.spring:
        return 'Spring';
      case AppWeatherFilter.summer:
        return 'Summer';
      case AppWeatherFilter.autumn:
        return 'Autumn';
      case AppWeatherFilter.winter:
        return 'Winter';
      case AppWeatherFilter.rainy:
        return 'Rainy';
      case AppWeatherFilter.snowy:
        return 'Snowy';
      case AppWeatherFilter.dryHot:
        return 'Dry & Hot';
    }
  }
}

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final AppLocale locale;
  final bool hasCompletedOnboarding;
  final Set<AppGender> genders;
  final Set<AppWeatherFilter> weatherFilters;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.locale = AppLocale.en,
    this.hasCompletedOnboarding = false,
    this.genders = const {},
    this.weatherFilters = const {},
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLocale? locale,
    bool? hasCompletedOnboarding,
    Set<AppGender>? genders,
    Set<AppWeatherFilter>? weatherFilters,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      genders: genders ?? this.genders,
      weatherFilters: weatherFilters ?? this.weatherFilters,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, hasCompletedOnboarding, genders, weatherFilters];
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

  void completeOnboarding() =>
      emit(state.copyWith(hasCompletedOnboarding: true));

  void setGenders(Set<AppGender> g) => emit(state.copyWith(genders: g));
  void setWeatherFilters(Set<AppWeatherFilter> f) =>
      emit(state.copyWith(weatherFilters: f));
}
