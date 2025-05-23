import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(String, double) onAddExpense;
  const AddExpenseScreen({Key? key, required this.onAddExpense}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une dépense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom de la dépense'),
                validator: (value) => value == null || value.isEmpty ? "Champ requis" : null,
                onSaved: (value) => _title = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Champ requis";
                  final v = double.tryParse(value);
                  if (v == null || v <= 0) return "Montant invalide";
                  return null;
                },
                onSaved: (value) => _amount = double.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    widget.onAddExpense(_title, _amount);
                  }
                },
                child: const Text("Ajouter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}