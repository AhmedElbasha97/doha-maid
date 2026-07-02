import 'dart:convert';

// ─── Root response ────────────────────────────────────────────────────────────
class CleaningServicesModel {
  final bool? success;
  final String? message;
  final List<CleaningServiceItem>? data;

  CleaningServicesModel({this.success, this.message, this.data});

  factory CleaningServicesModel.fromRawJson(String str) =>
      CleaningServicesModel.fromJson(json.decode(str));

  factory CleaningServicesModel.fromJson(Map<String, dynamic> json) =>
      CleaningServicesModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<CleaningServiceItem>.from(
                json['data'].map((x) => CleaningServiceItem.fromJson(x))),
      );
}

// ─── Single service item ──────────────────────────────────────────────────────
class CleaningServiceItem {
  final int? workerId;
  final String? name;
  final dynamic priceRaw; // can be int, String or "00000"
  final int? companyId;
  final String? companyName;
  final String? thumb;
  final String? thumb2;
  final String? thumb3;
  final int? age;
  final String? gallery;
  final String? gallery2;
  final String? gallery3;

  CleaningServiceItem({
    this.workerId,
    this.name,
    this.priceRaw,
    this.companyId,
    this.companyName,
    this.thumb,
    this.thumb2,
    this.thumb3,
    this.age,
    this.gallery,
    this.gallery2,
    this.gallery3,
  });

  /// Parsed price — returns null if price is 0 / "0" / "000..." (means "contact us").
  double? get parsedPrice {
    if (priceRaw == null) return null;
    final s = priceRaw.toString().trim();
    // "00000", "0000", "000" → no price
    if (RegExp(r'^0+$').hasMatch(s)) return null;
    return double.tryParse(s);
  }

  bool get hasPriceInfo => parsedPrice != null && parsedPrice! > 0;

  factory CleaningServiceItem.fromJson(Map<String, dynamic> json) =>
      CleaningServiceItem(
        workerId: json['worker_id'],
        name: json['name'],
        priceRaw: json['price'],
        companyId: json['company_id'],
        companyName: json['company_name'],
        thumb: json['thumb'],
        thumb2: json['thumb2'],
        thumb3: json['thumb3'],
        age: json['age'],
        gallery: json['gallery'],
        gallery2: json['gallery2'],
        gallery3: json['gallery3'],
      );
}
