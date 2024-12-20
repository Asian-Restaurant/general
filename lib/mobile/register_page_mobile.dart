import 'package:asian_paradise/mobile/main_page_mobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/firestore_helper.dart';

class RegisterPageMobile extends StatefulWidget {
  const RegisterPageMobile({super.key});

  @override
  _RegisterPageMobileState createState() => _RegisterPageMobileState();
}

class _RegisterPageMobileState extends State<RegisterPageMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final FirestoreHelper _firestoreHelper = FirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text(
          'WELCOME TO YOUR LITTLE DREAMWORLD',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'e-mail',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Розовая рамка
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'phone number',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Розовая рамка
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'password',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Розовая рамка
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'repeat password',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Розовая рамка
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Логика регистрации
                String email = _emailController.text;
                String phone = _phoneController.text;
                String password = _passwordController.text;
                String repeatPassword = _repeatPasswordController.text;

                // Проверка на пустые поля
                if (email.isEmpty || phone.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
                  _showErrorDialog('Please fill in all fields.');
                  return;
                }

                // Проверка на совпадение паролей
                if (password != repeatPassword) {
                  _showErrorDialog('Passwords do not match.');
                  return;
                }

                // Вставка пользователя в базу данных
                await _firestoreHelper.insertUser({
                  'name': phone, // Здесь можно заменить на имя, если оно будет добавлено
                  'email': email,
                  'password': password,
                  'phone': phone,
                });

                // Переход на главную страницу
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPageMobile()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                minimumSize: const Size(double.infinity, 50), // Широкая кнопка
              ),
              child: const Text(
                  'Register',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Login', style: TextStyle(color: Colors.pink),),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}