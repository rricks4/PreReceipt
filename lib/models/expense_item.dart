/// A single line item on one person's list: something they've picked up,
/// its price per unit, and how many they're taking.
class ExpenseItem {
  ExpenseItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final double unitPrice;
  int quantity;

  /// unitPrice × quantity — recalculates automatically whenever quantity
  /// changes, since callers always read this getter fresh.
  double get lineTotal => unitPrice * quantity;
}
