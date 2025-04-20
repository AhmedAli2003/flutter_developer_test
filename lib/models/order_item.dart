class OrderItem {
  final int? id;
  final int orderId;
  final String productName;
  final int quantity;
  final String? imagePath;
  final String? note;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    this.imagePath,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        'orderId': orderId,
        'productName': productName,
        'quantity': quantity,
        'imagePath': imagePath,
        'note': note,
      };

  static OrderItem fromMap(Map<String, dynamic> map) => OrderItem(
        id: map['id'],
        orderId: map['orderId'],
        productName: map['productName'],
        quantity: map['quantity'],
        imagePath: map['imagePath'],
        note: map['note'],
      );

  OrderItem copyWith({
    int? id,
    int? orderId,
    String? productName,
    int? quantity,
    String? imagePath,
    String? note,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(covariant OrderItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderId == orderId &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.imagePath == imagePath &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^ orderId.hashCode ^ productName.hashCode ^ quantity.hashCode ^ imagePath.hashCode ^ note.hashCode;
  }
}
