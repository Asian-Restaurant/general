import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reviews_page.dart' as reviews;
import 'main_page.dart';
import 'basket_page.dart' as basket;
import 'address_page.dart' as address;
import 'dish_page.dart';
import 'сart.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Cart(); // Создайте экземпляр Cart здесь

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Вертикальное расположение кнопок навигации
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavButton(context, "Main Page", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Basket", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => basket.BasketPage(cartData: cart)));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Reviews", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const reviews.ReviewsPage()));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Delivery", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => address.AddressPage()));
                }),
              ],
            ),
            const SizedBox(width: 16),
            // Изображения
            Expanded(
              child: _buildFoodGrid(context, cart), // Передайте cart сюда
            ),
          ],
        ),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context), // Используем метод для определения количества колонок
                childAspectRatio: 1,
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
                  cart, // Передайте cart в карточку
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
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width < 600 ? 140 : 220,
                height: MediaQuery.of(context).size.width < 600 ? 100 : 180,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.pink[300]!, width: 5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () {
            // Переход на страницу блюда с передачей корзины
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishPage(
                  title: title,
                  imagePath: imagePath,
                  description: description,
                  weight: weight,
                  price: price,
                  cart: cart, // Передайте корзину
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.pink[200],
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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

  // Метод для определения количества колонок в зависимости от ширины экрана
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) {
      return 3; // Большие экраны
    } else if (width >= 600) {
      return 2; // Средние экраны
    } else {
      return 1; // Маленькие экраны
    }
  }

  // Метод для создания кнопки навигации
  static Widget _buildNavButton(BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.pink[100],
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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