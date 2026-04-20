import 'package:dohamaid/features/auth/verification_code/presentation/verification_code_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/datasources/storage_local_data_source.dart';
import '../../home/presentation/home_screen.dart';
import '../../welcome/presentation/welcome_screen.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import 'package:dohamaid/core/config/app_color.dart';

class SplashScreen extends StatelessWidget {
   const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashFinished) {
          if(StorageLocalDataSource.instance.userSignedIn() ) {

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen(),    settings: const RouteSettings(name: "HomeScreen"),
              ),
                  (route) => false,
            );
          }else {
            if(StorageLocalDataSource.instance.getOtpVerification() ){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const VerificationCodeScreen(),    settings: const RouteSettings(name: "VerificationCodeScreen"),
                ),
                    (route) => false,
              );
            }else{
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen(),    settings: const RouteSettings(name: "WelcomeScreen"),
                ),
                    (route) => false,
              );}

          }
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              if (state is SplashAnimating) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: state.logoScale,
                      child: Image.asset(
                        "assets/logo with out background.png",
                        height: 130,
                      ),
                    ),
                    const SizedBox(height: 100),
                    Opacity(
                      opacity: state.textOpacity,
                      child: Transform.translate(
                        offset: Offset(0, state.textOffset),
                        child:  Text(
              "splash_subtitle".tr()
                          ,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColor.mainColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
