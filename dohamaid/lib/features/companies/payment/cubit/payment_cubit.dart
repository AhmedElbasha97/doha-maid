import 'package:dohamaid/features/auth/sign_up/data/regestier_model.dart';
import 'package:dohamaid/features/companies/payment/cubit/payment_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/services/booking_services.dart';
import '../../../home/presentation/home_screen.dart';
import '../../booking_screens/data/booking_category_model.dart';
import '../../location_selection/data/address_model.dart';
import 'package:dohamaid/core/config/app_color.dart';



class PaymentCubit extends Cubit<PaymentState> {
  bool isSendingReservation = false;
  PaymentCubit() : super( PaymentInitialState());
  void startingScreen() => emit(PaymentLoadedState());
  void setMethod(PaymentMethod m) => emit(PaymentLoadedState().copyWith(method: m));
  void setPolicyAgreed(bool v) => emit(PaymentLoadedState().copyWith(policyAgreed: v));
  String  formattedDate (DateTime? selectedDate) {
    if (selectedDate == null) return '';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = selectedDate!;
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year.toString().substring(2)}';
  }
  String formatDateToYMD(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
  Future<void> startSendingReservation(BuildContext context,
   String? totalPrice ,
   List<Datum>? selectedServices ,
   Datum? selectedHours,
   Datum? selectedWorkers,
   DateTime? selectedDate,
   Datum? arrivalTime,
   String? note,
   AddressModel? address,
   bool? policyAgreed,
  String servicesId,) async {
    isSendingReservation = true;
    emit(PaymentLoadedState());
    if(!(policyAgreed ?? false)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColor.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "policy_alert".tr(),
                  style: const TextStyle(color: AppColor.white, fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.errorShade,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      isSendingReservation = false;
      emit(PaymentLoadedState());
      return;
    }
    try {
    isSendingReservation = true;
    emit(PaymentLoadedState());
    RegisterModel? data = await BookingServices(ApiService()).bookingForCompanyServices(
      address: address?.streetName,
      workerId: servicesId,
      date: selectedDate != null ? formatDateToYMD(selectedDate) : '',
      workerNo: selectedWorkers?.id.toString(),
      hoursNo: selectedHours?.id.toString(),
      arrivalTime: selectedHours?.id.toString(),
      services: selectedServices?.map((e) => e.id.toString()).toList(),
      notes: note,
      longitude: address?.lng.toString(),
      latitude: address?.lat.toString(),
      region: address?.regionName,
      regionNo: address?.regionNumber,
      streetNo: address?.streetNumber,
      buildingNo: address?.buildingNumber,);
     if (data != null && (data.success ?? false)) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Row(
             children: [
               const Icon(Icons.check_circle_outline, color: AppColor.white),
               const SizedBox(width: 12),
               Expanded(
                 child: Text(
                   "reservation_success_alert".tr(),
                   style: const TextStyle(color: AppColor.white, fontSize: 16),
                 ),
               ),
             ],
           ),
           backgroundColor: AppColor.successShade, // Success color
           duration: const Duration(milliseconds: 1500),
           behavior: SnackBarBehavior.floating, // For a cleaner look
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
           ),
         ),
       );
       isSendingReservation = false;
       emit(PaymentLoadedState());
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: const RouteSettings(name: "HomeScreen"),
            ),
            (route) => false,
          ); // Return true to indicate success

        });
    } else {
       isSendingReservation = false;
       emit(PaymentLoadedState());
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Row(
             children: [
               const Icon(Icons.error_outline, color: AppColor.white),
               const SizedBox(width: 12),
               Expanded(
                 child: Text(
                   "reservation_error_alert".tr(),
                   maxLines: 3,
                   overflow: TextOverflow.ellipsis,
                   style: const TextStyle(color: AppColor.white, fontSize: 16),
                 ),
               ),
             ],
           ),
           backgroundColor: AppColor.errorShade,
           // Error color
           duration: const Duration(seconds: 3),
           behavior: SnackBarBehavior.floating,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
           ),
         ),
       );
     }
     } catch (e) {
      isSendingReservation = false;
      emit(PaymentLoadedState());
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Row(
             children: [
               const Icon(Icons.error_outline, color: AppColor.white),
               const SizedBox(width: 12),
               Expanded(
                 child: Text(
                   e.toString(),
                   style: const TextStyle(color: AppColor.white, fontSize: 16),
                   maxLines: 3,
                   overflow: TextOverflow.ellipsis,
                 ),
               ),
             ],
           ),
           backgroundColor: AppColor.errorShade, // Error color
           duration: const Duration(seconds: 3),
           behavior: SnackBarBehavior.floating,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
           ),
         ),
       );
     }
    }


  void stopSendingReservation() {
    isSendingReservation = false;
    emit(state);
  }
}
