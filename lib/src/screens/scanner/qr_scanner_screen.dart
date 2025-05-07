import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:test1/src/usb/usb_manager.dart';
import 'package:test1/src/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';


class QRScannerScreen extends StatelessWidget {
  QRScannerScreen({super.key});

  final UsbManager usbManager = UsbManager(UsbService());

  Future<String> _waitForArduinoResponse(UsbPort port,
      {Duration timeout = const Duration(seconds: 2),}) async {
    final completer = Completer<String>();
    String buffer = '';
    late StreamSubscription<Uint8List> sub;

    sub = port.inputStream!.listen((event) {
      buffer += String.fromCharCodes(event);
      if (buffer.contains('\n')) {
        completer.complete(buffer.trim());
        sub.cancel();
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      sub.cancel();
      return '⏱ Arduino не відповів';
    },
    );
  }


  Future<void> _sendToArduino(BuildContext context, String code) async {
    final port = await usbManager.selectDevice();
    if (!context.mounted) return;

    if (port == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Arduino не знайдено')),
      );
      return;
    }

    await usbManager.sendData('$code\n');
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ QR надіслано: $code')),
    );

    final response = await _waitForArduinoResponse(port);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('📬 Arduino відповів: $response')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканування QR-коду')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final code = barcode.rawValue;
          if (code != null) {
            _sendToArduino(context, code);
            Navigator.pop(context); // Закрити після сканування
          }
        },
      ),
    );
  }
}
