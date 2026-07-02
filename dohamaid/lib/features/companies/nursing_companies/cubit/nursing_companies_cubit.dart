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
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

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
    _searchQuery = '';

    try {
      final data = await CompaniesServices(ApiService()).getAllNursingCompanies( currentPage);
      activateWebViewUrls = data?.active??0;

      nursingCompanies = data?.data;
      hasMore = (data?.data?.length??0 )>= 10; // backend page size

      _createAnimations(nursingCompanies?.length??0);

      emit(NursingCompaniesLoaded(
        nursingCompanies,
        displayedCompanies: _applySearch(nursingCompanies),
        hasMore: hasMore,
        searchQuery: _searchQuery,
      ));
      controller.forward();
    } catch (e) {
      emit(NursingCompaniesError(e.toString()));
    }
  }

  // 🔥 Load More Data
  Future<void> loadMore(BuildContext context) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(NursingCompaniesLoadingMore(
      nursingCompanies,
      displayedCompanies: _applySearch(nursingCompanies),
      searchQuery: _searchQuery,
    ));

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
      emit(NursingCompaniesLoaded(
        nursingCompanies,
        displayedCompanies: _applySearch(nursingCompanies),
        hasMore: hasMore,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      isLoadingMore = false;
      emit(NursingCompaniesError(e.toString()));
    }


  }


  /// Filters the already-fetched list locally — does NOT hit the network.
  List<WorkerCompanyData> _applySearch(List<WorkerCompanyData>? all) {
    final list = all ?? [];
    if (_searchQuery.isEmpty) return List<WorkerCompanyData>.from(list);
    final q = _searchQuery.toLowerCase();
    return list.where((c) => (c.name ?? '').toLowerCase().contains(q)).toList();
  }

  /// Updates the search query and re-emits the current list filtered locally.
  /// Works whether the list is fully loaded or still paginating —
  /// new pages fetched afterwards will also be filtered by this query.
  void search(String query,BuildContext context) {
    _searchQuery = query.trim();
    final displayed = _applySearch(nursingCompanies);
    if(displayed.length < 10){
      if (isLoadingMore || !hasMore) return;
      loadMore(context);
    }

    if (state is NursingCompaniesLoaded || state is NursingCompaniesLoadingMore) {
      emit(NursingCompaniesLoaded(
        nursingCompanies,
        displayedCompanies: displayed,
        hasMore: hasMore,
        searchQuery: _searchQuery,
      ));
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