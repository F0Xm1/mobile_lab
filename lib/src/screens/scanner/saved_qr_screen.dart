import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test1/src/usb/usb_manager.dart';
import 'package:test1/src/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

class SavedQrScreen extends StatefulWidget {
  const SavedQrScreen({super.key});

  @override
  State<SavedQrScreen> createState() => _SavedQrScreenState();
}

class _SavedQrScreenState extends State<SavedQrScreen> {
  final UsbManager usbManager = UsbManager(UsbService());
  String savedMessage = 'Зчитування...';

  @override
  void initState() {
    super.initState();
    _readMessageFromArduino();
  }

  Future<void> _readMessageFromArduino() async {
    setState(() => savedMessage = 'Зчитування...');

    await usbManager.dispose();
    final port = await usbManager.selectDevice();

    if (port == null) {
      setState(() => savedMessage = '❌ Arduino не знайдено');
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final response = await _readFromArduino(port);
    if (mounted) {
      setState(() => savedMessage = response);
    }
  }

  Future<String> _readFromArduino(UsbPort port) async {
    final completer = Completer<String>();
    String buffer = '';

    StreamSubscription<Uint8List>? sub;
    sub = port.inputStream?.listen(
          (data) {
        buffer += String.fromCharCodes(data);
        if (buffer.contains('\n')) {
          sub?.cancel();
          completer.complete(buffer.trim());
        }
      },
      onError: (Object error) {
        sub?.cancel();
        completer.completeError('❌ Помилка читання: $error');
      },
      cancelOnError: true,
    );

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub?.cancel();
        return '⏱ Немає відповіді від Arduino';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Збережене повідомлення')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            savedMessage,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
