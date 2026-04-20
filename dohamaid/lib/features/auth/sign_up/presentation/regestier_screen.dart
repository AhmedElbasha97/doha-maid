// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validation.dart';
import '../../../../loader.dart';

import '../../../webview/web_view.dart';
import '../../sign_in/presentation/log_in_screen.dart';
import '../cubit/regestier_cubit.dart';
import '../cubit/regestier_state.dart';
import 'package:dohamaid/core/config/app_color.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();


    final cubit = context.read<RegisterCubit>();

    cubit.getCountriesCodes(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColor.authBackground,
      body:BlocBuilder<RegisterCubit, RegisterStates>(

            builder: (context, state) {
              final cubit = context.read<RegisterCubit>();
              if (state is RegisterLoading) {
                return const Loader();
              }

              if (state is RegisterError) {
                return Center(child: Text(state.message,style: const TextStyle(color: AppColor.red),));
              }

              if (state is RegisterLoaded ) {
                return

                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: [
                            const SizedBox(height: 80),

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
                              "register_title".tr(),
                              style: const TextStyle(
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
                                      focusNode: cubit.nameFocusNode,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(cubit.phoneFocusNode);
                                      },
                                      controller: cubit.nameController,
                                      validator: Validation.validateName,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        errorMaxLines: 3, // <-- Allow multiple lines for errors

                                        labelText:"full_name_label".tr(),
                                        prefixIcon: const Icon(Icons.person_outline, color: AppColor.secondaryColor),
                                        border: OutlineInputBorder(

                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    TextFormField(
                                      controller: cubit.phoneController,
                                      focusNode: cubit.phoneFocusNode,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(cubit.emailFocusNode);
                                      },
                                      validator: Validation.validatePhoneNumber,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        suffixIcon: cubit.isFoundCountry? InkWell(
                                          onTap: (){
                                            cubit. choosingCountryCode( context);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "   ${cubit.selectedCountryCode?.code??"wait"}    ",
                                                style: TextStyle(
                                                  fontSize: 15.0,

                                                  color:AppColor.mainColor,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ):
                                        InkWell(
                                          onTap: (){
                                            cubit. choosingCountryCode( context);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.warning_amber,color: AppColor.secondaryColor,),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              Text(
                                                "choose",
                                                style: TextStyle(
                                                  fontSize: 15.0,

                                                  color: AppColor.mainColor,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        errorMaxLines: 3, // <-- Allow multiple lines for errors

                                        labelText: "phone".tr(),
                                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColor.secondaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: cubit.emailController,
                                      validator: Validation.validateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: cubit.emailFocusNode,
                                       textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(cubit.passwordFocusNode);
                                      },
                                      decoration: InputDecoration(
                                        errorMaxLines: 3, // <-- Allow multiple lines for errors

                                        labelText: "email_label".tr(),
                                        prefixIcon: const Icon(Icons.email_outlined ,color: AppColor.secondaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: cubit.passwordController,
                                      obscureText: cubit.showPassword,
                                      keyboardType: TextInputType.visiblePassword,
                                      validator: Validation.validatePassword,
                                      focusNode: cubit.passwordFocusNode,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) {
                                        cubit.passwordFocusNode.unfocus();
                                      },

                                      decoration: InputDecoration(
                                        errorMaxLines: 3, // <-- Allow multiple lines for errors

                                        labelText: "password_label".tr(),
                                        prefixIcon: const Icon(Icons.lock_outline, color: AppColor.secondaryColor),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            cubit.showPassword
                                                ? Icons.visibility_off:Icons.visibility,
                                            color: AppColor.secondaryColor,
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

                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          fillColor: MaterialStateProperty.all<Color>( AppColor.mainColor),

                                          groupValue: cubit.val,
                                          onChanged: (value) {
                                            cubit.changeValueOfRadioBTN(value,context);
                                          },
                                          toggleable: true,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "readAppPolicyAndTerms".tr(),  style:  const TextStyle(

                                                color: AppColor.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>  const WebViewContainer( "https://dohamaid.com/qa/ar/page/3/mobile"),
                                                        settings: const RouteSettings(name: "webView"),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "privacyPolicy".tr(),
                                                    style:  const TextStyle(

                                                        color: AppColor.mainColor,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Text(
                                                  "and".tr(),  style:  const TextStyle(

                                                    color: AppColor.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),),

                                              ],
                                            ),
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>  const WebViewContainer( "https://dohamaid.com/qa/ar/page/10/mobile"),
                                                    settings: const RouteSettings(name: "webView"),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "termsAndCondition".tr(),
                                                style:  const TextStyle(

                                                    color: AppColor.mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 25),

                                    state is RegisterLoading
                                        ? Container(
                                        decoration: const BoxDecoration( color:  AppColor.mainColor, shape: BoxShape.circle ),
                                        child: const Padding( padding: EdgeInsets.all(8.0),
                                          child: Center( child: CircularProgressIndicator(color: AppColor.white, ), ),)
                                    )
                                        : ElevatedButton(
                                      onPressed: () => cubit.register(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:  AppColor.mainColor,
                                        minimumSize: const Size(double.infinity, 55),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child:  Text(
                                        "register_title".tr(),
                                        style: const TextStyle(fontSize: 18, color: AppColor.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("have_account_prompt".tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                      settings: const RouteSettings(name: "LoginScreen"),),
                                  ),

                                  child:  Text(
                                    "login_title".tr(),
                                    style: const TextStyle(
                                      color: AppColor.mainColor,
                                      fontSize: 16,
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

              }
              return const SizedBox();
            },
      ),
    );
  }
}
