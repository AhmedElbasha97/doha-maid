import 'package:dohamaid/core/utils/api_constant.dart';
import 'package:dohamaid/features/auth/data/auth_model.dart';

import '../../features/auth/data/data_model.dart';
import '../../features/auth/data/otp_model.dart';
import '../../features/auth/sign_up/data/country_code_model.dart';
import '../../features/auth/sign_up/data/regestier_model.dart';
import '../../features/profile_screen/data/profile_model.dart';
import '../data/datasources/api_service.dart';

class AuthServices {
  final ApiService api;
  AuthServices(this.api);

  Future<AuthModel?> loggingIn(String? email, String? password) async {
    final resp = await api.post(ApiConstant.loginLink,data: {
      "email": email,
      "password": password,
    });
    final data = resp.data;
    if (data == null) return null;
    return AuthModel.fromJson(data);
  }
  Future<AuthModel?> checkingOtp(String? phoneNumber, String? otp) async {
    final resp = await api.post(ApiConstant.checkingOtpLink,data: {
      "mobile": phoneNumber,
      "otp": otp,
    });
    final data = resp.data;
    if (data == null) return null;
    return AuthModel.fromJson(data);
  }
  Future<OtpModel?> resendingOtp(String? phoneNumber,String countryCode) async {
    final resp = await api.post(ApiConstant.resendingOtpLink,data: {
      "mobile": phoneNumber,
      "country_id": countryCode
    });
    final data = resp.data;
    if (data == null) return null;
    return OtpModel.fromJson(data);
  }

  Future<RegisterModel?> signingUp(String? email, String? password, String? name,String phoneNumber,String countryCode) async {
    final resp = await api.post(ApiConstant.regesteirLink,data: {
      "name": name,
      "email": email,
      "password": password,
      "mobile": phoneNumber,
      "country_id":countryCode,
    });
    final data = resp.data;
    if (data == null) return null;
    return RegisterModel.fromJson(data);
  }
  Future<DataModel?> deletingAnAccount() async {
    final resp = await api.get(ApiConstant.deletingLink,);
    final data = resp.data;
    if (data == null) return null;
    return DataModel.fromJson(data);
  }  Future<DataModel?> loggingOut() async {
    final resp = await api.get(ApiConstant.loggingOutLink,);
    final data = resp.data;
    if (data == null) return null;
    return DataModel.fromJson(data);
  }
  Future<CountryCodeModel?> getCountriesCodesServices() async {

    final resp = await api.get(ApiConstant.countryCodesLink,);
    final data = resp.data;
    if (data == null) return null;

    return CountryCodeModel.fromJson(data);
  }
  Future<ProfileModel?> getProfileData() async {
    final resp = await api.get(ApiConstant.profileLink,);
    final data = resp.data;
    if (data == null) return null;
    return ProfileModel.fromJson(data);
  }
}