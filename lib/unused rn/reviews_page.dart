// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ReviewsPage extends StatefulWidget {
//   const ReviewsPage({Key? key}) : super(key: key);
//
//   @override
//   _ReviewsPageState createState() => _ReviewsPageState();
// }
//
// class _ReviewsPageState extends State<ReviewsPage> {
//   final TextEditingController _reviewController = TextEditingController();
//   final List<Map<String, String>> _reviews = [
//     {"user": "User1", "review": "blah-blah-blah"},
//     {"user": "User2", "review": "blah-blah-blah"},
//     {"user": "User3", "review": "blah-blah-blah"},
//     {"user": "User4", "review": "blah-blah-blah"},
//   ];
//
//   void _addReview() {
//     if (_reviewController.text.isNotEmpty) {
//       setState(() {
//         _reviews.add({"user": "You", "review": _reviewController.text});
//         _reviewController.clear(); // Очистка текстового поля
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'ASIAN PARADISE',
//           style: GoogleFonts.mali(fontSize: 24),
//         ),
//         backgroundColor: Colors.pink[100],
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Leave your review!',
//               style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             _buildReviewInput(),
//             const SizedBox(height: 16),
//             Text(
//               'Reviews:',
//               style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Expanded(child: _buildReviewList()),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addReview,
//         backgroundColor: Colors.pink[300],
//         child: Icon(Icons.send),
//       ),
//     );
//   }
//
//   Widget _buildReviewInput() {
//     return TextField(
//       controller: _reviewController,
//       maxLines: 3,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16.0), // Закругление углов
//           borderSide: BorderSide.none, // Убираем рамку
//         ),
//         hintText: 'Tell us everything you want...',
//         filled: true,
//         fillColor: Colors.pink[50],
//         contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Паддинг внутри текстового поля
//       ),
//     );
//   }
//
//   Widget _buildReviewList() {
//     return ListView.builder(
//       itemCount: _reviews.length,
//       itemBuilder: (context, index) {
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _reviews[index]["user"]!,
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(_reviews[index]["review"]!),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }