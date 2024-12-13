import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reviews_page.dart' as reviews;
import 'main_page.dart';
import 'menu_page.dart';

class BasketPage extends StatefulWidget {
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, int> _orderItems = {
    "Nigiri": 1,
    "Kimbap": 2,
    "Dal": 1,
    "Tteokbokki": 2,
    "Dim Sum": 1,
    "Yakitori": 4,
  };

  String? _sendMessage;

  void _incrementItem(String item) {
    setState(() {
      _orderItems[item] = (_orderItems[item] ?? 0) + 1;
    });
  }

  void _decrementItem(String item) {
    setState(() {
      if (_orderItems[item] != null && _orderItems[item]! > 1) {
        _orderItems[item] = _orderItems[item]! - 1;
      } else {
        _orderItems.remove(item);
      }
    });
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
              isLargeScreen ? _buildCommentsSection() : Container(),
              if (!isLargeScreen) _buildCommentsSection(), // Если экран маленький, показываем комментарии
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButtons(BuildContext context, bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Выравнивание кнопок с пространством между ними
      children: [
        for (String title in ["Main Page", "Menu", "Reviews", "Contacts"])
          _buildNavButton(context, title, isLargeScreen),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String text, bool isLargeScreen) {
    return Container(
      width: isLargeScreen ? 120 : 80, // Уменьшение ширины кнопок
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Увеличение радиуса закругления
          padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 8 : 4),
        ),
        onPressed: () {
          // Логика навигации
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
            // Действие для Contacts
              break;
          }
        },
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: isLargeScreen ? 18 : 13, fontWeight: FontWeight.w600, color: Colors.black), // Размер шрифта
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _orderItems.keys.length,
            itemBuilder: (context, index) {
              final item = _orderItems.keys.elementAt(index);
              final quantity = _orderItems[item]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: GoogleFonts.mali(fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _decrementItem(item),
                        ),
                        Text(
                          "x$quantity",
                          style: GoogleFonts.mali(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _incrementItem(item),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSum() {
    final totalSum = _orderItems.values.fold(0, (sum, quantity) => sum + quantity * 50); // Пример цены
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
            "$totalSum BYN",
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
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _sendMessage!,
                style: GoogleFonts.mali(color: Colors.green, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}