import '../data/worker_companies_model.dart';

abstract class WorkerCompaniesState {}

class WorkerCompaniesInitial extends WorkerCompaniesState {}

class WorkerCompaniesLoading extends WorkerCompaniesState {}

class WorkerCompaniesLoaded extends WorkerCompaniesState {
  /// All items accumulated across pages.
  final List<WorkerCompanyData>? workerCompanies;

  /// Items after applying [searchQuery] — what the list renders.
  final List<WorkerCompanyData>? displayedCompanies;

  final bool hasMore;
  final String searchQuery;

  WorkerCompaniesLoaded(
    this.workerCompanies, {
    this.displayedCompanies,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

class WorkerCompaniesLoadingMore extends WorkerCompaniesState {
  final List<WorkerCompanyData>? workerCompanies;
  final List<WorkerCompanyData>? displayedCompanies;
  final String searchQuery;

  WorkerCompaniesLoadingMore(
    this.workerCompanies, {
    this.displayedCompanies,
    this.searchQuery = '',
  });
}
class WorkerCompaniesError extends WorkerCompaniesState {
  final String message;
  WorkerCompaniesError(this.message);
}
