
class WelcomeState {
  final double logoOpacity;
  final double textOpacity;
  final double buttonsOpacity;

  WelcomeState({
    required this.logoOpacity,
    required this.textOpacity,
    required this.buttonsOpacity,
  });

  WelcomeState copyWith({
    double? logoOpacity,
    double? textOpacity,
    double? buttonsOpacity,
  }) {
    return WelcomeState(
      logoOpacity: logoOpacity ?? this.logoOpacity,
      textOpacity: textOpacity ?? this.textOpacity,
      buttonsOpacity: buttonsOpacity ?? this.buttonsOpacity,
    );
  }
}