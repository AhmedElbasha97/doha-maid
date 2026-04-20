import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/services/booking_services.dart';
import '../data/location_list_model.dart';
import 'booking_list_state.dart';

class LocationListCubit extends Cubit<LocationListState> {
  LocationListCubit() : super(LocationListInitial());

  LocationResponseModel? locationListResponse;

  Future<void> getBookingList() async {
    emit(LocationListLoading());

    try {
      locationListResponse = await BookingServices(ApiService()).getLocationList();
      if (locationListResponse == null) {
        emit(LocationListError('Empty response from server'));
        return;
      }

      emit(LocationListLoaded(locationListResponse!));
    } catch (e) {
      emit(LocationListError(e.toString()));
    }
  }
}