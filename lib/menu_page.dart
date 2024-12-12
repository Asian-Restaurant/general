import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(8.0),
        children: [
          buildMenuCard('Jiaozi', 'jiaozi.jpg'),
          buildMenuCard('Onigiri', 'onigiri.jpg'),
          buildMenuCard('Bibimbap', 'bibimbap.jpg'),
          buildMenuCard('Satay', 'satay.jpg'),
        ],
      ),
    );
  }

  Widget buildMenuCard(String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset('assets/$imagePath', height: 100, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
