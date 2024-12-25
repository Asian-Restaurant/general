import 'package:asian_paradise/web/address_page_web.dart';
import 'package:asian_paradise/web/basket_page_web.dart';
import 'package:asian_paradise/web/dish_page_web.dart';
import 'package:asian_paradise/web/main_page_web.dart';
import 'package:asian_paradise/web/reviews_page_web.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/api_service.dart';
import '../database/сart.dart';

class MenuPageWeb extends StatelessWidget {
  MenuPageWeb({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService('http://127.0.0.1:5000');

  @override
  Widget build(BuildContext context) {
    final cart = Cart();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink[100],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _apiService.getMenu(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menu items found.'));
            }

            final menuItems = snapshot.data!;
            final Map<String, List<Map<String, dynamic>>> groupedDishes = {};

            for (var item in menuItems) {
              final category = item['category'];
              if (!groupedDishes.containsKey(category)) {
                groupedDishes[category] = [];
              }
              groupedDishes[category]!.add({
                'dish_name': item['dish_name'],
                'image_url': item['image_url'],
              });
            }

            return Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavButton(context, "Main Page", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageWeb()));
                    }),
                    const SizedBox(height: 8),
                    _buildNavButton(context, "Basket", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BasketPageWeb(cartData: cart)));
                    }),
                    const SizedBox(height: 8),
                    _buildNavButton(context, "Reviews", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPageWeb()));
                    }),
                    const SizedBox(height: 8),
                    _buildNavButton(context, "Delivery", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressPageWeb()));
                    }),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFoodGrid(groupedDishes, context, cart),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFoodGrid(Map<String, List<Map<String, dynamic>>> groupedDishes, BuildContext context, Cart cart) {
    return ListView.builder(
      itemCount: groupedDishes.keys.length,
      itemBuilder: (context, categoryIndex) {
        final category = groupedDishes.keys.elementAt(categoryIndex);
        final dishes = groupedDishes[category]!;

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
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: dishes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, dishIndex) {
                final dish = dishes[dishIndex];
                return _buildFoodCard(
                  dish['image_url'] ?? '',
                  dish['dish_name'] ?? 'Unknown Title',
                  '',
                  0.0,
                  0.0,
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

  Widget _buildFoodCard(String imagePath, String title, String description, double weight, double price, BuildContext context, Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.pink[300],
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.0),
            child: imagePath.isNotEmpty
                ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              width: 220,
              height: 200,
            )
                : Container(
              width: 220,
              height: 200,
              color: Colors.grey,
              child: const Center(child: Text('No Image')),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishPageWeb(
                  dishName: title,
                  cart: cart,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.pink[200],
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

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