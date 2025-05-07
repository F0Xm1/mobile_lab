import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/business/use_caces/login_user_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase loginUserUseCase;

  AuthCubit({required this.loginUserUseCase}) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final error = await loginUserUseCase.execute(username, password);

      if (error == null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error));
      }
    } catch (e) {
      emit(AuthFailure('Сталася помилка: $e'));
    }
  }

  Future<void> checkAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
