import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class ViewTransactionScreen extends StatelessWidget {
  const ViewTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<TransactionModel> transactionBox = Hive.box<TransactionModel>('transactionsBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          final transactions = box.values.toList().reversed.toList(); // most recent first

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];

              return ListTile(
                leading: Icon(
                  tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: tx.isIncome ? Colors.green : Colors.red,
                ),
                title: Text(tx.title),
                subtitle: Text('${tx.category} • ${tx.date.toLocal().toString().split(' ')[0]}'),
                trailing: Text(
                  '${tx.isIncome ? '+' : '-'} \$${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: tx.isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
