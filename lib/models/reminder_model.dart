import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 1)
class ReminderModel extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  DateTime? reminderDate;

  ReminderModel({
    required this.message,
    this.reminderDate,
  });
}
