// import 'package:flutter/material.dart';
// import 'database/database_helper.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   String? _message;
//
//   void _register() async {
//     final name = _nameController.text;
//     final email = _emailController.text;
//     final password = _passwordController.text;
//     final phone = _phoneController.text;
//
//     // Validation
//     if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
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
//     await _dbHelper.insertUser({
//       'name': name,
//       'email': email,
//       'password': password,
//       'phone': phone,
//     });
//
//     setState(() {
//       _message = "Registration successful!";
//     });
//
//     // Optionally navigate to login page or main page
//     Navigator.pop(context); // Close registration page
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Registration")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(labelText: "Phone"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _register,
//               child: Text("Register"),
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