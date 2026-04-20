import '../data/location_list_model.dart';

abstract class LocationListState {}

class LocationListInitial extends LocationListState {}

class LocationListLoading extends LocationListState {}

class LocationListLoaded extends LocationListState {
  final LocationResponseModel locationListResponse;

  LocationListLoaded(this.locationListResponse);
}

class LocationListError extends LocationListState {
  final String message;

  LocationListError(this.message);
}