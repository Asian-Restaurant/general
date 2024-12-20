// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';
// import 'package:flutter/foundation.dart' show kIsWeb;
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//
//   factory DatabaseHelper() {
//     return _instance;
//   }
//
//   DatabaseHelper._internal();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path;
//
//     if (kIsWeb) {
//       path = 'app.db'; // Используйте относительный путь для Web
//     } else {
//       path = join(await getDatabasesPath(), 'app.db');
//     }
//
//     print('Database path: $path');
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future _onCreate(Database db, int version) async {
//     print('Creating database tables...');
//
//     // Создание таблицы users с хешированием пароля
//     await db.execute('''
//       CREATE TABLE users (
//         user_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         email TEXT UNIQUE,
//         password TEXT,
//         phone TEXT
//       )
//     ''');
//
//     // Создание таблицы menu_items
//     await db.execute('''
//       CREATE TABLE menu_items (
//         item_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         description TEXT,
//         price REAL,
//         stock INTEGER,
//         imagePath TEXT
//       )
//     ''');
//
//     // Создание таблицы cart
//     await db.execute('''
//       CREATE TABLE cart (
//         cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER,
//         item_id INTEGER,
//         quantity INTEGER,
//         total_price REAL,
//         FOREIGN KEY (user_id) REFERENCES users (user_id),
//         FOREIGN KEY (item_id) REFERENCES menu_items (item_id)
//       )
//     ''');
//
//     // Создание таблицы orders
//     await db.execute('''
//       CREATE TABLE orders (
//         order_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER,
//         order_date TEXT,
//         total_price REAL,
//         comments TEXT,
//         FOREIGN KEY (user_id) REFERENCES users (user_id)
//       )
//     ''');
//
//     // Создание таблицы delivery_addresses
//     await db.execute('''
//       CREATE TABLE delivery_addresses (
//         address_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         user_id INTEGER,
//         street TEXT,
//         house TEXT,
//         entrance TEXT,
//         floor TEXT,
//         apartment TEXT,
//         FOREIGN KEY (user_id) REFERENCES users (user_id)
//       )
//     ''');
//
//     // Создание таблицы reviews
//     await db.execute('''
//       CREATE TABLE reviews (
//         review_id INTEGER PRIMARY KEY AUTOINCREMENT,
//         item_id INTEGER,
//         user_id INTEGER,
//         rating INTEGER,
//         comment TEXT,
//         review_date TEXT,
//         FOREIGN KEY (item_id) REFERENCES menu_items (item_id),
//         FOREIGN KEY (user_id) REFERENCES users (user_id)
//       )
//     ''');
//   }
//
//   // Вставка отзыва
//   Future<void> insertReview(Map<String, dynamic> review) async {
//     final db = await database;
//     try {
//       review['review_date'] = DateTime.now().toIso8601String(); // Устанавливаем текущую дату
//       await db.insert('reviews', review);
//       print('Review added: $review');
//     } catch (e) {
//       print('Error adding review: $e');
//     }
//   }
//
//   // Получение отзывов по item_id
//   Future<List<Map<String, dynamic>>> getReviewsByItemId(int itemId) async {
//     final db = await database;
//     return await db.query(
//       'reviews',
//       where: 'item_id = ?',
//       whereArgs: [itemId],
//     );
//   }
//
//   // Удаление отзыва
//   Future<void> deleteReview(int id) async {
//     final db = await database;
//     await db.delete('reviews', where: 'review_id = ?', whereArgs: [id]);
//   }
//
//   // Вставка данных в таблицу users с хешированием пароля
//   Future<void> insertUser(Map<String, dynamic> user) async {
//     final db = await database;
//     try {
//       String hashedPassword = _hashPassword(user['password']);
//       user['password'] = hashedPassword; // Хешируем пароль перед сохранением
//       await db.insert('users', user);
//       print('User added: $user');
//     } catch (e) {
//       print('Error adding user: $e');
//     }
//   }
//
//   // Хеширование пароля
//   String _hashPassword(String password) {
//     return sha256.convert(utf8.encode(password)).toString();
//   }
//
//   // Вход пользователя
//   Future<bool> loginUser(String email, String password) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'users',
//       where: 'email = ?',
//       whereArgs: [email],
//     );
//
//     if (maps.isNotEmpty) {
//       String hashedPassword = _hashPassword(password);
//       if (maps[0]['password'] == hashedPassword) {
//         return true; // Успешный вход
//       }
//     }
//     return false; // Неверные учетные данные
//   }
//
//   // Вставка адреса доставки
//   Future<void> insertDeliveryAddress(Map<String, dynamic> address) async {
//     final db = await database;
//     try {
//       await db.insert('delivery_addresses', address);
//       print('Delivery address added: $address');
//     } catch (e) {
//       print('Error adding delivery address: $e');
//     }
//   }
//
//   // Загрузка данных о корзине
//   Future<List<CartItem>> loadCart(int userId) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT c.cart_id, c.user_id, c.item_id, c.quantity, c.total_price,
//              m.name as title, m.imagePath
//       FROM cart c
//       JOIN menu_items m ON c.item_id = m.item_id
//       WHERE c.user_id = ?
//     ''', [userId]);
//
//     print('Loaded cart items: $maps');
//     return List.generate(maps.length, (i) {
//       return CartItem(
//         itemId: maps[i]['item_id'],
//         title: maps[i]['title'] ?? '',
//         imagePath: maps[i]['imagePath'] ?? '',
//         price: maps[i]['total_price'] / maps[i]['quantity'],
//         quantity: maps[i]['quantity'],
//       );
//     });
//   }
//
//   // Сохранение данных в корзину
//   Future<void> saveCart(List<CartItem> cartItems, int userId) async {
//     final db = await database;
//
//     // Очистка старых данных для пользователя
//     await db.delete('cart', where: 'user_id = ?', whereArgs: [userId]);
//
//     // Сохранение новых товаров в корзину
//     for (var item in cartItems) {
//       await db.insert('cart', {
//         'user_id': userId,
//         'item_id': item.itemId,
//         'quantity': item.quantity,
//         'total_price': item.price * item.quantity,
//       });
//       print('Added new item to cart: ${item.title}');
//     }
//   }
//
//   // Дополнительные методы для удаления данных из базы
//   Future<void> deleteUser(int id) async {
//     final db = await database;
//     await db.delete('users', where: 'user_id = ?', whereArgs: [id]);
//   }
//
//   Future<void> deleteMenuItem(int id) async {
//     final db = await database;
//     await db.delete('menu_items', where: 'item_id = ?', whereArgs: [id]);
//   }
//
//   Future<void> deleteCartItem(int id) async {
//     final db = await database;
//     await db.delete('cart', where: 'cart_id = ?', whereArgs: [id]);
//   }
//
//   Future<void> deleteOrder(int id) async {
//     final db = await database;
//     await db.delete('orders', where: 'order_id = ?', whereArgs: [id]);
//   }
//
//   Future<void> deleteDeliveryAddress(int id) async {
//     final db = await database;
//     await db.delete('delivery_addresses', where: 'address_id = ?', whereArgs: [id]);
//   }
// }
//
// class CartItem {
//   final int itemId; // ID товара
//   final String title; // Название товара
//   final String imagePath; // Путь к изображению
//   final double price; // Цена товара
//   int quantity; // Количество товара
//
//   CartItem({
//     required this.itemId,
//     required this.title,
//     required this.imagePath,
//     required this.price,
//     this.quantity = 1,
//   });
// }