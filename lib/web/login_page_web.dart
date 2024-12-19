import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asian_paradise/web/main_page_web.dart';
import 'package:asian_paradise/web/register_page_web.dart';
import '../database/database_helper.dart';

class LoginPageWeb extends StatefulWidget {
  const LoginPageWeb({super.key});

  @override
  _LoginPageWebState createState() => _LoginPageWebState();
}

class _LoginPageWebState extends State<LoginPageWeb> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text(
          'ASIAN PARADISE',
          style: GoogleFonts.mali(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Больше отступы для веба
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'e-mail',
                  border: OutlineInputBorder(
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
                  filled: true,
                  fillColor: Colors.pink[50],
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  // Проверка на пустые поля
                  if (email.isEmpty || password.isEmpty) {
                    _showErrorDialog('Please enter both email and password.');
                    return;
                  }

                  bool loginSuccess = await _databaseHelper.loginUser(email, password);
                  if (loginSuccess) {
                    // Переход на главную страницу
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPageWeb()),
                    );
                  } else {
                    _showErrorDialog('Invalid email or password.');
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black), // Черный текст
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  minimumSize: Size(double.infinity, 50), // Широкая кнопка
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPageWeb()), // Веб-страница регистрации
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.pink), // Цвет текста кнопки
                ),
              ),
            ],
          ),
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