import 'package:flutter_developer_test/controllers/orders_controller.dart';
import 'package:flutter_developer_test/models/order.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderByIdProvider = FutureProvider.family<Order?, int>((ref, orderId) async {
  final orders = ref.watch(ordersProvider);
  const fakeOrder = Order.fake();
  final order = orders.firstWhere((o) => o.id == orderId, orElse: () => fakeOrder);
  if (order == fakeOrder) return null;
  return order;
});
