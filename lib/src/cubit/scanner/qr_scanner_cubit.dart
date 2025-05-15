import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/services/usb/usb_manager.dart';
import 'package:usb_serial/usb_serial.dart';

part 'qr_scanner_state.dart';

class QrScannerCubit extends Cubit<QrScannerState> {
  final UsbManager usbManager;

  QrScannerCubit({required this.usbManager}) : super(QrScannerInitial());

  Future<void> sendToArduino(String code) async {
    emit(QrScannerSending());

    final port = await usbManager.selectDevice();
    if (port == null) {
      emit(QrScannerFailure('❌ Arduino не знайдено'));
      return;
    }

    await usbManager.sendData('$code\n');

    final response = await _waitForArduinoResponse(port);
    emit(QrScannerSuccess('📬 Arduino відповів: $response'));
  }

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
}
