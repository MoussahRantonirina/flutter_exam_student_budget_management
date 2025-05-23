import 'package:flutter/material.dart';
import '../widgets/expense_list.dart';
import '../screens/add_expense_screen.dart';
import '../screens/tips_screen.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _budget = 0.0;
  List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final b = await StorageService.loadBudget();
    final e = await StorageService.loadExpenses();
    setState(() {
      _budget = b;
      _expenses = e;
    });
  }

  double get _totalExpenses =>
      _expenses.fold(0.0, (sum, e) => sum + (e['amount'] as double));

  Future<void> _addExpense(String title, double amount) async {
    final exp = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    };
    setState(() {
      _expenses.add(exp);
    });
    await StorageService.saveExpenses(_expenses);
    if (_totalExpenses > _budget && _budget > 0) {
      await NotificationService.showBudgetExceededNotification();
    }
  }

  Future<void> _removeExpense(String id) async {
    setState(() {
      _expenses.removeWhere((e) => e['id'] == id);
    });
    await StorageService.saveExpenses(_expenses);
  }

  Future<void> _setBudget(BuildContext context) async {
    double newBudget = _budget;
    await showDialog(
      context: context,
      builder: (context) {
        final ctrl = TextEditingController(text: _budget.toStringAsFixed(2));
        return AlertDialog(
          title: const Text("Définir le budget mensuel"),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Montant (MGA)"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                newBudget = double.tryParse(ctrl.text) ?? _budget;
                Navigator.of(context).pop();
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
    setState(() {
      _budget = newBudget;
    });
    await StorageService.saveBudget(_budget);
  }

  @override
  Widget build(BuildContext context) {
    final reste = _budget - _totalExpenses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon budget étudiant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tips_and_updates),
            tooltip: "Astuces",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TipsScreen(tips: _getTips()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Budget",
            onPressed: () => _setBudget(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: reste < 0 ? Colors.red[100] : Colors.green[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Budget", style: TextStyle(fontSize: 16)),
                        Text("${_budget.toStringAsFixed(2)} MGA",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Dépensé", style: TextStyle(fontSize: 16)),
                        Text("${_totalExpenses.toStringAsFixed(2)} MGA",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Reste", style: TextStyle(fontSize: 16)),
                        Text(
                          "${reste.toStringAsFixed(2)} MGA",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: reste < 0 ? Colors.red : Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Dépenses :", style: TextStyle(fontSize: 18)),
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(child: Text("Aucune dépense enregistrée."))
                  : ExpenseList(
                expenses: _expenses,
                onDelete: _removeExpense,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter une dépense",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                onAddExpense: (title, amount) async {
                  await _addExpense(title, amount);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<String> _getTips() {
    List<String> tips = [
      "Fixe-toi un budget et respecte-le chaque mois.",
      "Note toutes tes dépenses, même les plus petites.",
      "Repère les catégories où tu dépenses trop (fast-food, sorties, etc).",
      "Evite les achats impulsifs, réfléchis avant d’acheter.",
      "Privilégie la cuisine maison pour économiser.",
      "Compare les prix avant d’acheter.",
      "Essaie de mettre de côté un petit montant chaque mois."
    ];
    // Astuce personnalisée
    final fastFood = _expenses.where((e) =>
    e['title'].toString().toLowerCase().contains('fast') ||
        e['title'].toString().toLowerCase().contains('resto'));
    if (fastFood.length > 3) {
      tips.insert(
          0, "Tu dépenses beaucoup en fast-food/restaurants : cuisiner plus souvent peut t’aider à économiser !");
    }
    if (_budget > 0 && _totalExpenses > _budget) {
      tips.insert(
          0, "Attention ! Tu as dépassé ton budget. Analyse tes dépenses pour te remettre sur la bonne voie.");
    }
    return tips;
  }
}