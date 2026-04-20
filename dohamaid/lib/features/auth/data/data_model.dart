import 'dart:convert';

class DataModel {
  final bool? success;
  final String? message;
  final bool? data;

  DataModel({
    this.success,
    this.message,
    this.data,
  });

  DataModel copyWith({
    bool? success,
    String? message,
    bool? data,
  }) =>
      DataModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DataModel.fromRawJson(String str) => DataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
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
