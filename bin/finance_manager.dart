import 'dart:convert';
import 'dart:io';

import 'package:finance_manager/application/use_cases/add_transaction_use_case.dart';
import 'package:finance_manager/application/use_cases/delete_transaction_use_case.dart';
import 'package:finance_manager/application/use_cases/get_balance_use_case.dart';
import 'package:finance_manager/application/use_cases/get_recent_transactions_use_case.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';
import 'package:finance_manager/infrastructure/config/app_config.dart';
import 'package:finance_manager/infrastructure/repositories/in_memory_transaction_repository.dart';
import 'package:finance_manager/infrastructure/repositories/json_transaction_repository.dart';
import 'package:finance_manager/presentation/cli/dashboard_cli.dart';

void main() {
  stdout.encoding = utf8;

  // 1. Читаємо налаштування
  final config = AppConfig('config/settings.json');

  // 2. Обираємо сховище (Dependency Injection)
  TransactionRepository repository;
  if (config.storage == 'json') {
    repository = JsonTransactionRepository(config.dataFile);
  } else {
    repository = InMemoryTransactionRepository();
  }

  // 3. Створюємо use cases і передаємо їм репозиторій через конструктор
  final addTransaction = AddTransactionUseCase(repository);
  final deleteTransaction = DeleteTransactionUseCase(repository);
  final getRecent = GetRecentTransactionsUseCase(repository);
  final getBalance = GetBalanceUseCase(repository);

  // 4. Демо-дані, щоб дашборд не був порожнім
  addDemoData(addTransaction, getRecent);

  // 5. Запускаємо інтерфейс
  final cli = DashboardCli(
    addTransaction,
    deleteTransaction,
    getRecent,
    getBalance,
    config.currency,
  );
  cli.run();
}

void addDemoData(
  AddTransactionUseCase add,
  GetRecentTransactionsUseCase recent,
) {
  // Якщо вже є дані (JSON-файл), нічого не додаємо
  if (recent.execute(1).isNotEmpty) {
    return;
  }
  final now = DateTime.now();
  add.execute('Зарплата', 32000, true, date: now.subtract(Duration(hours: 2)));
  add.execute('Сільпо', 1250.50, false, date: now.subtract(Duration(days: 1)));
  add.execute('Bolt', 185, false, date: now.subtract(Duration(days: 2)));
  add.execute('Netflix', 299, false, date: now.subtract(Duration(days: 3)));
  add.execute('Переказ від Олени', 1500, true,
      date: now.subtract(Duration(days: 4)));
}