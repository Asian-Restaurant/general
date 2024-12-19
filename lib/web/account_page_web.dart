import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPageWeb extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

                // Здесь можно добавить логику для сохранения данных
                // Например, вы можете вызвать метод для сохранения данных в БД

                // Показываем сообщение об успешном сохранении
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200], // Черный цвет кнопки
                minimumSize: const Size(double.infinity, 50), // Широкая кнопка
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white), // Белый текст
              ),
            ),
          ],
        ),
      ),
    );
  }
}