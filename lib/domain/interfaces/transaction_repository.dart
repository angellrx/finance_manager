import 'package:finance_manager/domain/entities/transaction.dart';

/// Контракт сховища транзакцій.
/// Описаний у Domain, а реалізується в Infrastructure.
abstract class TransactionRepository {
  /// Зберігає нову транзакцію.
  void add(Transaction transaction);

  /// Видаляє транзакцію за id. Повертає true, якщо вона існувала.
  bool remove(String id);

  /// Повертає всі транзакції.
  List<Transaction> getAll();
}