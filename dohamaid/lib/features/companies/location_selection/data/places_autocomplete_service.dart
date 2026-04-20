import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/utils/app_constants.dart';
import 'place_suggestion.dart';

/// Calls Google Places Autocomplete (Legacy) and Place Details (Legacy) APIs.
/// Requires Places API enabled for the project and [AppConstants.kGoogleMapsApiKey].
class PlacesAutocompleteService {
  PlacesAutocompleteService() : _key = AppConstants.kGoogleMapsApiKey;

  final String _key;
  static const _base = 'https://maps.googleapis.com/maps/api/place';

  /// Fetches address suggestions for [input]. Optional [language] (e.g. 'en', 'ar').
  /// Biases results to Qatar via components=country:qa.
  Future<List<PlaceSuggestion>> fetchSuggestions(
    String input, {
        required double lat,
        required double lng,
    String? language,
  }) async {
    final q = input.trim();
    if (q.isEmpty) return [];
    final query = <String, String>{
      'input': q,
      'types': 'geocode',
      'location': '$lat,$lng',
      'radius': '50000', // 50 km
      'key': _key,
      'components': 'country:eg',
    };
    if (language != null && language.isNotEmpty) query['language'] = language;
    final uri = Uri.parse('$_base/autocomplete/json').replace(queryParameters: query);
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final json = jsonDecode(res.body) as Map<String, dynamic>?;
    if (json == null) return [];
    final status = json['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') return [];
    final list = json['predictions'] as List<dynamic>?;
    if (list == null || list.isEmpty) return [];
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      final desc = m['description'] as String? ?? '';
      final id = m['place_id'] as String? ?? '';
      return PlaceSuggestion(description: desc, placeId: id);
    }).where((s) => s.placeId.isNotEmpty).toList();
  }

  /// Fetches lat/lng for [placeId] via Place Details (Legacy). Request only geometry.
  Future<({double lat, double lng})?> fetchPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;
    final uri = Uri.parse('$_base/details/json').replace(
      queryParameters: {
        'place_id': placeId,
        'fields': 'geometry',
        'key': _key,
      },
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) return null;
    final json = jsonDecode(res.body) as Map<String, dynamic>?;
    if (json == null) return null;
    if (json['status'] != 'OK') return null;
    final result = json['result'] as Map<String, dynamic>?;
    final geometry = result?['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    if (location == null) return null;
    final lat = (location['lat'] as num?)?.toDouble();
    final lng = (location['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return (lat: lat, lng: lng);
  }
}
