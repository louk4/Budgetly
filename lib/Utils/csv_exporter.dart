import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class CSVExportService {
  static Future<String> exportTransactionsToCSV() async {
    final box = Hive.box<TransactionModel>('transactionsBox');
    final transactions = box.values.toList();

    List<List<dynamic>> csvData = [
      ['Title', 'Category', 'Amount', 'Income/Expense', 'Date']
    ];

    for (var tx in transactions) {
      csvData.add([
        tx.title,
        tx.category,
        tx.amount.toStringAsFixed(2),
        tx.isIncome ? 'Income' : 'Expense',
        tx.date.toIso8601String().split('T')[0],
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transactions_export.csv');
    await file.writeAsString(csv);

    return file.path;
  }
}
