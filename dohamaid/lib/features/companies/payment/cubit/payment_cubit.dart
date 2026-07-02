

import 'package:dohamaid/features/auth/sign_up/data/regestier_model.dart';
import 'package:dohamaid/features/companies/payment/cubit/payment_state.dart';
import 'package:dohamaid/features/webview/web_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/services/booking_services.dart';
import '../../../home/presentation/home_screen.dart';
import '../../booking_screens/data/booking_category_model.dart';
import '../../location_selection/data/address_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

import '../../widget/payment_failed_screen.dart';
import '../../widget/payment_success_screen.dart';
import '../model/payment_model.dart';

class PaymentCubit extends Cubit<PaymentState> {
  bool isSendingReservation = false;

  PaymentCubit() : super(PaymentInitialState());

  // ── Load wallet balance ───────────────────────────────────────────────

  Future<void> startingScreen({double orderTotal = 0}) async {
    final balanceData = await BookingServices(ApiService()).getUserBalance();

    final double walletBalance = _parseBalance(balanceData);
    final double parsedTotal = orderTotal;

    // Default method: wallet if it has money, otherwise cash.
    final defaultMethod =
    walletBalance > 0 ? PaymentMethod.wallet : PaymentMethod.cash;

    emit(PaymentLoadedState(
      walletBalance: walletBalance,
      orderTotal: parsedTotal,
      method: defaultMethod,
    ));
  }

  double _parseBalance(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString()) ?? 0;
  }

  // ── Method selection ─────────────────────────────────────────────────

  void setMethod(PaymentMethod m) {
    final s = _loaded;
    if (s == null) return;

    emit(s.copyWith(
      method: m,
      clearSubMethod: true, // reset sub-method when primary changes
    ));
  }

  void setSubMethod(SubPaymentMethod m) {
    final s = _loaded;
    if (s == null) return;

    emit(s.copyWith(subMethod: m));
  }

  void setPolicyAgreed(bool v) {
    final s = _loaded;
    if (s == null) return;

    emit(s.copyWith(policyAgreed: v));
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  PaymentLoadedState? get _loaded =>
      state is PaymentLoadedState ? state as PaymentLoadedState : null;

  // ── Booking submission ────────────────────────────────────────────────

  Future<void> startSendingReservation(
      BuildContext context,
      String? totalPrice,
      List<Datum>? selectedServices,
      Datum? selectedHours,
      Datum? selectedWorkers,
      DateTime? selectedDate,
      Datum? arrivalTime,
      String? note,
      AddressModel? address,
      bool? policyAgreed,
      String servicesId,
      ) async {
    final s = _loaded;
    if (s == null) return;

    if (!(policyAgreed ?? false)) {
      _showSnack(context, "policy_alert".tr(), isError: true);
      return;
    }

    if (!s.isSelectionComplete) {
      _showSnack(context, "select_sub_payment_method".tr(), isError: true);
      return;
    }

    isSendingReservation = true;
    emit(s.copyWith());

    // ── Derive wallet/cash flags to send to the API ──────────────────────
    //
    // Rules:
    //   - method == cash  →  cash: true,  wallet: false
    //   - method == online → cash: false, wallet: false (handled by payment gateway)
    //   - method == wallet + covers all → wallet: true, cash: false
    //   - method == wallet + partial + subMethod == cash → wallet: true, cash: true
    //   - method == wallet + partial + subMethod == online → wallet: true, cash: false

    final bool sendWallet = s.method == PaymentMethod.wallet;
    final bool sendCash = s.method == PaymentMethod.cash ||
        (s.walletIsPartial && s.subMethod == SubPaymentMethod.cash);

    try {
      PaymentModel? data = await BookingServices(ApiService()).bookingForCompanyServices(
        address: address?.streetName,
        workerId: servicesId,
        date: selectedDate != null ? formatDateToYMD(selectedDate) : '',
        workerNo: selectedWorkers?.id.toString(),
        hoursNo: selectedHours?.id.toString(),
        arrivalTime: arrivalTime?.id.toString(),
        services: selectedServices?.map((e) => e.id.toString()).toList(),
        notes: note,
        longitude: address?.lng.toString(),
        latitude: address?.lat.toString(),
        region: address?.regionName,
        regionNo: address?.regionNumber,
        streetNo: address?.streetNumber,
        buildingNo: address?.buildingNumber,
        wallet: sendWallet,
        cash: sendCash,
      );

      isSendingReservation = false;
      emit(s.copyWith());

      if (data != null && (data.success ?? false)) {
        _showSnack(context, "reservation_success_alert".tr(), isError: false);
        Future.delayed(const Duration(seconds: 2), () {

          if("${data.data?.url}" != "")
          {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WebViewContainer(
                      "${data.data?.url}", forBayingOnline: true, onSuccess: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentSuccessScreen(),
                          settings: const RouteSettings(name: "PaymentSuccessScreen"),
                        ),
                      );
                    },
                      onFailed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentFailedScreen(),
                            settings: const RouteSettings(name:"PaymentFailedScreen"),
                          ),
                        );
                      },
                    ),
                settings: const RouteSettings(name: "webView"),
              ),
                  (route) => false,
            );
          }else{
            if(data.success == true){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentSuccessScreen(),
                  settings: const RouteSettings(name: "PaymentSuccessScreen"),
                ));}else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentFailedScreen(),
                  settings: const RouteSettings(name:"PaymentFailedScreen"),
                ),
              );
            }
          }
          });

      } else {
        _showSnack(context, "reservation_error_alert".tr(), isError: true);
      }

    }catch (e) {
      isSendingReservation = false;
      emit(s.copyWith());
      _showSnack(context, e.toString(), isError: true);
    }
  }

  String formatDateToYMD(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void stopSendingReservation() {
    isSendingReservation = false;
    emit(state);
  }

  void _showSnack(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColor.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColor.white, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColor.errorShade : AppColor.successShade,
        duration: Duration(seconds: isError ? 3 : 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}