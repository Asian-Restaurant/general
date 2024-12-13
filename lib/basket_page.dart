import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database/database_helper.dart' as db; // Alias for database_helper.dart
import 'сart.dart' as cart; // Alias for сart.dart
import 'reviews_page.dart' as reviews;
import 'main_page.dart';
import 'menu_page.dart';

class BasketPage extends StatefulWidget {
  final cart.Cart cartData; // Renamed from cart to cartData to avoid shadowing

  const BasketPage({Key? key, required this.cartData}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final TextEditingController _commentController = TextEditingController();
  final db.DatabaseHelper _dbHelper = db.DatabaseHelper();
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

  void _loadCart() async {
    final userId = 1; // Replace with the actual user ID
    final loadedItems = await _dbHelper.loadCart(userId);
    setState(() {
      widget.cartData.items.clear(); // Clear current items
      widget.cartData.items.addAll(loadedItems.map((item) => cart.CartItem(
        title: item.title,
        imagePath: item.imagePath,
        price: item.price,
        quantity: item.quantity,
      )));
    });
  }

  void _saveCart() async {
    final userId = 1; // Replace with the actual user ID
    await _dbHelper.saveCart(widget.cartData.items.cast<db.CartItem>(), userId);
  }

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

  void _showAddMessage(String message) {
    setState(() {
      _sendMessage = message;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _sendMessage = null;
      });
    });
  }

  void _addItemToCart(cart.CartItem item) {
    setState(() {
      // Check if item already exists in cart
      final existingItemIndex = widget.cartData.items.indexWhere((cartItem) => cartItem.title == item.title);

      if (existingItemIndex != -1) {
        // If item already exists, increase quantity
        widget.cartData.items[existingItemIndex].quantity++;
      } else {
        // If item does not exist, add it to cart
        widget.cartData.addItem(cart.CartItem(
          title: item.title,
          imagePath: item.imagePath,
          price: item.price,
          quantity: 1, // Set initial quantity to 1
        ));
      }

      _showAddMessage("${item.title} added to cart!");
    });
  }

  void _increaseItemQuantity(int index) {
    setState(() {
      widget.cartData.items[index].quantity++;
    });
  }

  void _decreaseItemQuantity(int index) {
    setState(() {
      if (widget.cartData.items[index].quantity > 1) {
        widget.cartData.items[index].quantity--;
      } else {
        widget.cartData.items.removeAt(index);
      }
    });
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

  Widget _buildNavButtons(BuildContext context, bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (String title in ["Main Page", "Menu", "Reviews", "Contacts"])
          _buildNavButton(context, title, isLargeScreen),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String text, bool isLargeScreen) {
    return Container(
      width: isLargeScreen ? 120 : 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 8 : 4),
        ),
        onPressed: () {
          switch (text) {
            case "Main Page":
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              break;
            case "Menu":
              Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
              break;
            case "Reviews":
              Navigator.push(context, MaterialPageRoute(builder: (context) => const reviews.ReviewsPage()));
              break;
            case "Contacts":
            // Action for Contacts
              break;
          }
        },
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: isLargeScreen ? 18 : 13, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

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
              height: 200, // Set a fixed height for the list
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
                            "${item.title}",
                            style: GoogleFonts.mali(fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
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
                              icon: Icon(Icons.add),
                              onPressed: () => _increaseItemQuantity(index),
                            ),
                          ],
                        ),
                        Text(
                          "${(item.price * item.quantity).toStringAsFixed(2)} BYN", // Multiply price by quantity
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

  Widget _buildTotalSum() {
    final totalSum = widget.cartData.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)); // Calculate total sum
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
            "${totalSum.toStringAsFixed(2)} BYN", // Change currency to BYN
            style: GoogleFonts.mali(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

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
          if (_sendMessage != null) // Show message under the button
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _sendMessage!,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}