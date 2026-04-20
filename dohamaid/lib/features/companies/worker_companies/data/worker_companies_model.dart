import 'dart:convert';

class WorkerCompaniesModel {
  final bool? success;
  final String? message;
  final int? active;
  final List<WorkerCompanyData>? data;

  WorkerCompaniesModel({
    this.success,
    this.message,
    this.active,
    this.data,
  });

  WorkerCompaniesModel copyWith({
    bool? success,
    String? message,
    int? active,
    List<WorkerCompanyData>? data,
  }) =>
      WorkerCompaniesModel(
        success: success ?? this.success,
        message: message ?? this.message,
        active: active ?? this.active,
        data: data ?? this.data,
      );

  factory WorkerCompaniesModel.fromRawJson(String str) => WorkerCompaniesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkerCompaniesModel.fromJson(Map<String, dynamic> json) => WorkerCompaniesModel(
    success: json["success"],
    message: json["message"],
    active: json["active"],
    data: json["data"] == null ? [] : List<WorkerCompanyData>.from(json["data"]!.map((x) => WorkerCompanyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "active": active,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WorkerCompanyData {
  final int? id;
  final String? name;
  final String? url;
  final int? workers;
  final String? thumb;

  WorkerCompanyData({
    this.id,
    this.name,
    this.url,
    this.workers,
    this.thumb,
  });

  WorkerCompanyData copyWith({
    int? id,
    String? name,
    String? url,
    int? workers,
    String? thumb,
  }) =>
      WorkerCompanyData(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        workers: workers ?? this.workers,
        thumb: thumb ?? this.thumb,
      );

  factory WorkerCompanyData.fromRawJson(String str) => WorkerCompanyData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkerCompanyData.fromJson(Map<String, dynamic> json) => WorkerCompanyData(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    workers: json["workers"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "workers": workers,
    "thumb": thumb,
  };
}
