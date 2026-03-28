import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/domain/repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository;

  CartViewModel(this._cartRepository);

  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    _items = await _cartRepository.getCartItems();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    await _cartRepository.addItem(item);
    await loadCart();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await _cartRepository.updateQuantity(productId, quantity);
    await loadCart();
  }

  Future<void> removeItem(int productId) async {
    await _cartRepository.removeItem(productId);
    await loadCart();
  }

  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    await loadCart();
  }
}
