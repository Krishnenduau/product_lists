import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_list/core/app_url.dart';

import 'package:product_list/models/product_model.dart';

class ProductsService {
  static Future<List<ProductModel>> fetchProducts(int pageNo) async {
    final url = Uri.parse(AppUrl.base);
    final headers = {
      'appid': '2IPbyrCUM7s5JZhnB9fxFAD6',
    };
    final body = {
      'page': '$pageNo',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final productList = List<ProductModel>.from(
            responseData['list'].map((x) => ProductModel.fromJson(x)));
        return productList;
      } else {
        throw Exception(
            'Failed to load products: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
