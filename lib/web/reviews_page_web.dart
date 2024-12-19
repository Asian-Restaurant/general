import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AuthService.dart';
import '../database/database_helper.dart';

class ReviewsPageWeb extends StatefulWidget {
  const ReviewsPageWeb({super.key});

  @override
  _ReviewsPageWebState createState() => _ReviewsPageWebState();
}

class _ReviewsPageWebState extends State<ReviewsPageWeb> {
  final TextEditingController _reviewController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, String>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews(); // Загрузить отзывы при инициализации
  }

  void _loadReviews() async {
    int itemId = 1; // Замените на актуальный item_id
    List<Map<String, dynamic>> reviews = await _databaseHelper.getReviewsByItemId(itemId);
    setState(() {
      _reviews = reviews.map((review) => {
        "user": "User ${review['user_id']}",  // Приведение к строке
        "review": review['comment'] as String, // Явно указываем, что это строка
      }).toList().cast<Map<String, String>>(); // Приведение всего списка к нужному типу
    });
  }

  void _addReview() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated) {
      if (_reviewController.text.isNotEmpty) {
        int itemId = 1; // Замените на актуальный item_id
        await _databaseHelper.insertReview({
          'item_id': itemId,
          'user_id': authService.currentUserId, // Получите ID текущего пользователя
          'rating': 5, // Можно добавить функциональность оценки
          'comment': _reviewController.text,
        });

        // Обновляем список отзывов
        _loadReviews();
        _reviewController.clear(); // Очистка текстового поля
      }
    } else {
      _showAuthDialog(); // Показать диалог авторизации
    }
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authentication Required'),
          content: const Text('You need to be logged in to leave a review.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login'); // Переход на страницу логина
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(fontSize: 20),
        ),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave your review!',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildReviewInput(),
            const SizedBox(height: 8),
            Text(
              'Reviews:',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Expanded(child: _buildReviewList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReview,
        backgroundColor: Colors.pink[300],
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildReviewInput() {
    return TextField(
      controller: _reviewController,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Tell us everything you want...',
        filled: true,
        fillColor: Colors.pink[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }

  Widget _buildReviewList() {
    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _reviews[index]["user"]!,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_reviews[index]["review"]!),
              ],
            ),
          ),
        );
      },
    );
  }
}