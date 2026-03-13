import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings/app_settings_cubit.dart';

enum AppLocale {
  en(Locale('en'), 'English'),
  ru(Locale('ru'), 'Русский'),
  uz(Locale('uz'), "O'zbekcha");

  final Locale locale;
  final String label;
  const AppLocale(this.locale, this.label);
}

class AppLocalizations {
  final AppLocale _locale;
  const AppLocalizations(this._locale);

  String get(String key) =>
      _data[_locale]?[key] ?? _data[AppLocale.en]![key] ?? key;

  // ── Navigation ──
  String get home => get('home');
  String get catalog => get('catalog');
  String get cart => get('cart');
  String get profile => get('profile');

  // ── Home ──
  String get searchHint => get('searchHint');
  String get categories => get('categories');
  String get popularProducts => get('popularProducts');
  String get newArrivals => get('newArrivals');
  String get specialOffers => get('specialOffers');
  String get recommendedForYou => get('recommendedForYou');
  String get viewAll => get('viewAll');

  // ── Categories ──
  String get women => get('women');
  String get men => get('men');
  String get shoes => get('shoes');
  String get accessories => get('accessories');
  String get newCollection => get('newCollection');

  // ── Auth ──
  String get enterPhoneNumber => get('enterPhoneNumber');
  String get getCode => get('getCode');
  String get enterOtp => get('enterOtp');
  String get otpSubtitle => get('otpSubtitle');
  String get confirm => get('confirm');
  String get resendCode => get('resendCode');
  String get resendCodeIn => get('resendCodeIn');
  String get agreementPrefix => get('agreementPrefix');
  String get personalDataPolicy => get('personalDataPolicy');

  // ── Profile ──
  String get settings => get('settings');
  String get theme => get('theme');
  String get language => get('language');
  String get darkMode => get('darkMode');
  String get lightMode => get('lightMode');
  String get systemMode => get('systemMode');
  String get loginToAccount => get('loginToAccount');
  String get loginDescription => get('loginDescription');
  String get login => get('login');

  // ── Product ──
  String get addToCart => get('addToCart');
  String get currency => get('currency');

  static const Map<AppLocale, Map<String, String>> _data = {
    AppLocale.en: _en,
    AppLocale.ru: _ru,
    AppLocale.uz: _uz,
  };

  static const _en = {
    'home': 'Home',
    'catalog': 'Catalog',
    'cart': 'Cart',
    'profile': 'Profile',
    'searchHint': 'Search for clothes...',
    'categories': 'Categories',
    'popularProducts': 'Popular',
    'newArrivals': 'New Arrivals',
    'specialOffers': 'Special Offers',
    'recommendedForYou': 'Recommended For You',
    'viewAll': 'View All',
    'women': 'Women',
    'men': 'Men',
    'shoes': 'Shoes',
    'accessories': 'Accessories',
    'newCollection': 'New Collection',
    'enterPhoneNumber': 'Enter your phone number',
    'getCode': 'Get Code',
    'enterOtp': 'Enter verification code',
    'otpSubtitle': 'We sent a code to your phone number',
    'confirm': 'Confirm',
    'resendCode': 'Resend code',
    'resendCodeIn': 'Resend code in',
    'agreementPrefix':
        'By continuing you agree to the processing of your ',
    'personalDataPolicy': 'Personal Data Policy',
    'settings': 'Settings',
    'theme': 'Theme',
    'language': 'Language',
    'darkMode': 'Dark',
    'lightMode': 'Light',
    'systemMode': 'System',
    'loginToAccount': 'Log in to your account',
    'loginDescription':
        'Track orders, save favorites, and get personal offers',
    'login': 'Login',
    'addToCart': 'Add to cart',
    'currency': 'sum',
  };

  static const _ru = {
    'home': 'Главная',
    'catalog': 'Каталог',
    'cart': 'Корзина',
    'profile': 'Профиль',
    'searchHint': 'Поиск одежды...',
    'categories': 'Категории',
    'popularProducts': 'Популярное',
    'newArrivals': 'Новинки',
    'specialOffers': 'Скидки',
    'recommendedForYou': 'Рекомендуем',
    'viewAll': 'Все',
    'women': 'Женское',
    'men': 'Мужское',
    'shoes': 'Обувь',
    'accessories': 'Аксессуары',
    'newCollection': 'Новая коллекция',
    'enterPhoneNumber': 'Введите номер телефона',
    'getCode': 'Получить код',
    'enterOtp': 'Введите код подтверждения',
    'otpSubtitle': 'Мы отправили код на ваш номер',
    'confirm': 'Подтвердить',
    'resendCode': 'Отправить повторно',
    'resendCodeIn': 'Повторить через',
    'agreementPrefix': 'Продолжая, вы соглашаетесь с обработкой ',
    'personalDataPolicy': 'персональных данных',
    'settings': 'Настройки',
    'theme': 'Тема',
    'language': 'Язык',
    'darkMode': 'Тёмная',
    'lightMode': 'Светлая',
    'systemMode': 'Системная',
    'loginToAccount': 'Войдите в аккаунт',
    'loginDescription':
        'Отслеживайте заказы, сохраняйте избранное',
    'login': 'Войти',
    'addToCart': 'В корзину',
    'currency': 'сум',
  };

  static const _uz = {
    'home': 'Bosh sahifa',
    'catalog': 'Katalog',
    'cart': 'Savat',
    'profile': 'Profil',
    'searchHint': 'Kiyim qidirish...',
    'categories': 'Kategoriyalar',
    'popularProducts': 'Mashhur',
    'newArrivals': 'Yangi',
    'specialOffers': 'Chegirmalar',
    'recommendedForYou': 'Tavsiya etilgan',
    'viewAll': 'Hammasi',
    'women': 'Ayollar',
    'men': 'Erkaklar',
    'shoes': 'Oyoq kiyim',
    'accessories': 'Aksessuarlar',
    'newCollection': 'Yangi kolleksiya',
    'enterPhoneNumber': 'Telefon raqamingizni kiriting',
    'getCode': 'Kod olish',
    'enterOtp': 'Tasdiqlash kodini kiriting',
    'otpSubtitle': 'Kod telefon raqamingizga yuborildi',
    'confirm': 'Tasdiqlash',
    'resendCode': 'Qayta yuborish',
    'resendCodeIn': 'Qayta yuborish',
    'agreementPrefix': "Davom etish orqali siz rozilik bildirasiz ",
    'personalDataPolicy': "Maxfiylik siyosati",
    'settings': 'Sozlamalar',
    'theme': 'Mavzu',
    'language': 'Til',
    'darkMode': "Qorong'u",
    'lightMode': "Yorug'",
    'systemMode': 'Tizim',
    'loginToAccount': 'Hisobingizga kiring',
    'loginDescription':
        'Buyurtmalarni kuzating, sevimlilarni saqlang',
    'login': 'Kirish',
    'addToCart': 'Savatga',
    'currency': "so'm",
  };
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get tr =>
      AppLocalizations(read<AppSettingsCubit>().state.locale);
}
