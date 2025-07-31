import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_model.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final Box<CategoryModel> _categoryBox = Hive.box<CategoryModel>('categoriesBox');

  final TextEditingController _nameController = TextEditingController();
  String _selectedType = 'expense';

  void _addCategory() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final newCategory = CategoryModel(name: name, type: _selectedType);
      _categoryBox.add(newCategory);
      _nameController.clear();
      setState(() {});
    }
  }

  void _deleteCategory(int index) {
    _categoryBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                DropdownMenuItem(value: 'income', child: Text('Income')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Add Category'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _categoryBox.listenable(),
                builder: (context, Box<CategoryModel> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(child: Text('No categories added.'));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final category = box.getAt(index);
                      return ListTile(
                        title: Text('${category?.name} (${category?.type})'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(index),
                        ),
                      );
                    },
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
