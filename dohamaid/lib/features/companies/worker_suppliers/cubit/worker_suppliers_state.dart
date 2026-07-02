import '../../worker_companies/data/worker_companies_model.dart';

abstract class WorkerSuppliersState {}

class WorkerSuppliersInitial extends WorkerSuppliersState {}

class WorkerSuppliersLoading extends WorkerSuppliersState {}

class WorkerSuppliersLoaded extends WorkerSuppliersState {
  /// All items accumulated across pages.
  final List<WorkerCompanyData>? workerSuppliers;

  /// Items after applying [searchQuery] — what the list renders.
  final List<WorkerCompanyData>? displayedCompanies;

  final bool hasMore;
  final String searchQuery;

  WorkerSuppliersLoaded(
    this.workerSuppliers, {
    this.displayedCompanies,
    this.hasMore = true,
    this.searchQuery = '',
  });
}

class WorkerSuppliersLoadingMore extends WorkerSuppliersState {
  final List<WorkerCompanyData>? workerSuppliers;
  final List<WorkerCompanyData>? displayedCompanies;
  final String searchQuery;

  WorkerSuppliersLoadingMore(
    this.workerSuppliers, {
    this.displayedCompanies,
    this.searchQuery = '',
  });
}
class WorkerSuppliersError extends WorkerSuppliersState {
  final String message;
  WorkerSuppliersError(this.message);
}