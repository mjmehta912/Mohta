class SecondaryGroupDm {
  final String igCode;
  final String igName;

  SecondaryGroupDm({
    required this.igCode,
    required this.igName,
  });

  factory SecondaryGroupDm.fromJson(Map<String, dynamic> json) {
    return SecondaryGroupDm(
      igCode: json['IGCODE'],
      igName: json['IGNAME'],
    );
  }
}
