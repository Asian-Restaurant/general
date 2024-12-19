import 'package:asian_paradise/mobile/main_page_mobile.dart';
import 'package:asian_paradise/mobile/menu_page_mobile.dart';
import 'package:asian_paradise/mobile/address_page_mobile.dart' as address;
import 'package:asian_paradise/mobile/reviews_page_mobile.dart' as reviews;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart' as db;
import '../database/сart.dart' as cart;


class BasketPageMobile extends StatefulWidget {
  final cart.Cart cartData;

  const BasketPageMobile({super.key, required this.cartData});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPageMobile> {
  final TextEditingController _commentController = TextEditingController();
  final db.DatabaseHelper _dbHelper = db.DatabaseHelper();
  String? _sendMessage;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void dispose() {
    _saveCart();
    super.dispose();
  }

  void _loadCart() async {
    const userId = 1; // Замените на фактический ID пользователя
    final loadedItems = await _dbHelper.loadCart(userId);
    setState(() {
      widget.cartData.items.clear();
      widget.cartData.items.addAll(loadedItems.map((item) => cart.CartItem(
        title: item.title,
        imagePath: item.imagePath,
        price: item.price,
        quantity: item.quantity,
      )));
    });
  }

  void _saveCart() async {
    const userId = 1; // Замените на фактический ID пользователя
    await _dbHelper.saveCart(widget.cartData.items.cast<db.CartItem>(), userId);
  }

  void _sendComment() {
    setState(() {
      _sendMessage = "Sent!";
      _commentController.clear();
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _sendMessage = null;
      });
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

  void _navigateTo(String page) {
    _saveCart();
    switch (page) {
      case "Main Page":
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageMobile()));
        break;
      case "Menu":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPageMobile()));
        break;
      case "Reviews":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const reviews.ReviewsPageMobile()));
        break;
      case "Delivery":
        Navigator.push(context, MaterialPageRoute(builder: (context) => address.AddressPageMobile()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNavButtons(),
            const SizedBox(height: 16),
            _buildOrderList(),
            const SizedBox(height: 16),
            _buildTotalSum(),
            const SizedBox(height: 16),
            _buildCommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (String title in ["Main Page", "Menu", "Reviews", "Delivery"])
          _buildNavButton(title),
      ],
    );
  }

  Widget _buildNavButton(String text) {
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => _navigateTo(text),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
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
            _buildOrderListView(),
        ],
      ),
    );
  }

  Widget _buildOrderListView() {
    return SizedBox(
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
                _buildQuantityControls(index),
                Text(
                  "${(item.price * item.quantity).toStringAsFixed(2)} BYN",
                  style: GoogleFonts.mali(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantityControls(int index) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _decreaseItemQuantity(index),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "${widget.cartData.items[index].quantity}",
            style: GoogleFonts.mali(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _increaseItemQuantity(index),
        ),
      ],
    );
  }

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