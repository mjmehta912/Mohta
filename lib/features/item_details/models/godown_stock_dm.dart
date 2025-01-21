class GodownStockDm {
  final String goDownName;
  final int qty;

  GodownStockDm({
    required this.goDownName,
    required this.qty,
  });

  factory GodownStockDm.fromJson(Map<String, dynamic> json) {
    return GodownStockDm(
      goDownName: json['GDNAME'],
      qty: json['QTY'],
    );
  }
}
