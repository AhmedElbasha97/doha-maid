import 'dart:convert';

HomeModel homeModelFromJson(String str) {
  final jsonData = json.decode(str);
  return HomeModel.fromJson(jsonData);
}

String homeModelToJson(HomeModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class HomeModel {
  bool? success;
  String? message;
  List<Datum>? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) =>  HomeModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null :  List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  int? active;
  String? url;

  Datum({
    this.id,
    this.name,
    this.active,
    this.url,
  });

  factory Datum.fromJson(Map<String, dynamic> json) =>  Datum(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active": active,
    "url": url,
  };
}
