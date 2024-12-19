class CartItem {
  final String title;
  final String imagePath;
  final double price;
  int quantity; // Свойство для количества

  CartItem({
    required this.title,
    required this.imagePath,
    required this.price,
    this.quantity = 1, // Количество по умолчанию
  });

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
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