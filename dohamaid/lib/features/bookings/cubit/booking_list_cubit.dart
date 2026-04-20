import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/services/booking_services.dart';
import '../data/booking_list_model.dart';
import 'booking_list_state.dart';

class BookingListCubit extends Cubit<BookingListState> {
  BookingListCubit() : super(BookingListInitial());

  BookingListResponse? bookingListResponse;

  Future<void> getBookingList() async {
    emit(BookingListLoading());

    try {
      bookingListResponse = await BookingServices(ApiService()).getBookingList();
      if (bookingListResponse == null) {
        emit(BookingListError('Empty response from server'));
        return;
      }

      emit(BookingListLoaded(bookingListResponse!));
    } catch (e) {
      emit(BookingListError(e.toString()));
    }
  }
}