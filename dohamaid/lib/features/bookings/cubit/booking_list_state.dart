// ============================================================
//  booking_list_state.dart
// ============================================================

import '../data/booking_list_model.dart';

abstract class BookingListState {}

class BookingListInitial extends BookingListState {}

class BookingListLoading extends BookingListState {}

class BookingListLoaded extends BookingListState {
  final BookingListResponse bookingListResponse;

  /// ID of the booking currently calling /cancel/status (button shows a
  /// small spinner, button is disabled, only for this card).
  final int? checkingCancelForId;

  /// ID of the booking currently calling /cancel (after status check
  /// passed). Kept separate from [checkingCancelForId] so the UI can
  /// show different labels/spinners for each step if desired.
  final int? cancellingForId;

  BookingListLoaded(
    this.bookingListResponse, {
    this.checkingCancelForId,
    this.cancellingForId,
  });

  BookingListLoaded copyWith({
    BookingListResponse? bookingListResponse,
    int? checkingCancelForId,
    int? cancellingForId,
    bool clearChecking = false,
    bool clearCancelling = false,
  }) {
    return BookingListLoaded(
      bookingListResponse ?? this.bookingListResponse,
      checkingCancelForId:
          clearChecking ? null : (checkingCancelForId ?? this.checkingCancelForId),
      cancellingForId:
          clearCancelling ? null : (cancellingForId ?? this.cancellingForId),
    );
  }
}

class BookingListError extends BookingListState {
  final String message;

  BookingListError(this.message);
}

// ============================================================
//  Dialog-trigger states — the cubit only signals intent here.
//  AwesomeDialog needs BuildContext, so the actual `.show()` call
//  lives in the screen's BlocListener, never in the cubit.
// ============================================================

/// Emitted when /cancel/status returned status == 0 (time window passed).
class ShowCancelNotAllowedDialog extends BookingListState {
  final int bookingId;
  final String message;
  ShowCancelNotAllowedDialog(this.bookingId, this.message);
}

/// Emitted when /cancel succeeded.
class ShowCancelSuccessDialog extends BookingListState {
  final int bookingId;
  final String message;
  ShowCancelSuccessDialog(this.bookingId, this.message);
}

/// Emitted on any network/unexpected failure during the cancel flow
/// (status check or the cancel call itself).
class ShowCancelErrorDialog extends BookingListState {
  final String message;
  ShowCancelErrorDialog(this.message);
}
