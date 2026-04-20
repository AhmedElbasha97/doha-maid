import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) {
    startSplashAnimation();
  }

  Future<void> startSplashAnimation() async {
    // LOGO SCALE 0 → 1
    for (double s = 0; s <= 1; s += 0.05) {
      emit(SplashAnimating(
        logoScale: s,
        textOpacity: 0,
        textOffset: 40, // hidden down
      ));
      await Future.delayed(const Duration(milliseconds: 25));
    }

    // SMALL PAUSE
    await Future.delayed(const Duration(milliseconds: 300));

    // TEXT OPACITY + SLIDE
    for (double o = 0; o <= 1; o += 0.05) {
      emit(SplashAnimating(
        logoScale: 1,
        textOpacity: o,
        textOffset: 40 * (1 - o), // from 40 → 0
      ));
      await Future.delayed(const Duration(milliseconds: 25));
    }

    // WAIT THEN NAVIGATE
    await Future.delayed(const Duration(seconds: 1));
    emit(SplashFinished());
  }
}
