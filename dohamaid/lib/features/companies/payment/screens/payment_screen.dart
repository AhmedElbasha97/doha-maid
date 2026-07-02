// ============================================================
//  payment_screen.dart
// ============================================================

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_color.dart';
import '../../../../core/presentation/cubit/localization_cubit.dart';
import '../../../../core/utils/responsive.dart';
import '../../../webview/web_view.dart';
import '../../booking_screens/data/booking_category_model.dart';
import '../../location_selection/data/address_model.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.address,
    this.totalPrice,
    required this.selectedServices,
    this.selectedHours,
    this.selectedWorkers,
    this.selectedDate,
    this.arrivalTime,
    this.note,
    required this.servicesId,
  });

  final String? totalPrice;
  final List<Datum>? selectedServices;
  final Datum? selectedHours;
  final Datum? selectedWorkers;
  final DateTime? selectedDate;
  final Datum? arrivalTime;
  final String? note;
  final String servicesId;
  final AddressModel? address;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().startingScreen(
      orderTotal: double.tryParse(widget.totalPrice ?? '0') ?? 0,
    );
  }

  String? _servicesSummary() {
    if (widget.selectedServices?.isEmpty ?? true) return "sampleServices".tr();
    return widget.selectedServices?.map((e) => e.name ?? "").join(', ');
  }

  String get formattedDate {
    if (widget.selectedDate == null) return '';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final d = widget.selectedDate!;
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year.toString().substring(2)}';
  }

  String get formattedDateTime => widget.selectedDate != null && widget.arrivalTime != null
      ? '$formattedDate - ${widget.arrivalTime?.name}'
      : '';

  String get _fontFamily =>
      context.read<LocalizationCubit>().isArabic() ? "Cairo" : "Montserrat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.appBarBackground,
        elevation: 3,
        title: Image.asset("assets/logo with out background.png", scale: 4.5),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColor.mainColor),
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'drawer',
              pageBuilder: (ctx, anim1, anim2) => BlocProvider(
                create: (_) => DrawerCubit()..load(),
                child: const CustomDrawer(),
              ),
              transitionBuilder: (ctx, anim, _, child) =>
                  FadeTransition(opacity: anim, child: child),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_forward_ios, color: AppColor.mainColor),
          ),
        ],
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, payment) {
          if (payment is! PaymentLoadedState) return const SizedBox();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Booking info ────────────────────────────────────
                  Text("bookingInfo".tr(),
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: _fontFamily,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimaryDark)),
                  const SizedBox(height: 16),
                  _InfoRow(label: "dayAndTime".tr(), value: formattedDateTime),
                  _Divider(),
                  _InfoRow(label: "services".tr(), value: _servicesSummary() ?? ""),
                  _Divider(),
                  _InfoRow(
                      label: "yourNotes".tr(),
                      value: widget.note?.isEmpty ?? true ? '-' : widget.note ?? ""),
                  const SizedBox(height: 24),

                  // ── Address ─────────────────────────────────────────
                  Text("address".tr(),
                      style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          color: AppColor.textSecondaryDark,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    widget.address != null && widget.address!.displayAddress.isNotEmpty
                        ? widget.address!.displayAddress
                        : "sampleAddress".tr(),
                    style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 16,
                        color: AppColor.textPrimaryDark,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 28),

                  // ── Payment method section ──────────────────────────
                  Text("paymentMethod".tr(),
                      style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimaryDark)),
                  const SizedBox(height: 14),

                  // ── Wallet option (hidden if balance == 0) ──────────
                  if (payment.showWallet) ...[
                    _WalletOption(
                      payment: payment,
                      fontFamily: _fontFamily,
                      onTap: () => context.read<PaymentCubit>().setMethod(PaymentMethod.wallet),
                    ),
                    const SizedBox(height: 10),

                    // Sub-method selector (appears only when wallet is
                    // selected and doesn't fully cover the order total)
                    if (payment.walletIsPartial) ...[
                      _SubMethodSelector(
                        payment: payment,
                        fontFamily: _fontFamily,
                        onSelectOnline: () => context.read<PaymentCubit>().setSubMethod(SubPaymentMethod.online),
                        onSelectCash: () => context.read<PaymentCubit>().setSubMethod(SubPaymentMethod.cash),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],

                  // ── Cash ────────────────────────────────────────────
                  (payment.walletIsPartial&&payment.method == PaymentMethod.wallet)?SizedBox(): _PaymentOption(
                    label: "cashPayment".tr(),
                    icon: Icons.payments_outlined,
                    selected: payment.method == PaymentMethod.cash,
                    onTap: () => context.read<PaymentCubit>().setMethod(PaymentMethod.cash),
                    fontFamily: _fontFamily,
                  ),
                  const SizedBox(height: 10),

                  // ── Online / credit card ─────────────────────────────
                  (payment.walletIsPartial&&payment.method == PaymentMethod.wallet)?SizedBox():_PaymentOption(
                    label: "onlinePayment".tr(),
                    icon: Icons.credit_card_rounded,
                    selected: payment.method == PaymentMethod.online,
                    onTap: () {
                      context.read<PaymentCubit>().setMethod(PaymentMethod.online);
                    },
                    fontFamily: _fontFamily,
                  ),

                  const SizedBox(height: 28),

                  // ── Summary ─────────────────────────────────────────
                  Text("paymentSummary".tr(),
                      style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimaryDark)),
                  const SizedBox(height: 12),
                  _SummaryRow(
                      label: "serviceFees".tr(),
                      value: '${widget.totalPrice} ${"currencyQAR".tr()}'),

                  // If wallet is partial, show the split breakdown
                  if (payment.walletIsPartial) ...[
                    const SizedBox(height: 6),
                    _SummaryRow(
                        label: "walletDeduction".tr(),
                        value: '- ${payment.walletBalance.toStringAsFixed(2)} ${"currencyQAR".tr()}',
                        valueColor: Colors.green),
                    _SummaryRow(
                        label: "remainingAmount".tr(),
                        value: '${payment.remainingAfterWallet.toStringAsFixed(2)} ${"currencyQAR".tr()}',
                        valueColor: AppColor.errorShade),
                  ],

                  const SizedBox(height: 8),
                  _SummaryRow(
                      label: "totalAmount".tr(),
                      value: '${widget.totalPrice} ${"currencyQAR".tr()}'),
                  const SizedBox(height: 20),

                  // ── Policy checkbox ──────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: payment.policyAgreed,
                        onChanged: (v) =>
                            context.read<PaymentCubit>().setPolicyAgreed(v ?? false),
                        activeColor: AppColor.secondaryColor,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WebViewContainer('https://dohamaid.com/qa/ar/page/13/mobile'),
                              settings: const RouteSettings(name: "WebViewContainer"),
                            ),
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontFamily: _fontFamily,
                                  color: AppColor.textPrimaryDark,
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                    text: "cancellationPolicyAgree".tr(),
                                    style: TextStyle(
                                        fontFamily: _fontFamily,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: ' ${"cancellationPolicyLink".tr()}',
                                    style: TextStyle(
                                        fontFamily: _fontFamily,
                                        decoration: TextDecoration.underline,
                                        color: AppColor.secondaryColor,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Submit button ────────────────────────────────────
                  context.read<PaymentCubit>().isSendingReservation
                      ? Center(
                    child: SizedBox(
                      width: screenWidth(context) * 0.24,
                      height: screenHeight(context) * 0.07,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                            color: AppColor.mainColor, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<PaymentCubit>().startSendingReservation(
                          context,
                          widget.totalPrice,
                          widget.selectedServices,
                          widget.selectedHours,
                          widget.selectedWorkers,
                          widget.selectedDate,
                          widget.arrivalTime,
                          widget.note,
                          widget.address,
                          payment.policyAgreed,
                          widget.servicesId,
                        );
                      },
                      child: Text("requestService".tr(),
                          style: TextStyle(
                              color: AppColor.white,
                              fontFamily: _fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
//  Wallet payment option — shows balance + full/partial badge
// ============================================================================
class _WalletOption extends StatelessWidget {
  final PaymentLoadedState payment;
  final String fontFamily;
  final VoidCallback onTap;

  const _WalletOption({
    required this.payment,
    required this.fontFamily,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = payment.method == PaymentMethod.wallet;
    final coversAll = payment.walletCoversAll;
    final balanceLabel =
        '${payment.walletBalance.toStringAsFixed(2)} ${"currencyQAR".tr()}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.secondaryColor.withOpacity(0.06)
            : AppColor.gray100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColor.secondaryColor : AppColor.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Radio circle
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.secondaryColor, width: 2),
                  color: isSelected ? AppColor.secondaryColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Icon(Icons.account_balance_wallet_outlined,
                  color: isSelected ? AppColor.secondaryColor : AppColor.textSecondaryDark,
                  size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("walletPayment".tr(),
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textPrimaryDark)),
                    const SizedBox(height: 2),
                    Text(
                      '${"availableBalance".tr()}: $balanceLabel',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 12,
                          color: AppColor.textSecondaryDark),
                    ),
                  ],
                ),
              ),
              // Covers-all badge OR partial warning chip
              if (coversAll)
                _Chip(
                  label: "fullCoverage".tr(),
                  color: Colors.green,
                )
              else
                _Chip(
                  label: "partialCoverage".tr(),
                  color: Colors.orange.shade700,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
//  Sub-method selector — shown ONLY when wallet is partial
// ============================================================================
class _SubMethodSelector extends StatelessWidget {
  final PaymentLoadedState payment;
  final String fontFamily;
  final VoidCallback onSelectOnline;
  final VoidCallback onSelectCash;

  const _SubMethodSelector({
    required this.payment,
    required this.fontFamily,
    required this.onSelectOnline,
    required this.onSelectCash,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: Colors.orange.shade700),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "walletPartialInfo".tr(namedArgs: {
                    'balance': payment.walletBalance.toStringAsFixed(2),
                    'remaining': payment.remainingAfterWallet.toStringAsFixed(2),
                  }),
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 12.5,
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text("chooseSubPayment".tr(),
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimaryDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SubMethodChip(
                  label: "cashPayment".tr(),
                  icon: Icons.payments_outlined,
                  selected: payment.subMethod == SubPaymentMethod.cash,
                  onTap: onSelectCash,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SubMethodChip(
                  label: "onlinePayment".tr(),
                  icon: Icons.credit_card_rounded,
                  selected: payment.subMethod == SubPaymentMethod.online,
                  onTap: onSelectOnline,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubMethodChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String fontFamily;

  const _SubMethodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColor.secondaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColor.secondaryColor : AppColor.borderLight,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: selected ? AppColor.secondaryColor : AppColor.textSecondaryDark),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? AppColor.secondaryColor : AppColor.textPrimaryDark)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
//  Generic payment option tile (cash / online)
// ============================================================================
class _PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String fontFamily;

  const _PaymentOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? AppColor.secondaryColor.withOpacity(0.06) : AppColor.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColor.secondaryColor : AppColor.borderLight,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.secondaryColor, width: 2),
                  color: selected ? AppColor.secondaryColor : Colors.transparent,
                ),
                child: selected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Icon(icon,
                  size: 20,
                  color: selected ? AppColor.secondaryColor : AppColor.textSecondaryDark),
              const SizedBox(width: 10),
              Text(label,
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textPrimaryDark)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
//  Shared widgets
// ============================================================================
class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LocalizationCubit>().isArabic();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColor.textPrimaryDark, fontSize: 15))),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                color: AppColor.textSecondaryDark,
                fontSize: 15,
                fontFamily: isArabic ? "Cairo" : "Montserrat")),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(height: 1, color: AppColor.borderLight),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LocalizationCubit>().isArabic();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: TextStyle(
                  color: valueColor ?? AppColor.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                  fontFamily: isArabic ? "Cairo" : "Montserrat")),
          Text(label,
              style: TextStyle(
                  color: AppColor.textSecondaryDark,
                  fontFamily: isArabic ? "Cairo" : "Montserrat")),
        ],
      ),
    );
  }
}