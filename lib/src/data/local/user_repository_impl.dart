import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/domain/models/user.dart';
import 'package:test1/src/domain/repositories/i_user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  // Ключ для зберігання даних користувача
  static const String _userKey = 'user_data';

  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // Кодуємо об'єкт користувача в JSON
    final userJson = jsonEncode({
      'email': user.email,
      'name': user.name,
      'password': user.password,
    });
    // Зберігаємо JSON-рядок у local storage
    await prefs.setString(_userKey, userJson);
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null; // Якщо користувача нема — повертаємо null

    final map = jsonDecode(data) as Map<String, dynamic>;
    final storedUser = User(
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
    );

    // Перевірка, чи збігаються email і пароль
    if (storedUser.email == email && storedUser.password == password) {
      return storedUser;
    }
    return null;
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null;

    final map = jsonDecode(data) as Map<String, dynamic>;
    // Відновлюємо об'єкт користувача з JSON
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
    );
  }

  @override
  Future<void> updateUser(User user) async {
    // Просто перезаписуємо існуючі дані новими
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'email': user.email,
      'name': user.name,
      'password': user.password,
    });
    await prefs.setString(_userKey, userJson);
  }

  @override
  Future<void> deleteUser() async {
    // Видаляємо дані користувача з local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
