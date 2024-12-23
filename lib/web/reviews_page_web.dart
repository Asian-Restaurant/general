import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AuthService.dart';
import '../api/api_service.dart';

class ReviewsPageWeb extends StatefulWidget {
  const ReviewsPageWeb({Key? key}) : super(key: key);

  @override
  _ReviewsPageWebState createState() => _ReviewsPageWebState();
}

class _ReviewsPageWebState extends State<ReviewsPageWeb> {
  final TextEditingController _reviewController = TextEditingController();
  final ApiService _apiService = ApiService('http://127.0.0.1:5000');
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<dynamic> reviews = await _apiService.getAllReviews();
      setState(() {
        _reviews = reviews.map((review) => {
          "user": review['name'] ?? "Anonymous",
          "review": review['comment'] ?? "No comment",
        }).toList();
      });
    } catch (e) {
      setState(() {
        _reviews = [];
      });
      _showDialog('Error', 'Error loading reviews: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addReview() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (!authService.isAuthenticated) {
      _showAuthDialog();
      return;
    }

    if (_reviewController.text.isEmpty) {
      _showDialog('Error', 'Review text cannot be empty.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.addReview({
        'email': authService.currentUserEmail,
        'name': authService.currentUserName,
        'comment': _reviewController.text,
      });

      _reviewController.clear();
      await _loadReviews(); // Reload reviews after adding the new one
    } catch (e) {
      _showDialog('Error', 'Failed to add review: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAuthDialog() {
    _showDialog(
      'Authentication Required',
      'You need to be logged in to leave a review.',
      onConfirm: () {
        Navigator.pushNamed(context, '/login');
      },
    );
  }

  void _showDialog(String title, String message, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            if (onConfirm != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: const Text('Confirm'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[100],
          title: Text('Reviews', style: GoogleFonts.mali(fontSize: 20)),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('Reviews', style: GoogleFonts.mali(fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check if user is logged in, display the username
            if (authService.isAuthenticated)
              Text(
                'Logged in as: ${authService.currentUserName}',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              )
            else
              Text(
                'You are not logged in. Please log in to leave a review.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
            const SizedBox(height: 16),
            TextField(
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
                _addReview();
              },
            ),
            const SizedBox(height: 8),
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

  Widget _buildReviewList() {
    if (_reviews.isEmpty) {
      return Center(
        child: Text(
          'No reviews yet. Be the first to leave one!',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

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
                  _reviews[index]["user"] ?? "Unknown User",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_reviews[index]["review"] ?? "No review provided"),
              ],
            ),
          ),
        );
      },
    );
  }
}
