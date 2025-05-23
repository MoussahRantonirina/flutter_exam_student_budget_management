import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static Future<double?> getExchangeRate(String from, String to) async {
    final url = Uri.parse('https://v6.exchangerate-api.com/v6/YOUR_API_KEY/latest/$from');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['conversion_rates'][to];
    }
    return null;
  }
}