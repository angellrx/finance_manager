import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Use case: видалити транзакцію за id.
class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  bool execute(String id) {
    return repository.remove(id);
  }
}