enum OrderStatus {
  pending,
  drafted,
  submitted,
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    return toString().split('.').last;
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere((e) => e.name == value);
  }
}
