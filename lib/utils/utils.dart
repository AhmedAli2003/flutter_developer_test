class Utils {
  const Utils._();

  static int getOrderId() => DateTime.now().millisecondsSinceEpoch ~/ 100;
}
