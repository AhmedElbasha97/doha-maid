// ignore_for_file: use_build_context_synchronously

import 'package:dohamaid/features/auth/sign_up/cubit/regestier_state.dart';
import 'package:dohamaid/features/auth/sign_up/data/regestier_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../core/services/auth_services.dart';
import '../../../webview/web_view.dart';
import '../../data/auth_model.dart';
import '../../verification_code/presentation/verification_code_screen.dart';
import '../data/country_code_model.dart';
import 'package:dohamaid/core/config/app_color.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());

  int val = 0;
  Datum? selectedCountryCode;
CountryCodeModel? countriesCodesData;
  bool isFoundCountry = false;
  final phoneController = TextEditingController();

  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showPassword = true;
  void resetState() {
    emit( RegisterLoaded()); // or reload data as needed
  }
   void showingPassword(){
     showPassword = !showPassword;
     emit(RegisterLoaded());
   }
  Future<void> showPrivacyTermsDialog(BuildContext context) async {

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      padding: const EdgeInsets.all(20),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "accept_terms_title".tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          Text(
            "accept_terms_message".tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),

          const SizedBox(height: 20),

          // Privacy Policy Link
          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  const WebViewContainer( "https://dohamaid.com/qa/ar/page/3/mobile"),
                  settings: const RouteSettings(name: "webView"),
                ),
              );
            },
            child: Text(
              "privacy_policy".tr(),
              style: const TextStyle(
                color: AppColor.mainColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Terms Conditions Link
          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  const WebViewContainer( "https://dohamaid.com/qa/ar/page/10/mobile"),
                  settings: const RouteSettings(name: "webView"),
                ),
              );
            },
            child: Text(
              "terms_conditions".tr(),
              style: const TextStyle(
                color: AppColor.mainColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),

      // Buttons
      btnOkText: "accept".tr(),
      btnCancelText:"decline".tr(),

      btnOkOnPress: () {
        val = 1;
        // TODO: Save acceptance logic
      },

      btnCancelOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }
  void changeValueOfRadioBTN(int? value, BuildContext context) {
    if (val == 0) {
      val = 1;
    } else {
      val = 0;
    }
    emit(RegisterLoaded());
  }
  Future<void> getCountriesCodes(BuildContext context) async {
    try {
      emit(RegisterLoading());
      countriesCodesData = await AuthServices(ApiService()).getCountriesCodesServices();
      print(countriesCodesData?.data);
      if (countriesCodesData == null) {
        emit(RegisterError(" Try again"));

        return;
      }
      _getCurrentLocation(context);


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColor.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: AppColor.white, fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.errorShade, // Error color
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      emit(RegisterError(e.toString()));
    }
    emit(RegisterLoaded());

  }
  String tr(String ar, String en,BuildContext context) {
    return context.locale.languageCode == 'en'  ? en : ar;
  }
  void _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isFoundCountry = false;
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      isFoundCountry = false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isFoundCountry = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isFoundCountry = false;
      return;
    }

    // Permission granted, get location
    Position res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getAddressOfLocation(res.latitude, res.longitude);
  }
  void _showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("تشغيل الموقع", "Enable Location",context)),
        content: Text(tr(
          "خدمة الموقع غير مفعّلة. من فضلك فعّلها من الإعدادات.",
          "Location services are disabled. Please enable them from settings.",context
        )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: Text(tr("فتح الإعدادات", "Open Settings",context)),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("إذن الموقع مرفوض", "Location Permission Denied",context)),
        content: Text(tr(
          "نحتاج إذن الموقع لتشغيل هذه الميزة.",
          "Location permission is required to use this feature.",context
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr("حسناً", "OK",context)),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("إذن الموقع مرفوض دائمًا", "Permission Denied Forever",context)),
        content: Text(tr(
          "لقد قمت برفض إذن الموقع دائمًا. الرجاء السماح من إعدادات التطبيق.",
          "You have permanently denied location permission. Please allow it from app settings.",context
        )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: Text(tr("فتح إعدادات التطبيق", "Open App Settings",context)),
          ),
        ],
      ),
    );
  }
  Future<void> getAddressOfLocation(double lat,double long) async {
    List<Placemark> i =
    await placemarkFromCoordinates(lat, long);
    Placemark placeMark = i.first;


    for(var countryCode in ((countriesCodesData?.data)??[])){
      if(placeMark.country == countryCode.name){
        selectedCountryCode = countryCode;

        isFoundCountry = true;

      }
    }



  }

  void choosingAnotherCountryCode(Datum chosenCountryCode,BuildContext context){
    selectedCountryCode = chosenCountryCode;
    isFoundCountry = true;
emit(RegisterLoaded());
    Navigator.pop(context);
  }
  void choosingCountryCode(BuildContext context){
    showModalBottomSheet(
      context:context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer, builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: countriesCodesData?.data?.map((e){
                  return InkWell(
                    onTap: (){
                      choosingAnotherCountryCode(e, context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: AppColor.grey,
                                            blurRadius: 2,
                                            offset:
                                            Offset(1, 1), // Shadow position
                                          ),
                                        ],
                                        border: Border.all(
                                            color:  AppColor.mainColor, width: 1)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check_box,
                                        color: selectedCountryCode?.name==e.name
                                            ?  AppColor.mainColor
                                            : AppColor.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),

                              Text(
                                    "   ${e.name}    ",
                                    style: TextStyle(
                                      fontSize: 15.0,

                                      color: AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "   ${e.code}    ",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          e ==  countriesCodesData?.data?.last
                              ? const SizedBox()
                              : const Divider(
                            color:  AppColor.mainColor,
                            height: 1,
                            thickness: 1,
                            endIndent: 0,
                            indent: 0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()??[],
              ),
               SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      );
    },
    );
  }
  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if(val == 0){
      showPrivacyTermsDialog(context);
      return;
    }
    emit(RegisterLoading());

    try {


      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

    RegisterModel? authData = await AuthServices(ApiService()).signingUp(email, password, name,phoneController.text,"${selectedCountryCode?.countryId}");

      if (authData == null|| authData.success == false) {
        emit(RegisterLoaded());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColor.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      authData?.data??"",
                    style: const TextStyle(color: AppColor.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor.errorShade, // Error color
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }else  {
        // Save token to storage
        await StorageLocalDataSource.instance.setOtpVerification(true);
        await StorageLocalDataSource.instance.setUserPhoneNumber(phoneController.text);
        await StorageLocalDataSource.instance.setUserCountryCode("${selectedCountryCode?.countryId}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColor.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "register_success".tr(),
                    style: const TextStyle(color: AppColor.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor.successShade, // Success color
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating, // For a cleaner look
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        // Navigate to the home screen

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const VerificationCodeScreen(),    settings: const RouteSettings(name: "VerificationCodeScreen"),
        ),
              (route) => false,
        );

        return;
      }



    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColor.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: AppColor.white, fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.errorShade, // Error color
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
