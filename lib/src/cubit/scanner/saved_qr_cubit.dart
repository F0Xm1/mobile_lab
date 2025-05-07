import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/services/usb/usb_manager.dart';
import 'package:usb_serial/usb_serial.dart';

part 'saved_qr_state.dart';

class SavedQrCubit extends Cubit<SavedQrState> {
  final UsbManager usbManager;

  SavedQrCubit({required this.usbManager}) : super(SavedQrInitial());

  Future<void> readFromArduino() async {
    emit(SavedQrLoading());

    await usbManager.dispose();
    final port = await usbManager.selectDevice();

    if (port == null) {
      emit(SavedQrFailure('❌ Arduino не знайдено'));
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final response = await _read(port);
    emit(SavedQrSuccess(response));
  }

  Future<String> _read(UsbPort port) async {
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
}
