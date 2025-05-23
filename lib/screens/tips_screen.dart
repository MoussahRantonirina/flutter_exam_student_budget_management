import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  final List<String> tips;
  const TipsScreen({Key? key, required this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Astuces Budget')),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, idx) => ListTile(
          leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
          title: Text(tips[idx]),
        ),
      ),
    );
  }
}