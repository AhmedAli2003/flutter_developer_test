import 'package:flutter_developer_test/services/products_api_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productSuggestionsProvider = FutureProvider<List<String>>((ref) async {
  final api = ref.watch(productsApiServiceProvider);
  return api.fetchProducts(); 
});
