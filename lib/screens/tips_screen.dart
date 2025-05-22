import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  final List<String> tips;
  TipsScreen({required this.tips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Astuces Budget')),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, idx) => ListTile(
          leading: Icon(Icons.lightbulb),
          title: Text(tips[idx]),
        ),
      ),
    );
  }
}