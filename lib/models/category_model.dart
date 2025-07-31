import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String type; // "income" or "expense"

  CategoryModel({required this.name, required this.type});
}
