import 'dart:convert';

class LocationResponseModel {
  final bool? success;
  final String? message;
  final List<LocationListItem>? data;

  LocationResponseModel({
    this.success,
    this.message,
    this.data,
  });

  LocationResponseModel copyWith({
    bool? success,
    String? message,
    List<LocationListItem>? data,
  }) =>
      LocationResponseModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LocationResponseModel.fromRawJson(String str) => LocationResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) => LocationResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LocationListItem>.from(json["data"]!.map((x) => LocationListItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LocationListItem {
  final String? address;
  final String? location;
  final String? regionNo;
  final String? region;
  final String? buildingNo;
  final String? streetNo;

  LocationListItem({
    this.address,
    this.location,
    this.regionNo,
    this.region,
    this.buildingNo,
    this.streetNo,
  });

  LocationListItem copyWith({
    String? address,
    String? location,
    String? regionNo,
    String? region,
    String? buildingNo,
    String? streetNo,
  }) =>
      LocationListItem(
        address: address ?? this.address,
        location: location ?? this.location,
        regionNo: regionNo ?? this.regionNo,
        region: region ?? this.region,
        buildingNo: buildingNo ?? this.buildingNo,
        streetNo: streetNo ?? this.streetNo,
      );

  factory LocationListItem.fromRawJson(String str) => LocationListItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationListItem.fromJson(Map<String, dynamic> json) => LocationListItem(
    address: json["address"],
    location: json["location"],
    regionNo: json["region_no"],
    region: json["region"],
    buildingNo: json["building_no"],
    streetNo: json["street_no"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "location": location,
    "region_no": regionNo,
    "region": region,
    "building_no": buildingNo,
    "street_no": streetNo,
  };
  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
double? get latitude => _parseCoordinate(index: 0);

double? get longitude => _parseCoordinate(index: 1);

bool get hasValidCoordinates => latitude != null && longitude != null;

double? _parseCoordinate({required int index}) {
  final parts = location?.split(',');
  if ((parts?.length??0) < 2) return null;

  return double.tryParse(parts?[index]?.trim() ?? '');
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