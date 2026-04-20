import 'package:dohamaid/core/data/datasources/api_service.dart';
import 'package:dohamaid/core/services/companies_services.dart';
import 'package:dohamaid/features/companies/anti_bug_companies/presentaion/anti_bug_companies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/home_screen.dart';
import '../../worker_companies/data/worker_companies_model.dart';
import 'anti_bug_companies_state.dart';

class AntiBugCompaniesCubit extends Cubit<AntiBugCompaniesState> with ChangeNotifier {
  AntiBugCompaniesCubit() : super(AntiBugCompaniesInitial());
  List<WorkerCompanyData>? antiBugCompanies = [];
  int? activateWebViewUrls;
  late AnimationController controller;
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
      screen: const AntiBugCompaniesScreen(),
      routeName: "AntiBugCompaniesScreen",
    );// or reload data as needed
  }
  Future<void> loadAntiBugCompanies(AnimationController ctrl) async {
    controller = ctrl;
    emit(AntiBugCompaniesLoading());
    currentPage = 1;
    hasMore = true;

    try {
      final data = await CompaniesServices(ApiService()).getAllAntiBugCompanies( currentPage);
      activateWebViewUrls = data?.active??0;
      antiBugCompanies = data?.data;
      hasMore = (data?.data?.length??0 )>= 10; // backend page size

      _createAnimations(antiBugCompanies?.length??0);

      emit(AntiBugCompaniesLoaded(antiBugCompanies, hasMore: hasMore));
      controller.forward();
    } catch (e) {
      emit(AntiBugCompaniesError(e.toString()));
    }
  }

  // 🔥 Load More Data
  Future<void> loadMore(BuildContext context) async {
      if (isLoadingMore || !hasMore) return;

      isLoadingMore = true;
      emit(AntiBugCompaniesLoadingMore(antiBugCompanies));

      currentPage++;

      try {
        final data = await CompaniesServices(ApiService())
            .getAllAntiBugCompanies(currentPage);
        final moreData = data?.data ?? [];

        if (moreData.isEmpty) {
          hasMore = false;
        } else {
          antiBugCompanies?.addAll(moreData);
          _createAnimations(antiBugCompanies?.length ?? 0);
        }

        isLoadingMore = false;
        emit(AntiBugCompaniesLoaded(antiBugCompanies, hasMore: hasMore));
      } catch (e) {
        isLoadingMore = false;
        emit(AntiBugCompaniesError(e.toString()));
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