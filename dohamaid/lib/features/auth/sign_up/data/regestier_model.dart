import 'dart:convert';

class RegisterModel {
  final bool? success;
  final String? message;
  final String? data;

  RegisterModel({
    this.success,
    this.message,
    this.data,
  });

  RegisterModel copyWith({
    bool? success,
    String? message,
    String? data,
  }) =>
      RegisterModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory RegisterModel.fromRawJson(String str) => RegisterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
  };
}
