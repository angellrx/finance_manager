import 'package:finance_manager/domain/entities/transaction.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Use case: отримати останні транзакції (найновіші першими).
class GetRecentTransactionsUseCase {
  final TransactionRepository repository;

  GetRecentTransactionsUseCase(this.repository);

  List<Transaction> execute(int limit) {
        if (limit <= 0) {
      throw ArgumentError('Ліміт має бути більшим за нуль');
    }
    final all = List<Transaction>.from(repository.getAll());
    all.sort((a, b) => b.date.compareTo(a.date));
    if (all.length > limit) {
      return all.sublist(0, limit);
    }
    return all;
  }
}