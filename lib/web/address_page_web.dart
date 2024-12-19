import 'package:asian_paradise/web/main_page_web.dart';
import 'package:asian_paradise/web/menu_page_web.dart';
import 'package:asian_paradise/web/basket_page_web.dart' as basket;
import 'package:asian_paradise/web/reviews_page_web.dart' as reviews;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../database/сart.dart';


class AddressPageWeb extends StatefulWidget {
  const AddressPageWeb({super.key});

  @override
  _AddressPageWebState createState() => _AddressPageWebState();
}

class _AddressPageWebState extends State<AddressPageWeb> {
  final Cart cart = Cart();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Кнопки навигации
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton(context, "Main Page", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageWeb()));
                  }),
                  _buildNavButton(context, "Menu", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPageWeb()));
                  }),
                  _buildNavButton(context, "Basket", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => basket.BasketPageWeb(cartData: cart)));
                  }),
                  _buildNavButton(context, "Reviews", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => reviews.ReviewsPageWeb()));
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Форма адреса
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Your address',
                      style: GoogleFonts.mali(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Street', _streetController),
                    const SizedBox(height: 10),
                    _buildTextField('House', _houseController),
                    const SizedBox(height: 10),
                    _buildTextField('Floor', _floorController),
                    const SizedBox(height: 10),
                    _buildTextField('Apartment', _apartmentController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Future<void> _saveAddress() async {
    final address = {
      'user_id': 1,
      'street': _streetController.text,
      'house': _houseController.text,
      'floor': _floorController.text,
      'apartment': _apartmentController.text,
    };

    final dbHelper = DatabaseHelper();
    await dbHelper.insertDeliveryAddress(address);
    _clearFields();

    // Информируем пользователя о том, что адрес отправлен
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sent')));
  }

  void _clearFields() {
    _streetController.clear();
    _houseController.clear();
    _floorController.clear();
    _apartmentController.clear();
  }
}