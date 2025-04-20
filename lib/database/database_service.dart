import 'package:flutter_developer_test/database/local_database.dart';
import 'package:flutter_developer_test/models/order.dart';
import 'package:flutter_developer_test/models/order_item.dart';
import 'package:flutter_developer_test/models/order_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final localDb = ref.watch(localDatabaseProvider);
  return DatabaseService(localDb);
});

class DatabaseService {
  final LocalDatabase database;

  const DatabaseService(this.database);

  Future<void> insertOrder(Order order) async {
    final db = await database.database;

    final orderId = await db.insert('orders', {
      'id': order.id,
      'status': order.status.name,
    });

    for (var item in order.items) {
      await db.insert('order_items', item.copyWith(orderId: orderId).toMap());
    }
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database.database;

    final orderMaps = await db.query('orders');

    final orders = <Order>[];

    for (var order in orderMaps) {
      final orderId = order['id'] as int;
      final status = OrderStatusExtension.fromString(order['status'] as String);

      final itemMaps = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [orderId],
      );

      final items = itemMaps.map((e) => OrderItem.fromMap(e)).toList();

      orders.add(Order(
        id: orderId,
        items: items,
        status: status,
      ));
    }

    return orders;
  }

  Future<Order?> getOrderById(int id) async {
    final db = await database.database;

    final orderMap = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (orderMap.isEmpty) return null;

    final itemMaps = await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [id],
    );

    final items = itemMaps.map((e) => OrderItem.fromMap(e)).toList();

    return Order.fromMap(orderMap.first, items);
  }

  Future<void> updateOrderStatus(int orderId, OrderStatus status) async {
    final db = await database.database;

    await db.update(
      'orders',
      {
        'status': status.name,
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<void> deleteOrderById(int orderId) async {
    final db = await database.database;

    // Delete related items first
    await db.delete(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );

    // Then delete the order
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
