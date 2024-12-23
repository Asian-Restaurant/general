import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/сart.dart' as cart;
import '../web/reviews_page_web.dart' as reviews;
import '../web/address_page_web.dart' as address;
import '../web/main_page_web.dart';
import '../web/menu_page_web.dart';

class BasketPageWeb extends StatefulWidget {
  final cart.Cart cartData;

  const BasketPageWeb({super.key, required this.cartData});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPageWeb> {
  final TextEditingController _commentController = TextEditingController();
  String? _sendMessage;

  @override
  void initState() {
    super.initState();
    _loadCart(); // Load cart on initialization
  }

  @override
  void dispose() {
    _saveCart(); // Save cart on exit
    super.dispose();
  }

  // Load cart from the server
  void _loadCart() async {
    const userId = '1'; // Replace with the actual user ID
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/cart/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      setState(() {
        widget.cartData.items.clear();
        widget.cartData.items.addAll(items.map((item) => cart.CartItem(
          title: item['title'],
          imagePath: item['imagePath'],
          price: item['price'],
          quantity: item['quantity'],
        )));
      });
    } else {
      print('Failed to load cart');
    }
  }

  // Save cart to the server
  void _saveCart() async {
    const userId = '1'; // Replace with the actual user ID
    final List<Map<String, dynamic>> cartItems = widget.cartData.items.map((item) {
      return {
        'title': item.title,
        'imagePath': item.imagePath,
        'price': item.price,
        'quantity': item.quantity,
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/save_cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'items': cartItems}),
    );

    if (response.statusCode == 200) {
      print('Cart saved');
    } else {
      print('Failed to save cart');
    }
  }

  // Send comment
  void _sendComment() {
    setState(() {
      _sendMessage = "Sent!";
      _commentController.clear(); // Clear input field
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _sendMessage = null; // Remove message after 2 seconds
      });
    });
  }

  // Increase item quantity
  void _increaseItemQuantity(int index) {
    setState(() {
      widget.cartData.items[index].quantity++;
    });
  }

  // Decrease item quantity
  void _decreaseItemQuantity(int index) {
    setState(() {
      if (widget.cartData.items[index].quantity > 1) {
        widget.cartData.items[index].quantity--;
      } else {
        widget.cartData.items.removeAt(index);
      }
    });
  }

  // Navigate to different pages
  void _navigateTo(String page) {
    _saveCart();

    switch (page) {
      case "Main Page":
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageWeb()));
        break;
      case "Menu":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPageWeb()));
        break;
      case "Reviews":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const reviews.ReviewsPageWeb()));
        break;
      case "Delivery":
        Navigator.push(context, MaterialPageRoute(builder: (context) => address.AddressPageWeb()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNavButtons(context, isLargeScreen),
              const SizedBox(height: 16),
              _buildOrderList(),
              const SizedBox(height: 16),
              _buildTotalSum(),
              const SizedBox(height: 16),
              _buildCommentsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation buttons
  Widget _buildNavButtons(BuildContext context, bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (String title in ["Main Page", "Menu", "Reviews", "Delivery"])
          _buildNavButton(context, title, isLargeScreen),
      ],
    );
  }

  // Navigation button
  Widget _buildNavButton(BuildContext context, String text, bool isLargeScreen) {
    return SizedBox(
      width: isLargeScreen ? 120 : 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 8 : 4),
        ),
        onPressed: () => _navigateTo(text),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: isLargeScreen ? 18 : 13, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  // Build order list widget
  Widget _buildOrderList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pinkAccent, width: 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Order",
            style: GoogleFonts.mali(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.pinkAccent),
          if (widget.cartData.items.isEmpty)
            Text(
              "Your basket is empty.",
              style: GoogleFonts.mali(fontSize: 16, fontStyle: FontStyle.italic),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.cartData.items.length,
                itemBuilder: (context, index) {
                  final item = widget.cartData.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.mali(fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decreaseItemQuantity(index),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${item.quantity}",
                                style: GoogleFonts.mali(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _increaseItemQuantity(index),
                            ),
                          ],
                        ),
                        Text(
                          "${(item.price * item.quantity).toStringAsFixed(2)} BYN",
                          style: GoogleFonts.mali(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Build total sum widget
  Widget _buildTotalSum() {
    final totalSum = widget.cartData.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pinkAccent, width: 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total sum:",
            style: GoogleFonts.mali(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "${totalSum.toStringAsFixed(2)} BYN",
            style: GoogleFonts.mali(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Build comments section widget
  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pinkAccent, width: 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Any comments?",
            style: GoogleFonts.mali(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.pinkAccent),
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Write here...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _sendComment,
            child: Text(
              "Send",
              style: GoogleFonts.mali(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          if (_sendMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _sendMessage!,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
