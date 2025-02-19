class ItemStockDm {
  final String billDate;
  final int qty;
  final int days;
  final int rate;

  ItemStockDm({
    required this.billDate,
    required this.qty,
    required this.days,
    required this.rate,
  });

  factory ItemStockDm.fromJson(Map<String, dynamic> json) {
    return ItemStockDm(
      billDate: json['BillDate'],
      qty: json['QTY'],
      days: json['Days'],
      rate: json['RATE'],
    );
  }
}
