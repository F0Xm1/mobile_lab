import 'package:flutter/material.dart';

class ChipiDizelConnector extends StatefulWidget {
  final void Function(bool)? onConnectionChanged;
  final bool isOnline;

  const ChipiDizelConnector({
    required this.isOnline,
    this.onConnectionChanged,
    super.key,
  });

  @override
  ChipiDizelConnectorState createState() => ChipiDizelConnectorState();
}

class ChipiDizelConnectorState extends State<ChipiDizelConnector> {
  static bool connected = false;
  bool isLoading = false;

  void _toggleConnection() async {
    if (!widget.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Немає інтернету — підключення неможливе.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Імітуємо підключення (можеш забрати, якщо не треба)
    await Future<void>.delayed(const Duration(seconds: 1));

    setState(() {
      connected = !connected;
      isLoading = false;
    });

    widget.onConnectionChanged?.call(connected);
  }

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF8A2BE2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: !widget.isOnline
              ? const Text(
            'Немає інтернету',
            key: ValueKey('no_inet'),
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          )
              : isLoading
              ? const SizedBox(
            key: ValueKey('loading'),
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
              : Text(
            connected ? 'Підключено' : 'Не підключено',
            key: ValueKey(connected),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: isLoading ? null : _toggleConnection,
          child: Text(connected ? 'Відключитись' : 'Підключитись'),
        ),
      ],
    );
  }
}
