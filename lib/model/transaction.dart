class MainRecord {
  int id;
  int categoryId;
  double amount;
  String note;
  DateTime date;

  MainRecord({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory MainRecord.fromMap(Map<String, dynamic> map) {
    return MainRecord(
      id: map['id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }

  contains(String filterData) {}

  getCardWidget() {}
}
