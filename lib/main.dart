import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Инициализация фрейма Flutter
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Инициализация базы данных

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asian Paradise', // Название приложения
      home: MainPage(), // Главная страница приложения
    );
  }
}