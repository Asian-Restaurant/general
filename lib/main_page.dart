import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_page.dart'; // Импортируем MenuPage
import 'reviews_page.dart'; // Импортируем ReviewsPage

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Заголовок
              Text(
                "WELCOME TO YOUR LITTLE DREAMWORLD",
                style: GoogleFonts.mali(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Кнопки навигации
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton(context, "Menu", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuPage()),
                    );
                  }),
                  _buildNavButton(context, "Basket", () {
                    // Действие для Basket
                  }),
                  _buildNavButton(context, "Reviews", () {

                  }),
                  _buildNavButton(context, "Contacts", () {
                    // Действие для Contacts
                  }),
                ],
              ),
              const SizedBox(height: 20),
              // Категории еды
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Мобильная версия: карточки друг под другом
                    return Column(
                      children: [
                        _buildFoodCard("assets/sushi.jpg", "Try classic of Japan"),
                        const SizedBox(height: 16),
                        _buildFoodCard("assets/indian.jpg", "Would you like to fall in love with India?"),
                        const SizedBox(height: 16),
                        _buildFoodCard("assets/thai.jpg", "Say Hello to Thailand!"),
                        const SizedBox(height: 16),
                        _buildFoodCard("assets/korean.jpg", "Must have Korean set"),
                      ],
                    );
                  } else {
                    // Веб-версия: карточки в сетке
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        return _buildFoodCard(
                          ["assets/sushi.jpg", "assets/indian.jpg", "assets/thai.jpg", "assets/korean.jpg"][index],
                          ["Try classic of Japan", "Would you like to fall in love with India?", "Say Hello to Thailand!", "Must have Korean set"][index],
                        );
                      },
                      itemCount: 4,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет для кнопок навигации
  static Widget _buildNavButton(BuildContext context, String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.pink[300]!, width: 5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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