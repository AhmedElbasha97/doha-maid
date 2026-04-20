import '../../worker_companies/data/worker_companies_model.dart';

abstract class NursingCompaniesState {}

class NursingCompaniesInitial extends NursingCompaniesState {}

class NursingCompaniesLoading extends NursingCompaniesState {}

class NursingCompaniesLoaded extends NursingCompaniesState {
  final List<WorkerCompanyData>? nursingCompanies;
  final bool hasMore;

  NursingCompaniesLoaded(this.nursingCompanies,{this.hasMore = true});
}

class NursingCompaniesLoadingMore extends NursingCompaniesState {
  final List<WorkerCompanyData>? nursingCompanies;
  NursingCompaniesLoadingMore(this.nursingCompanies);
}
class NursingCompaniesError extends NursingCompaniesState {
  final String message;
  NursingCompaniesError(this.message);
}