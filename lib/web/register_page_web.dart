import 'package:asian_paradise/web/main_page_web.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';

class RegisterPageWeb extends StatefulWidget {
  const RegisterPageWeb({super.key});

  @override
  _RegisterPageWebState createState() => _RegisterPageWebState();
}

class _RegisterPageWebState extends State<RegisterPageWeb> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'e-mail'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'phone number'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _repeatPasswordController,
                      decoration: const InputDecoration(labelText: 'repeat password'),
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
                        await _databaseHelper.insertUser({
                          'name': phone, // Здесь можно заменить на имя, если оно будет добавлено
                          'email': email,
                          'password': password,
                          'phone': phone,
                        });

                        // Переход на главную страницу
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPageWeb()),
                        );
                      },
                      child: const Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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