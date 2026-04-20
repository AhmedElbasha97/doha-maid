import '../data/address_model.dart';
import '../data/place_suggestion.dart';

enum SavedLocationType { none, home, work }

class LocationSelectionState {
  const LocationSelectionState({
    this.streetNumber = '',
    this.lat,
    this.lng,
    this.streetName = '',
    this.regionName = '',
    this.regionNumber = '',
    this.buildingNumber = '',
    this.isLoading = false,
    this.error,
    this.selectedSavedLocation = SavedLocationType.none,
    this.searchQuery = '',
    this.suggestions = const [],
    this.suggestionsLoading = false,
  });

  final double? lat;
  final double? lng;
  final String streetName;
  final String streetNumber;
  final String regionName;
  final String regionNumber;
  final String buildingNumber;
  final bool isLoading;
  final String? error;
  final SavedLocationType selectedSavedLocation;
  final String searchQuery;
  final List<PlaceSuggestion> suggestions;
  final bool suggestionsLoading;

  AddressModel get address => AddressModel(
        streetName: streetName,
        streetNumber: streetNumber,
        buildingNumber: buildingNumber,
        regionNumber: regionNumber,
        regionName: regionName,
        lat: lat,
        lng: lng,
      );

  LocationSelectionState copyWith({
    double? lat,
    double? lng,
    String? streetName,
    String? regionName,
     String? streetNumber,

    String? regionNumber,
    String? buildingNumber,
    bool? isLoading,
    String? error,
    bool clearError = false,
    SavedLocationType? selectedSavedLocation,
    String? searchQuery,
    List<PlaceSuggestion>? suggestions,
    bool? suggestionsLoading,
  }) {
    return LocationSelectionState(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      streetName: streetName ?? this.streetName,
      regionName: regionName ?? this.regionName,
      regionNumber: regionNumber ?? this.regionNumber,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      isLoading: isLoading ?? this.isLoading,
         streetNumber: streetNumber ?? this.streetNumber,

    error: clearError ? null : (error ?? this.error),
      selectedSavedLocation: selectedSavedLocation ?? this.selectedSavedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
      suggestions: suggestions ?? this.suggestions,
      suggestionsLoading: suggestionsLoading ?? this.suggestionsLoading,
    );
  }
}
