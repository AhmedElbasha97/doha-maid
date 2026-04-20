import 'package:easy_localization/easy_localization.dart';

/// Holds address details from location selection (street, building, floor, apartment).
class AddressModel {
  const AddressModel( {this.streetNumber = '',
    this.streetName = '',
    this.buildingNumber = '',
    this.regionName = '',
    this.regionNumber = '',
    this.lat,
    this.lng,
  });

  final String streetName;
  final String streetNumber;
  final String regionName;
  final String regionNumber;
  final String buildingNumber;
  final double? lat;
  final double? lng;

  String get displayAddress {
    final parts = <String>[
      if (streetName.isNotEmpty) streetName,
      if (streetNumber.isNotEmpty) '${"street_number".tr()} $streetNumber',
      if (regionName.isNotEmpty) '${"region_name".tr()} $regionName',
      if (regionNumber.isNotEmpty) '${"region_no".tr()} $regionNumber',
      if (buildingNumber.isNotEmpty) '${"building_no".tr()} $buildingNumber',
    ];
    return parts.isEmpty ? '' : parts.join(', ');
  }

  AddressModel copyWith({
     String? streetName,
     String? streetNumber,
     String? regionName,
     String? regionNumber,
     String? buildingNumber,
    double? lat,
    double? lng,
  }) {
    return AddressModel(
      streetName: streetName ?? this.streetName,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      streetNumber: streetNumber ?? this.streetNumber,
      regionName: regionName ?? this.regionName,
      regionNumber: regionNumber ?? this.regionNumber,

      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
