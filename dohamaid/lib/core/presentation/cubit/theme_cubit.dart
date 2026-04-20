import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/storage_local_data_source.dart';
class ThemeCubit extends Cubit<ThemeMode> {
  final StorageLocalDataSource storage;

  ThemeCubit(this.storage) : super(ThemeMode.system);

  void loadTheme() {
    final isDark = storage.getThemeIsDark();
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    storage.saveThemeIsDark(newMode == ThemeMode.dark);
    emit(newMode);
  }
}
