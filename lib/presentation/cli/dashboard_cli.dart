import 'dart:convert';
import 'dart:io';

import 'package:finance_manager/application/use_cases/add_transaction_use_case.dart';
import 'package:finance_manager/application/use_cases/delete_transaction_use_case.dart';
import 'package:finance_manager/application/use_cases/get_balance_use_case.dart';
import 'package:finance_manager/application/use_cases/get_recent_transactions_use_case.dart';

/// Консольний «екран дашборду».
/// Тут немає бізнес-логіки: лише ввід, вивід і виклик use cases.
class DashboardCli {
  final AddTransactionUseCase addTransaction;
  final DeleteTransactionUseCase deleteTransaction;
  final GetRecentTransactionsUseCase getRecent;
  final GetBalanceUseCase getBalance;
  final String currency;

  DashboardCli(
    this.addTransaction,
    this.deleteTransaction,
    this.getRecent,
    this.getBalance,
    this.currency,
  );

  // Головний цикл програми
  void run() {
    while (true) {
      _showDashboard();
      final choice = _ask('Оберіть дію: ');

      if (choice == null || choice == '0') {
        print('До побачення!');
        break;
      } else if (choice == '1') {
        _addMoney('Відправити', false);
      } else if (choice == '2') {
        _addMoney('Отримати', true);
      } else if (choice == '3') {
        _addMoney('Платіж', false);
      } else if (choice == '4') {
        _deleteMoney();
      } else {
        print('Невідома команда.');
      }
    }
  }

  // Показує баланс і останні 5 транзакцій
  void _showDashboard() {
    final summary = getBalance.execute();
    final recent = getRecent.execute(5);

    print('');
    print('Доброго дня, Ангеліно!');
    print('==========================================');
    print('Ангеліна Туз');
    print('Загальний баланс: ${_money(summary.balance)}');
    print('Доходи: ${_money(summary.totalIncome)}   '
        'Витрати: ${_money(summary.totalExpense)}');
    print('==========================================');
    print('[1] Відправити  [2] Отримати  [3] Платіж  '
        '[4] Ще (видалити)  [0] Вийти');
    print('');
    print('Транзакції (останні 5):');

    if (recent.isEmpty) {
      print('  (порожньо)');
    }
    for (int i = 0; i < recent.length; i++) {
      final t = recent[i];
      final sign = t.isIncome ? '+' : '-';
      print('  ${i + 1}. ${_date(t.date)}  ${t.title.padRight(20)} '
          '$sign${_money(t.amount)}');
    }
    print('');
  }

  // Додавання доходу або витрати
  void _addMoney(String actionName, bool isIncome) {
    print('--- $actionName ---');
    final title = _ask('Опис: ') ?? '';
    final amountText = _ask('Сума: ') ?? '';
    final amount = double.tryParse(amountText.replaceAll(',', '.'));

    if (amount == null) {
      print('Некоректна сума.');
      return;
    }

    try {
      addTransaction.execute(title, amount, isIncome);
      print('Готово: операцію додано.');
    } on ArgumentError catch (e) {
      print('Помилка: ${e.message}');
    }
  }

  // Видалення транзакції за номером зі списку
  void _deleteMoney() {
    final items = getRecent.execute(5);
    if (items.isEmpty) {
      print('Немає транзакцій для видалення.');
      return;
    }

    final text = _ask('Номер транзакції (1-${items.length}): ') ?? '';
    final number = int.tryParse(text);
    if (number == null || number < 1 || number > items.length) {
      print('Невірний номер.');
      return;
    }

    final answer = _ask('Видалити "${items[number - 1].title}"? (y/n): ');
    if (answer != 'y') {
      print('Скасовано.');
      return;
    }
    
    final removed = deleteTransaction.execute(items[number - 1].id);
    if (removed) {
      print('Видалено.');
    } else {
      print('Транзакцію не знайдено.');
    }
  }

  // Допоміжні методи
  String? _ask(String question) {
    stdout.write(question);
    return stdin.readLineSync(encoding: utf8)?.trim();
  }

  String _money(double value) {
    return '${value.toStringAsFixed(2)} $currency';
  }

  String _date(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day.$month';
  }
}