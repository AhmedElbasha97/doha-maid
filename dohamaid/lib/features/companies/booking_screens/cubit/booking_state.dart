import '../data/booking_category_model.dart';
abstract class BookingStates {}

class  BookingInitialState extends BookingStates {}

class BookingLoadingState extends BookingStates {}
class BookingLoadedState extends BookingStates {








}
class BookingErrorState extends BookingStates {
  final String message;
  BookingErrorState(this.message);
}