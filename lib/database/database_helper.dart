import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CartItem {
  final int itemId; // ID товара
  final String title; // Название товара
  final String imagePath; // Путь к изображению
  final double price; // Цена товара
  int quantity; // Количество товара

  CartItem({
    required this.itemId,
    required this.title,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE menu_items (
        item_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price REAL,
        stock INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        item_id INTEGER,
        quantity INTEGER,
        total_price REAL,
        FOREIGN KEY (item_id) REFERENCES menu_items (item_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        order_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        order_date TEXT,
        total_price REAL,
        comments TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE delivery_addresses (
        address_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        street TEXT,
        house TEXT,
        entrance TEXT,
        floor TEXT,
        apartment TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        review_id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER,
        user_id INTEGER,
        rating INTEGER,
        comment TEXT,
        review_date TEXT
      )
    ''');
  }

  // Insert methods
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user);
  }

  Future<void> insertMenuItem(Map<String, dynamic> menuItem) async {
    final db = await database;
    await db.insert('menu_items', menuItem);
  }

  Future<void> insertCartItem(Map<String, dynamic> cartItem) async {
    final db = await database;
    await db.insert('cart', cartItem);
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    await db.insert('orders', order);
  }

  Future<void> insertDeliveryAddress(Map<String, dynamic> address) async {
    final db = await database;
    await db.insert('delivery_addresses', address);
  }

  Future<void> insertReview(Map<String, dynamic> review) async {
    final db = await database;
    await db.insert('reviews', review);
  }

  // Query methods
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getMenuItems() async {
    final db = await database;
    return await db.query('menu_items');
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.query(
      'cart',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  Future<List<Map<String, dynamic>>> getDeliveryAddresses() async {
    final db = await database;
    return await db.query('delivery_addresses');
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    final db = await database;
    return await db.query('reviews');
  }

  // Update methods
  Future<void> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    await db.update('users', user, where: 'user_id = ?', whereArgs: [id]);
  }

  Future<void> updateMenuItem(int id, Map<String, dynamic> menuItem) async {
    final db = await database;
    await db.update('menu_items', menuItem, where: 'item_id = ?', whereArgs: [id]);
  }

  Future<void> updateCartItem(int id, Map<String, dynamic> cartItem) async {
    final db = await database;
    await db.update('cart', cartItem, where: 'cart_id = ?', whereArgs: [id]);
  }

  // Delete methods
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'user_id = ?', whereArgs: [id]);
  }

  Future<void> deleteMenuItem(int id) async {
    final db = await database;
    await db.delete('menu_items', where: 'item_id = ?', whereArgs: [id]);
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete('cart', where: 'cart_id = ?', whereArgs: [id]);
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete('orders', where: 'order_id = ?', whereArgs: [id]);
  }

  Future<void> deleteDeliveryAddress(int id) async {
    final db = await database;
    await db.delete('delivery_addresses', where: 'address_id = ?', whereArgs: [id]);
  }

  Future<void> deleteReview(int id) async {
    final db = await database;
    await db.delete('reviews', where: 'review_id = ?', whereArgs: [id]);
  }

  // Save and load cart methods
  Future<void> saveCart(List<CartItem> cartItems, int userId) async {
    final db = await database;

    // Очистка старых данных для пользователя
    await db.delete('cart', where: 'user_id = ?', whereArgs: [userId]);

    // Сохранение новых товаров в корзину
    for (var item in cartItems) {
      await db.insert('cart', {
        'user_id': userId,
        'item_id': item.itemId,
        'quantity': item.quantity,
        'total_price': item.price * item.quantity,
      });
    }
  }

  Future<List<CartItem>> loadCart(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return CartItem(
        itemId: maps[i]['item_id'],
        title: maps[i]['title'], // Убедитесь, что это поле добавлено в CartItem
        imagePath: maps[i]['imagePath'], // Убедитесь, что это поле добавлено в CartItem
        price: maps[i]['total_price'] / maps[i]['quantity'],
        quantity: maps[i]['quantity'],
      );
    });
  }
}