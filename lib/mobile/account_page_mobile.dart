import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/firestore_helper.dart';

class AccountPageMobile extends StatefulWidget {
  final String email; // Email для поиска пользователя

  AccountPageMobile({Key? key, required this.email}) : super(key: key);

  @override
  _AccountPageMobileState createState() => _AccountPageMobileState();
}

class _AccountPageMobileState extends State<AccountPageMobile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  FirestoreHelper _firestoreHelper = FirestoreHelper();
  Map<String, dynamic>? userData; // Данные пользователя

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Загрузка данных пользователя
  Future<void> _loadUserData() async {
    userData = await _firestoreHelper.getUser(widget.email);
    if (userData != null) {
      setState(() {
        _nameController.text = userData!['name'] ?? '';
        _phoneController.text = userData!['phone'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[100],
          title: Text(
            "Account",
            style: GoogleFonts.mali(color: Colors.black, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Please log in to your account.',
            style: GoogleFonts.mali(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text(
          "Account",
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
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
                labelText: 'Phone Number',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Розовая рамка
                ),
                filled: true,
                fillColor: Colors.pink[50],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Логика сохранения данных пользователя
                String name = _nameController.text;
                String phone = _phoneController.text;

                // Обновление данных в Firestore
                _updateUserData(name, phone);

                // Показываем сообщение об успешном сохранении
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200], // Цвет кнопки
                minimumSize: const Size(double.infinity, 50), // Широкая кнопка
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.black), // Цвет текста
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Обновление данных пользователя в Firestore
  Future<void> _updateUserData(String name, String phone) async {
    await _firestoreHelper.insertUser({
      'email': widget.email,
      'name': name,
      'phone': phone,
    });
  }
}