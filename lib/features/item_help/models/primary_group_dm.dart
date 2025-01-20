class PrimaryGroupDm {
  final String mCode;
  final String mName;

  PrimaryGroupDm({
    required this.mCode,
    required this.mName,
  });

  factory PrimaryGroupDm.fromJson(Map<String, dynamic> json) {
    return PrimaryGroupDm(
      mCode: json['MCODE'],
      mName: json['MNAME'],
    );
  }
}
