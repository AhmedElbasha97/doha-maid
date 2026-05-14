     import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../core/presentation/cubit/localization_cubit.dart';
import '../../../../core/utils/responsive.dart';
import '../cubit/verification_code_cubit.dart';
import '../cubit/verification_code_state.dart';
import 'package:dohamaid/core/config/app_color.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  @override
  void initState() {
    super.initState();


    final cubit = context.read<VerificationCodeCubit>();

    cubit.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationCodeCubit, VerificationCodeState>(
      builder: (context, state) {
        final cubit = context.read<VerificationCodeCubit>();
        if(state is VerificationCodeInitial){
          return Scaffold(
            backgroundColor:  AppColor.authBackground,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      "assets/logo with out background.png",
                      height: 140,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "verification_code_title".tr(),
                      style:  TextStyle(
                        fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "otp_title".tr() + cubit.phoneNumber,
                                textAlign: TextAlign.right,
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.mainColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              4,
                                  (index) =>
                                  SizedBox(
                                    width: 38,
                                    height: 48,
                                    child: TextField(
                                      controller: context
                                          .read<VerificationCodeCubit>()
                                          .controllers[index],
                                      focusNode: context
                                          .read<VerificationCodeCubit>()
                                          .focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) =>
                                          context
                                              .read<
                                              VerificationCodeCubit>()
                                              .onCodeChanged(index, value),
                                      decoration: InputDecoration(

                                        contentPadding: EdgeInsets.zero,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          borderSide: const BorderSide(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              5),
                                          borderSide: const BorderSide(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              cubit.verifyCode(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cubit.isResendingOTPCode
                                  ? AppColor.grey
                                  :  AppColor.mainColor,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "verification_confirm_button".tr(),
                              style:  TextStyle(
                                fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                fontSize: 18,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "${"resend_after".tr()} ${cubit
                                .remainingSeconds} ${"seconds".tr()}",
                            style:  TextStyle(
                              fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                              fontSize: 16,
                              color: AppColor.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    cubit.isResendingOTPCode?Container(
                        width:screenWidth(context)*0.24,
                        height:screenHeight(context)*0.07,
                        decoration: const BoxDecoration( color:  AppColor.mainColor, shape: BoxShape.circle ),
                        child: const Padding( padding: EdgeInsets.all(8.0),
                          child: Center( child: CircularProgressIndicator(color: AppColor.white, ), ),)
                    ):ElevatedButton(
                      onPressed:  (cubit.remainingSeconds != 0 )
                          ? (){
                        print("object");
                      }
                          : () {
                        cubit.resendingCode(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (cubit.remainingSeconds!=0)
                            ? AppColor.grey
                            :  AppColor.mainColor,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "resend_code_button".tr(),
                              style:  TextStyle(
                                fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                fontSize: 18,
                                color: AppColor.white,
                              ),
                            ),SizedBox(width: 10,),Icon(
                              Icons.refresh,
                              color: AppColor.secondaryColor,
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
