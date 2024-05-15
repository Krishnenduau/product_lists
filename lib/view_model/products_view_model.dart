import 'package:flutter/material.dart';
import 'package:product_list/models/product_model.dart';
import 'package:product_list/services/product_service.dart';

class ProductsViewModel with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  String _errorMessage = '';
  bool _isCompleted = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  int currentPage = 1;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      _errorMessage = ''; // Reset error message
      notifyListeners();
      _products = await ProductsService.fetchProducts(currentPage);
    } catch (e) {
      _errorMessage = 'Failed to fetch products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMore(BuildContext context) async {
    if (!_isCompleted) {
      try {
        currentPage++;
        _isMoreLoading = true;
        _errorMessage = ''; // Reset error message
        notifyListeners();
        final items = await ProductsService.fetchProducts(currentPage);
        if (items.isEmpty) _isCompleted = true;
        _products.addAll(items);
      } catch (e) {
        _errorMessage = 'Failed to fetch products: $e';
      } finally {
        Future.delayed(
          Durations.extralong3,
          () {
            _isMoreLoading = false;

            notifyListeners();
          },
        );
      }
    } else {
      print("no more product");
    }
  }
}
