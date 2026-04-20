import '../data/booking_list_model.dart';

abstract class BookingListState {}

class BookingListInitial extends BookingListState {}

class BookingListLoading extends BookingListState {}

class BookingListLoaded extends BookingListState {
  final BookingListResponse bookingListResponse;

  BookingListLoaded(this.bookingListResponse);
}

class BookingListError extends BookingListState {
  final String message;

  BookingListError(this.message);
}