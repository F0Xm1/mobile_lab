import 'package:flutter/material.dart';

class ChipiDizelConnector extends StatefulWidget {
  const ChipiDizelConnector({super.key});

  @override
  ChipiDizelConnectorState createState() => ChipiDizelConnectorState();
}

class ChipiDizelConnectorState extends State<ChipiDizelConnector> {
  bool connected = false;

  void _toggleConnection() => setState(() => connected = !connected);

  @override
  Widget build(BuildContext context) {
    // Основний фірмовий фіолетовий колір
    const Color accentPurple = Color(0xFF8A2BE2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Текст стану підключення
        Text(
          connected ? 'Підключено' : 'Не підключено',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            // Колір білий, адже фон у нас тепер темний (прозорий)
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        // Кнопка перемикання (завжди фіолетова, текст білий)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentPurple,
            foregroundColor: Colors.white, // Текст кнопки білий
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle
              (fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: _toggleConnection,
          child: Text(connected ? 'Відключитись' : 'Підключитись'),
        ),
      ],
    );
  }
}
