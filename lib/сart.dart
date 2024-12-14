class CartItem {
  final String title;
  final String imagePath;
  final double price;
  int quantity;

  CartItem({
    required this.title,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });
}

class Cart {
  final List<CartItem> items = [];

  void addItem(CartItem item) {
    final existingItemIndex = items.indexWhere((cartItem) => cartItem.title == item.title);
    if (existingItemIndex != -1) {
      items[existingItemIndex].quantity++;
    } else {
      items.add(item);
    }
  }

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}