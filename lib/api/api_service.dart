import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Method for user registration
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body); // Return user data
    } else {
      print('Registration failed: ${response.body}');
      throw Exception('Failed to register user');
    }
  }

  // Method for user login
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return user object
    } else {
      print('Login failed: ${response.body}');
      throw Exception('Invalid credentials');
    }
  }

  // Method to add an item to the cart
  Future<void> addToCart(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name_dish': itemData['name_dish'],
        'price': itemData['price'],
        'quantity': itemData['quantity'],
        'comment': itemData['comment'] ?? 'Want to bring home',
      }),
    );

    if (response.statusCode != 201) {
      print('Failed to add item to cart: ${response.body}');
      throw Exception('Failed to add item to cart');
    }
  }

  // Method to retrieve the cart
  Future<List<dynamic>> getCart() async {
    final response = await http.get(Uri.parse('$baseUrl/cart'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the cart items
    } else {
      print('Failed to load cart: ${response.body}');
      throw Exception('Failed to load cart');
    }
  }

  // Method to save cart data
  Future<bool> saveCart(List<Map<String, dynamic>> cartItems) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'items': cartItems,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Cart saved successfully
    } else {
      print('Failed to save cart: ${response.body}');
      return false;
    }
  }

  // Method to retrieve the menu
  Future<List<dynamic>> getMenu() async {
    final response = await http.get(Uri.parse('$baseUrl/menu'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load menu: ${response.body}');
      throw Exception('Failed to load menu');
    }
  }

  // Method to retrieve dish information
  Future<Map<String, dynamic>> getDish(String dishName) async {
    String requestUrl = '$baseUrl/dish?dish_name=${Uri.encodeComponent(dishName)}';
    print("Requesting URL: $requestUrl"); // Log the request URL

    try {
      final response = await http.get(Uri.parse(requestUrl), headers: {'Content-Type': 'application/json'});

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch dish: ${response.body}');
        throw Exception('Dish not found');
      }
    } catch (e) {
      print('Error in ApiService.getDish: $e');
      throw Exception('Failed to fetch dish data');
    }
  }

  // Static method to get cart data
  Future<List<dynamic>> getCartData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the cart items
    } else {
      print('Failed to load cart: ${response.body}');
      throw Exception('Failed to load cart');
    }
  }

  // Method to send a comment
  Future<bool> sendComment(String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'comment': comment}),
    );

    if (response.statusCode == 200) {
      return true; // Comment sent successfully
    } else {
      print('Failed to send comment: ${response.body}');
      return false;
    }
  }

  // Method to retrieve all reviews
  Future<List<dynamic>> getAllReviews() async {
    try {
      final uri = Uri.parse('$baseUrl/reviews');
      final response = await http.get(uri);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Error fetching reviews: $e');
    }
  }

  // Method to add a review
  Future<void> addReview(Map<String, dynamic> reviewData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reviewData),
    );

    if (response.statusCode != 201) {
      print('Failed to add review: ${response.body}');
      throw Exception('Failed to add review');
    }
  }

  // Method to submit a delivery address
  Future<void> submitDeliveryAddress(Map<String, dynamic> addressData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delivery'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(addressData),
    );

    if (response.statusCode != 201) {
      print('Failed to save delivery address: ${response.body}');
      throw Exception('Failed to save delivery address');
    }
  }

  // Method to get user data by email
  Future<Map<String, dynamic>> getUser(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user?email=${Uri.encodeComponent(email)}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data: ${response.body}');
    }
  }

  // Method to update user data
  Future<void> updateUser(Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode != 200) {
      print('Failed to update user data: ${response.body}');
      throw Exception('Failed to update user data');
    }
  }

  // Save user data locally
  Future<void> saveUserDataLocally(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', userData['email']);
    await prefs.setString('name', userData['name']);
    await prefs.setString('phone', userData['phone']);
  }

  // Load user data from local storage
  Future<Map<String, dynamic>?> loadUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final name = prefs.getString('name');
    final phone = prefs.getString('phone');

    if (email != null && name != null && phone != null) {
      return {'email': email, 'name': name, 'phone': phone};
    }

    return null;
  }

  // Clear user data from local storage
  Future<void> clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}