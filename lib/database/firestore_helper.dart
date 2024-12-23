import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FirestoreHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Вставка пользователя с хешированием пароля
  Future<void> insertUser(Map<String, dynamic> user) async {
    if (await _isEmailExists(user['email'])) {
      throw Exception('Email already exists');
    }

    String hashedPassword = _hashPassword(user['password']);
    user['password'] = hashedPassword; // Хешируем пароль

    try {
      await _db.collection('users').add(user);
      print('User added: $user');
    } catch (e) {
      print('Error adding user: $e');
      throw Exception('Failed to add user');
    }
  }

  // Проверка на существование email
  Future<bool> _isEmailExists(String email) async {
    QuerySnapshot snapshot = await _db.collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Хеширование пароля
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Вход пользователя
  Future<bool> loginUser(String email, String password) async {
    QuerySnapshot snapshot = await _db.collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String hashedPassword = _hashPassword(password);
      if (snapshot.docs[0]['password'] == hashedPassword) {
        return true; // Успешный вход
      }
    }
    return false; // Неверные учетные данные
  }

  // Получение данных пользователя
  Future<Map<String, dynamic>?> getUser(String email) async {
    QuerySnapshot snapshot = await _db.collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs[0].data() as Map<String, dynamic>;
    }
    return null; // Пользователь не найден
  }

  // Вставка адреса доставки
  Future<void> insertDeliveryAddress(Map<String, dynamic> address) async {
    try {
      await _db.collection('delivery_addresses').add(address);
      print('Delivery address added: $address');
    } catch (e) {
      print('Error adding delivery address: $e');
      throw Exception('Failed to add delivery address');
    }
  }

  // Вставка отзыва
  Future<void> insertReview(Map<String, dynamic> review) async {
    review['review_date'] = DateTime.now().toIso8601String(); // Устанавливаем текущую дату
    try {
      await _db.collection('reviews').add(review);
      print('Review added: $review');
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Failed to add review');
    }
  }

  // Получение отзывов по item_id
  Future<List<Map<String, dynamic>>> getReviewsByItemId(String itemId) async {
    QuerySnapshot snapshot = await _db.collection('reviews')
        .where('item_id', isEqualTo: itemId)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Загрузка данных о корзине
  Future<List<CartItem>> loadCart(String userId) async {
    QuerySnapshot snapshot = await _db.collection('cart')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return CartItem(
        itemId: data['item_id'],
        title: data['title'],
        imagePath: data['imagePath'],
        price: data['total_price'] / data['quantity'],
        quantity: data['quantity'],
      );
    }).toList();
  }

  // Сохранение данных в корзину
  Future<void> saveCart(List<CartItem> cartItems, String userId) async {
    try {
      // Очистка старых данных для пользователя
      await _db.collection('cart').where('user_id', isEqualTo: userId).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Сохранение новых товаров в корзину
      for (var item in cartItems) {
        await _db.collection('cart').add({
          'user_id': userId,
          'item_id': item.itemId,
          'quantity': item.quantity,
          'total_price': item.price * item.quantity,
          'title': item.title,
          'imagePath': item.imagePath,
        });
        print('Added new item to cart: ${item.title}');
      }
    } catch (e) {
      print('Error saving cart: $e');
      throw Exception('Failed to save cart');
    }
  }

  // Метод для увеличения количества товара в корзине
  Future<void> increaseItemQuantity(String cartItemId) async {
    DocumentSnapshot snapshot = await _db.collection('cart').doc(cartItemId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      int newQuantity = data['quantity'] + 1;
      await _db.collection('cart').doc(cartItemId).update({'quantity': newQuantity});
      print('Increased quantity for item: $cartItemId');
    }
  }

  // Метод для уменьшения количества товара в корзине
  Future<void> decreaseItemQuantity(String cartItemId) async {
    DocumentSnapshot snapshot = await _db.collection('cart').doc(cartItemId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      int newQuantity = data['quantity'] - 1;
      if (newQuantity <= 0) {
        await _db.collection('cart').doc(cartItemId).delete();
        print('Removed item from cart: $cartItemId');
      } else {
        await _db.collection('cart').doc(cartItemId).update({'quantity': newQuantity});
        print('Decreased quantity for item: $cartItemId');
      }
    }
  }
}

class CartItem {
  final String itemId; // Добавлено поле itemId
  final String title;
  final String imagePath;
  final double price;
  int quantity;

  CartItem({
    required this.itemId, // Добавлено в конструктор
    required this.title,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId, // Добавлено в метод toJson
      'title': title,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
  }
}