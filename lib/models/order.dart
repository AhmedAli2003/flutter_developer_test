import 'package:flutter_developer_test/models/order_item.dart';
import 'package:flutter_developer_test/models/order_status.dart';

class Order {
  final int id;
  final List<OrderItem> items;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.items,
    required this.status,
  });

  const Order.fake({
    this.id = -1,
    this.items = const [],
    this.status = OrderStatus.drafted,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'status': status.name,
      };

  static Order fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'],
      status: OrderStatusExtension.fromString(map['status']),
      items: items,
    );
  }
}
