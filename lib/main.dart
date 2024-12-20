import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'mobile/main_page_mobile.dart' as mobile;
import 'web/main_page_web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase с параметрами из firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asian Paradise',
      home: (kIsWeb
          ? web.MainPageWeb()
          : mobile.MainPageMobile()),
    );
  }
}
