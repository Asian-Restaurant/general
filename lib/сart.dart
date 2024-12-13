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
}

class Cart {
  final List<CartItem> items = [];

  void addItem(CartItem item) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.title == item.title);
    if (existingItemIndex != -1) {
      // Если товар уже есть, увеличиваем количество
      items[existingItemIndex].quantity++;
    } else {
      // Если товара нет, добавляем его в корзину
      items.add(item);
    }
  }

  // Метод для получения общей суммы
  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}