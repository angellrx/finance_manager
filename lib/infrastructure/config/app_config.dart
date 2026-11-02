import 'dart:convert';
import 'dart:io';

/// Налаштування застосунку з файлу config/settings.json.
class AppConfig {
  String storage = 'memory'; // memory або json
  String dataFile = 'data/transactions.json';
  String currency = '₴';

  AppConfig(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return;
    }
    final map = jsonDecode(file.readAsStringSync());
    if (map['storage'] != null) {
      storage = map['storage'];
    }
    if (map['dataFile'] != null) {
      dataFile = map['dataFile'];
    }
    if (map['currency'] != null) {
      currency = map['currency'];
    }
  }
}