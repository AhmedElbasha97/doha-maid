import 'package:dohamaid/core/data/datasources/storage_local_data_source.dart';
import '../../../../core/data/datasources/api_service.dart';
import '../../features/home/data/model/home_model.dart';
import '../utils/api_constant.dart';

class HomeServices {
  final ApiService api;
  HomeServices(this.api);

  Future<HomeModel?> getAllHomeTaps() async {
    // BUG FIX 10: getSavedLocaleCode() is synchronous — removed incorrect `await`.
    // The file had // ignore_for_file: await_only_futures to suppress the warning,
    // masking this bug instead of fixing it.
    final local = StorageLocalDataSource.instance.getSavedLocaleCode();
    final resp = await api.get(ApiConstant.homeLink, data: {"x-locale": local});
    final data = resp.data;
    if (data == null) return null;
    return HomeModel.fromJson(data);
  }
}
