import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/business/use_caces/login_user_use_case.dart';
import 'package:test1/src/data/local/user_repository_impl.dart';
import 'package:test1/src/widgets/reusable/reusable_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Контролери для полів вводу
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Повідомлення про помилку (якщо логін неуспішний)
  String? _errorMessage;

  // Репозиторій та use case
  final _userRepository = UserRepositoryImpl();
  late final LoginUserUseCase _loginUseCase;

  @override
  void initState() {
    super.initState();
    _loginUseCase = LoginUserUseCase(_userRepository);
    _checkAutoLogin();
  }

  // Перевірка, чи користувач вже увійшов
  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == true && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Спроба логіну через use case
  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Викликаємо use case
    final error = await _loginUseCase.execute(email, password);

    if (error != null) {
      // Логін неуспішний: виводимо помилку
      setState(() => _errorMessage = error);
    } else {
      // Логін успішний: зберігаємо прапорець і переходимо на /home
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

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
          // Перший шар: градієнтний фон
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkBackground,
                  Color(0xFF25274D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Другий шар: напівпрозорі кола (Positioned)
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: lightPurple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Основний вміст
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Заголовок
                      const Text(
                        'Ласкаво просимо назад',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Увійдіть у свій обліковий запис',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Блок полів вводу
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Використовуємо ReusableTextField з контролером
                            ReusableTextField(
                              hint: 'Email',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 16),
                            ReusableTextField(
                              hint: 'Пароль',
                              obscure: true,
                              controller: _passwordController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Кнопка "Увійти"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Увійти',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Виведення помилки (якщо є)
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Посилання "Забули пароль?"
                      TextButton(
                        onPressed: () {
                          // Тут можна додати логіку для відновлення паролю
                        },
                        child: const Text(
                          'Забули пароль?',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Роздільник «або»
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 1,
                            color: Colors.white30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'або',
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            height: 1,
                            color: Colors.white30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Посилання "Немає облікового запису? Зареєструватися"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Немає облікового запису? ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Зареєструватися',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
