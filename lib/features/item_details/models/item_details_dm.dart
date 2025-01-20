class ItemDetailDm {
  final List<PriceDm> priceDmData;
  final List<CompanyStockDm> companyStockData;
  final List<TotalStockDm> totalStockData;
  ItemDetailDm({
    required this.priceDmData,
    required this.companyStockData,
    required this.totalStockData,
  });
  factory ItemDetailDm.fromJson(Map<String, dynamic> json) {
    return ItemDetailDm(
      priceDmData:
          (json['data'] as List).map((item) => PriceDm.fromJson(item)).toList(),
      companyStockData: (json['data1'] as List)
          .map((item) => CompanyStockDm.fromJson(item))
          .toList(),
      totalStockData: (json['data2'] as List)
          .map((item) => TotalStockDm.fromJson(item))
          .toList(),
    );
  }
}

class PriceDm {
  final String priceHead;
  final double price;
  final double prvPrice;
  final double minSRate;
  final double maxDiscP;
  final double maxDiscA;
  final double marketPrice;
  final String iw;
  final String ow;
  PriceDm({
    required this.priceHead,
    required this.price,
    required this.prvPrice,
    required this.minSRate,
    required this.maxDiscP,
    required this.maxDiscA,
    required this.marketPrice,
    required this.iw,
    required this.ow,
  });
  factory PriceDm.fromJson(Map<String, dynamic> json) {
    return PriceDm(
      priceHead: json['PriceHead'],
      price: json['Price'].toDouble(),
      prvPrice: json['PrvPrice'].toDouble(),
      minSRate: json['MinSRate'].toDouble(),
      maxDiscP: json['MaxDisc_P'].toDouble(),
      maxDiscA: json['MaxDisc_A'].toDouble(),
      marketPrice: json['MarketPrice'].toDouble(),
      iw: json['I/W'],
      ow: json['O/W'],
    );
  }
}

class CompanyStockDm {
  final int cocode;
  final String cmp;
  final int totalStk;
  final int damage;
  final int resvStk;
  final String godownStk;
  final int soQty;
  final String? cardStk;
  CompanyStockDm({
    required this.cocode,
    required this.cmp,
    required this.totalStk,
    required this.damage,
    required this.resvStk,
    required this.godownStk,
    required this.soQty,
    this.cardStk,
  });
  factory CompanyStockDm.fromJson(Map<String, dynamic> json) {
    return CompanyStockDm(
      cocode: json['COCODE'],
      cmp: json['CMP'],
      totalStk: json['TOTALSTK'],
      damage: json['DAMAGE'],
      resvStk: json['RESVSTK'],
      godownStk: json['GODOWNSTK'],
      soQty: json['SOQTY'],
      cardStk: json['CARDSTK'],
    );
  }
}

class TotalStockDm {
  final String billDate;
  final int qty;
  final int days;
  final double rate;
  TotalStockDm({
    required this.billDate,
    required this.qty,
    required this.days,
    required this.rate,
  });
  factory TotalStockDm.fromJson(Map<String, dynamic> json) {
    return TotalStockDm(
      billDate: json['BillDate'],
      qty: json['QTY'],
      days: json['Days'],
      rate: json['RATE'].toDouble(),
    );
  }
}
