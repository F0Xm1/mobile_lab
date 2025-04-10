import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/widgets/dialogs/logout_confirmation_dialog.dart';
import 'package:test1/src/widgets/reusable/reusable_button.dart';

class SmartStationPage extends StatefulWidget {
  const SmartStationPage({super.key});

  @override
  State<SmartStationPage> createState() => _SmartStationPageState();
}

class _SmartStationPageState extends State<SmartStationPage> {
  late Timer _timer;
  final Random _random = Random();

  int temperature = 0;
  int humidity = 0;
  int pressure = 0;

  @override
  void initState() {
    super.initState();
    _updateSensorData();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateSensorData();
    });
  }

  void _updateSensorData() {
    setState(() {
      temperature = 15 + _random.nextInt(16);
      humidity = 40 + _random.nextInt(37);
      pressure = 961 + _random.nextInt(100);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Функція для виходу з аккаунту
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    if (context.mounted) Navigator.pushReplacementNamed(context, '/');
  }

  // Функція для побудови карточки з даними сенсора
  Widget _buildSensorData(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Основні кольори для темного дизайну
    const Color darkBackground = Color(0xFF1A1B2D);
    const Color accentPurple = Color(0xFF8A2BE2);
    const Color lightPurple = Color(0xFFB19CD9);

    return Scaffold(
      // Верхній AppBar із кнопкою виходу
      appBar: AppBar(
        backgroundColor: darkBackground,
        title: const Text('Станція Чіпідізєль'),
        actions: [
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => LogoutConfirmationDialog(
                  onConfirm: () => _logout(context),
                ),
              );
            },
          ),
        ],
      ),

      backgroundColor: darkBackground,
      body: Stack(
        children: [
          // Градієнтний фон
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkBackground,
                  Color(0xFF25274D),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Декоративні елементи
          Positioned(
            top: -50,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: lightPurple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Основний вміст
          SafeArea(
            child: Column(
              children: [
                // Верхній блок із назвою та банером
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentPurple.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Center(
                    child: Text(
                      'Чіпідізєль',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Основна зона з даними сенсорів
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSensorData('Температура', '$temperature°C'),
                        _buildSensorData('Вологість', '$humidity%'),
                        _buildSensorData('Тиск', '$pressure hPa'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                // Кнопка "Головна" внизу
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: ReusableButton(
                      text: 'Головна',
                      onPressed: () => Navigator.pushNamed(context, '/home'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
