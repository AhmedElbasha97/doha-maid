import 'package:dohamaid/core/data/datasources/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../data/cleaning_services_model.dart';
import 'cleaning_services_state.dart';

class CleaningServicesCubit extends Cubit<CleaningServicesState>
    with ChangeNotifier {
  CleaningServicesCubit() : super(CleaningServicesInitial());

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int _pageSize = 10;
  static const String _endpoint = 'https://dohamaid.com/api/all/services';

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // ── Data ──────────────────────────────────────────────────────────────────
  final List<CleaningServiceItem> _allItems = [];
  String _searchQuery = '';

  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController controller;
  List<Animation<double>> fadeAnimations = [];
  List<Animation<Offset>> slideAnimations = [];

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> loadServices(AnimationController ctrl) async {
    controller = ctrl;
    emit(CleaningServicesLoading());

    _currentPage = 1;
    _hasMore = true;
    _allItems.clear();
    _searchQuery = '';

    try {
      final items = await _fetchPage(_currentPage);
      _allItems.addAll(items);
      _hasMore = items.length >= _pageSize;
      _buildAnimations(_allItems.length);

      emit(CleaningServicesLoaded(
        allItems: List.from(_allItems),
        displayedItems: _applySearch(_allItems),
        hasMore: _hasMore,
        searchQuery: _searchQuery,
      ));
      controller.forward();
    } catch (e) {
      emit(CleaningServicesError(e.toString()));
    }
  }

  /// Called from the scroll listener.
  /// Key behaviour: pagination only returns items the user has scrolled to —
  /// i.e. the new page is appended but search is re-applied so displayed list
  /// grows naturally as the user scrolls, no jumpiness.
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    final current = _currentLoaded;
    if (current == null) {
      _isLoadingMore = false;
      return;
    }

    emit(CleaningServicesLoadingMore(
      allItems: current.allItems,
      displayedItems: current.displayedItems,
      searchQuery: _searchQuery,
    ));

    _currentPage++;

    try {
      final items = await _fetchPage(_currentPage);

      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _allItems.addAll(items);
        _buildAnimations(_allItems.length);
      }

      _isLoadingMore = false;

      emit(CleaningServicesLoaded(
        allItems: List.from(_allItems),
        displayedItems: _applySearch(_allItems),
        hasMore: _hasMore,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      _isLoadingMore = false;
      emit(CleaningServicesError(e.toString()));
    }
  }

  /// Filters the already-fetched list — does NOT hit the network.
  /// When the user clears the query, all accumulated items are visible again.
  void search(String query) {
    _searchQuery = query.trim();
    final current = _currentLoaded ?? _currentLoadingMore;
    if (current == null) return;

    emit(CleaningServicesLoaded(
      allItems: List.from(_allItems),
      displayedItems: _applySearch(_allItems),
      hasMore: _hasMore,
      searchQuery: _searchQuery,
    ));
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<List<CleaningServiceItem>> _fetchPage(int page) async {
    final dio = Dio();
    final response = await dio.get(
      _endpoint,

    );
    final model = CleaningServicesModel.fromJson(response.data);
    return model.data ?? [];
  }

  List<CleaningServiceItem> _applySearch(List<CleaningServiceItem> source) {
    if (_searchQuery.isEmpty) return List.from(source);
    final q = _searchQuery.toLowerCase();
    return source.where((item) {
      return (item.name?.toLowerCase().contains(q) ?? false) ||
          (item.companyName?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  void _buildAnimations(int count) {
    fadeAnimations = List.generate(
      count,
      (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval((i * 0.05).clamp(0.0, 1.0), 1.0,
              curve: Curves.easeOut),
        ),
      ),
    );
    slideAnimations = List.generate(
      count,
      (i) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval((i * 0.05).clamp(0.0, 1.0), 1.0,
              curve: Curves.easeOut),
        ),
      ),
    );
  }

  CleaningServicesLoaded? get _currentLoaded =>
      state is CleaningServicesLoaded ? state as CleaningServicesLoaded : null;

  CleaningServicesLoadingMore? get _currentLoadingMore =>
      state is CleaningServicesLoadingMore
          ? state as CleaningServicesLoadingMore
          : null;
}
