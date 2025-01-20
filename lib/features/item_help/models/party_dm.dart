class PartyDm {
  final String pCode;
  final String pName;

  PartyDm({
    required this.pCode,
    required this.pName,
  });

  factory PartyDm.fromJson(Map<String, dynamic> json) {
    return PartyDm(
      pCode: json['PCODE'],
      pName: json['PNAME'],
    );
  }
}
