import '../../worker_companies/data/worker_companies_model.dart';

abstract class WorkerSuppliersState {}

class WorkerSuppliersInitial extends WorkerSuppliersState {}

class WorkerSuppliersLoading extends WorkerSuppliersState {}

class WorkerSuppliersLoaded extends WorkerSuppliersState {
  final List<WorkerCompanyData>? workerSuppliers;
  final bool hasMore;

  WorkerSuppliersLoaded(this.workerSuppliers,{this.hasMore = true});
}

class WorkerSuppliersLoadingMore extends WorkerSuppliersState {
  final List<WorkerCompanyData>? workerSuppliers;
  WorkerSuppliersLoadingMore(this.workerSuppliers);
}
class WorkerSuppliersError extends WorkerSuppliersState {
  final String message;
  WorkerSuppliersError(this.message);
}