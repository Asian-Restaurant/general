// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';
// import 'basket_page.dart' as basket;
// import 'database/database_helper.dart';
// import 'main_page.dart';
// import 'menu_page.dart';
// import 'reviews_page.dart' as reviews;
// import 'сart.dart';
//
// class AddressPage extends StatefulWidget {
//   AddressPage({Key? key}) : super(key: key);
//
//   @override
//   _AddressPageState createState() => _AddressPageState();
// }
//
// class _AddressPageState extends State<AddressPage> {
//   final Cart cart = Cart();
//   final TextEditingController _streetController = TextEditingController();
//   final TextEditingController _houseController = TextEditingController();
//   final TextEditingController _floorController = TextEditingController();
//   final TextEditingController _apartmentController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink[100],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           'ASIAN PARADISE',
//           style: GoogleFonts.mali(color: Colors.black, fontSize: 24),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//
//               // Кнопки навигации в ряд
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildNavButton(context, "Main Page", () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
//                     }),
//                     _buildNavButton(context, "Menu", () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
//                     }),
//                     _buildNavButton(context, "Basket", () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => basket.BasketPage(cartData: cart,)));
//                     }),
//                     _buildNavButton(context, "Reviews", () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => reviews.ReviewsPage()));
//                     }),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Контейнер с формой
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.pink[100],
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Your address',
//                       style: GoogleFonts.mali(fontSize: 24, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     _buildTextField('Street', _streetController),
//                     const SizedBox(height: 10),
//                     _buildTextField('House', _houseController),
//                     const SizedBox(height: 10),
//                     _buildTextField('Floor', _floorController),
//                     const SizedBox(height: 10),
//                     _buildTextField('Apartment', _apartmentController),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () async {
//                         await _saveAddress();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink[300],
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       child: const Text(
//                         'Submit',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavButton(BuildContext context, String title, VoidCallback onPressed) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.pink[300],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.black,
//             fontFamily: 'Poppins',
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.black),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
//
//   Future<void> _saveAddress() async {
//     final address = {
//       'user_id': 1, // Предположим, что у вас есть ID пользователя
//       'street': _streetController.text,
//       'house': _houseController.text,
//       'floor': _floorController.text,
//       'apartment': _apartmentController.text,
//     };
//
//     final dbHelper = DatabaseHelper();
//     await dbHelper.insertDeliveryAddress(address);
//
//     // Очистка текстовых полей после сохранения
//     _streetController.clear();
//     _houseController.clear();
//     _floorController.clear();
//     _apartmentController.clear();
//
//     // Информируем пользователя о том, что адрес отправлен
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Sent')),
//     );
//   }
// }