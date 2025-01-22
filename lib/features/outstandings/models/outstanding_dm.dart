class OutstandingDm {
  final int order;
  final String type;
  final String invNo;
  final String date;
  final String dueDate;
  final double amount;
  final double recAmount;
  final double balance;
  final int days;
  final String pono;
  final String remark;
  final int pdc;
  final String bookCode;
  final int yearId;

  OutstandingDm({
    required this.order,
    required this.type,
    required this.invNo,
    required this.date,
    required this.dueDate,
    required this.amount,
    required this.recAmount,
    required this.balance,
    required this.days,
    required this.pono,
    required this.remark,
    required this.pdc,
    required this.bookCode,
    required this.yearId,
  });

  factory OutstandingDm.fromJson(Map<String, dynamic> json) {
    return OutstandingDm(
      order: json['ORDER'] ?? 0,
      type: json['TYPE'] ?? '',
      invNo: json['Invoice No'] ?? '',
      date: json['Date'] ?? '',
      dueDate: json['Due Date'] ?? '',
      amount: (json['Amount'] ?? 0.0).toDouble(),
      recAmount: (json['Rec. Amount'] ?? 0.0).toDouble(),
      balance: (json['Balance'] ?? 0.0).toDouble(),
      days: json['DAYS'] ?? 0,
      pono: json['PONO'] ?? '',
      remark: json['Remark'] ?? '',
      pdc: json['PDC'] ?? 0,
      bookCode: json['BOOKCODE'] ?? '',
      yearId: json['YEARID'] ?? 0,
    );
  }
}
