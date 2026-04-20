enum PaymentMethod { online, cash, wallet }

abstract class PaymentState  {

}
class PaymentInitialState extends PaymentState {}
class PaymentLoadedState extends PaymentState {
   PaymentLoadedState({
    this.method = PaymentMethod.cash,
    this.promoCode = '',
    this.policyAgreed = false,
    this.walletBalance = 0,
  });

  final PaymentMethod method;
  final String promoCode;
  final bool policyAgreed;
  final int walletBalance;

  PaymentState copyWith({
    PaymentMethod? method,
    String? promoCode,
    bool? policyAgreed,
    int? walletBalance,
  }) {
    return PaymentLoadedState(
      method: method ?? this.method,
      promoCode: promoCode ?? this.promoCode,
      policyAgreed: policyAgreed ?? this.policyAgreed,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}