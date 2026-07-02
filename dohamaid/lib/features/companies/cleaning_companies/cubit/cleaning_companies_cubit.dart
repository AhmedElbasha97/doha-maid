import 'package:dohamaid/core/data/datasources/api_service.dart';
import 'package:dohamaid/core/services/companies_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/home_screen.dart';
import '../../worker_companies/data/worker_companies_model.dart';
import '../presentation/cleaning_companies_screen.dart';
import 'cleaning_comanies_state.dart';

class CleaningCompaniesCubit extends Cubit<CleaningCompaniesState> with ChangeNotifier {
  CleaningCompaniesCubit() : super(CleaningCompaniesInitial());
  List<WorkerCompanyData>? cleaningCompanies = [];
  late AnimationController controller;
  List<Animation<double>> fadeAnimations = [];
  List<Animation<Offset>> slideAnimations = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  int? activateWebViewUrls;

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
      screen: const CleaningCompaniesScreen(),
      routeName: "CleaningCompaniesScreen",
    );// or reload data as needed
  }
  Future<void> loadCleaningCompanies(AnimationController ctrl) async {
    controller = ctrl;
    emit(CleaningCompaniesLoading());
    currentPage = 1;
    hasMore = true;
    _searchQuery = '';

    try {
      final data = await CompaniesServices(ApiService()).getAllCleaningCompanies( currentPage);

      cleaningCompanies = data?.data;
      activateWebViewUrls = data?.active??0;

      hasMore = (data?.data?.length??0 )>= 10; // backend page size

      _createAnimations(cleaningCompanies?.length??0);

      emit(CleaningCompaniesLoaded(
        cleaningCompanies,
        displayedCompanies: _applySearch(cleaningCompanies),
        hasMore: hasMore,
        searchQuery: _searchQuery,
      ));
      controller.forward();
    } catch (e) {
      emit(CleaningCompaniesError(e.toString()));
    }
  }

  // 🔥 Load More Data
  Future<void> loadMore(BuildContext context) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(CleaningCompaniesLoadingMore(
      cleaningCompanies,
      displayedCompanies: _applySearch(cleaningCompanies),
      searchQuery: _searchQuery,
    ));

    currentPage++;

    try {
      final data = await CompaniesServices(ApiService()).getAllCleaningCompanies( currentPage);
      final moreData = data?.data??[];

      if (moreData.isEmpty) {
        hasMore = false;
      } else {
        cleaningCompanies?.addAll(moreData);
        _createAnimations(cleaningCompanies?.length??0);
      }

      isLoadingMore = false;
      emit(CleaningCompaniesLoaded(
        cleaningCompanies,
        displayedCompanies: _applySearch(cleaningCompanies),
        hasMore: hasMore,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      isLoadingMore = false;
      emit(CleaningCompaniesError(e.toString()));
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
    final displayed = _applySearch(cleaningCompanies);
    if(displayed.length < 10){
      if (isLoadingMore || !hasMore) return;
      loadMore(context);
    }

    if (state is CleaningCompaniesLoaded || state is CleaningCompaniesLoadingMore) {
      emit(CleaningCompaniesLoaded(
        cleaningCompanies,
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