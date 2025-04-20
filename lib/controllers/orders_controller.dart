import 'package:flutter_developer_test/database/database_service.dart';
import 'package:flutter_developer_test/models/order_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_developer_test/models/order.dart';

class OrderStateNotifier extends StateNotifier<List<Order>> {
  final DatabaseService databaseService;

  OrderStateNotifier(this.databaseService) : super([]) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final orders = await databaseService.getAllOrders();
    state = orders;
  }

  Future<void> addOrder(Order order) async {
    await databaseService.insertOrder(order);
    await loadOrders();
  }

  Future<Order?> getOrderById(int id) {
    return databaseService.getOrderById(id);
  }

  Future<void> updateStatus(int orderId, OrderStatus newStatus) async {
    await databaseService.updateOrderStatus(orderId, newStatus);
    await loadOrders();
  }

  Future<void> deleteOrder(int orderId) async {
    await databaseService.deleteOrderById(orderId);
    await loadOrders();
  }
}

final ordersProvider = StateNotifierProvider<OrderStateNotifier, List<Order>>(
  (ref) {
    final dbService = ref.watch(databaseServiceProvider);
    return OrderStateNotifier(dbService);
  },
);
