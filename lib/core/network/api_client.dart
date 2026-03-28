import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/utils/constants.dart';
import 'package:mirage_by_aurues/core/storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Configured Dio client for API communication.
class ApiClient {
  late final Dio dio;

  ApiClient({required SecureStorageService secureStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    ]);
  }
}
