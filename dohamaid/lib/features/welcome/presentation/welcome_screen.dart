import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/cubit/localization_cubit.dart';
import '../../auth/sign_in/presentation/log_in_screen.dart';
import '../../auth/sign_up/presentation/regestier_screen.dart';

import '../../home/presentation/home_screen.dart';
import '../cubit/welcome_cuibit.dart';
import '../cubit/welcome_state.dart';
import '../widget/button_widget.dart';
import 'package:dohamaid/core/config/app_color.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeCubit()..startAnimation(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<WelcomeCubit, WelcomeState>(
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                        settings: const RouteSettings(name: "HomeScreen"),)
                                  );
                                },
                                child:  Row(
                                  children: [
                                    Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(

                                            decoration: BoxDecoration(
                                              color:  AppColor.mainColor,

                                              borderRadius: BorderRadius.circular(50),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: AppColor.grey,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 1), // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Icon(Icons.home,color: AppColor.white,size: 15,),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                  Text("skipToHomeBTN".tr(),
                                      textAlign: TextAlign.center,
                                      style:   TextStyle(
                                      fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                               color: AppColor.mainColor,

                                          fontWeight: FontWeight.w800,
                                          fontSize: 13),),


                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  context.read<LocalizationCubit>().toggleLanguage(context);

                                  // Update EasyLocalization


                                  final newLocale = context.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
                                  context.setLocale(newLocale);

                                },
                                child:  Row(
                                  children: [

                                    Text("languageWelcomeBTN".tr(),
                                      textAlign: TextAlign.center,
                                      style:   TextStyle(
                                          fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                                          color: AppColor.mainColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15),),
                                    const SizedBox(width: 10,),
                                    Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),

                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(

                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color:  AppColor.mainColor,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: AppColor.grey,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 1), // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Icon(Icons.translate,color: AppColor.white,size: 15,),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),


                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: state.logoOpacity,
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Image.asset("assets/logo with out background.png", scale: 1.2),
                            ],
                          ),
                        ),

                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: state.textOpacity,
                          child:  Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                  "welcome_title".tr(),

                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: state.buttonsOpacity,
                          child: Column(
                            children: [
                              buildButton(
                                context,
                                text: "sign_in".tr(),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                      settings: const RouteSettings(name: "LoginScreen"),)
                                ),
                              ),
                              const SizedBox(height: 12),
                              buildButton(
                                context,
                                text: "sign_up".tr(),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                      settings: const RouteSettings(name: "RegisterScreen"),)
                                ),
                                ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


}
