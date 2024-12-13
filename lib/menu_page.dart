import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reviews_page.dart' as reviews;
import 'main_page.dart';
import 'basket_page.dart' as basket;

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => basket.BasketPage()));
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Reviews", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const reviews.ReviewsPage()),
                  );
                }),
                const SizedBox(height: 8),
                _buildNavButton(context, "Contacts", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsPage()));
                }),
              ],
            ),
            const SizedBox(width: 16),
            // Изображения
            Expanded(
              child: _buildFoodGrid(context),
            ),
          ],
        ),
      ),
    );
  }

  // Метод для создания сетки с изображениями
  Widget _buildFoodGrid(BuildContext context) {
    final foodItems = [
      {"image": "assets/jiaozi.jpg", "title": "Jiaozi"},
      {"image": "assets/onigiri.jpg", "title": "Onigiri"},
      {"image": "assets/bibimbap.jpg", "title": "Bibimbap"},
      {"image": "assets/satay.jpg", "title": "Satay"},
      {"image": "assets/biryani.jpg", "title": "Biryani"},
      {"image": "assets/bun bo hue.jpg", "title": "Bun Bo Hue"},
      {"image": "assets/char siu.jpg", "title": "Char Siu"},
      {"image": "assets/kimchi.jpg", "title": "Kimchi"},
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 3,
        childAspectRatio: 1,
      ),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return _buildFoodCard(foodItems[index]["image"] as String, foodItems[index]["title"] as String, context);
      },
    );
  }

  // Метод для создания карточки с едой
  Widget _buildFoodCard(String imagePath, String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Изображение
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width < 600 ? 140 : 220, // Увеличиваем ширину
                height: MediaQuery.of(context).size.width < 600 ? 100 : 180, // Увеличиваем высоту
              ),
            ),
            // Рамка
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
            print('$title selected');
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

// Заглушки для других страниц
class BasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Basket')),
      body: Center(child: Text('This is the Basket Page')),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body: Center(child: Text('This is the Reviews Page')),
    );
  }
}

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: Center(child: Text('This is the Contacts Page')),
    );
  }
}