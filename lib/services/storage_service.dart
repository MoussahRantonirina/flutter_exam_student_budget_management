import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_budget', budget);
  }

  static Future<double> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('total_budget') ?? 0.0;
  }

  static Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(expenses);
    await prefs.setString('expenses', str);
  }

  static Future<List<Map<String, dynamic>>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    String? expensesStr = prefs.getString('expenses');
    if (expensesStr == null) return [];
    List list = jsonDecode(expensesStr);
    return List<Map<String, dynamic>>.from(list);
  }
}