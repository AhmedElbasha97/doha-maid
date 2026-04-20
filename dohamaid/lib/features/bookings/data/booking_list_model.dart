import 'dart:convert';

class BookingListResponse {
  final bool success;
  final String message;
  final List<BookingListItem> data;

  BookingListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BookingListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BookingListItem {
  final int id;
  final int workerId;
  final int userId;
  final String workersNo;
  final String hoursNo;
  final String arrivalTime;
  final String services;
  final String address;
  final String location;
  final String region;
  final String regionNo;
  final String streetNo;
  final String buildingNo;
  final String status;
  final String notes;
  final String date;
  final String? createdAt;

  BookingListItem({
    required this.id,
    required this.workerId,
    required this.userId,
    required this.workersNo,
    required this.hoursNo,
    required this.arrivalTime,
    required this.services,
    required this.address,
    required this.location,
    required this.region,
    required this.regionNo,
    required this.streetNo,
    required this.buildingNo,
    required this.status,
    required this.notes,
    required this.date,
    required this.createdAt,
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) {
    return BookingListItem(
      id: _toInt(json['id']),
      workerId: _toInt(json['worker_id']),
      userId: _toInt(json['user_id']),
      workersNo: (json['workers_no'] ?? '').toString(),
      hoursNo: (json['hours_no'] ?? '').toString(),
      arrivalTime: (json['arrival_time'] ?? '').toString(),
      services: json['services'],
      address: (json['address'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      region: (json['region'] ?? '').toString(),
      regionNo: (json['region_no'] ?? '').toString(),
      streetNo: (json['street_no'] ?? '').toString(),
      buildingNo: (json['building_no'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double? get latitude => _parseCoordinate(index: 0);

  double? get longitude => _parseCoordinate(index: 1);

  bool get hasValidCoordinates => latitude != null && longitude != null;

  double? _parseCoordinate({required int index}) {
    final parts = location.split(',');
    if (parts.length < 2) return null;

    return double.tryParse(parts[index].trim());
  }

  static List<int> _parseServices(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => _toInt(e)).toList();
    }

    final text = (raw ?? '').toString();
    if (text.isEmpty) return <int>[];

    try {
      final decoded = jsonDecode(text);
      if (decoded is List) {
        return decoded.map((e) => _toInt(e)).toList();
      }
    } catch (_) {
      return <int>[];
    }

    return <int>[];
  }
}