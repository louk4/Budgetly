import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class MonthlySummaryScreen extends StatelessWidget {
  final Box<TransactionModel> transactionsBox = Hive.box<TransactionModel>('transactionsBox');

  MonthlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthTransactions = transactionsBox.values.where((transaction) {
      return transaction.date.year == now.year && transaction.date.month == now.month;
    }).toList();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var transaction in currentMonthTransactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    double balance = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryCard(title: 'Income', amount: totalIncome, color: Colors.green),
            const SizedBox(height: 12),
            SummaryCard(title: 'Expenses', amount: totalExpenses, color: Colors.red),
            const SizedBox(height: 12),
            SummaryCard(title: 'Balance', amount: balance, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          '€${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
