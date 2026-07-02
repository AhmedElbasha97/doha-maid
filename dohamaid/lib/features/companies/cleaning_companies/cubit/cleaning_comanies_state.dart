import '../../worker_companies/data/worker_companies_model.dart';

abstract class CleaningCompaniesState {}

class CleaningCompaniesInitial extends CleaningCompaniesState {}

class CleaningCompaniesLoading extends CleaningCompaniesState {}

class CleaningCompaniesLoaded extends CleaningCompaniesState {
  /// All items accumulated across pages.
  final List<WorkerCompanyData>? cleaningCompanies;

  /// Items after applying [searchQuery] — what the list renders.
  final List<WorkerCompanyData>? displayedCompanies;

  final bool hasMore;
  final String searchQuery;

  CleaningCompaniesLoaded(
    this.cleaningCompanies, {
    this.displayedCompanies,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

class CleaningCompaniesLoadingMore extends CleaningCompaniesState {
  final List<WorkerCompanyData>? cleaningCompanies;
  final List<WorkerCompanyData>? displayedCompanies;
  final String searchQuery;

  CleaningCompaniesLoadingMore(
    this.cleaningCompanies, {
    this.displayedCompanies,
    this.searchQuery = '',
  });
}
class CleaningCompaniesError extends CleaningCompaniesState {
  final String message;
  CleaningCompaniesError(this.message);
}
