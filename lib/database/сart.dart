class CartItem {
  final String title;
  final String imagePath;
  final double price;
  int quantity; // This should be mutable
  String? comment;

  CartItem({
    required this.title,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
    this.comment,
  });

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
      'comment': comment ?? '', // Provide a default empty string for comment
    };
  }

  // Method to create a CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      price: (json['price'] as num).toDouble(), // Ensure price is parsed as double
      quantity: json['quantity'] ?? 1,
      comment: json['comment'] as String?, // Allow for nullable comment
    );
  }
}

class Cart {
  final List<CartItem> items = [];

  void addItem(CartItem item) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.title == item.title);
    if (existingItemIndex != -1) {
      // Увеличиваем количество, если товар уже есть
      items[existingItemIndex].quantity++;
    } else {
      // Добавляем новый товар
      items.add(item);
    }
  }

  void removeItem(String title) {
    items.removeWhere((cartItem) => cartItem.title == title);
  }

  void clear() {
    items.clear();
  }

  // Метод для получения общей суммы
  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Метод для получения общего количества товаров
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}