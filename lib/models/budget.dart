class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  Expense({required this.id, required this.title, required this.amount, required this.date});
}

class Budget {
  double totalBudget;
  List<Expense> expenses;
  Budget({required this.totalBudget, required this.expenses});
}