part of 'company_details_cubit.dart';


abstract class CompanyDetailsState {}

class CompanyDetailsInitial extends CompanyDetailsState {}

class CompanyDetailsLoading extends CompanyDetailsState {}

class CompanyDetailsLoaded extends CompanyDetailsState {
  final CompanyDetailsModel? model;
  CompanyDetailsLoaded(this.model);
}

class CompanyDetailsError extends CompanyDetailsState {
  final String message;
  CompanyDetailsError(this.message);
}
