import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/reminder_model.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _messageController = TextEditingController();
  DateTime? _selectedDate;
  final Box<ReminderModel> reminderBox = Hive.box<ReminderModel>('remindersBox');

  void _addReminder() {
    if (_messageController.text.trim().isEmpty) return;

    final newReminder = ReminderModel(
      message: _messageController.text.trim(),
      reminderDate: _selectedDate,
    );

    reminderBox.add(newReminder);

    _messageController.clear();
    _selectedDate = null;

    setState(() {});
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = reminderBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Reminder Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Select Date'),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'No date selected',
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Add Reminder'),
            ),
            const Divider(height: 30),
            const Text(
              'Active Reminders:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ListTile(
                    title: Text(reminder.message),
                    subtitle: reminder.reminderDate != null
                        ? Text(
                      'Due: ${reminder.reminderDate!.day}/${reminder.reminderDate!.month}/${reminder.reminderDate!.year}',
                    )
                        : const Text('No date set'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
