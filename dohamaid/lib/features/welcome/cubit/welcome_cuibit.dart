import 'package:dohamaid/features/welcome/cubit/welcome_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/welcome_screen.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit()
      : super(
    WelcomeState(logoOpacity: 0, textOpacity: 0, buttonsOpacity: 0),
  );
  bool isScreenAlreadyOpen(BuildContext context, Type screenType) {
    bool isOpen = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == "$screenType") {
        isOpen = true;
      }
      return true;
    });

    return isOpen;
  }
  void _navigateIfNotOpen(
      BuildContext context, {
        required Widget screen,
        required String routeName,
      }) {
    if (isScreenAlreadyOpen(context, screen.runtimeType)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen(),    settings: const RouteSettings(name: "WelcomeScreen"),
        ),
            (route) => false,
      );

    }
  }
  void resetState(BuildContext context) {
    _navigateIfNotOpen(
      context,
      screen: const WelcomeScreen(),
      routeName: "WelcomeScreen",
    );// or reload data as needed
  }
  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(logoOpacity: 1));

    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(textOpacity: 1));

    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(buttonsOpacity: 1));
  }
}