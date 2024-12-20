import 'package:asian_paradise/mobile/address_page_mobile.dart';
import 'package:asian_paradise/mobile/basket_page_mobile.dart';
import 'package:asian_paradise/mobile/dish_page_mobile.dart';
import 'package:asian_paradise/mobile/main_page_mobile.dart';
import 'package:asian_paradise/mobile/reviews_page_mobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/сart.dart';

class MenuPageMobile extends StatelessWidget {
  const MenuPageMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Cart();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Боковая панель с вертикальным расположением кнопок
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavButton(context, "Main Page", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageMobile()));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Basket", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BasketPageMobile(cartData: cart)));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Reviews", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPageMobile()));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Delivery", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPageMobile()));
                }),
              ],
            ),
          ),
          // Основное содержимое
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFoodGrid(context, cart),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания сетки с изображениями
  Widget _buildFoodGrid(BuildContext context, Cart cart) {
    final foodCategories = {
      "Korean": [
        {
          "image": "assets/bibimbap.jpg",
          "title": "Bibimbap",
          "description": "A delicious Korean dish made with rice and vegetables.",
          "weight": 250.0,
          "price": 15.99,
        },
        {
          "image": "assets/kimbap.jpg",
          "title": "Kimbap",
          "description": "Korean sushi rolls filled with vegetables and meat.",
          "weight": 300.0,
          "price": 12.50,
        },
        {
          "image": "assets/tteokbokki.jpg",
          "title": "Tteokbokki",
          "description": "Spicy rice cakes, a popular Korean street food.",
          "weight": 200.0,
          "price": 10.00,
        },
      ],
      "Japanese": [
        {
          "image": "assets/onigiri.jpg",
          "title": "Onigiri",
          "description": "Japanese rice ball with various fillings.",
          "weight": 200.0,
          "price": 10.00,
        },
        {
          "image": "assets/ramen.jpg",
          "title": "Ramen",
          "description": "Noodle soup with meat and vegetables.",
          "weight": 400.0,
          "price": 18.00,
        },
        {
          "image": "assets/sushi.jpg",
          "title": "Sushi",
          "description": "Traditional Japanese dish with vinegared rice and seafood.",
          "weight": 250.0,
          "price": 14.00,
        },
      ],
      "Chinese": [
        {
          "image": "assets/jiaozi.jpg",
          "title": "Jiaozi",
          "description": "Chinese dumplings filled with meat and vegetables.",
          "weight": 300.0,
          "price": 14.50,
        },
        {
          "image": "assets/dim sum.jpg",
          "title": "Dim Sum",
          "description": "Steamed buns with various fillings.",
          "weight": 250.0,
          "price": 16.00,
        },
        {
          "image": "assets/char siu.jpg",
          "title": "Char Siu",
          "description": "Chinese BBQ pork with a sweet glaze.",
          "weight": 300.0,
          "price": 17.00,
        },
      ],
    };

    return ListView.builder(
      itemCount: foodCategories.keys.length,
      itemBuilder: (context, categoryIndex) {
        String category = foodCategories.keys.elementAt(categoryIndex);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                category,
                style: GoogleFonts.mali(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Два элемента в строке для мобильной версии
                childAspectRatio: 0.7,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: foodCategories[category]!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, itemIndex) {
                final foodItem = foodCategories[category]![itemIndex];
                return _buildFoodCard(
                  foodItem["image"] as String,
                  foodItem["title"] as String,
                  foodItem["description"] as String,
                  foodItem["weight"] as double,
                  foodItem["price"] as double,
                  context,
                  cart,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Метод для создания карточки с едой
  Widget _buildFoodCard(String imagePath, String title, String description, double weight, double price, BuildContext context, Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pink[300] ?? Colors.pink, width: 5), // Розовая рамка
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 150, // Ширина для мобильной версии
              height: 100, // Высота для мобильной версии
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishPageMobile(
                  title: title,
                  imagePath: imagePath,
                  description: description,
                  weight: weight,
                  price: price,
                  cart: cart,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.pink[200],
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Метод для создания кнопки навигации
  static Widget _buildNavButton(BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.pink[100],
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
