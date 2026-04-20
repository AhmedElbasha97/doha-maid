import '../data/worker_companies_model.dart';

abstract class WorkerCompaniesState {}

class WorkerCompaniesInitial extends WorkerCompaniesState {}

class WorkerCompaniesLoading extends WorkerCompaniesState {}

class WorkerCompaniesLoaded extends WorkerCompaniesState {
  final List<WorkerCompanyData>? workerCompanies;
  final bool hasMore;

  WorkerCompaniesLoaded(this.workerCompanies,{this.hasMore = true});
}

class WorkerCompaniesLoadingMore extends WorkerCompaniesState {
  final List<WorkerCompanyData>? workerCompanies;
  WorkerCompaniesLoadingMore(this.workerCompanies);
}
class WorkerCompaniesError extends WorkerCompaniesState {
  final String message;
  WorkerCompaniesError(this.message);
}
