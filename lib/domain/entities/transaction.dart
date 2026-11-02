/// Сутність «Транзакція» (дохід або витрата).
class Transaction {
  final String id;
  final String title;
  final double amount; // завжди додатна
  final bool isIncome; // true - дохід, false - витрата
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
  }) {
    // Бізнес-правила
    if (title.trim().isEmpty) {
      throw ArgumentError('Опис не може бути порожнім');
    }
    if (amount <= 0) {
      throw ArgumentError('Сума має бути більшою за нуль');
    }
  }
}