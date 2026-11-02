import 'package:finance_manager/domain/entities/transaction.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Use case: додати нову транзакцію.
class AddTransactionUseCase {
  final TransactionRepository repository;
  static int _counter = 0; // щоб id завжди були унікальні

  AddTransactionUseCase(this.repository);

  Transaction execute(
    String title,
    double amount,
    bool isIncome, {
    DateTime? date,
  }) {
    _counter++;
    final transaction = Transaction(
      id: '${DateTime.now().microsecondsSinceEpoch}_$_counter',
      title: title.trim(),
      amount: amount,
      isIncome: isIncome,
      date: date ?? DateTime.now(),
    );
    repository.add(transaction);
    return transaction;
  }
}