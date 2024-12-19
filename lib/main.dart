import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'mobile/main_page_mobile.dart' as mobile;
import 'web/main_page_web.dart' as web;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

    databaseFactory = databaseFactoryFfi;

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