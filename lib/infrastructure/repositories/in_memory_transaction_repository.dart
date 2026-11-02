import 'package:finance_manager/domain/entities/transaction.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Сховище в пам'яті (дані зникають після закриття програми).
class InMemoryTransactionRepository implements TransactionRepository {
  final List<Transaction> _items = [];

  @override
  void add(Transaction transaction) {
    _items.add(transaction);
  }

  @override
  bool remove(String id) {
    final before = _items.length;
    _items.removeWhere((t) => t.id == id);
    return _items.length < before;
  }

  @override
  List<Transaction> getAll() {
    return List<Transaction>.from(_items);
  }
}