import 'package:dohamaid/core/data/datasources/api_service.dart';
import 'package:dohamaid/core/services/companies_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/home_screen.dart';
import '../../worker_companies/data/worker_companies_model.dart';
import '../presentation/nursing_companies_screen.dart';
import 'nursing_companies_state.dart';

class NursingCompaniesCubit extends Cubit<NursingCompaniesState> with ChangeNotifier {
  NursingCompaniesCubit() : super(NursingCompaniesInitial());
  List<WorkerCompanyData>? nursingCompanies = [];
  late AnimationController controller;
  List<Animation<double>> fadeAnimations = [];
  List<Animation<Offset>> slideAnimations = [];
  int? activateWebViewUrls;
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
      screen: const NursingCompaniesScreen(),
      routeName: "NursingCompaniesScreen",
    );// or reload data as needed
  }

  Future<void> loadNursingCompanies(AnimationController ctrl) async {
    controller = ctrl;
    emit(NursingCompaniesLoading());
    currentPage = 1;
    hasMore = true;

    try {
      final data = await CompaniesServices(ApiService()).getAllNursingCompanies( currentPage);
      activateWebViewUrls = data?.active??0;

      nursingCompanies = data?.data;
      hasMore = (data?.data?.length??0 )>= 10; // backend page size

      _createAnimations(nursingCompanies?.length??0);

      emit(NursingCompaniesLoaded(nursingCompanies, hasMore: hasMore));
      controller.forward();
    } catch (e) {
      emit(NursingCompaniesError(e.toString()));
    }
  }

  // 🔥 Load More Data
  Future<void> loadMore(BuildContext context) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(NursingCompaniesLoadingMore(nursingCompanies));

    currentPage++;

    try {
      final data = await CompaniesServices(ApiService()).getAllNursingCompanies( currentPage);
      final moreData = data?.data??[];

      if (moreData.isEmpty) {
        hasMore = false;
      } else {
        nursingCompanies?.addAll(moreData);
        _createAnimations(nursingCompanies?.length??0);
      }

      isLoadingMore = false;
      emit(NursingCompaniesLoaded(nursingCompanies, hasMore: hasMore));
    } catch (e) {
      isLoadingMore = false;
      emit(NursingCompaniesError(e.toString()));
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