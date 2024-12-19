import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database/сart.dart';

Future<void> saveCart(int userId, List<CartItem> cartItems) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/cart/$userId'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(cartItems.map((item) => item.toJson()).toList()),
  );

  if (response.statusCode == 200) {
    print('Cart saved successfully');
  } else {
    throw Exception('Failed to save cart');
  }
}