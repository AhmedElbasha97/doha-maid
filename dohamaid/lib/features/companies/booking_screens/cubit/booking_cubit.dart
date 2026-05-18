import 'package:dohamaid/core/services/booking_services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../location_selection/presentation/location_selection_screen.dart';
import '../data/booking_category_model.dart';
import '../data/booking_price_model.dart';
import 'booking_state.dart';


class BookingCubit extends Cubit<BookingStates> with ChangeNotifier {
  BookingCubit() : super(BookingInitialState());
  final FocusNode textFocusNode = FocusNode();

  void unFocusText() {
    if(textFocusNode.hasFocus) textFocusNode.unfocus();
  }
  BookingCategoryModel? bookingTimes;
  BookingCategoryModel? bookingHours;
  BookingCategoryModel? bookingServices;
  BookingCategoryModel? bookingWorkers;
  String? totalPrice = "0";
  List<Datum> selectedServices = [];
   Datum? selectedHours;
   Datum? selectedWorkers;
   DateTime? selectedDate;
   Datum? arrivalTime;
   bool checkingThePrice = false;
   String servicesId = "";
   String dateAndTime = "";
TextEditingController notes = TextEditingController();

  String get formattedDate {
    if (selectedDate == null) return '';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = selectedDate!;
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year.toString().substring(2)}';
  }
  String get formattedDateTime => selectedDate != null && arrivalTime != null
      ? '$formattedDate - $arrivalTime'
      : '';

  Future<void> initDefaultDate(String id) async {
    try {
      emit(BookingLoadingState());
      servicesId = id;
      final now = DateTime.now();
      bookingTimes = await BookingServices(ApiService()).getAllBookingTimes();
      bookingHours = await BookingServices(ApiService()).getAllBookingHours();
      bookingServices =
      await BookingServices(ApiService()).getAllBookingServices();
      bookingWorkers =
      await BookingServices(ApiService()).getAllBookingWorkers();


      selectedDate = DateTime(now.year, now.month, now.day);

      emit(BookingLoadedState());


    }catch (e){
      emit(BookingErrorState(e.toString()));
    }
  }

  void setDate(DateTime date) {
    selectedDate = date;
    emit(BookingInitialState());

    emit(BookingLoadedState());}
  void setProviderCount(Datum? n){
    selectedWorkers = n;
    emit(BookingLoadedState());}
  void setCleaningHours(Datum? n) {
    selectedHours = n;
    emit(BookingInitialState());

    emit(BookingLoadedState());}

  void setArrivalTime(Datum? time) {
    arrivalTime = time;
    emit(BookingInitialState());

    emit(BookingLoadedState());}

  void toggleService(Datum type) {

    if ((selectedServices.contains(type)??false)) {
      selectedServices.remove(type);
    } else {

      selectedServices.add(type);


    }
    emit(BookingLoadedState());
  }


  Future<void> getTotalPrice(BuildContext context) async {
    if(selectedWorkers == null) {

      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
       showCloseIcon: true,
        padding: const EdgeInsets.all(20),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "errorKey".tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            Text(
              "servantAlert".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),


          ],
        ),

        // Buttons
        btnOkText: "accept".tr(),

        btnOkOnPress: () {
        },


      ).show();

    }else if(selectedHours == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        padding: const EdgeInsets.all(20),
        showCloseIcon: true,

        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "errorKey".tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            Text(
              "numbersOfHoursAlert".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),


          ],
        ),

        // Buttons
        btnOkText: "accept".tr(),

        btnOkOnPress: () {
        },

      ).show();

    }else if(arrivalTime == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        padding: const EdgeInsets.all(20),
        showCloseIcon: true,

        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "errorKey".tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            Text(
              "arrivalAlert".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),


          ],
        ),

        // Buttons
        btnOkText: "accept".tr(),
        btnOkOnPress: () {
        },


      ).show();
    }else if(selectedServices.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        padding: const EdgeInsets.all(20),
        showCloseIcon: true,

        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "errorKey".tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            Text(
              "servicesAlert".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),


          ],
        ),

        // Buttons
        btnOkText: "accept".tr(),

        btnOkOnPress: () {
        },


      ).show();
    }else {
      try {
        checkingThePrice = true;
        emit(BookingLoadedState());

        BookingPriceModel? data = await BookingServices(ApiService())
            .checkingPricesOfBooking(
          workerId: servicesId,
          date: selectedDate!.toIso8601String(),
          workerNo: selectedWorkers!.id.toString(),
          hoursNo: selectedHours!.id.toString(),
          arrivalTime: arrivalTime!.id.toString(),
          services: "${selectedServices
              .map((e) => e.id.toString())
              .toList()}",
        );
        if (data != null) {
          totalPrice = "${data.data?.price ?? 0}";
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: true,
            padding: const EdgeInsets.all(20),
            showCloseIcon: true,

            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "errorKey".tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                Text(
                  "${"totalPriceAlert".tr()} ${data.data?.price ?? 0} ${"currencyQAR".tr()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),


              ],
            ),

            // Buttons
            btnOkText: "accept".tr(),

            btnOkOnPress: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value:BookingCubit()
                    ,
                    child: LocationSelectionScreen(
                      selectedDate: selectedDate,
                      selectedHours: selectedHours,
                      selectedServices: selectedServices,
                      selectedWorkers: selectedWorkers,
                      arrivalTime: arrivalTime,
                      totalPrice: totalPrice,
                      note: notes.text.isEmpty?"":notes.text, servicesId: servicesId,
                    ),
                  ),
                ),
              );

            },


          ).show();
          checkingThePrice = false;
          emit(BookingLoadedState());
          dateAndTime = formattedDate;

        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            padding: const EdgeInsets.all(20),
            showCloseIcon: true,

            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "errorKey".tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                Text(
                  "totalPriceError".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),


              ],
            ),

            // Buttons
            btnOkText: "accept".tr(),

            btnOkOnPress: () {
            },


          ).show();
        }
      }catch (e){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          padding: const EdgeInsets.all(20),
          showCloseIcon: true,

          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "errorKey".tr(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),


            ],
          ),

          // Buttons
          btnOkText: "accept".tr(),
          btnOkOnPress: () {
          },

        ).show();
      }
    }
  }
}
