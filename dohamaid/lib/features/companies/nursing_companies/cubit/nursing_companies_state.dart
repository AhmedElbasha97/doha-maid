import '../../worker_companies/data/worker_companies_model.dart';

abstract class NursingCompaniesState {}

class NursingCompaniesInitial extends NursingCompaniesState {}

class NursingCompaniesLoading extends NursingCompaniesState {}

class NursingCompaniesLoaded extends NursingCompaniesState {
  /// All items accumulated across pages.
  final List<WorkerCompanyData>? nursingCompanies;

  /// Items after applying [searchQuery] — what the list renders.
  final List<WorkerCompanyData>? displayedCompanies;

  final bool hasMore;
  final String searchQuery;

  NursingCompaniesLoaded(
    this.nursingCompanies, {
    this.displayedCompanies,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

class NursingCompaniesLoadingMore extends NursingCompaniesState {
  final List<WorkerCompanyData>? nursingCompanies;
  final List<WorkerCompanyData>? displayedCompanies;
  final String searchQuery;

  NursingCompaniesLoadingMore(
    this.nursingCompanies, {
    this.displayedCompanies,
    this.searchQuery = '',
  });
}
class NursingCompaniesError extends NursingCompaniesState {
  final String message;
  NursingCompaniesError(this.message);
}