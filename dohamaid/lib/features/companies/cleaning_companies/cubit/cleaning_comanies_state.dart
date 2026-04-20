import '../../worker_companies/data/worker_companies_model.dart';

abstract class CleaningCompaniesState {}

class CleaningCompaniesInitial extends CleaningCompaniesState {}

class CleaningCompaniesLoading extends CleaningCompaniesState {}

class CleaningCompaniesLoaded extends CleaningCompaniesState {
  final List<WorkerCompanyData>? cleaningCompanies;
  final bool hasMore;

  CleaningCompaniesLoaded(this.cleaningCompanies,{this.hasMore = true});
}

class CleaningCompaniesLoadingMore extends CleaningCompaniesState {
  final List<WorkerCompanyData>? cleaningCompanies;
  CleaningCompaniesLoadingMore(this.cleaningCompanies);
}
class CleaningCompaniesError extends CleaningCompaniesState {
  final String message;
  CleaningCompaniesError(this.message);
}
