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
  String get phoneHint => get('phoneHint');

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
  String get editProfile => get('editProfile');
  String get myOrders => get('myOrders');
  String get myReviews => get('myReviews');
  String get becomeASeller => get('becomeASeller');
  String get myChats => get('myChats');
  String get notifications => get('notifications');
  String get myPromoCodes => get('myPromoCodes');
  String get contactUs => get('contactUs');
  String get defaultUserName => get('defaultUserName');
  String get newUserName => get('newUserName');
  String get phonePlaceholder => get('phonePlaceholder');

  // ── Product ──
  String get addToCart => get('addToCart');
  String get addedToCart => get('addedToCart');
  String get currency => get('currency');
  String get newBadge => get('newBadge');

  // ── Search & Filters ──
  String get noResults => get('noResults');
  String get noResultsDescription => get('noResultsDescription');
  String get filters => get('filters');
  String get priceRange => get('priceRange');
  String get sortBy => get('sortBy');
  String get sortNewest => get('sortNewest');
  String get sortPriceAsc => get('sortPriceAsc');
  String get sortPriceDesc => get('sortPriceDesc');
  String get applyFilters => get('applyFilters');
  String get resetFilters => get('resetFilters');
  String get allCategories => get('allCategories');

  // ── Cart ──
  String get clearCart => get('clearCart');
  String get delivery => get('delivery');
  String get freeDelivery => get('freeDelivery');
  String get checkout => get('checkout');
  String get orderTotal => get('orderTotal');

  // ── Empty states ──
  String get emptyCart => get('emptyCart');
  String get emptyCartDescription => get('emptyCartDescription');
  String get emptyWishlist => get('emptyWishlist');
  String get emptyWishlistDescription => get('emptyWishlistDescription');
  String get wishlist => get('wishlist');

  // ── Banners ──
  String get bannerSaleTitle => get('bannerSaleTitle');
  String get bannerSaleSubtitle => get('bannerSaleSubtitle');
  String get bannerDeliveryTitle => get('bannerDeliveryTitle');
  String get bannerDeliverySubtitle => get('bannerDeliverySubtitle');
  String get bannerNewTitle => get('bannerNewTitle');
  String get bannerNewSubtitle => get('bannerNewSubtitle');

  // ── Product detail ──
  String get reviews => get('reviews');
  String get sold => get('sold');
  String get description => get('description');
  String get details => get('details');
  String get inStock => get('inStock');
  String get outOfStock => get('outOfStock');
  String get size => get('size');
  String get color => get('color');

  // ── Errors ──
  String get errorGeneric => get('errorGeneric');
  String get errorNetwork => get('errorNetwork');
  String get errorServer => get('errorServer');

  // ── Validation ──
  String get validationPhoneRequired => get('validationPhoneRequired');
  String get validationPhoneInvalid => get('validationPhoneInvalid');
  String get validationOtpRequired => get('validationOtpRequired');
  String get validationOtpLength => get('validationOtpLength');
  String get validationOtpDigits => get('validationOtpDigits');

  // ── Profile edit ──
  String get profileEditTitle => get('profileEditTitle');
  String get profileEditDescription => get('profileEditDescription');

  // ── Catalog categories ──
  String get catClothing => get('catClothing');
  String get catBeauty => get('catBeauty');
  String get catVenues => get('catVenues');
  String get catPhoto => get('catPhoto');
  String get catDecor => get('catDecor');
  String get catEntertainment => get('catEntertainment');
  String get catTransport => get('catTransport');
  String get catGifts => get('catGifts');
  String get catTravel => get('catTravel');
  String get catWomen => get('catWomen');
  String get catMen => get('catMen');
  String get catWedding => get('catWedding');
  String get catEvening => get('catEvening');
  String get catSuits => get('catSuits');
  String get catKids => get('catKids');

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
    'agreementPrefix': 'By continuing you agree to the processing of your ',
    'personalDataPolicy': 'Personal Data Policy',
    'phoneHint': '00 000 00 00',
    'settings': 'Settings',
    'theme': 'Theme',
    'language': 'Language',
    'darkMode': 'Dark',
    'lightMode': 'Light',
    'systemMode': 'System',
    'loginToAccount': 'Log in to your account',
    'loginDescription': 'Track orders, save favorites, and get personal offers',
    'login': 'Login',
    'editProfile': 'Edit Profile',
    'myOrders': 'My Orders',
    'myReviews': 'My Reviews',
    'becomeASeller': 'Become a Seller',
    'myChats': 'My Chats',
    'notifications': 'Notifications',
    'myPromoCodes': 'My Promo Codes',
    'contactUs': 'Contact Us',
    'defaultUserName': 'Fashion Shopper',
    'newUserName': 'New Shopper',
    'phonePlaceholder': '+998 -- --- -- --',
    'addToCart': 'Add to cart',
    'addedToCart': 'Added to cart',
    'currency': 'sum',
    'newBadge': 'NEW',
    'noResults': 'No results found',
    'noResultsDescription': 'Try different keywords or filters',
    'filters': 'Filters',
    'sortDefault': 'Default',
    'sortPopular': 'Popular',
    'sortDiscount': 'Biggest Discount',
    'onlyDiscounts': 'Only with discounts',
    'onlyNew': 'Only new items',
    'priceRange': 'Price Range',
    'sortBy': 'Sort By',
    'sortNewest': 'Newest',
    'sortPriceAsc': 'Price: Low to High',
    'sortPriceDesc': 'Price: High to Low',
    'applyFilters': 'Apply',
    'resetFilters': 'Reset',
    'allCategories': 'All',
    'clearCart': 'Clear',
    'delivery': 'Delivery',
    'freeDelivery': 'Free',
    'checkout': 'Checkout',
    'orderTotal': 'Total',
    'reviews': 'Reviews',
    'sold': 'sold',
    'description': 'Description',
    'details': 'Details',
    'inStock': 'In stock',
    'outOfStock': 'Out of stock',
    'size': 'Size',
    'color': 'Color',
    'emptyCart': 'Cart is empty',
    'emptyCartDescription': 'Add items to get started',
    'emptyWishlist': 'Wishlist is empty',
    'emptyWishlistDescription': 'Save items you like here',
    'wishlist': 'Wishlist',
    'bannerSaleTitle': 'Spring Sale\nUp to 50% Off',
    'bannerSaleSubtitle': 'New spring collection available now',
    'bannerDeliveryTitle': 'Free Delivery',
    'bannerDeliverySubtitle': 'On orders over 200 000 sum',
    'bannerNewTitle': 'New Arrivals',
    'bannerNewSubtitle': 'Fresh styles every week',
    'errorGeneric': 'An unexpected error occurred',
    'errorNetwork': 'No internet connection',
    'errorServer': 'Server error occurred',
    'validationPhoneRequired': 'Phone number is required',
    'validationPhoneInvalid': 'Please enter a valid phone number',
    'validationOtpRequired': 'Verification code is required',
    'validationOtpLength': 'Verification code must be 6 digits',
    'validationOtpDigits': 'Verification code must contain only digits',
    'profileEditTitle': 'Edit Profile',
    'profileEditDescription': 'You can update your profile details here.',
    'catClothing': 'Clothing &\nAccessories',
    'catBeauty': 'Beauty &\nCare',
    'catVenues': 'Venues',
    'catPhoto': 'Photo &\nVideo',
    'catDecor': 'Decor &\nDesign',
    'catEntertainment': 'Entertainment\n& Music',
    'catTransport': 'Transport',
    'catGifts': 'Gifts &\nSouvenirs',
    'catTravel': 'Travel',
    'catWomen': 'Women',
    'catMen': 'Men',
    'catWedding': 'Wedding Dresses',
    'catEvening': 'Evening Dresses',
    'catSuits': 'Suits',
    'catKids': 'Kids',
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
    'phoneHint': '00 000 00 00',
    'settings': 'Настройки',
    'theme': 'Тема',
    'language': 'Язык',
    'darkMode': 'Тёмная',
    'lightMode': 'Светлая',
    'systemMode': 'Системная',
    'loginToAccount': 'Войдите в аккаунт',
    'loginDescription': 'Отслеживайте заказы, сохраняйте избранное',
    'login': 'Войти',
    'editProfile': 'Редактировать профиль',
    'myOrders': 'Мои заказы',
    'myReviews': 'Мои отзывы',
    'becomeASeller': 'Стать продавцом',
    'myChats': 'Мои чаты',
    'notifications': 'Уведомления',
    'myPromoCodes': 'Мои промокоды',
    'contactUs': 'Связаться с нами',
    'defaultUserName': 'Покупатель',
    'newUserName': 'Новый покупатель',
    'phonePlaceholder': '+998 -- --- -- --',
    'addToCart': 'В корзину',
    'addedToCart': 'Добавлено в корзину',
    'currency': 'сум',
    'newBadge': 'НОВОЕ',
    'noResults': 'Ничего не найдено',
    'noResultsDescription': 'Попробуйте другие ключевые слова',
    'filters': 'Фильтры',
    'sortDefault': 'По умолчанию',
    'sortPopular': 'Популярные',
    'sortDiscount': 'Макс. скидка',
    'onlyDiscounts': 'Только со скидкой',
    'onlyNew': 'Только новинки',
    'priceRange': 'Диапазон цен',
    'sortBy': 'Сортировка',
    'sortNewest': 'Новинки',
    'sortPriceAsc': 'Цена: по возрастанию',
    'sortPriceDesc': 'Цена: по убыванию',
    'applyFilters': 'Применить',
    'resetFilters': 'Сбросить',
    'allCategories': 'Все',
    'clearCart': 'Очистить',
    'delivery': 'Доставка',
    'freeDelivery': 'Бесплатно',
    'checkout': 'Оформить заказ',
    'orderTotal': 'Итого',
    'reviews': 'Отзывы',
    'sold': 'продано',
    'description': 'Описание',
    'details': 'Характеристики',
    'inStock': 'В наличии',
    'outOfStock': 'Нет в наличии',
    'size': 'Размер',
    'color': 'Цвет',
    'emptyCart': 'Корзина пуста',
    'emptyCartDescription': 'Добавьте товары, чтобы начать',
    'emptyWishlist': 'Список желаний пуст',
    'emptyWishlistDescription': 'Сохраняйте понравившиеся товары',
    'wishlist': 'Избранное',
    'bannerSaleTitle': 'Весенняя распродажа\nДо 50% скидки',
    'bannerSaleSubtitle': 'Новая весенняя коллекция уже здесь',
    'bannerDeliveryTitle': 'Бесплатная доставка',
    'bannerDeliverySubtitle': 'На заказы от 200 000 сум',
    'bannerNewTitle': 'Новинки',
    'bannerNewSubtitle': 'Свежие стили каждую неделю',
    'errorGeneric': 'Произошла непредвиденная ошибка',
    'errorNetwork': 'Нет подключения к интернету',
    'errorServer': 'Ошибка сервера',
    'validationPhoneRequired': 'Введите номер телефона',
    'validationPhoneInvalid': 'Введите корректный номер телефона',
    'validationOtpRequired': 'Введите код подтверждения',
    'validationOtpLength': 'Код подтверждения должен быть 6 цифр',
    'validationOtpDigits': 'Код должен содержать только цифры',
    'profileEditTitle': 'Редактирование профиля',
    'profileEditDescription': 'Обновите данные вашего профиля.',
    'catClothing': 'Одежда,\nаксессуары',
    'catBeauty': 'Красота\nи уход',
    'catVenues': 'Места\nпроведения',
    'catPhoto': 'Фото\nи видео',
    'catDecor': 'Оформление\nи декор',
    'catEntertainment': 'Развлечения\nи музыка',
    'catTransport': 'Транспорт',
    'catGifts': 'Сувениры\nи подарки',
    'catTravel': 'Путешествия',
    'catWomen': 'Женщинам',
    'catMen': 'Мужчинам',
    'catWedding': 'Свадебные платья',
    'catEvening': 'Вечерние платья',
    'catSuits': 'Мужские костюмы',
    'catKids': 'Детская одежда',
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
    'phoneHint': '00 000 00 00',
    'settings': 'Sozlamalar',
    'theme': 'Mavzu',
    'language': 'Til',
    'darkMode': "Qorong'u",
    'lightMode': "Yorug'",
    'systemMode': 'Tizim',
    'loginToAccount': 'Hisobingizga kiring',
    'loginDescription': 'Buyurtmalarni kuzating, sevimlilarni saqlang',
    'login': 'Kirish',
    'editProfile': 'Profilni tahrirlash',
    'myOrders': 'Buyurtmalarim',
    'myReviews': 'Sharhlarim',
    'becomeASeller': "Sotuvchi bo'lish",
    'myChats': 'Chatlarim',
    'notifications': 'Bildirishnomalar',
    'myPromoCodes': 'Promokodlarim',
    'contactUs': "Biz bilan bog'laning",
    'defaultUserName': 'Xaridor',
    'newUserName': 'Yangi xaridor',
    'phonePlaceholder': '+998 -- --- -- --',
    'addToCart': 'Savatga',
    'addedToCart': "Savatga qo'shildi",
    'currency': "so'm",
    'newBadge': 'YANGI',
    'noResults': 'Hech narsa topilmadi',
    'noResultsDescription': "Boshqa kalit so'zlarni sinab ko'ring",
    'filters': 'Filterlar',
    'sortDefault': 'Standart',
    'sortPopular': 'Mashhur',
    'sortDiscount': 'Eng katta chegirma',
    'onlyDiscounts': 'Faqat chegirmali',
    'onlyNew': 'Faqat yangilar',
    'priceRange': "Narx oralig'i",
    'sortBy': 'Saralash',
    'sortNewest': 'Eng yangi',
    'sortPriceAsc': 'Narx: arzon → qimmat',
    'sortPriceDesc': 'Narx: qimmat → arzon',
    'applyFilters': "Qo'llash",
    'resetFilters': 'Tozalash',
    'allCategories': 'Hammasi',
    'clearCart': 'Tozalash',
    'delivery': 'Yetkazib berish',
    'freeDelivery': 'Bepul',
    'checkout': 'Buyurtma berish',
    'orderTotal': 'Jami',
    'reviews': 'Sharhlar',
    'sold': 'sotilgan',
    'description': 'Tavsif',
    'details': "Xususiyatlar",
    'inStock': 'Mavjud',
    'outOfStock': 'Mavjud emas',
    'size': "O'lcham",
    'color': 'Rang',
    'emptyCart': 'Savat bosh',
    'emptyCartDescription': "Boshlash uchun mahsulot qo'shing",
    'emptyWishlist': "Sevimlilar ro'yxati bosh",
    'emptyWishlistDescription': "Yoqtirgan mahsulotlarni saqlang",
    'wishlist': 'Sevimlilar',
    'bannerSaleTitle': "Bahorgi chegirma\n50% gacha",
    'bannerSaleSubtitle': "Yangi bahorgi kolleksiya mavjud",
    'bannerDeliveryTitle': "Bepul yetkazib berish",
    'bannerDeliverySubtitle': "200 000 so'mdan ortiq buyurtmalarga",
    'bannerNewTitle': 'Yangi mahsulotlar',
    'bannerNewSubtitle': "Har hafta yangi uslublar",
    'errorGeneric': "Kutilmagan xatolik yuz berdi",
    'errorNetwork': "Internet aloqasi yo'q",
    'errorServer': 'Server xatoligi',
    'validationPhoneRequired': 'Telefon raqam kiritilishi shart',
    'validationPhoneInvalid': "To'g'ri telefon raqam kiriting",
    'validationOtpRequired': 'Tasdiqlash kodi kiritilishi shart',
    'validationOtpLength': "Tasdiqlash kodi 6 ta raqamdan iborat bo'lishi kerak",
    'validationOtpDigits': "Kod faqat raqamlardan iborat bo'lishi kerak",
    'profileEditTitle': 'Profilni tahrirlash',
    'profileEditDescription': "Profil ma'lumotlarini yangilang.",
    'catClothing': "Kiyim va\naksessuarlar",
    'catBeauty': "Go'zallik\nva parvarish",
    'catVenues': "O'tkazish\njoylari",
    'catPhoto': "Foto va\nvideo",
    'catDecor': "Bezatish\nva dizayn",
    'catEntertainment': "Ko'ngil ochar\nva musiqa",
    'catTransport': 'Transport',
    'catGifts': "Sovg'alar",
    'catTravel': "Sayohat",
    'catWomen': 'Ayollar',
    'catMen': 'Erkaklar',
    'catWedding': "To'y ko'ylaklari",
    'catEvening': "Kechki ko'ylaklar",
    'catSuits': 'Erkak kostyumlari',
    'catKids': 'Bolalar kiyimi',
  };
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get tr =>
      AppLocalizations(read<AppSettingsCubit>().state.locale);
}
