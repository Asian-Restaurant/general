import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asian Paradise'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Welcome to Your Little Dreamworld',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // Карточки блюд
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                buildFoodCard('Try classic of Japan', 'sushi.jpg'),
                buildFoodCard('Would you like to fall in love with India?', 'indian.jpg'),
                buildFoodCard('Say Hello to Thailand!', 'thai.jpg'),
                buildFoodCard('Must have Korean set', 'korean.jpg'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildFoodCard(String title, String imagePath) {
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

  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main Page'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Basket'),
        BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Reviews'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/menu');
            break;
          case 2:
            Navigator.pushNamed(context, '/basket');
            break;
          case 3:
            Navigator.pushNamed(context, '/reviews');
            break;
        }
      },
    );
  }
}
