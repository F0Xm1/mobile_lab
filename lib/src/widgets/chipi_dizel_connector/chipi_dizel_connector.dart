import 'package:flutter/material.dart';

class ChipiDizelConnector extends StatefulWidget {
  final void Function(bool)? onConnectionChanged;

  const ChipiDizelConnector({super.key, this.onConnectionChanged});

  @override
  ChipiDizelConnectorState createState() => ChipiDizelConnectorState();
}

class ChipiDizelConnectorState extends State<ChipiDizelConnector> {
  static bool connected = false;

  void _toggleConnection() {
    setState(() {
      connected = !connected;
    });
    widget.onConnectionChanged?.call(connected);
  }

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF8A2BE2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          connected ? 'Підключено' : 'Не підключено',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
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
              fontSize: 18, fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _toggleConnection,
          child: Text(connected ? 'Відключитись' : 'Підключитись'),
        ),
      ],
    );
  }
}
