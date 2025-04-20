import 'package:dio/dio.dart';
import 'package:flutter_developer_test/constants/api_urls.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider<Dio>((_) => Dio());

final productsApiServiceProvider = Provider<ProductsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductsApiService(dio);
});

class ProductsApiService {
  final Dio dio;

  const ProductsApiService(this.dio);

  Future<List<String>> fetchProducts() async {
    const url = ApiUrls.products;
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data as Map;
      return data.values.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
