import 'dart:convert';

class CompaniesServicesModel {
  final bool? success;
  final String? message;
  final int? active;
  final List<Datum>? data;

  CompaniesServicesModel({
    this.success,
    this.message,
    this.active,
    this.data,
  });

  CompaniesServicesModel copyWith({
    bool? success,
    String? message,
    int? active,
    List<Datum>? data,
  }) =>
      CompaniesServicesModel(
        success: success ?? this.success,
        message: message ?? this.message,
        active: active ?? this.active,
        data: data ?? this.data,
      );

  factory CompaniesServicesModel.fromRawJson(String str) => CompaniesServicesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompaniesServicesModel.fromJson(Map<String, dynamic> json) => CompaniesServicesModel(
    success: json["success"],
    message: json["message"],
    active: json["active"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "active": active,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? workerId;
  final String? name;
  final int? price;
  final String? companyName;
  final String? type;
  final String? thumb;

  Datum({
    this.workerId,
    this.name,
    this.price,
    this.companyName,
    this.type,
    this.thumb,
  });

  Datum copyWith({
    int? workerId,
    String? name,
    int? price,
    String? companyName,
    String? type,
    String? thumb,
  }) =>
      Datum(
        workerId: workerId ?? this.workerId,
        name: name ?? this.name,
        price: price ?? this.price,
        companyName: companyName ?? this.companyName,
        type: type ?? this.type,
        thumb: thumb ?? this.thumb,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    workerId: json["worker_id"],
    name: json["name"],
    price: json["price"],
    companyName: json["company_name"],
    type: json["type"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "worker_id": workerId,
    "name": name,
    "price": price,
    "company_name": companyName,
    "type": type,
    "thumb": thumb,
  };
}
