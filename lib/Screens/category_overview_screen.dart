import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class CategoryOverviewScreen extends StatelessWidget {
  final transactionsBox = Hive.box<TransactionModel>('transactionsBox');

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};

    for (var transaction in transactionsBox.values) {

      if (!transaction.isIncome) {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses by Category'),
      ),
      body: categoryTotals.isEmpty
          ? const Center(child: Text("No expenses to show."))
          : ListView(
        children: categoryTotals.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: Text('€${entry.value.toStringAsFixed(2)}'),
          );
        }).toList(),
      ),
    );
  }
}
