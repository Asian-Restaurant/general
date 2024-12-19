// import 'package:asian_paradise/%D1%81art.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class DishPage extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final String description;
//   final double weight;
//   final double price;
//   final Cart cart;
//
//   const DishPage({
//     Key? key,
//     required this.title,
//     required this.imagePath,
//     required this.description,
//     required this.weight,
//     required this.price,
//     required this.cart,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           title,
//           style: GoogleFonts.mali(color: Colors.black),
//         ),
//         backgroundColor: Colors.pink[100],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.pink[300]!, width: 5),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(11),
//                 child: Image.asset(imagePath),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Text(
//                 description,
//                 style: GoogleFonts.poppins(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Text(
//                 "Weight: ${weight}g",
//                 style: GoogleFonts.poppins(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Text(
//                 "Price: ${price.toStringAsFixed(2)} BYN",
//                 style: GoogleFonts.poppins(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _addToCart(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black,
//                 backgroundColor: Colors.pink[300],
//               ),
//               child: Text(
//                 "Add to Cart",
//                 style: GoogleFonts.poppins(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _addToCart(BuildContext context) {
//     final existingItemIndex = cart.items.indexWhere((item) => item.title == title);
//     if (existingItemIndex != -1) {
//       cart.items[existingItemIndex].quantity++;
//       print("Increased quantity for item: ${cart.items[existingItemIndex].title}");
//     } else {
//       cart.addItem(CartItem(title: title, imagePath: imagePath, price: price));
//       print("Added new item to cart: $title");
//     }
//
//     Navigator.pop(context, true);
//   }
// }