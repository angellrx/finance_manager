import 'package:finance_manager/domain/entities/balance_summary.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Use case: порахувати баланс, доходи та витрати.
class GetBalanceUseCase {
  final TransactionRepository repository;

  GetBalanceUseCase(this.repository);

  BalanceSummary execute() {
    double income = 0;
    double expense = 0;
    for (final t in repository.getAll()) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return BalanceSummary(income, expense);
  }
}