import 'package:dohamaid/core/data/datasources/api_service.dart';
import 'package:dohamaid/core/services/companies_services.dart';
import 'package:dohamaid/features/companies/worker_companies/cubit/worker_companies_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/home_screen.dart';
import '../data/worker_companies_model.dart';
import '../presentation/worker_companies_screen.dart';

class WorkerCompaniesCubit extends Cubit<WorkerCompaniesState> with ChangeNotifier {
  WorkerCompaniesCubit() : super(WorkerCompaniesInitial());
  List<WorkerCompanyData>? workerCompanies = [];
  late AnimationController controller;
  int? activateWebViewUrls;

  List<Animation<double>> fadeAnimations = [];
  List<Animation<Offset>> slideAnimations = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isScreenAlreadyOpen(BuildContext context, Type screenType) {
    bool isOpen = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == "$screenType") {
        isOpen = true;
      }
      return true;
    });

    return isOpen;
  }
  void _navigateIfNotOpen(
      BuildContext context, {
        required Widget screen,
        required String routeName,
      }) {
    if (isScreenAlreadyOpen(context, screen.runtimeType)) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen(),    settings: const RouteSettings(name: "HomeScreen"),
        ),
            (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: routeName),
        ),
      );
    }
  }
  void resetState(BuildContext context) {
     _navigateIfNotOpen(
      context,
      screen: const WorkerCompaniesScreen(),
      routeName: "WorkerCompaniesScreen",
    );// or reload data as needed
  }
  Future<void> loadWorkerCompanies(AnimationController ctrl) async {
    controller = ctrl;
    emit(WorkerCompaniesLoading());
    currentPage = 1;
    hasMore = true;

    try {
      final data = await CompaniesServices(ApiService()).getAllWorkerCompanies( currentPage);
      activateWebViewUrls = data?.active??0;
      workerCompanies = data?.data;
      hasMore = (data?.data?.length??0 )>= 10; // backend page size


      _createAnimations(workerCompanies?.length??0);

      emit(WorkerCompaniesLoaded(workerCompanies, hasMore: hasMore));
      controller.forward();
    } catch (e) {
      emit(WorkerCompaniesError(e.toString()));
    }
  }

  // 🔥 Load More Data
  Future<void> loadMore(BuildContext context) async {
      if (isLoadingMore || !hasMore) return;

      isLoadingMore = true;
      emit(WorkerCompaniesLoadingMore(workerCompanies));

      currentPage++;

      try {
        final data = await CompaniesServices(ApiService())
            .getAllWorkerCompanies(currentPage);
        final moreData = data?.data ?? [];

        if (moreData.isEmpty) {
          hasMore = false;
        } else {
          workerCompanies?.addAll(moreData);
          _createAnimations(workerCompanies?.length ?? 0);
        }

        isLoadingMore = false;
        emit(WorkerCompaniesLoaded(workerCompanies, hasMore: hasMore));
      } catch (e) {
        isLoadingMore = false;
        emit(WorkerCompaniesError(e.toString()));
      }

  }


  void _createAnimations(int count) {
    fadeAnimations = List.generate(
      count,
          (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval((i * 0.05).clamp(0, 1.0), 1, curve: Curves.easeOut),
        ),
      ),
    );

    slideAnimations = List.generate(
      count,
          (i) => Tween<Offset>(
        begin: const Offset(0, .3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval((i * 0.05).clamp(0, 1.0), 1, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
