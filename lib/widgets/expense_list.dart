import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final Function(String) onDelete;
  const ExpenseList({Key? key, required this.expenses, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    expenses.sort((a, b) => b['date'].compareTo(a['date']));
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, idx) {
        final exp = expenses[idx];
        final date = DateTime.tryParse(exp['date'] ?? '') ?? DateTime.now();
        return Card(
          child: ListTile(
            title: Text(exp['title']),
            subtitle: Text("${exp['amount'].toStringAsFixed(2)} MGA - ${date.day}/${date.month}/${date.year}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(exp['id']),
            ),
          ),
        );
      },
    );
  }
}