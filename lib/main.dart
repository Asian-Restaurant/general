import 'package:flutter/material.dart';
import 'mobile/main_page_mobile.dart' as mobile;
import 'web/main_page_web.dart' as web;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asian Paradise',
      home: (isWeb()
          ? web.MainPageWeb()
          : mobile.MainPageMobile()),
    );
  }

  bool isWeb() {
    return identical(0, 0.0);
  }
}