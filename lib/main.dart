import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/src/business/use_caces/login_user_use_case.dart';
import 'package:test1/src/business/use_caces/register_user_use_case.dart';
import 'package:test1/src/data/local/user_repository_impl.dart';
import 'package:test1/src/domain/repositories/i_user_repository.dart';
import 'package:test1/src/screens/auth_page/login_page.dart';
import 'package:test1/src/screens/auth_page/register_page.dart';
import 'package:test1/src/screens/home_page/home_page.dart';
import 'package:test1/src/screens/home_page/smart_station_page.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      // Репозиторій користувачів (локальне сховище)
      Provider<IUserRepository>(
        create: (_) => UserRepositoryImpl(),
      ),
      // Use case логіну
      Provider<LoginUserUseCase>(
        create: (context) =>
            LoginUserUseCase(context.read<IUserRepository>()),
      ),
      // Use case реєстрації
      Provider<RegisterUserUseCase>(
        create: (context) =>
            RegisterUserUseCase(context.read<IUserRepository>()),
      ),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home: Чіпідізєль',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/station': (context) => const SmartStationPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
