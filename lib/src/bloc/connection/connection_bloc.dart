import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test1/src/bloc/connection/connection_event.dart';
import 'package:test1/src/bloc/connection/connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectionStarted>(_onConnectionStarted);
    on<ConnectionChanged>(_onConnectionChanged);

    // Оскільки onConnectivityChanged повертає Stream<List<ConnectivityResult>>,
    // беремо перший елемент списку або none, якщо список порожній.
    _subscription =
        Connectivity().onConnectivityChanged.listen(
                (List<ConnectivityResult> results) {
          final connectivityResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
          add(ConnectionChanged(connectivityResult));
        });
  }

  Future<void> _onConnectionStarted(
      ConnectionStarted event,
      Emitter<ConnectionState> emit,
      ) async {
    final results = await Connectivity().checkConnectivity();

    // Тут results — це List<ConnectivityResult>
    final hasConnection = results.any((r) => r != ConnectivityResult.none);

    if (hasConnection) {
      emit(ConnectionConnected());
    } else {
      emit(ConnectionDisconnected());
    }
  }


  void _onConnectionChanged(
      ConnectionChanged event, Emitter<ConnectionState> emit,) {
    if (event.connectivityResult == ConnectivityResult.none) {
      emit(ConnectionDisconnected());
    } else {
      emit(ConnectionConnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
