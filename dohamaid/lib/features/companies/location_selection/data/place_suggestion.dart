/// A single suggestion from Places Autocomplete.
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.description,
    required this.placeId,
  });

  final String description;
  final String placeId;
}
