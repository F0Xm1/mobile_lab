import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вихід з акаунту'),
      content: const Text('Ви впевнені, що хочете вийти?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text('Вийти'),
            ),
          ],
        ),
      ],
    );
  }
}
