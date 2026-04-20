import 'dart:convert';

class BookingCategoryModel {
  final bool? success;
  final String? message;
  final List<Datum>? data;

  BookingCategoryModel({
    this.success,
    this.message,
    this.data,
  });

  BookingCategoryModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) =>
      BookingCategoryModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory BookingCategoryModel.fromRawJson(String str) => BookingCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingCategoryModel.fromJson(Map<String, dynamic> json) => BookingCategoryModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? name;

  Datum({
    this.id,
    this.name,
  });

  Datum copyWith({
    int? id,
    String? name,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
