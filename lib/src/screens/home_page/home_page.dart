import 'package:flutter/material.dart';
import 'package:test1/src/widgets/chipi_dizel_connector/chipi_dizel_connector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Основні кольори для темного дизайну
    const Color darkBackground = Color(0xFF1A1B2D);
    const Color accentPurple = Color(0xFF8A2BE2);
    const Color lightPurple = Color(0xFFB19CD9);

    return Scaffold(
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
          // Декоративні напівпрозорі кола
          Positioned(
            top: -80,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: lightPurple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Основний вміст
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Верхній заголовок
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Чіпідізєль Smart Station',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Основний контент: круг, у якому розміщено ChipiDizelConnector
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentPurple.withOpacity(0.3),
                                accentPurple.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: ChipiDizelConnector(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Кнопка переходу до станції
                Container(
                  margin: const EdgeInsets.symmetric
                    (horizontal: 24, vertical: 8),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/station'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Перейти до станції',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Нижній напис
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Ласкаво просимо до розумного дому!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
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
