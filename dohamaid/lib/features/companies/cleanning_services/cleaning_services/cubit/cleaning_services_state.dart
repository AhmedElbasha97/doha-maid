import '../data/cleaning_services_model.dart';

abstract class CleaningServicesState {}

class CleaningServicesInitial extends CleaningServicesState {}

class CleaningServicesLoading extends CleaningServicesState {}

/// Normal loaded state — carries both the full list and the search-filtered view.
class CleaningServicesLoaded extends CleaningServicesState {
  /// All items fetched so far (accumulates across pages).
  final List<CleaningServiceItem> allItems;

  /// Items after applying [searchQuery] — what the list renders.
  final List<CleaningServiceItem> displayedItems;

  final bool hasMore;
  final String searchQuery;

   CleaningServicesLoaded({
    required this.allItems,
    required this.displayedItems,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

/// Appended to the bottom of the list while the next page is fetching.
class CleaningServicesLoadingMore extends CleaningServicesState {
  final List<CleaningServiceItem> allItems;
  final List<CleaningServiceItem> displayedItems;
  final String searchQuery;

   CleaningServicesLoadingMore({
    required this.allItems,
    required this.displayedItems,
    required this.searchQuery,
  });
}

class CleaningServicesError extends CleaningServicesState {
  final String message;
  CleaningServicesError(this.message);
}
