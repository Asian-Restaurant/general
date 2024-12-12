import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AsianParadiseApp());
}

class AsianParadiseApp extends StatelessWidget {
  const AsianParadiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Header with logo and navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "WELCOME TO YOUR LITTLE DREAMWORLD",
                        style: GoogleFonts.pacifico(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavButton("Menu"),
                      _buildNavButton("Basket"),
                      _buildNavButton("Reviews"),
                      _buildNavButton("Contacts"),
                    ],
                  ),
                ],
              ),
            ),

            // Food categories
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildFoodCard("assets/sushi.jpg", "Try classic of Japan"),
                  _buildFoodCard("assets/indian.jpg", "Would you like to fall in love with India?"),
                  _buildFoodCard("assets/thai.jpg", "Say Hello to Thailand!"),
                  _buildFoodCard("assets/korean.jpg", "Must have Korean set"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for navigation buttons
  static Widget _buildNavButton(String title) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: Colors.pink[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Виджет для карточек с едой
  Widget _buildFoodCard(String imagePath, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 473, // Фиксированная ширина
          height: 292, // Фиксированная высота
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.pink[300]!, width: 5), // Толще рамка
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4), // Уменьшенный отступ между изображением и текстом
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), // Уменьшенные отступы
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}