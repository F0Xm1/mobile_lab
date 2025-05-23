import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/src/business/use_caces/register_user_use_case.dart';
import 'package:test1/src/domain/models/user.dart';
import 'package:test1/src/widgets/reusable/reusable_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Контролери для полів вводу
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  String? _errorMessage;

  Future<void> _onRegister() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Простий додатковий перевірка на рівність паролів
    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Паролі не співпадають');
      return;
    }

    // Отримуємо use case реєстрації через Provider
    final registerUseCase = context.read<RegisterUserUseCase>();

    final user = User(
      email: email,
      name: name,
      password: password,
    );

    final error = await registerUseCase.execute(user);
    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      // Якщо реєстрація успішна, переходимо на екран логіну
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric
                  (horizontal: 24, vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Реєстрація',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Створіть новий обліковий запис',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ReusableTextField(
                            hint: 'Email',
                            controller: _emailController,
                          ),
                          const SizedBox(height: 16),
                          ReusableTextField(
                            hint: 'Ім’я',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),
                          ReusableTextField(
                            hint: 'Пароль',
                            obscure: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 16),
                          ReusableTextField(
                            hint: 'Підтвердіть пароль',
                            obscure: true,
                            controller: _confirmPasswordController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Виведення повідомлення про помилку (якщо є)
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Кнопка "Зареєструватися"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Зареєструватися',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Посилання для повернення до логіну
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Вже маєте обліковий запис? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Увійдіть',
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
        ],
      ),
    );
  }
}
