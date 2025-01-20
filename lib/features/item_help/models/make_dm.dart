class MakeDm {
  final String bCode;
  final String bName;

  MakeDm({
    required this.bCode,
    required this.bName,
  });

  factory MakeDm.fromJson(Map<String, dynamic> json) {
    return MakeDm(
      bCode: json['BCODE'],
      bName: json['BNAME'],
    );
  }
}
