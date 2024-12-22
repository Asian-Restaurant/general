import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AuthService.dart';
import '../api/api_service.dart'; // Импортируйте ваш API сервис

class ReviewsPageWeb extends StatefulWidget {
  const ReviewsPageWeb({super.key});

  @override
  _ReviewsPageWebState createState() => _ReviewsPageWebState();
}

class _ReviewsPageWebState extends State<ReviewsPageWeb> {
  final TextEditingController _reviewController = TextEditingController();
  final ApiService _apiService = ApiService('http://127.0.0.1:5000'); // URL вашего API
  List<Map<String, String>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews(); // Загрузить отзывы при инициализации
  }

  void _loadReviews() async {
    try {
      List reviews = await _apiService.getAllReviews();
      print('Reviews loaded: $reviews');
      setState(() {
        _reviews = reviews
            .map((review) => {
          "user": "User ${review['user_id']}",
          "review": review['comment'] as String,
        })
            .toList()
            .cast<Map<String, String>>();
      });
    } catch (e) {
      print('Error loading reviews: ${e.toString()}');
      _showErrorDialog('Error loading reviews: ${e.toString()}');
    }
  }


  void _addReview() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated) {
      if (_reviewController.text.isNotEmpty) {
        print("Attempting to add review: ${_reviewController.text}");
        try {
          await _apiService.addReview({
            'user_id': authService.currentUserId, // Получите ID текущего пользователя
            'comment': _reviewController.text,
          });

          print("Review added successfully");
          // Обновляем список отзывов
          _loadReviews();
          _reviewController.clear(); // Очистка текстового поля
        } catch (e) {
          print("Error adding review: $e");
          _showErrorDialog('Failed to add review: ${e.toString()}');
        }
      } else {
        print("Review text is empty");
      }
    } else {
      print("User is not authenticated");
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
        child: const Text('Login')),
      ],
    );
  },
  );
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (!authService.isAuthenticated) {
      // Если пользователь не залогинен, перенаправить на страницу логина
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Center(child: CircularProgressIndicator());
    }

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
      onSubmitted: (value) {
        _addReview(); // Вызываем метод отправки отзыва при нажатии Enter
      },
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