/// Підсумок: доходи, витрати та баланс.
class BalanceSummary {
  final double totalIncome;
  final double totalExpense;

  BalanceSummary(this.totalIncome, this.totalExpense);

  double get balance => totalIncome - totalExpense;
}