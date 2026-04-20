import 'dart:convert';

class OtpModel {
  final bool? success;
  final String? message;
  final Data? data;

  OtpModel({
    this.success,
    this.message,
    this.data,
  });

  OtpModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      OtpModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory OtpModel.fromRawJson(String str) => OtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
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
  final String? mobile;
  final int? otp;

  Data({
    this.mobile,
    this.otp,
  });

  Data copyWith({
    String? mobile,
    int? otp,
  }) =>
      Data(
        mobile: mobile ?? this.mobile,
        otp: otp ?? this.otp,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mobile: json["mobile"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "otp": otp,
  };
}
