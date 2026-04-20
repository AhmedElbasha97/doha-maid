import '../../worker_companies/data/worker_companies_model.dart';

abstract class AntiBugCompaniesState {}

class AntiBugCompaniesInitial extends AntiBugCompaniesState {}

class AntiBugCompaniesLoading extends AntiBugCompaniesState {}

class AntiBugCompaniesLoaded extends AntiBugCompaniesState {
  final List<WorkerCompanyData>? antiBugCompanies;
  final bool hasMore;

  AntiBugCompaniesLoaded(this.antiBugCompanies,{this.hasMore = true});
}

class AntiBugCompaniesLoadingMore extends AntiBugCompaniesState {
  final List<WorkerCompanyData>? antiBugCompanies;
  AntiBugCompaniesLoadingMore(this.antiBugCompanies);
}
class AntiBugCompaniesError extends AntiBugCompaniesState {
  final String message;
  AntiBugCompaniesError(this.message);
}