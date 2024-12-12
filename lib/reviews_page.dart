import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Leave your review...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Обработка отправки отзыва
              print('Review submitted: ${_controller.text}');
            },
            child: Text('Send Review'),
          ),
          Expanded(
            child: ListView(
              children: List.generate(
                4,
                    (index) => ListTile(
                  title: Text('User$index'),
                  subtitle: Text('blah-blah-blah'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
