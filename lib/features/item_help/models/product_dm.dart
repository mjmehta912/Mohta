class ProductDm {
  final String prCode;
  final String prName;
  final String desc1;
  final String desc2;
  final String desc3;
  final String desc4;
  final String desc5;
  final String desc6;
  final String desc7;
  final String desc8;
  final String desc9;
  final String desc10;
  final String desc11;
  final String desc12;

  ProductDm({
    required this.prCode,
    required this.prName,
    required this.desc1,
    required this.desc2,
    required this.desc3,
    required this.desc4,
    required this.desc5,
    required this.desc6,
    required this.desc7,
    required this.desc8,
    required this.desc9,
    required this.desc10,
    required this.desc11,
    required this.desc12,
  });

  factory ProductDm.fromJson(Map<String, dynamic> json) {
    return ProductDm(
      prCode: json['PRCODE'],
      prName: json['PRNAME'],
      desc1: json['DESC1'],
      desc2: json['DESC2'],
      desc3: json['DESC3'],
      desc4: json['DESC4'],
      desc5: json['DESC5'],
      desc6: json['DESC6'],
      desc7: json['DESC7'],
      desc8: json['DESC8'],
      desc9: json['DESC9'],
      desc10: json['DESC10'],
      desc11: json['DESC11'],
      desc12: json['DESC12'],
    );
  }
}
