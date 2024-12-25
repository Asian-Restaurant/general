import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/api_service.dart';
import '../database/сart.dart';

class DishPageWeb extends StatefulWidget {
  final String dishName; // Название блюда
  final Cart cart;

  const DishPageWeb({
    Key? key,
    required this.dishName,
    required this.cart,
  }) : super(key: key);

  @override
  _DishPageWebState createState() => _DishPageWebState();
}

class _DishPageWebState extends State<DishPageWeb> {
  String? title;
  String? imagePath;
  String? description;
  double? weight;
  double? price;

  bool isLoading = true; // Флаг загрузки
  bool hasError = false; // Флаг ошибки

  final ApiService _apiService = ApiService("http://127.0.0.1:5000");

  @override
  void initState() {
    super.initState();
    print("Fetching data for dish: ${widget.dishName}");
    _fetchDishData(widget.dishName);
  }

  Future<void> _fetchDishData(String dishName) async {
    try {
      final data = await _apiService.getDish(dishName);
      print("Data received: $data");

      if (data == null || data.isEmpty) {
        throw Exception("Dish data is empty or null.");
      }

      setState(() {
        title = data['dish_name'];
        imagePath = data['image_url'];
        description = data['description'];
        weight = double.tryParse(data['weight'].toString()) ?? 0.0;
        price = double.tryParse(data['price'].toString()) ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching dish data: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch dish data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading..."), automaticallyImplyLeading: false),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error"), automaticallyImplyLeading: false),
        body: Center(
          child: Text(
            "Failed to load dish data. Please try again later.",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? "Dish",
          style: GoogleFonts.mali(color: Colors.black),
        ),
        backgroundColor: Colors.pink[100],
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: Center( // Center the entire content
        child: SingleChildScrollView( // Enable scrolling if content overflows
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink[300]!, width: 5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.network(
                    imagePath ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description ?? "No description available.",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Weight: ${weight ?? 0}g",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Price: ${price?.toStringAsFixed(2) ?? "0.00"} BYN",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addToCart(context, widget.cart);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.pink[300],
                ),
                child: Text(
                  "Add to Cart",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, Cart cart) {
    final existingItemIndex = cart.items.indexWhere((item) => item.title == title);
    if (existingItemIndex != -1) {
      cart.items[existingItemIndex].quantity++;
      print("Increased quantity for item: ${cart.items[existingItemIndex].title}");
    } else {
      cart.addItem(CartItem(title: title!, imagePath: imagePath!, price: price!));
      print("Added new item to cart: $title");
    }

    Navigator.pop(context, true);
  }
}
