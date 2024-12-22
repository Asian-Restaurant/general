import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Метод для регистрации пользователя
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body); // Возвращаем данные пользователя
    } else {
      print('Registration failed: ${response.body}');
      throw Exception('Failed to register user');
    }
  }

  // Метод для логина пользователя
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Возвращаем весь объект пользователя
    } else {
      print('Login failed: ${response.body}');
      throw Exception('Invalid credentials');
    }
  }

  // Метод для добавления элемента в корзину
  Future<void> addToCart(String userId, Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_to_cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'item_data': itemData}),
    );

    if (response.statusCode != 200) {
      print('Failed to add item to cart: ${response.body}');
      throw Exception('Failed to add item to cart');
    }
  }

  // Метод для получения меню
  Future<List<dynamic>> getMenu() async {
    final response = await http.get(Uri.parse('$baseUrl/menu'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load menu: ${response.body}');
      throw Exception('Failed to load menu');
    }
  }

  // Метод для получения всех отзывов
  Future<List<dynamic>> getAllReviews() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load reviews: ${response.body}');
      throw Exception('Failed to load reviews');
    }
  }

  // Метод для добавления отзыва
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

  // Метод для отправки адреса доставки
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

  // Метод для получения данных пользователя по email
  Future<Map<String, dynamic>> getUser(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user?email=$email'), // Параметр email передается в URL
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data: ${response.body}');
    }
  }

  // Метод для обновления данных пользователя
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

  // Сохранение данных пользователя локально
  Future<void> saveUserDataLocally(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', userData['email']);
    await prefs.setString('name', userData['name']);
    await prefs.setString('phone', userData['phone']);
  }

  // Загрузка данных пользователя из локального хранилища
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

  // Удаление данных пользователя из локального хранилища
  Future<void> clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}