import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/bloc/connection/connection_bloc.dart';
import 'package:test1/src/bloc/connection/connection_state.dart' as connection;
import 'package:test1/src/business/use_caces/login_user_use_case.dart';
import 'package:test1/src/cubit/auth/auth_cubit.dart';
import 'package:test1/src/widgets/reusable/reusable_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _checkAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == true && context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _onLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF1A1B2D);
    const Color accentPurple = Color(0xFF8A2BE2);
    const Color lightPurple = Color(0xFFB19CD9);

    return BlocProvider(
      create: (context) {
        final cubit =
        AuthCubit(loginUserUseCase: context.read<LoginUserUseCase>());
        cubit.checkAutoLogin(context);
        return cubit;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectionBloc, connection.ConnectionState>(
            listener: (context, state) {
              if (state is connection.ConnectionDisconnected) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Відсутнє підключення'),
                    content: const Text(
                      'Інтернет зник! Деякі функції можуть бути недоступні.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is AuthSuccess) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', true);
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              }
            },
          ),
        ],
        child: Scaffold(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                  hint: 'Пароль',
                                  obscure: true,
                                  controller: _passwordController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _onLogin(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentPurple,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    'Увійти',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is AuthFailure) {
                                return Column(
                                  children: [
                                    Text(
                                      state.message,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              // Відновлення паролю
                            },
                            child: const Text(
                              'Забули пароль?',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 16),
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
        ),
      ),
    );
  }
}
