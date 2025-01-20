class DescDm {
  final int code;
  final String name;

  DescDm({
    required this.code,
    required this.name,
  });

  factory DescDm.fromJson(Map<String, dynamic> json) {
    return DescDm(
      code: json['CODE'],
      name: json['NAME'],
    );
  }
}
