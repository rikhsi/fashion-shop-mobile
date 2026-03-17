import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';
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
  String get showMore => get('showMore');

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

  // ── Checkout ──
  String get deliveryTypeStep => get('deliveryTypeStep');
  String get deliveryOption => get('deliveryOption');
  String get deliveryOptionSubtitle => get('deliveryOptionSubtitle');
  String get pickupOption => get('pickupOption');
  String get pickupOptionSubtitle => get('pickupOptionSubtitle');
  String get selectPointOnMap => get('selectPointOnMap');
  String get deliveryAddress => get('deliveryAddress');
  String get city => get('city');
  String get tashkent => get('tashkent');
  String get streetHouse => get('streetHouse');
  String get streetHint => get('streetHint');
  String get apartment => get('apartment');
  String get optional => get('optional');
  String get phone => get('phone');
  String get selectWarehouse => get('selectWarehouse');
  String get choosePaymentMethod => get('choosePaymentMethod');
  String get orderItems => get('orderItems');
  String get deliveryTitle => get('deliveryTitle');
  String get pickup => get('pickup');
  String get payment => get('payment');
  String get orderSummary => get('orderSummary');
  String get continueBtn => get('continue');
  String get placingOrder => get('placingOrder');
  String get orderPlacedSuccess => get('orderPlacedSuccess');
  String get addressWillBeConfirmed => get('addressWillBeConfirmed');
  String get warehouseSelected => get('warehouseSelected');
  String get pickupPointWillBeConfirmed => get('pickupPointWillBeConfirmed');

  // ── Order detail ──
  String get orderStatusPending => get('orderStatusPending');
  String get orderStatusProcessing => get('orderStatusProcessing');
  String get orderStatusShipped => get('orderStatusShipped');
  String get orderStatusDelivered => get('orderStatusDelivered');
  String get orderStatusCancelled => get('orderStatusCancelled');
  String get orderStatusPendingDesc => get('orderStatusPendingDesc');
  String get orderStatusProcessingDesc => get('orderStatusProcessingDesc');
  String get orderStatusShippedDesc => get('orderStatusShippedDesc');
  String get orderStatusDeliveredDesc => get('orderStatusDeliveredDesc');
  String get orderStatusCancelledDesc => get('orderStatusCancelledDesc');
  String get orderNumber => get('orderNumber');
  String get date => get('date');
  String get items => get('items');
  String get trackingNumber => get('trackingNumber');
  String get trackingNumberCopied => get('trackingNumberCopied');
  String get paymentMethod => get('paymentMethod');
  String get paid => get('paid');
  String get subtotal => get('subtotal');
  String get shipping => get('shipping');
  String get refund => get('refund');
  String get total => get('total');
  String get qty => get('qty');

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

  // ── Settings ──
  String get thankYouOpeningStore => get('thankYouOpeningStore');
  String get clearCache => get('clearCache');
  String get clearCacheConfirm => get('clearCacheConfirm');
  String get cancel => get('cancel');
  String get cacheClearedSuccess => get('cacheClearedSuccess');
  String get clearAction => get('clearAction');
  String get logOut => get('logOut');
  String get logOutConfirm => get('logOutConfirm');
  String get appearance => get('appearance');
  String get privacySecurity => get('privacySecurity');
  String get about => get('about');
  String get orderUpdates => get('orderUpdates');
  String get promotionsSales => get('promotionsSales');
  String get priceDrops => get('priceDrops');
  String get chatMessages => get('chatMessages');
  String get changePhoneNumber => get('changePhoneNumber');
  String get privacyPolicy => get('privacyPolicy');
  String get termsOfService => get('termsOfService');
  String get appVersion => get('appVersion');
  String get rateTheApp => get('rateTheApp');
  String get shareWithFriends => get('shareWithFriends');
  String get deleteAccount => get('deleteAccount');
  String get deleteAccountConfirm => get('deleteAccountConfirm');

  // ── Contact ──
  String get copiedToClipboard => get('copiedToClipboard');

  // ── Chat ──
  String get reply => get('reply');
  String get copy => get('copy');

  // ── Try-on ──
  String get photoAdded => get('photoAdded');
  String get removePhoto => get('removePhoto');
  String get removePhotoConfirm => get('removePhotoConfirm');
  String get remove => get('remove');
  String get addPhoto => get('addPhoto');
  String get tryOn => get('tryOn');
  String get tryAgain => get('tryAgain');
  String get done => get('done');

  // ── Promo ──
  String get codeCopied => get('codeCopied');
  String get viewOrder => get('viewOrder');
  String get expired => get('expired');
  String get promoAppliedAtCheckout => get('promoAppliedAtCheckout');
  String get useThisCode => get('useThisCode');

  // ── Custom order ──
  String get fillMeasurementsRequired => get('fillMeasurementsRequired');
  String get fillAllFieldsRequired => get('fillAllFieldsRequired');
  String get agreeToTermsRequired => get('agreeToTermsRequired');
  String get newDesign => get('newDesign');
  String get measurementsSaved => get('measurementsSaved');
  String get yourDesign => get('yourDesign');
  String get measurements => get('measurements');
  String get tailoringDetails => get('tailoringDetails');
  String get totalPrice => get('totalPrice');

  // ── Preferences ──
  String get preferencesSaved => get('preferencesSaved');
  String get seasonalPreferencesSaved => get('seasonalPreferencesSaved');
  String get preferencesBySeason => get('preferencesBySeason');
  String get preferencesBySeasonDesc => get('preferencesBySeasonDesc');
  String get save => get('save');
  String get skip => get('skip');
  String get whoIsThisFor => get('whoIsThisFor');
  String get selectAllThatApply => get('selectAllThatApply');
  String get seasonAndWeather => get('seasonAndWeather');
  String get pickAllConditions => get('pickAllConditions');
  String get whatsYourStyle => get('whatsYourStyle');
  String get pickStylesMatch => get('pickStylesMatch');
  String get whatWeatherDressFor => get('whatWeatherDressFor');
  String get whereDoYouWear => get('whereDoYouWear');
  String get tellUsLifestyle => get('tellUsLifestyle');
  String get whatDoYouWear => get('whatDoYouWear');
  String get pickCategoriesShop => get('pickCategoriesShop');
  String get fabricPreferences => get('fabricPreferences');
  String get whatMaterialsLove => get('whatMaterialsLove');

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
    AppLocale.en: appLocalizationsEn,
    AppLocale.ru: appLocalizationsRu,
    AppLocale.uz: appLocalizationsUz,
  };
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get tr =>
      AppLocalizations(read<AppSettingsCubit>().state.locale);
}
