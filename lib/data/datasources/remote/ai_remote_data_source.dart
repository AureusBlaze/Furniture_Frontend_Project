import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/product_model.dart';

class AiRemoteDataSource {
  final ApiClient _apiClient;

  AiRemoteDataSource(this._apiClient);

  /// Upload a room image to the AI endpoint and get product suggestions.
  Future<List<ProductModel>> getSuggestions(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: 'room_analysis.jpg',
        ),
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.aiSuggest,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final data = response.data;
      List<dynamic> items;
      if (data is Map && data.containsKey('data')) {
        items = data['data'] as List;
      } else if (data is Map && data.containsKey('products')) {
        items = data['products'] as List;
      } else if (data is List) {
        items = data;
      } else {
        items = [];
      }

      return items
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'AI analysis failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
