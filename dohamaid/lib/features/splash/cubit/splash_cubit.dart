import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  // BUG FIX 1: Removed startSplashAnimation() from constructor.
  // It was also called via ..startSplashAnimation() in main.dart,
  // causing two concurrent animation loops and double-emit crashes.
  SplashCubit() : super(SplashInitial());

  Future<void> startSplashAnimation() async {
    for (double s = 0; s <= 1; s += 0.05) {
      if (isClosed) return; // BUG FIX 2: guard emit-after-close
      emit(SplashAnimating(logoScale: s, textOpacity: 0, textOffset: 40));
      await Future.delayed(const Duration(milliseconds: 25));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    for (double o = 0; o <= 1; o += 0.05) {
      if (isClosed) return;
      emit(SplashAnimating(
        logoScale: 1,
        textOpacity: o,
        textOffset: 40 * (1 - o),
      ));
      await Future.delayed(const Duration(milliseconds: 25));
    }
    await Future.delayed(const Duration(seconds: 1));
    if (isClosed) return;
    emit(SplashFinished());
  }
}
