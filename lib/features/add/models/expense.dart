class Expense {
  final String id;
  final String category; // 'expense'
  final String subCategory;
  final String date; // format: dd-mm-yyyy
  final double amount;
  final String? description;

  Expense({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.amount,
    this.description,
  });

  factory Expense.create({
    required String subCategory,
    required String date,
    required double amount,
    String? description,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return Expense(
      id: id,
      category: 'expense',
      subCategory: subCategory,
      date: date,
      amount: amount,
      description: description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'subCategory': subCategory,
        'date': date,
        'amount': amount,
        'description': description,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] as String,
        category: json['category'] as String,
        subCategory: json['subCategory'] as String,
        date: json['date'] as String,
        amount: (json['amount'] as num).toDouble(),
        description: json['description'] as String?,
      );
}
