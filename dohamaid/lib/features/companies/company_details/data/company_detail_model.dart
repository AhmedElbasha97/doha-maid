import 'dart:convert';

class CompanyDetailsModel {
  final bool? success;
  final String? message;
  final CompanyData? data;

  CompanyDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  CompanyDetailsModel copyWith({
    bool? success,
    String? message,
    CompanyData? data,
  }) =>
      CompanyDetailsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CompanyDetailsModel.fromRawJson(String str) => CompanyDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) => CompanyDetailsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : CompanyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class CompanyData {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? tel;
  final String? whatsapp;
  final String? address;
  final String? location;
  final String? image;
  final String? image2;
  final String? image3;
  final List<Service>? services;
  final String? thumb;
  final Country? country;
  final Country? type;
  final List<String>? images;

  CompanyData({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.tel,
    this.whatsapp,
    this.address,
    this.location,
    this.image,
    this.image2,
    this.image3,
    this.services,
    this.thumb,
    this.country,
    this.type,
    this.images,
  });

  CompanyData copyWith({
    int? id,
    String? name,
    String? email,
    String? mobile,
    String? tel,
    String? whatsapp,
    String? address,
    String? location,
    String? image,
    String? image2,
    String? image3,
     List<String>? images,
    List<Service>? services,
    String? thumb,
    Country? country,
    Country? type,
  }) =>
      CompanyData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        tel: tel ?? this.tel,
        images: images ?? this.images,
        whatsapp: whatsapp ?? this.whatsapp,
        address: address ?? this.address,
        location: location ?? this.location,
        image: image ?? this.image,
        image2: image2 ?? this.image2,
        image3: image3 ?? this.image3,
        services: services ?? this.services,
        thumb: thumb ?? this.thumb,
        country: country ?? this.country,
        type: type ?? this.type,
      );

  factory CompanyData.fromRawJson(String str) => CompanyData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    /// ⭐ Combine images manually into a list
    List<String> imgs = [];

    if (json['image'] != null) imgs.add(json['image']);
    if (json['image2'] != null && json['image2'] != "") imgs.add(json['image2']);
    if (json['image3'] != null && json['image3'] != "") imgs.add(json['image3']);

    return CompanyData(


    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    tel: json["tel"],
    whatsapp: json["whatsapp"],
    address: json["address"],
    location: json["location"],
    image: json["image"],
    image2: json["image2"],
    image3: json["image3"],
    thumb: json["thumb"],
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
 images: imgs,
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    type: json["type"] == null ? null : Country.fromJson(json["type"]),
  );
}
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "tel": tel,
    "whatsapp": whatsapp,
    "address": address,
    "location": location,
    "image": image,
    "image2": image2,
    "image3": image3,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
    "thumb": thumb,
    "country": country?.toJson(),
    "type": type?.toJson(),
  };
}

class Country {
  final int? id;
  final String? name;

  Country({
    this.id,
    this.name,
  });

  Country copyWith({
    int? id,
    String? name,
  }) =>
      Country(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Service {
  final String? workerId;
  final String? name;
  final String? price;
  final String? thumb;

  Service({
    this.workerId,
    this.name,
    this.price,
    this.thumb,
  });

  Service copyWith({
    String? workerId,
    String? name,
    String? price,
    String? thumb,
  }) =>
      Service(
        workerId: workerId ?? this.workerId,
        name: name ?? this.name,
        price: price ?? this.price,
        thumb: thumb ?? this.thumb,
      );

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    workerId: "${json["worker_id"]}",
    name: json["name"],
    price: json["price"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "worker_id": workerId,
    "name": name,
    "price": price,
    "thumb": thumb,
  };
}
