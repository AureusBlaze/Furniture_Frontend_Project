import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';

class CatalogViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  CatalogViewModel(this._productRepository);

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _currentPage = 1;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadProducts({int? categoryId}) async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    final result = await _productRepository.getProducts(
      page: _currentPage,
      categoryId: categoryId,
    );
    result.fold(
      (failure) => _error = failure.message,
      (products) {
        _products = products;
        _hasMore = products.length >= 20;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore({int? categoryId}) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final result = await _productRepository.getProducts(
      page: _currentPage,
      categoryId: categoryId,
    );
    result.fold(
      (failure) {
        _currentPage--;
        _error = failure.message;
      },
      (products) {
        _products = [..._products, ...products];
        _hasMore = products.length >= 20;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh({int? categoryId}) async {
    await loadProducts(categoryId: categoryId);
  }
}
