import '../../worker_companies/data/worker_companies_model.dart';

abstract class AntiBugCompaniesState {}

class AntiBugCompaniesInitial extends AntiBugCompaniesState {}

class AntiBugCompaniesLoading extends AntiBugCompaniesState {}

class AntiBugCompaniesLoaded extends AntiBugCompaniesState {
  /// All items accumulated across pages.
  final List<WorkerCompanyData>? antiBugCompanies;

  /// Items after applying [searchQuery] — what the list renders.
  final List<WorkerCompanyData>? displayedCompanies;

  final bool hasMore;
  final String searchQuery;

  AntiBugCompaniesLoaded(
    this.antiBugCompanies, {
    this.displayedCompanies,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

class AntiBugCompaniesLoadingMore extends AntiBugCompaniesState {
  final List<WorkerCompanyData>? antiBugCompanies;
  final List<WorkerCompanyData>? displayedCompanies;
  final String searchQuery;

  AntiBugCompaniesLoadingMore(
    this.antiBugCompanies, {
    this.displayedCompanies,
    this.searchQuery = '',
  });
}
class AntiBugCompaniesError extends AntiBugCompaniesState {
  final String message;
  AntiBugCompaniesError(this.message);
}