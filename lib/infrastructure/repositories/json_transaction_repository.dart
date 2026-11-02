import 'dart:convert';
import 'dart:io';

import 'package:finance_manager/domain/entities/transaction.dart';
import 'package:finance_manager/domain/interfaces/transaction_repository.dart';

/// Сховище у JSON-файлі.
class JsonTransactionRepository implements TransactionRepository {
  final String filePath;

  JsonTransactionRepository(this.filePath);

  @override
  void add(Transaction transaction) {
    final items = _read();
    items.add(transaction);
    _write(items);
  }

  @override
  bool remove(String id) {
    final items = _read();
    final before = items.length;
    items.removeWhere((t) => t.id == id);
    if (items.length == before) {
      return false;
    }
    _write(items);
    return true;
  }

  @override
  List<Transaction> getAll() {
    return _read();
  }

  // Читає всі транзакції з файлу
  List<Transaction> _read() {
    final file = File(filePath);
    if (!file.existsSync()) {
      return [];
    }
    final text = file.readAsStringSync();
    if (text.trim().isEmpty) {
      return [];
    }
       List list;
    try {
      list = jsonDecode(text) as List;
    } on FormatException {
      throw Exception('Файл $filePath пошкоджено: некоректний JSON');
    }
    final result = <Transaction>[];
    for (final item in list) {
      result.add(Transaction(
        id: item['id'],
        title: item['title'],
        amount: (item['amount'] as num).toDouble(),
        isIncome: item['isIncome'],
        date: DateTime.parse(item['date']),
      ));
    }
    return result;
  }

  // Записує всі транзакції у файл
  void _write(List<Transaction> items) {
    final file = File(filePath);
    file.parent.createSync(recursive: true);
    final list = [];
    for (final t in items) {
      list.add({
        'id': t.id,
        'title': t.title,
        'amount': t.amount,
        'isIncome': t.isIncome,
        'date': t.date.toIso8601String(),
      });
    }
    final encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(list));
  }
}
