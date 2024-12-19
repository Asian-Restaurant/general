// import 'package:flutter/material.dart';
// import 'database/database_helper.dart';
// import 'unused rn/main_page.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   String? _message;
//
//   void _login() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;
//
//     // Validation
//     if (email.isEmpty || password.isEmpty) {
//       setState(() {
//         _message = "Please fill in all fields.";
//       });
//       return;
//     }
//
//     // Check if email is valid
//     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
//       setState(() {
//         _message = "Please enter a valid email.";
//       });
//       return;
//     }
//
//     bool success = await _dbHelper.loginUser(email, password);
//
//     if (success) {
//       // Navigate to MainPage after successful login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainPage()),
//       );
//     } else {
//       setState(() {
//         _message = "Invalid username or password.";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text("Login"),
//             ),
//             if (_message != null) ...[
//               SizedBox(height: 20),
//               Text(_message!, style: TextStyle(color: Colors.red)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }