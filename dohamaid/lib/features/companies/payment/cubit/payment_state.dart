// ============================================================
//  payment_state.dart
// ============================================================

enum PaymentMethod { online, cash, wallet }

// Sub-method required when wallet balance < order total.
// null means no sub-method needed (wallet covers the full amount).
enum SubPaymentMethod { online, cash }

abstract class PaymentState {}

class PaymentInitialState extends PaymentState {}

class PaymentLoadedState extends PaymentState {
  PaymentLoadedState({
    this.method = PaymentMethod.cash,
    this.subMethod,         // only set when wallet is primary but insufficient
    this.promoCode = '',
    this.policyAgreed = false,
    this.walletBalance = 0,
    this.orderTotal = 0,
  });

  final PaymentMethod method;
  final SubPaymentMethod? subMethod;
  final String promoCode;
  final bool policyAgreed;
  final double walletBalance;
  final double orderTotal;

  // ── Derived helpers ───────────────────────────────────────────────────

  /// Whether the wallet option should be shown at all.
  bool get showWallet => walletBalance > 0;

  /// Wallet covers the ENTIRE order — no sub-method needed.
  bool get walletCoversAll => walletBalance >= orderTotal;

  /// Wallet is selected but only covers part of the order.
  bool get walletIsPartial => method == PaymentMethod.wallet && !walletCoversAll;

  /// Amount still owed after using the wallet.
  double get remainingAfterWallet =>
      walletIsPartial ? (orderTotal - walletBalance).clamp(0, double.infinity) : 0;

  /// The form is fully filled in — primary method chosen,
  /// and if wallet is partial a sub-method is also chosen.
  bool get isSelectionComplete {
    if (method == PaymentMethod.wallet && walletIsPartial) {
      return subMethod != null;
    }
    return true; // cash or online are always complete on their own
  }

  PaymentState copyWith({
    PaymentMethod? method,
    SubPaymentMethod? subMethod,
    bool clearSubMethod = false,
    String? promoCode,
    bool? policyAgreed,
    double? walletBalance,
    double? orderTotal,
  }) {
    return PaymentLoadedState(
      method: method ?? this.method,
      subMethod: clearSubMethod ? null : (subMethod ?? this.subMethod),
      promoCode: promoCode ?? this.promoCode,
      policyAgreed: policyAgreed ?? this.policyAgreed,
      walletBalance: walletBalance ?? this.walletBalance,
      orderTotal: orderTotal ?? this.orderTotal,
    );
  }
}