import 'dart:convert';

class CountryCodeModel {
  final bool? success;
  final String? message;
  final List<Datum>? data;

  CountryCodeModel({
    this.success,
    this.message,
    this.data,
  });

  CountryCodeModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) =>
      CountryCodeModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CountryCodeModel.fromRawJson(String str) => CountryCodeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) => CountryCodeModel(
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
  final int? countryId;
  final String? name;
  final int? code;

  Datum({
    this.countryId,
    this.name,
    this.code,
  });

  Datum copyWith({
    int? countryId,
    String? name,
    int? code,
  }) =>
      Datum(
        countryId: countryId ?? this.countryId,
        name: name ?? this.name,
        code: code ?? this.code,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    countryId: json["country_id"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "name": name,
    "code": code,
  };
}
