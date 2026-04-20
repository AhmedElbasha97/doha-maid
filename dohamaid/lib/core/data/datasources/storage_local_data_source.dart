
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StorageLocalDataSource {
  final SharedPreferences prefs;
  StorageLocalDataSource._(this.prefs);

  static late final StorageLocalDataSource instance;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance = StorageLocalDataSource._(prefs);
  }

  static SharedPreferences get prefsSync => instance.prefs;

  // 🌍 Locale management
  static const activeLocaleKey = 'ACTIVE_LOCALE';
  static const onboardingKey = 'ONBOARDING_DONE';
  static const themeModeKey = 'THEME_MODE'; // ✅ Added key for theme
  static const userTokenKey = 'User_token';
static const otpVerificationKey = 'otp_verification';
static const userPhoneNumberKey = 'user_phone_number';
static const userCountryCodeKey = 'user_country_code';


  Future<void> saveLocaleCode(String code) async {
    await prefsSync.setString(activeLocaleKey, code);
  }

  String getSavedLocaleCode()  {
    return prefsSync.getString(activeLocaleKey)??"";
  }



  Future<void> setActiveLocale(Locale locale) async =>
      prefsSync.setString(activeLocaleKey, locale.languageCode);
  Future<void> setUserToken(String userId ) async =>
      prefsSync.setString(userTokenKey, userId);
  Future<void> setOtpVerification(bool otpVerification ) async =>
      prefsSync.setBool(otpVerificationKey, otpVerification);
  Future<void> setUserPhoneNumber(String phoneNumber ) async =>
      prefsSync.setString(userPhoneNumberKey, phoneNumber);
  Future<void> setUserCountryCode(String countryCode ) async =>
      prefsSync.setString(userCountryCodeKey, countryCode);

  // 🚀 Onboarding management
  bool get onboardingCompleted => prefsSync.getBool(onboardingKey) ?? false;
  Future<void> setOnboardingCompleted() async =>
      prefsSync.setBool(onboardingKey, true);
  bool userSignedIn()  =>
      prefsSync.containsKey(userTokenKey);

  // 🌗 Theme management (NEW)
  bool getThemeIsDark() {
    return prefsSync.getBool(themeModeKey) ?? false;
  }
  String getUserToken() {
    return prefsSync.getString(userTokenKey) ?? "";
  }
  bool getOtpVerification() {
    return prefsSync.getBool(otpVerificationKey) ?? false;
  }
  String getUserPhoneNumber() {
    return prefsSync.getString(userPhoneNumberKey) ?? "";
  }
  String getUserCountryCode() {
    return prefsSync.getString(userCountryCodeKey) ?? "";
  }
  Future<void> loggingOut() async {
     await prefsSync.remove(userTokenKey);
  }
  Future<void> theUserVerified() async{
    await prefsSync.remove(otpVerificationKey);
    await prefsSync.remove(userPhoneNumberKey);
    await prefsSync.remove(userCountryCodeKey);
  }
  Future<void> saveThemeIsDark(bool isDark) async {
    await prefsSync.setBool(themeModeKey, isDark);
  }
}
