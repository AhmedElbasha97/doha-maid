// ============================================================
//  booking_list_cubit.dart
// ============================================================
//
//  Cancel-reservation flow, step by step:
//
//   1. requestCancelBooking(id) is called from the screen when the
//      user taps "Cancel Reservation" on a card.
//   2. Cubit marks that single card as "checking" (checkingCancelForId)
//      and calls BookingServices.checkBookingCancelStatus(id), which
//      hits POST /api/booking/cancel/status with { booking_id: id }.
//   3. If status == 0 -> emit ShowCancelNotAllowedDialog, then restore
//      the list (clearing the checking flag) so the UI is interactive
//      again.
//   4. If status == 1 -> cubit marks the card as "cancelling"
//      (cancellingForId) and calls BookingServices.cancelBooking(id).
//   5. On success -> emit ShowCancelSuccessDialog, then refetch the
//      whole list so the cancelled booking's status/visibility updates
//      from the source of truth.
//   6. On any failure along the way -> emit ShowCancelErrorDialog and
//      restore the list with both flags cleared.
//
//  The screen never decides any of this — it only calls
//  requestCancelBooking() and reacts to whichever state comes back.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/services/booking_services.dart';
import '../data/booking_list_model.dart';
import 'booking_list_state.dart';

class BookingListCubit extends Cubit<BookingListState> {
  BookingListCubit() : super(BookingListInitial());

  BookingListResponse? bookingListResponse;

  final BookingServices _bookingServices = BookingServices(ApiService());

  // ── Load list ────────────────────────────────────────────────────────

  Future<void> getBookingList() async {
    emit(BookingListLoading());

    try {
      bookingListResponse = await _bookingServices.getBookingList();
      if (bookingListResponse == null) {
        emit(BookingListError('Empty response from server'));
        return;
      }

      emit(BookingListLoaded(bookingListResponse!));
    } catch (e) {
      emit(BookingListError(e.toString()));
    }
  }

  // ── Cancel reservation flow ─────────────────────────────────────────

  Future<void> requestCancelBooking(int bookingId) async {
    final current = state;
    if (current is! BookingListLoaded) return;

    // Step 1 — mark this card as "checking" and call /cancel/status
    emit(current.copyWith(checkingCancelForId: bookingId, clearCancelling: true));

    try {
      final statusResponse =
      await _bookingServices.checkBookingCancelStatus(bookingId);

      if (statusResponse == null) {
        emit(ShowCancelErrorDialog('Empty response from server'));
        emit(current.copyWith(clearChecking: true, clearCancelling: true));
        return;
      }

      if (!statusResponse.canCancel) {
        emit(ShowCancelNotAllowedDialog(bookingId, statusResponse.message));
        emit(current.copyWith(clearChecking: true, clearCancelling: true));
        return;
      }

      // Step 2 — status allows cancellation, move to "cancelling" and
      // call the actual cancel endpoint.
      emit(current.copyWith(
        checkingCancelForId: null,
        cancellingForId: bookingId,
      ));

      final cancelResponse = await _bookingServices.cancelBooking(bookingId);

      if (cancelResponse == null) {
        emit(ShowCancelErrorDialog('Empty response from server'));
        emit(current.copyWith(clearChecking: true, clearCancelling: true));
        return;
      }

      emit(ShowCancelSuccessDialog(bookingId, cancelResponse.message));

      // Refresh from the source of truth so the list reflects the
      // booking's new status (or its removal, depending on your API).
      await getBookingList();
    } catch (e) {
      emit(ShowCancelErrorDialog(e.toString()));
      emit(current.copyWith(clearChecking: true, clearCancelling: true));
    }
  }
}