import 'package:asian_paradise/web/main_page_web.dart';
import 'package:asian_paradise/web/register_page_web.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Логика логина
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
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPageWeb()),
                        );
                      },
                      child: const Text('Register'),
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