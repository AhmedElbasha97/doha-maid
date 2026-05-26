// ignore_for_file: deprecated_member_use

import  'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/cubit/localization_cubit.dart';
import '../../../../core/utils/validation.dart';
import '../../sign_up/presentation/regestier_screen.dart';
import '../cubit/log_in_cubit.dart';
import '../cubit/log_in_state.dart';
import 'package:dohamaid/core/config/app_color.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColor.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "login_success".tr(),
                        style:  TextStyle(color: AppColor.white, fontSize: 16,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
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
          }
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColor.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message,
                        style:  TextStyle(color: AppColor.white, fontSize: 16,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
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
        },
        builder: (context, state) {
          final cubit = LoginCubit.get(context);

          return Scaffold(
            backgroundColor:  AppColor.authBackground,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 100),

                    /// LOGO
                    Center(
                      child: Image.asset(
                        "assets/logo with out background.png",
                        height: 130,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TITLE
                     Text(
                      "login_button".tr(),
                      style:  TextStyle(  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainColor,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FORM CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: cubit.emailFocusNode,
                          textInputAction:
                               TextInputAction.next
                              ,
                         onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(cubit.passwordFocusNode);
                         },
                              controller: cubit.emailController,
                              validator: Validation.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "email_label".tr(),
                                prefixIcon: const Icon(Icons.email_outlined, color: AppColor.secondaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AppColor.mainColor,
                                  ),
                                ),
                                errorMaxLines: 3, // <-- Allow multiple lines for errors

                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: cubit.passwordController,
                              obscureText: cubit.showPassword,
                              focusNode: cubit.passwordFocusNode,
                              textInputAction: TextInputAction.done,
                               onFieldSubmitted: (_) {
                                cubit.passwordFocusNode.unfocus();
                                cubit.login(context);
                         },
                              keyboardType: TextInputType.visiblePassword,
                              validator: Validation.validatePassword,
                              decoration: InputDecoration(
                                errorMaxLines: 3, // <-- Allow multiple lines for errors

                                labelText: "password_label".tr(),
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColor.secondaryColor),
                                suffixIcon:IconButton(
                                  icon: Icon(
                                    cubit.showPassword
                                        ? Icons.visibility_off:Icons.visibility,
                                    color:  AppColor.secondaryColor,
                                  ),
                                  onPressed: () => cubit.showingPassword(),
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AppColor.mainColor,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),


                            state is LoginLoading
                                ?Container(
                                decoration: const BoxDecoration( color:  AppColor.mainColor, shape: BoxShape.circle ),
                                child: const Padding( padding: EdgeInsets.all(8.0),
                                  child: Center( child: CircularProgressIndicator( color:  AppColor.white), ),)
                            )
                                : ElevatedButton(
                              onPressed: () => cubit.login(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  AppColor.mainColor,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child:  Text(
                                "login_button".tr(),
                                style:  TextStyle(fontSize: 18,color: AppColor.white,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        "no_account_prompt".tr(),
                        style:  TextStyle(
                          fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                          fontSize: 12,
                        ),
                      ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                                settings: const RouteSettings(name: "RegisterScreen"),)
                          ),
                          child:  Text(
                            "create_account_button".tr(),
                            style:  TextStyle(
                              fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                              color: AppColor.mainColor,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
