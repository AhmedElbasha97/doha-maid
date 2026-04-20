import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/place_suggestion.dart';
import '../data/places_autocomplete_service.dart';
import 'location_selection_state.dart';

/// Default map center (Doha) when location is unavailable.
const double _defaultLat = 25.2854;
const double _defaultLng = 51.5310;

class LocationSelectionCubit extends Cubit<LocationSelectionState> {
  final FocusNode streetNameFocusNode = FocusNode();
  final FocusNode streetNumberFocusNode = FocusNode();
  final FocusNode regionNameFocusNode = FocusNode();
  final FocusNode regionNumberFocusNode = FocusNode();
  final FocusNode buildingNumberFocusNode = FocusNode();

  LocationSelectionCubit() : super(const LocationSelectionState()) {
    _places = PlacesAutocompleteService();
    fetchCurrentLocation();
  }


  late final PlacesAutocompleteService _places;

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      suggestions: [],
    ));
    try {
      final granted = await _requestLocationPermission();
      if (!granted) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Location permission denied',
          lat: _defaultLat,
          lng: _defaultLng,
        ));
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await _updateFromPosition(pos.latitude, pos.longitude);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        lat: _defaultLat,
        lng: _defaultLng,
      ));
    }
  }

  Future<bool> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> _updateFromPosition(double lat, double lng) async {
    String street = '';
    try {
      final places = await placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final p = places.first;
        street = [
          p.thoroughfare,
          p.subThoroughfare,
          p.street,
          p.locality,
        ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
      }
    } catch (_) {
      /* keep street empty */
    }
    emit(state.copyWith(
      lat: lat,
      lng: lng,
      streetName: street,
      isLoading: false,
      clearError: true,
    ));
  }

  void useCurrentLocation() => fetchCurrentLocation();

  /// Search for an address and move map + update street. Uses [geocoding].
  Future<void> searchAddress(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final locations = await locationFromAddress(q);
      if (locations.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          error: 'address_not_found',
        ));
        return;
      }
      final loc = locations.first;
      await _updateFromPosition(loc.latitude, loc.longitude);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'address_not_found',
      ));
    }
  }

  /// Update selected location from map tap or drag (camera idle). Reverse-geocodes to street.
  Future<void> updatePositionFromMap(double lat, double lng) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      suggestions: [],
    ));
    await _updateFromPosition(lat, lng);
  }

  void setStreetName(String value) =>
      emit(state.copyWith(streetName: value));

  void setRegionName(String value) =>
      emit(state.copyWith(regionName: value));
  void setStreetNumber(String value) =>
      emit(state.copyWith(streetNumber: value));

  void setRegionNumber(String value) =>
      emit(state.copyWith(regionNumber: value));

  void setBuildingNumber(String value) =>
      emit(state.copyWith(buildingNumber: value));

  void setSearchQuery(String value) =>
      emit(state.copyWith(searchQuery: value));

  /// Fetches place suggestions as user types. Optional [language] e.g. 'en', 'ar'.
  Future<void> fetchSuggestions(String query, {String? language}) async {
    final q = query.trim();
    if (q.isEmpty) {
      emit(state.copyWith(suggestions: [], suggestionsLoading: false));
      return;
    }
    emit(state.copyWith(suggestionsLoading: true));
    try {
      final list = await _places.fetchSuggestions(q, language: language, lat: state.lat??0.0, lng: state.lng??0.0);
      print(list);
      emit(state.copyWith(
        suggestions: list,
        suggestionsLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        suggestions: [],
        suggestionsLoading: false,
      ));
    }
  }

  void clearSuggestions() =>
      emit(state.copyWith(suggestions: [], suggestionsLoading: false));

  /// Selects a suggestion: fetches lat/lng, updates map and address, clears suggestions.
  Future<void> selectSuggestion(PlaceSuggestion s) async {
    emit(state.copyWith(isLoading: true, clearError: true, suggestions: []));
    try {
      final details = await _places.fetchPlaceDetails(s.placeId);
      if (details == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'address_not_found',
        ));
        return;
      }
      await _updateFromPosition(details.lat, details.lng);
      emit(state.copyWith(searchQuery: s.description));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        error: 'address_not_found',
      ));
    }
  }

  void selectSavedLocation(SavedLocationType type) {
    emit(state.copyWith(selectedSavedLocation: type));
    // TODO: Load home/work from storage and update lat/lng + street if available.
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
