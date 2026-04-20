import 'dart:convert';

class BookingPriceModel {
  final bool? success;
  final String? message;
  final Data? data;

  BookingPriceModel({
    this.success,
    this.message,
    this.data,
  });

  BookingPriceModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      BookingPriceModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory BookingPriceModel.fromRawJson(String str) => BookingPriceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingPriceModel.fromJson(Map<String, dynamic> json) => BookingPriceModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? price;

  Data({
    this.price,
  });

  Data copyWith({
    int? price,
  }) =>
      Data(
        price: price ?? this.price,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
  };
}
