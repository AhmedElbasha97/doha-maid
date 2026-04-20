// ignore_for_file: await_only_futures

import 'package:dohamaid/core/data/datasources/storage_local_data_source.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../features/home/data/model/home_model.dart';
import '../utils/api_constant.dart';

class HomeServices {
  final ApiService api;
  HomeServices(this.api);

  Future<HomeModel?> getAllHomeTaps() async {
    final local = await StorageLocalDataSource.instance.getSavedLocaleCode();
      final resp = await api.get(ApiConstant.homeLink,data: {
        "x-locale": local,

      });
      final data = resp.data;
      if (data == null) return null;

    return HomeModel.fromJson(data);
  }


}