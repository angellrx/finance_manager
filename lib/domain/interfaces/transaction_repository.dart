import 'package:finance_manager/domain/entities/transaction.dart';

abstract class TransactionRepository {
  void add(Transaction transaction);
  bool remove(String id);
  List<Transaction> getAll();
}