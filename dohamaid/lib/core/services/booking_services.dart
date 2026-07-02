import '../../features/bookings/data/booking_cancel_model.dart';
import '../../features/bookings/data/booking_list_model.dart';
import 'package:dohamaid/features/auth/sign_up/data/regestier_model.dart';

import '../../features/companies/booking_screens/data/booking_category_model.dart';
import '../../features/companies/booking_screens/data/booking_price_model.dart';
import '../../features/companies/payment/model/payment_model.dart';
import '../../features/locations/data/location_list_model.dart';
import '../data/datasources/api_service.dart';
import '../utils/api_constant.dart';

class BookingServices {
  final ApiService api;

  BookingServices(this.api);

  Future<BookingCategoryModel?> getAllBookingServices() async {
    final resp = await api.get(ApiConstant.bookingServicesLink);
    final data = resp.data;
    if (data == null) return null;

    return BookingCategoryModel.fromJson(data);
  }

  Future<BookingCategoryModel?> getAllBookingHours() async {
    final resp = await api.get(ApiConstant.bookingHoursLink);
    final data = resp.data;
    if (data == null) return null;

    return BookingCategoryModel.fromJson(data);
  }

  Future<BookingCategoryModel?> getAllBookingWorkers() async {
    final resp = await api.get(ApiConstant.bookingWorkersLink);
    final data = resp.data;
    if (data == null) return null;

    return BookingCategoryModel.fromJson(data);
  }

  Future<BookingCategoryModel?> getAllBookingTimes() async {
    final resp = await api.get(ApiConstant.bookingTimesLink);
    final data = resp.data;
    if (data == null) return null;

    return BookingCategoryModel.fromJson(data);
  }
  Future<int?> getUserBalance() async {
    final resp = await api.get(ApiConstant.getUserBalance);
    final data = resp.data;
    print(data.toString());
    if (data == null) return null;

    return data["data"]["balance"];
  }

  Future<BookingPriceModel?> checkingPricesOfBooking({
    String? workerId,
    String? date,
    String? workerNo,
    String? hoursNo,
    String? arrivalTime,
    String? services,
  }) async {
    final resp = await api.post(
      ApiConstant.checkingPricesOfBookingLink,
      data: {
        'worker_id': workerId,
        'date': date,
        'workers_no': workerNo,
        'hours_no': hoursNo,
        'arrival_time': arrivalTime,
        'services': services,
      },
    );

    final data = resp.data;
    if (data == null) return null;

    return BookingPriceModel.fromJson(data);
  }


  Future<PaymentModel?> bookingForCompanyServices({String? address,String? workerId,String? date,String? workerNo,String? hoursNo,String? arrivalTime,List<String>? services,String? notes,String? longitude,String? latitude,String? region,String? regionNo,String? streetNo,String? buildingNo,bool? wallet, bool? cash}) async {

    final resp = await api.post(ApiConstant.bookingForCompanyServicesLink,data:{
      "worker_id": workerId,
      "date": date,
      "workers_no": workerNo,
      "hours_no": hoursNo,
      "arrival_time":arrivalTime,
      "address":address,
      "services":"${services?.join(', ')}",
      "notes":notes,
      "location":"$longitude,$latitude",
      "region":region,
      "region_no":regionNo,
      "street_no":streetNo,
      "building_no":buildingNo,
      "balance":wallet,
      "cash":cash

    });
    final data = resp.data;
    if (data == null) return null;

    return PaymentModel.fromJson(data);
  }

  Future<BookingListResponse?> getBookingList() async {
    final resp = await api.get(ApiConstant.bookingListLink);
    final data = resp.data;
    if (data == null) return null;

    return BookingListResponse.fromJson(data);
  }
  Future<LocationResponseModel?> getLocationList() async {
    final resp = await api.get(ApiConstant.locationListLink);
    final data = resp.data;
    if (data == null) return null;

    return LocationResponseModel.fromJson(data);
  }

  Future<BookingCancelStatusResponse?> checkBookingCancelStatus(
      int bookingId,
      ) async {
    final resp = await api.post(
      ApiConstant.bookingCancelStatusLink,
      data: {'booking_id': bookingId},
    );
    final data = resp.data;
    if (data == null) return null;

    return BookingCancelStatusResponse.fromJson(data);
  }

  Future<BookingCancelResponse?> cancelBooking(int bookingId) async {
    final resp = await api.post(
      ApiConstant.bookingCancelLink,
      data: {'booking_id': bookingId},
    );
    final data = resp.data;
    if (data == null) return null;

    return BookingCancelResponse.fromJson(data);
  }
}