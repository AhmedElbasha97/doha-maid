  // ignore_for_file: avoid_print

import 'package:dohamaid/core/data/datasources/storage_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/api_constant.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio dio;
  ApiService._internal() : dio = Dio() {
    dio.options
      ..baseUrl = ApiConstant.baseUrl
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    // Logging
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: false,
        ),
      );
      return true;
    }());

    // Attach token automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Always fetch latest token from SharedPreferences
          final token = StorageLocalDataSource.instance.getUserToken();
          final localLang = StorageLocalDataSource.instance.getSavedLocaleCode();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';

          }
            if (localLang.isNotEmpty) {
              options.headers['x-locale'] = localLang;
            }
          return handler.next(options);
        },
      ),
    );

    // Auto retry
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (_shouldRetry(e)) {
            try {
              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } catch (_) {
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? query,Map<String, dynamic>? data}) async {
    try {
      print(data);
      return await dio.get(path, queryParameters: query,data:data );
    } on DioException catch (e) {
      // Centralized error handling
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  Exception _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionError) {
      return Exception('No internet connection');
    } else if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return Exception('Request timed out');
    } else if (error.response != null) {
      return Exception(
          'Server error: ${error.response?.statusCode} ${error.response?.statusMessage}');
    } else {
      return Exception('Unexpected error occurred');
    }
  }
}

