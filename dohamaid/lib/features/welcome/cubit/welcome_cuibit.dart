import 'package:dohamaid/features/welcome/cubit/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit()
      : super(WelcomeState(logoOpacity: 0, textOpacity: 0, buttonsOpacity: 0));

  // BUG FIX 6: resetState previously called _navigateIfNotOpen which had
  // inverted logic — it navigated when screen WAS already open, and did
  // nothing when it wasn't. This caused infinite navigation loops on
  // language toggle. Now it simply resets and replays the animation.
  void resetState() {
    emit(WelcomeState(logoOpacity: 0, textOpacity: 0, buttonsOpacity: 0));
    startAnimation();
  }

  void startAnimation() async {
    if (isClosed) return; // BUG FIX 7: guard emit-after-close
    await Future.delayed(const Duration(milliseconds: 300));
    if (isClosed) return;
    emit(state.copyWith(logoOpacity: 1));

    await Future.delayed(const Duration(milliseconds: 300));
    if (isClosed) return;
    emit(state.copyWith(textOpacity: 1));

    await Future.delayed(const Duration(milliseconds: 300));
    if (isClosed) return;
    emit(state.copyWith(buttonsOpacity: 1));
  }
}
