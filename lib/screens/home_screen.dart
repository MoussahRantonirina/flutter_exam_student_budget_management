import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon budget étudiant')),
      body: Center(child: Text('Bienvenue ! Ajoutez vos dépenses.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers ajout de dépense
        },
        child: Icon(Icons.add),
      ),
    );
  }
}