class Income {
  final String id;
  final String category; // 'income' or 'expense'
  final String subCategory; // e.g., Salary, Investments, Part-Time, Bonus, Other
  final String date; // format: dd-mm-yyyy
  final double amount;
  final String? description;

  Income({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.amount,
    this.description,
  });

  factory Income.create({
    required String category,
    required String subCategory,
    required String date,
    required double amount,
    String? description,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return Income(
      id: id,
      category: category,
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

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        id: json['id'] as String,
        category: json['category'] as String,
        subCategory: json['subCategory'] as String,
        date: json['date'] as String,
        amount: (json['amount'] as num).toDouble(),
        description: json['description'] as String?,
      );
}
