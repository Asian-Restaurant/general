import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/сart.dart';
import 'address_page_web.dart';
import 'basket_page_web.dart';
import 'menu_page_web.dart';
import 'reviews_page_web.dart';
import 'login_page_web.dart';

class MainPageWeb extends StatelessWidget {
  final Cart cart = Cart(); // Создаем экземпляр корзины

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.login, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPageWeb()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton(context, "Menu", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPageWeb()));
                  }),
                  _buildNavButton(context, "Basket", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BasketPageWeb(cartData: cart)));
                  }),
                  _buildNavButton(context, "Reviews", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPageWeb()));
                  }),
                  _buildNavButton(context, "Delivery", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPageWeb()));
                  }),
                ],
              ),
              const SizedBox(height: 20),
              // Категории еды
              Column(
                children: [
                  _buildFoodCard("assets/sushi.jpg", "Try classic of Japan"),
                  const SizedBox(height: 16),
                  _buildFoodCard("assets/indian.jpg", "Would you like to fall in love with India?"),
                  const SizedBox(height: 16),
                  _buildFoodCard("assets/thai.jpg", "Say Hello to Thailand!"),
                  const SizedBox(height: 16),
                  _buildFoodCard("assets/korean.jpg", "Must have Korean set"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

// Dummy AccountPage class for navigation
class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: Center(child: Text("User Account Page")),
    );
  }
}