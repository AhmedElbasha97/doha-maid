abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashAnimating extends SplashState {
  final double logoScale;
  final double textOpacity;
  final double textOffset; // slide position

  SplashAnimating({
    required this.logoScale,
    required this.textOpacity,
    required this.textOffset,
  });
}

class SplashFinished extends SplashState {}