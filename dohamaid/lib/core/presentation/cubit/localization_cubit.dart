// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../features/companies/anti_bug_companies/cubit/anti_bug_companies_cubit.dart';
import '../../../features/companies/cleaning_companies/cubit/cleaning_companies_cubit.dart';
import '../../../features/companies/company_details/cubit/company_details_cubit.dart';
import '../../../features/companies/nursing_companies/cubit/nursing_companies_cubit.dart';
import '../../../features/companies/worker_companies/cubit/worker_companies_cubit.dart';
import '../../../features/companies/worker_suppliers/cubit/worker_suppliers_cubit.dart';
import '../../../features/home/cubit/home_cubit.dart';
import '../../../features/welcome/cubit/welcome_cuibit.dart';
import '../../data/datasources/storage_local_data_source.dart';

class LocalizationCubit extends Cubit<Locale> {
  final StorageLocalDataSource storage;

  static const Locale defaultLocale = Locale('en');

  LocalizationCubit(this.storage) : super(defaultLocale);

  // BUG FIX 3: getSavedLocaleCode() returns String, not Future<String>.
  // Removed incorrect `await` — it compiled only because Dart allows
  // `await` on non-Futures (returns the value directly), but it signals
  // a misunderstanding and can break if the signature ever changes.
  Future<void> loadLocale(BuildContext context) async {
    final code = storage.getSavedLocaleCode();
    final newLocale = code.isNotEmpty ? Locale(code) : defaultLocale;
    emit(newLocale);
    await context.setLocale(newLocale);
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final newCode = state.languageCode == 'en' ? 'ar' : 'en';
    final newLocale = Locale(newCode);
    await storage.saveLocaleCode(newCode);
    await context.setLocale(newLocale);
    _notifyCubitsToRefresh(context);
    emit(newLocale);
  }

  void _notifyCubitsToRefresh(BuildContext context) {
    try { context.read<HomeCubit>().resetState(context); } catch (_) {}
    try { context.read<WorkerCompaniesCubit>().resetState(context); } catch (_) {}
    try { context.read<NursingCompaniesCubit>().resetState(context); } catch (_) {}
    try { context.read<CleaningCompaniesCubit>().resetState(context); } catch (_) {}
    try { context.read<AntiBugCompaniesCubit>().resetState(context); } catch (_) {}
    try { context.read<WorkerSuppliersCubit>().resetState(context); } catch (_) {}
    try { context.read<CompanyDetailsCubit>().resetState(context); } catch (_) {}
    // BUG FIX 4: WelcomeCubit.resetState no longer takes BuildContext
    try { context.read<WelcomeCubit>().resetState(context); } catch (_) {}
  }

  // BUG FIX 5: Wrong operator precedence: (code == 'ar' ?? true)
  // The ?? operator has lower precedence than ==, so this was parsed as
  // code == ('ar' ?? true) == code == 'ar', which is always correct by
  // accident, but the intent was clearly: code == 'ar' with a fallback.
  // Simplified to the correct form.
  bool isArabic() {
    final code = storage.getSavedLocaleCode();
    return code == 'ar';
  }
}
