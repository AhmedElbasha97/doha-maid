import 'dart:async';

import 'package:dohamaid/features/home/presentation/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../core/services/auth_services.dart';
import '../../data/auth_model.dart';
import '../../data/otp_model.dart';
import 'verification_code_state.dart';
import 'package:dohamaid/core/config/app_color.dart';

class VerificationCodeCubit extends Cubit<VerificationCodeState> {
  VerificationCodeCubit() : super(VerificationCodeInitial());

  static VerificationCodeCubit get(BuildContext context) => BlocProvider.of(context);
  Timer? _timer;
  int remainingSeconds = 60;
  String phoneNumber = StorageLocalDataSource.instance.getUserPhoneNumber();
  bool isResendingOTPCode = false;
  void resetTimer() {
    startTimer();
  }
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );
  void startTimer() {
    remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        emit(VerificationCodeInitial());

      } else {
        timer.cancel();
        emit(VerificationCodeInitial());

      }
    });
    emit(VerificationCodeInitial());
  }
  Future<void> resendingCode(BuildContext context) async {

    if(isResendingOTPCode){

    }else {
      isResendingOTPCode = true;
      emit(VerificationCodeInitial());
      final OtpModel? data = await AuthServices(ApiService()).resendingOtp(StorageLocalDataSource.instance.getUserPhoneNumber(),StorageLocalDataSource.instance.getUserCountryCode());

      if (data?.success == true) {
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.check, color: AppColor.white,),
          const SizedBox(width: 10,),
          Text(context.locale.languageCode == 'en'  ? 'The OTP Code has been sent successfully'
              : 'تم إرسال رمز التحقق بنجاح', style: const TextStyle(
              color: AppColor.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: AppColor.green
        );
        emit(VerificationCodeInitial());
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isResendingOTPCode = false;
        resetTimer();
        emit(VerificationCodeInitial());
      }
      else {
        final snackBar = SnackBar(content:
        Row(children: [
          const Icon(Icons.close, color: AppColor.white,),
          const SizedBox(width: 10,),
          Text(context.locale.languageCode == 'en'  ? 'An error occurred while Resending the otp code'
              : 'حدث خطأ أثناء إعادة إرسال رمز التحقق', style: const TextStyle(
              color: AppColor.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor: AppColor.red
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isResendingOTPCode = false;
        resetTimer();
        emit(VerificationCodeInitial());
      }
    }
  }
  Future<void> verifyCode(BuildContext context) async {
    if (controllers.every((controller) => controller.text.isNotEmpty)) {
      final otp = controllers.map((controller) => controller.text).join();




        try {
          AuthModel? authData = await AuthServices(ApiService()).checkingOtp( StorageLocalDataSource.instance.getUserPhoneNumber(), otp);
          if (authData == null|| authData.success == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColor.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        (authData?.data?.error?.isEmpty??true)||(authData?.data?.error=="")?  ((context.locale.languageCode == 'en' ) ? 'An error occurred when checking the otp code'
                            : 'حدث خطأ أثناء التحقق رمز التحقق'):(authData?.data?.error??""),
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
            await StorageLocalDataSource.instance.theUserVerified();
            await StorageLocalDataSource.instance.setUserToken(authData.data?.token ?? "");

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
              MaterialPageRoute(builder: (_) => const HomeScreen(),    settings: const RouteSettings(name: "HomeScreen"),
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
    }

  void onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }


  @override
  Future<void> close() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    return super.close();
  }
}
