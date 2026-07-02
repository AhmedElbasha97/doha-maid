// ============================================================
//  booking_cancel_model.dart
// ============================================================
//
//  Models for the two cancel-related endpoints:
//    POST https://dohamaid.com/api/booking/cancel/status
//    POST https://dohamaid.com/api/booking/cancel

/// Response from /api/booking/cancel/status
/// {
///   "success": true,
///   "message": "Booking can be cancel.",
///   "data": { "status": 1 }
/// }
class BookingCancelStatusResponse {
  final bool success;
  final String message;

  /// 1 = booking can still be cancelled, 0 = time window has passed.
  final int status;

  const BookingCancelStatusResponse({
    required this.success,
    required this.message,
    required this.status,
  });

  bool get canCancel => status == 1;

  factory BookingCancelStatusResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final statusValue = data is Map ? data['status'] : null;

    return BookingCancelStatusResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      status: statusValue is int
          ? statusValue
          : int.tryParse('${statusValue ?? 0}') ?? 0,
    );
  }
}

/// Response from /api/booking/cancel
/// {
///   "success": true,
///   "message": "Booking has been canceled successfully.",
///   "data": ""
/// }
class BookingCancelResponse {
  final bool success;
  final String message;

  const BookingCancelResponse({
    required this.success,
    required this.message,
  });

  factory BookingCancelResponse.fromJson(Map<String, dynamic> json) {
    return BookingCancelResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
    );
  }
}
