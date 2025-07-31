import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import 'category_overview_screen.dart';
import 'monthly_summary_screen.dart';
import 'reminder_screen.dart';
import 'view_transaction_screen.dart';
import 'manage_categories_screen.dart';
import '../Utils/csv_exporter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<TransactionModel> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<TransactionModel>('transactionsBox');
  }

  // Helper function for styled buttons
  ButtonStyle customButtonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgetly'),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CategoryOverviewScreen()),
                        );
                      },
                      style: customButtonStyle(Colors.teal),
                      child: const Text('View Category Summary'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MonthlySummaryScreen()),
                        );
                      },
                      style: customButtonStyle(Colors.orange),
                      child: const Text('View Monthly Summary'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReminderScreen()),
                        );
                      },
                      style: customButtonStyle(Colors.purple),
                      child: const Text('View Reminders'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ViewTransactionScreen()),
                        );
                      },
                      style: customButtonStyle(Colors.blueGrey),
                      child: const Text('View Transaction History'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final path = await CSVExportService.exportTransactionsToCSV();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Exported to $path')),
                        );
                      },
                      style: customButtonStyle(Colors.green),
                      child: const Text('Export Transactions to CSV'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageCategoriesScreen()),
                        );
                      },
                      style: customButtonStyle(Colors.redAccent),
                      child: const Text('Manage Categories'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: box.values.isEmpty
                    ? const Center(child: Text('No transactions added.'))
                    : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final transaction = box.getAt(index);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(transaction?.title ?? ''),
                        subtitle: Text(
                          '${transaction?.category ?? ''} • ${transaction?.date.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddTransactionScreen(transaction: transaction),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Transaction'),
                                    content: const Text('Are you sure you want to delete this transaction?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          transactionBox.deleteAt(index);
                                          Navigator.pop(ctx);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Transaction deleted')),
                                          );
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
